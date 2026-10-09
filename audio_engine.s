PULSE1DUTY = $4000
PULSE1SWEEP = $4001
PULSE1TIMER = $4002
PULSE1LENGTH = $4003
PULSE2DUTY = $4004
PULSE2SWEEP = $4005
PULSE2TIMER = $4006
PULSE2LENGTH = $4007
TRIANGLELINEAR = $4008
TRIANGLETIMER = $400A
TRIANGLELENGTH = $400B
NOISEVOLUME = $400C
NOISEPERIOD = $400E
NOISELENGTH = $400F
APUDMC = $4010
APUSTATUS = $4015
APUFRAMECOUNTER = $4017

.pushseg
.zeropage
    pulse_1_sfx_addr: .res 2
    pulse_1_music_addr: .res 2
    pulse_2_sfx_addr: .res 2
    pulse_2_music_addr: .res 2
    triangle_sfx_addr: .res 2
    triangle_music_addr: .res 2
    noise_sfx_addr: .res 2
    noise_music_addr: .res 2
    audio_engine_scratch: .res 1
.popseg

.pushseg
.bss
    audio_update_flag: .res 1
    pulse_1_sfx_note: .res 1
    pulse_1_music_note: .res 1
    pulse_2_sfx_note: .res 1
    pulse_2_music_note: .res 1
    triangle_sfx_note: .res 1
    triangle_music_note: .res 1
    noise_sfx_note: .res 1
    noise_music_note: .res 1
    pulse_1_sfx_volume: .res 1
    pulse_1_music_volume: .res 1
    pulse_2_sfx_volume: .res 1
    pulse_2_music_volume: .res 1
    triangle_sfx_volume: .res 1
    triangle_music_volume: .res 1
    noise_sfx_volume: .res 1
    noise_music_volume: .res 1
    pulse_1_sfx_separation: .res 1
    pulse_1_music_separation: .res 1
    pulse_2_sfx_separation: .res 1
    pulse_2_music_separation: .res 1
    triangle_sfx_separation: .res 1
    triangle_music_separation: .res 1
    noise_sfx_separation: .res 1
    noise_music_separation: .res 1
    pulse_1_sfx_timer: .res 1
    pulse_1_music_timer: .res 1
    pulse_2_sfx_timer: .res 1
    pulse_2_music_timer: .res 1
    triangle_sfx_timer: .res 1
    triangle_music_timer: .res 1
    noise_sfx_timer: .res 1
    noise_music_timer: .res 1
.popseg

CHANNEL_MUTED = %00010000
CHANNEL_DISABLED = %00100000
channel_addr = pulse_1_sfx_addr
channel_note = pulse_1_sfx_note
channel_volume = pulse_1_sfx_volume
channel_separation = pulse_1_sfx_separation
channel_timer = pulse_1_sfx_timer

.pushseg
.segment "CODE"

init_apu:
    lda #$08
    sta PULSE1SWEEP
    sta PULSE2SWEEP
    lda #$80
    sta TRIANGLELINEAR
    lda #$30
    sta PULSE1DUTY
    sta PULSE2DUTY
    sta NOISEVOLUME
    ldy #$08
    :
    dey
    sta channel_volume, y
    bne :-
    lda #$00
    sta PULSE1TIMER
    sta PULSE1LENGTH
    sta PULSE2TIMER
    sta PULSE2LENGTH
    sta TRIANGLETIMER
    sta TRIANGLELENGTH
    sta NOISEPERIOD
    sta NOISELENGTH
    sta audio_update_flag
    lda #$0F
    sta APUSTATUS
    lda #$40
    sta APUFRAMECOUNTER
    rts

update_audio:
    lda audio_update_flag
    beq :+
    rts ; Avoid updating the audio this frame if the audio being updated was interrupted
    :
    ldx #$00
    ldy #$00
    jmp process_channel
after_process_channel:
    tya
    lsr
    beq :+
    lda channel_volume - 1, y
    and #CHANNEL_DISABLED | CHANNEL_MUTED
    beq after_play_channel ; Skip playing music channel if a sound effect is playing
    :
    lda channel_volume, y
    and #CHANNEL_MUTED
    bne silence_channel
    lda channel_timer, y
    cmp channel_separation, y
    bcs play_channel
silence_channel:
    lda channel_volume, y
    and #%11110000
    sta channel_volume, y
play_channel:
    sty audio_engine_scratch
    tya
    lsr
    tay
    lda ChannelHandlerJumpTableHigh, y
    pha
    lda ChannelHandlerJumpTableLow, y
    pha
    ldy audio_engine_scratch
    rts
after_play_channel:
    inx
    inx
    iny
    cpy #$08
    bcc process_channel
    rts
process_channel:
    lda channel_volume, y
    and #CHANNEL_DISABLED
    bne after_process_channel
    lda channel_timer, y
    sec
    sbc #$01
    sta channel_timer, y
    bcs after_process_channel
fetch_next_command:
    lda (channel_addr, x)
    sty audio_engine_scratch
    tay
    jsr increment_channel_pointer
    lda AudioCommandJumpTableHigh, y
    pha
    lda AudioCommandJumpTableLow, y
    pha
    ldy audio_engine_scratch
    rts

; THESE ARE PRIVATE ROUTINES, DO NOT CALL THEM

set_channel_volume:
    lda channel_volume, y
    and #%00110000
    sta audio_engine_scratch
    lda (channel_addr, x)
    ora audio_engine_scratch
    sta channel_volume, y
    jsr increment_channel_pointer
    jmp fetch_next_command

play_note:
    lda (channel_addr, x)
    sta channel_note, y
    jsr increment_channel_pointer
    lda (channel_addr, x)
    sta channel_timer, y
    jsr increment_channel_pointer
    jmp after_process_channel

play_rest:
    lda (channel_addr, x)
    sta channel_timer, y
    jsr increment_channel_pointer
    lda channel_volume, y
    and #%11110000
    sta channel_volume, Y
    jmp after_process_channel

set_separation:
    lda (channel_addr, x)
    sta channel_separation, y
    jsr increment_channel_pointer
    jmp fetch_next_command

goto_loop_point:
    lda (channel_addr, x)
    sta audio_engine_scratch
    jsr increment_channel_pointer
    lda (channel_addr, x)
    sta channel_addr + 1, x
    lda audio_engine_scratch
    sta channel_addr, x
    jsr increment_channel_pointer
    jmp fetch_next_command

end_sound_effect:
    lda channel_volume, y
    ora #CHANNEL_DISABLED
    sta channel_volume, y
    jmp after_process_channel

increment_channel_pointer:
    lda channel_addr, x
    clc
    adc #$01
    sta channel_addr, x
    lda channel_addr + 1, x
    adc #$00
    sta channel_addr + 1, x
    rts

handle_pulse_1:
    lda channel_volume, y
    ora #%00110000
    sta PULSE1DUTY
    lda channel_note, y
    sty audio_engine_scratch
    tay
    lda PeriodTableHigh, y
    sta PULSE1TIMER
    lda PeriodTableLow, y
    sta PULSE1LENGTH
    ldy audio_engine_scratch
    jmp after_play_channel

handle_pulse_2:
    lda channel_note, y
    sty audio_engine_scratch
    tay
    lda PeriodTableHigh, y
    sta PULSE2TIMER
    lda PeriodTableLow, y
    sta PULSE2LENGTH
    ldy audio_engine_scratch
    lda channel_volume, y
    ora #%00110000
    sta PULSE2DUTY
    jmp after_play_channel

handle_triangle:
    lda channel_note, y
    sty audio_engine_scratch
    tay
    lda PeriodTableHigh, y
    lsr
    sta TRIANGLETIMER
    lda PeriodTableLow, y
    ror
    sta TRIANGLELENGTH
    ldy audio_engine_scratch
    lda channel_volume, y
    and #%11000000
    sta TRIANGLELINEAR
    sta APUFRAMECOUNTER
    jmp after_play_channel

handle_noise:
    lda channel_note, y
    sta NOISEPERIOD
    lda channel_volume, y
    ora #%00110000
    sta NOISEVOLUME
    jmp after_play_channel

; Public interface

; Song index in Y
play_song:
    rts

; Channel index in X, SFX index in Y
play_sound_effect:
    rts

.popseg

.pushseg
.segment "RODATA"

.enum 
    SET_VOLUME
    PLAY_NOTE
    PLAY_REST
    SET_SEPARATION
    GOTO_LOOP
    END_SFX
.endenum

.define AudioCommandJumpTable \
    set_channel_volume - 1, \
    play_note - 1, \
    play_rest - 1, \
    set_separation - 1, \
    goto_loop_point - 1, \
    end_sound_effect - 1

AudioCommandJumpTableLow:
    .lobytes AudioCommandJumpTable

AudioCommandJumpTableHigh:
    .hibytes AudioCommandJumpTable

.define ChannelHandlerJumpTable \
    handle_pulse_1 - 1, \
    handle_pulse_2 - 1, \
    handle_triangle - 1, \
    handle_noise - 1

ChannelHandlerJumpTableLow:
    .lobytes ChannelHandlerJumpTable

ChannelHandlerJumpTableHigh:
    .hibytes ChannelHandlerJumpTable

PeriodTableLow:
    .byte $F1, $7F, $13, $AD, $4D, $F3, $9D, $4C, $00, $B8, $74, $34
    .byte $F8, $BF, $89, $56, $26, $F9, $CE, $A6, $80, $5C, $3A, $1A
    .byte $FB, $DF, $C4, $AB, $93, $7C, $67, $52, $3F, $2D, $1C, $0C
    .byte $FD, $EF, $E1, $D5, $C9, $BD, $B3, $A9, $9F, $96, $8E, $86
    .byte $7E, $77, $70, $6A, $64, $5E, $59, $54, $4F, $4B, $46, $42
    .byte $3F, $3B, $38, $34, $31, $2F, $2C, $29, $27, $25, $23, $21
    .byte $1F, $1D, $1B, $1A, $18, $17, $15, $14

PeriodTableHigh:
    .byte $07, $07, $07, $06, $06, $05, $05, $05, $05, $04, $04, $04
    .byte $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $02, $02
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00

.popseg