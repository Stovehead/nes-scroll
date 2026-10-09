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
    audio_engine_scratch: .res 2
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
    pulse_1_sfx_volume_mask: .res 1
    pulse_1_music_volume_mask: .res 1
    pulse_2_sfx_volume_mask: .res 1
    pulse_2_music_volume_mask: .res 1
    triangle_sfx_volume_mask: .res 1
    triangle_music_volume_mask: .res 1
    noise_sfx_volume_mask: .res 1
    noise_music_volume_mask: .res 1
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
    pulse_1_period_high_byte: .res 1
    pulse_2_period_high_byte: .res 1
    triangle_period_high_byte: .res 1
    resume_play_flag: .res 1
.popseg

CHANNEL_MUTED = %00010000
CHANNEL_DISABLED = %00100000
channel_addr = pulse_1_sfx_addr
channel_note = pulse_1_sfx_note
channel_volume = pulse_1_sfx_volume
channel_volume_mask = pulse_1_sfx_volume_mask
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
    lda #$20
    ldy #$08
    :
    dey
    sta channel_volume, y
    bne :-
    rts

.macro increment_channel_pointer
    inc channel_addr, x
    bne :+
        inc channel_addr+1, x
    :
.endmacro

update_audio:
    lda audio_update_flag
    beq :+
    rts ; Avoid updating the audio this frame if the audio being updated was interrupted
    :
    inc audio_update_flag
    ldx #$00
    ldy #$00
    jmp process_channel
after_process_channel:
    tya
    lsr
    bcc play_channel
    lda channel_volume - 1, y
    and #CHANNEL_DISABLED | CHANNEL_MUTED
    beq after_play_channel ; Skip playing music channel if a sound effect is playing
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
    tya
    lsr
    bcc :+
    lda channel_volume, y
    and #CHANNEL_MUTED
    bne silence_channel
    lda channel_timer, y
    cmp channel_separation, y
    bcc silence_channel
    :
    lda channel_volume, y
    sta audio_engine_scratch + 1
    rts
silence_channel:
    lda #%10000000
    sta audio_engine_scratch + 1
    rts
after_play_channel:
    lda audio_update_flag
    bmi :+ ; This is insane
    inx
    inx
    iny
    cpy #$08
    bcc process_channel
    dec audio_update_flag
    :
    rts
process_channel:
    lda channel_volume, y
    and #CHANNEL_DISABLED
    bne after_play_channel
    lda channel_timer, y
    sec
    sbc #$01
    sta channel_timer, y
    beq fetch_next_command
    lda resume_play_flag
    lsr
    sta resume_play_flag
    bcs after_process_channel
    lda channel_timer, y
    cmp channel_separation, y
    bcs after_play_channel
    sty audio_engine_scratch
    tya
    lsr
    tya
    lsr
    bcc :+
    sta audio_engine_scratch + 1
    lda channel_volume - 1, y
    and #CHANNEL_DISABLED | CHANNEL_MUTED
    beq after_play_channel ; Skip playing music channel if a sound effect is playing
    lda audio_engine_scratch + 1
    :
    tay
    lda ChannelHandlerJumpTableHigh, y
    pha
    lda ChannelHandlerJumpTableLow, y
    pha
    ldy audio_engine_scratch
    lda #%10000000
    sta audio_engine_scratch + 1
    rts
fetch_next_command:
    lda (channel_addr, x)
    sty audio_engine_scratch
    tay
    increment_channel_pointer
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
    increment_channel_pointer
    jmp fetch_next_command

play_note:
    lda (channel_addr, x)
    sta channel_note, y
    increment_channel_pointer
    lda (channel_addr, x)
    sta channel_timer, y
    lda #%11111111
    sta channel_volume_mask, y
    increment_channel_pointer
    jmp after_process_channel

play_rest:
    lda (channel_addr, x)
    sta channel_timer, y
    lda #%10000000
    sta channel_volume_mask, y
    increment_channel_pointer
    jmp after_process_channel

set_separation:
    lda (channel_addr, x)
    sta channel_separation, y
    increment_channel_pointer
    jmp fetch_next_command

goto_loop_point:
    lda (channel_addr, x)
    sta audio_engine_scratch
    increment_channel_pointer
    lda (channel_addr, x)
    sta channel_addr + 1, x
    lda audio_engine_scratch
    sta channel_addr, x
    jmp fetch_next_command

end_sound_effect:
    lda channel_volume, y
    ora #CHANNEL_DISABLED
    sta channel_volume, y
    inc resume_play_flag
    jmp after_process_channel

handle_pulse_1:
    lda channel_note, y
    sty audio_engine_scratch
    tay
    lda PeriodTableHigh, y
    cmp pulse_1_period_high_byte
    beq :+
    sta PULSE1LENGTH
    :
    sta pulse_1_period_high_byte
    lda PeriodTableLow, y
    sta PULSE1TIMER
    ldy audio_engine_scratch
    lda audio_engine_scratch + 1
    and channel_volume_mask, y
    ora #%00110000
    sta PULSE1DUTY
    jmp after_play_channel

handle_pulse_2:
    lda channel_note, y
    sty audio_engine_scratch
    tay
    lda PeriodTableHigh, y
    cmp pulse_2_period_high_byte
    beq :+
    sta PULSE2LENGTH
    :
    sta pulse_2_period_high_byte
    lda PeriodTableLow, y
    sta PULSE2TIMER
    ldy audio_engine_scratch
    lda audio_engine_scratch + 1
    and channel_volume_mask, y
    ora #%00110000
    sta PULSE2DUTY
    jmp after_play_channel

handle_triangle:
    lda channel_note, y
    sty audio_engine_scratch
    tay
    lda PeriodTableHigh, y
    cmp triangle_period_high_byte
    beq :+
    sta TRIANGLELENGTH
    :
    sta triangle_period_high_byte
    lda PeriodTableLow, y
    sta TRIANGLETIMER
    ldy audio_engine_scratch
    lda audio_engine_scratch + 1
    and channel_volume_mask, y
    sta TRIANGLELINEAR
    sta APUFRAMECOUNTER
    jmp after_play_channel

handle_noise:
    lda channel_note, y
    sta NOISEPERIOD
    lda audio_engine_scratch + 1
    and channel_volume_mask, y
    ora #%00110000
    sta NOISEVOLUME
    jmp after_play_channel

; Public interface

; Song index in Y
play_song:
    cpy NumSongs
    bcc :+
    rts
    :
    inc audio_update_flag
    lda SongPulse1PointersLow, y
    sta pulse_1_music_addr
    lda SongPulse1PointersHigh, y
    sta pulse_1_music_addr + 1
    lda SongPulse2PointersLow, y
    sta pulse_2_music_addr
    lda SongPulse2PointersHigh, y
    sta pulse_2_music_addr + 1
    lda SongTrianglePointersLow, y
    sta triangle_music_addr
    lda SongTrianglePointersHigh, y
    sta triangle_music_addr + 1
    lda SongNoisePointersLow, y
    sta noise_music_addr
    lda SongNoisePointersHigh, y
    sta noise_music_addr + 1
    lda #$00
    sta pulse_1_music_volume
    sta pulse_2_music_volume
    sta triangle_music_volume
    sta noise_music_volume
    lda #$01
    sta pulse_1_music_timer
    sta pulse_2_music_timer
    sta triangle_music_timer
    sta noise_music_timer
    dec audio_update_flag
    rts

; Channel index in X, SFX index in Y
play_sound_effect:
    inc audio_update_flag
    lda channel_volume, x
    and #$FF ^ CHANNEL_DISABLED ^ CHANNEL_MUTED
    sta channel_volume, x
    lda #$01
    sta channel_timer, x
    txa
    asl
    tax
    lda SoundEffectPointersLow, y
    sta channel_addr, x
    lda SoundEffectPointersHigh, y
    sta channel_addr + 1, x
    dec audio_update_flag
    rts

; Channel index in Y
mute_channel:
    dec audio_update_flag
    lda channel_volume, y
    ora #CHANNEL_MUTED
    sta channel_volume, y
    jsr after_process_channel
    inc audio_update_flag
    rts

unmute_channel:
    dec audio_update_flag
    lda channel_volume, y
    and #$FF ^ CHANNEL_MUTED
    sta channel_volume, y
    jsr after_process_channel
    inc audio_update_flag
    rts

pause_audio:
    dec audio_update_flag
    lda #%00110000
    sta PULSE1DUTY
    sta PULSE2DUTY
    sta NOISEVOLUME
    lda #%10000000
    sta TRIANGLELINEAR
    sta APUFRAMECOUNTER
    rts

unpause_audio:
    ldy #$00
    :
    jsr after_process_channel
    iny
    cpy #$08
    bcc :-
    inc audio_update_flag
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

.enum Note
    A0
    As0
    Bf0 = As0
    B0
    Bs0 = C1
    Cf1 = B0
    C1
    Cs1
    Df1 = Cs1
    D1
    Ds1
    Ef1 = Ds1
    E1
    Es1 = F1
    Ff1 = E1
    F1
    Fs1
    Gf1 = Fs1
    G1
    Gs1
    Af1 = Gs1
    A1
    As1
    Bf1 = As1
    B1
    Bs1 = C2
    Cf2 = B1
    C2
    Cs2
    Df2 = Cs2
    D2
    Ds2
    Ef2 = Ds2
    E2
    Es2 = F2
    Ff2 = E2
    F2
    Fs2
    Gf2 = Fs2
    G2
    Gs2
    Af2 = Gs2
    A2
    As2
    Bf2 = As2
    B2
    Bs2 = C3
    Cf3 = B2
    C3
    Cs3
    Df3 = Cs3
    D3
    Ds3
    Ef3 = Ds3
    E3
    Es3 = F3
    Ff3 = E3
    F3
    Fs3
    Gf3 = Fs3
    G3
    Gs3
    Af3 = Gs3
    A3
    As3
    Bf3 = As3
    B3
    Bs3 = C4
    Cf4 = B3
    C4
    Cs4
    Df4 = Cs4
    D4
    Ds4
    Ef4 = Ds4
    E4
    Es4 = F4
    Ff4 = E4
    F4
    Fs4
    Gf4 = Fs4
    G4
    Gs4
    Af4 = Gs4
    A4
    As4
    Bf4 = As4
    B4
    Bs4 = C5
    Cf5 = B4
    C5
    Cs5
    Df5 = Cs5
    D5
    Ds5
    Ef5 = Ds5
    E5
    Es5 = F5
    Ff5 = E5
    F5
    Fs5
    Gf5 = Fs5
    G5
    Gs5
    Af5 = Gs5
    A5
    As5
    Bf5 = As5
    B5
    Bs5 = C6
    Cf6 = B5
    C6
    Cs6
    Df6 = Cs6
    D6
    Ds6
    Ef6 = Ds6
    E6
    Es6 = F6
    Ff6 = E6
    F6
    Fs6
    Gf6 = Fs6
    G6
    Gs6
    Af6 = Gs6
    A6
    As6
    Bf6 = As6
    B6
    Bs6 = C7
    Cf7 = B6
    C7
    Cs7
    Df7 = Cs7
    D7
    Ds7
    Ef7 = Ds7
    E7
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