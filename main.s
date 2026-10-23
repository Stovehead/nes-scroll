.feature line_continuations +

PPUCTRL = $2000
PPUMASK = $2001
PPUSTATUS = $2002
OAMADDR = $2003
OAMDATA = $2004
PPUSCROLL = $2005
PPUADDR = $2006
PPUDATA = $2007
OAMDMA = $4014
JOY1 = $4016
JOY2 = $4017
JMP_OPCODE = $4C
RTI_OPCODE = $40
OAMBUFFER = $0200
BUTTON_A =      %10000000
BUTTON_B =      %01000000
BUTTON_SELECT = %00100000
BUTTON_START =  %00010000
BUTTON_UP =     %00001000
BUTTON_DOWN =   %00000100
BUTTON_LEFT =   %00000010
BUTTON_RIGHT =  %00000001
SCROLL_SPEED = 8
OBJECT_FLIPPED_V =      %10000000
OBJECT_FLIPPED_H =      %01000000
OBJECT_IS_PRIORITY =    %00100000
OBJECT_IS_HIDDEN =      %00010000
SUBPIXEL_MASK = %00000111
PAGE_MASK = %11111000
COLLISION_TOP =     %00000001
COLLISION_RIGHT =   %00000010
COLLISION_BOTTOM =  %00000100
COLLISION_LEFT =    %00001000
COLLISION_ONLY_WHEN_LIGHTS_ON = %00010000
GRAVITY = 2 ; Subpixels per frame
LIGHT_GRAVITY = 1 ; Subpixels per frame
TERMINAL_VELOCITY = 64 ; Subpixels per frame
LIGHTS_OFF = %00000001

.zeropage
    scratch: .res $10
    frame_done: .res 1
    frame_count: .res 1
    background_color: .res 1
    background_palettes: .res 12
    sprite_palettes: .res 12
    brightness: .res 1
    current_page: .res 1
    x_scroll: .res 1
    y_scroll: .res 1
    x_scroll_offset: .res 1
    y_scroll_offset: .res 1
    current_ppu_mask: .res 1
    current_ppu_ctrl: .res 1
    current_level: .res 1
    game_state: .res 1
    controller_input_prev: .res 1
    controller_input: .res 1
    buttons_pressed: .res 1
    buttons_released: .res 1
    vram_buffer_index: .res 1
    oam_offset: .res 1
    collision_buffer: .res 12
    collision_wrap_flag: .res 1
    level_flags: .res 1
    left_object_pointer: .res 2
    left_object_index: .res 1
    right_object_pointer: .res 2
    right_object_index: .res 1
    skip_light_switch_collision: .res 1
    light_fade_timer: .res 1
    seed: .res 2
    nmi_jump: .res 3
    game_paused: .res 1
    player_hp: .res 1
    dramatic_pause_timer: .res 1
    screen_fading: .res 1
    player_has_no_control: .res 1
    respawn_timer: .res 1
    where_to_go_after_fade_out: .res 2
    split_scroll_position = level_flags
    intro_stage = left_object_index
    current_opening_line = left_object_pointer
    current_line_character = left_object_pointer + 1
    character_draw_timer = left_object_index
    is_drawing_line = right_object_pointer
    shake_mask = right_object_pointer + 1
    shake_timer = right_object_index

.bss
    object_ids: .res $10
    object_x_positions: .res $10
    object_y_positions: .res $10
    object_x_page_subpixels: .res $10
    object_y_page_subpixels: .res $10
    object_flags: .res $10
    object_animations_ids: .res $10
    object_animations_frames: .res $10
    object_animation_timers: .res $10
    object_current_metasprites: .res $10
    object_indices: .res $10
    object_variables_0: .res $10
    object_variables_1: .res $10
    object_variables_2: .res $10
    object_variables_3: .res $10
    object_variables_4: .res $10
    object_spawned_flags: .res 32
    object_dead_flags: .res 32
    tile_buffer_1 = OAMBUFFER
    tile_buffer_2 = tile_buffer_1 + 30
    tile_buffer_3 = tile_buffer_2 + 30
    tile_buffer_4 = tile_buffer_3 + 30

.segment "HEADER"  
    .byte $4E, $45, $53, $1A    ; iNES header identifier
    .byte 2                     ; 2x 16KB PRG code
    .byte 1                     ; 1x  8KB CHR data
    .byte $01, $00              ; mapper 0, vertical mirroring

.segment "VECTORS"
    .addr nmi_jump
    .addr reset
    .addr crash_handler

.segment "STARTUP"

.segment "RODATA"

    .byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
    .byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
    .byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
    .byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
Colors:
    .byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0F, $0E, $0F
    .byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $00
    .byte $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $10
    .byte $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $30
    .byte $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    .byte $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    .byte $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    .byte $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30

; Put this at the top to ensure alignment

.segment "CODE"

.macro update_nmi NewAddr
    lda #RTI_OPCODE
    sta nmi_jump ; Replace JMP with RTI in case NMI interrupts this
    lda #<NewAddr
    sta nmi_jump + 1
    lda #>NewAddr
    sta nmi_jump + 2
    lda #JMP_OPCODE
    sta nmi_jump
.endmacro

reset:
    sta scratch + 1
    beq @zero_flag_set
    bmi @minus_flag_set
    lda #$00
    beq @after_get_zero_minus_flags
    @minus_flag_set:
    lda #%10000000
    bne @after_get_zero_minus_flags
    @zero_flag_set:
    bmi @zero_and_minus_flags_set
    lda #%00000010
    bne @after_get_zero_minus_flags
    @zero_and_minus_flags_set:
    bmi @zero_and_minus_flags_set
    lda #%10000010
    @after_get_zero_minus_flags:
    bcc @carry_flag_not_set
    ora #$01
    @carry_flag_not_set:
    sta scratch + 5
    lda #$00
    sta PPUCTRL
    sei
    cld
    stx scratch + 2
    sty scratch + 3
    tsx
    stx scratch + 4
    ldx #$40
    stx $4017  ; disable APU frame IRQ
    ldx #$ff
    txs        ; set stack pointer to $01ff
    inx        ; now X = 0
    stx $2001  ; disable rendering
    stx $4010  ; disable DMC IRQs


    ; Optional (omitted):
    ; Set up mapper and jmp to further init code here.

    ; The vblank flag is in an unknown state after reset,
    ; so it is cleared here to make sure that @vblankwait1
    ; does not exit immediately.
    bit $2002

    ; First of two waits for vertical blank to make sure that the
    ; PPU has stabilized
@vblankwait1:
    bit $2002
    bpl @vblankwait1

    lda #$01
    sta JOY1
    lsr
    sta JOY1
    lda JOY1
    lsr
    bcc :+
    lda JOY1
    lsr
    bcc :+
    lda JOY1
    lsr
    bcc :+
    lda JOY1
    lsr
    bcc :+
    jmp crash_handler_after_preserve_vars
    :

    ; We now have about 30,000 cycles to burn before the PPU stabilizes.
    ; One thing we can do with this time is put RAM in a known state.
    ; Here we fill it with $00, which matches what (say) a C compiler
    ; expects for BSS. Since we haven't modified the X register since
    ; the earlier code above, it's still set to 0, so we can just
    ; transfer it to the Accumulator and save a byte
    txa
@clrmem:
    sta $00,x
    sta $100,x
    sta $200,x
    sta $300,x
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    inx
    bne @clrmem

    ; Other things you can do between vblank waits are set up audio
    ; or set up other mapper registers.

@vblankwait2:
    bit $2002
    bpl @vblankwait2

main:
    ldx #$00 ; Init OAM
    lda #$FF
    :
    sta OAMBUFFER, x
    inx
    bne :-

    dec seed

    lda #$00 ; Is this necessary?
    sta OAMADDR

    lda #%00011110  ; Enable rendering
    sta current_ppu_mask

    jsr init_apu

    lda TitleScreenPalette
    sta background_color
    ldy #$01
    :
    lda TitleScreenPalette, y
    sta background_palettes - 1, y
    iny
    cpy #25
    bcc :-

    jsr read_controllers
    lda controller_input
    and #BUTTON_START
    beq :+
    inc frame_done
    update_nmi load_level
    jmp :++
    :

    update_nmi intro_setup_nmi
    :
    lda #%10101000	; Enable NMI and set sprite size
    sta current_ppu_ctrl
    bit PPUSTATUS
    sta PPUCTRL
    dec frame_done

forever:
    jmp forever

rand:
    lda seed+1
	tay ; store copy of high byte
	; compute seed+1 ($39>>1 = %11100)
	lsr ; shift to consume zeroes on left...
	lsr
	lsr
	sta seed+1 ; now recreate the remaining bits in reverse order... %111
	lsr
	eor seed+1
	lsr
	eor seed+1
	eor seed+0 ; recombine with original low byte
	sta seed+1
	; compute seed+0 ($39 = %111001)
	tya ; original high byte
	sta seed+0
	asl
	eor seed+0
	asl
	eor seed+0
	asl
	asl
	asl
	eor seed+0
	sta seed+0
	rts

push_palettes_to_ppu:
    lda #>Colors
    sta scratch + 1
    lda #<Colors
    sta scratch
    lda brightness
    ldy game_paused
    bne :+ ; Darken the screen if the game is paused
    clc
    adc #$02
    :
    sec
    sbc #$01
    cmp #$80
    ror
    bcs @no_emphasis
    cmp #$01
    bpl @no_emphasis
    @add_emphasis:
    tay
    lda current_ppu_mask
    ora #%11100000
    jmp @after_emphasis
    @no_emphasis:
    tay
    lda current_ppu_mask
    and #%00011111
    @after_emphasis:
    sta current_ppu_mask
    tya
    asl
    asl
    asl
    asl
    clc
    bmi @negative_brightness
    adc scratch
    sta scratch
    lda scratch + 1
    adc #$00
    sta scratch + 1
    jmp @after_calculate_color_table_address
    @negative_brightness:
    adc scratch
    sta scratch
    lda scratch + 1
    sbc #$00
    sta scratch + 1
    @after_calculate_color_table_address:
    lda current_ppu_ctrl
    and #%11111011 ; Set PPU increment to right
    sta current_ppu_ctrl
    bit PPUSTATUS
    sta PPUCTRL
    lda #$3F
    sta PPUADDR
    lda #$01
    sta PPUADDR
    .repeat 4, i
    .if i <> 0
    sta PPUDATA
    .endif
    .repeat 3, j
    ldy background_palettes + i * 3 + j
    lda (scratch), y
    sta PPUDATA
    .endrepeat
    .endrepeat
    ldy background_color
    lda (scratch), y
    ldx game_paused
    beq :+
    sta PPUDATA
    lda #$20
    sta PPUDATA
    rts
    :
    .repeat 4, i
    sta PPUDATA
    .repeat 3, j
    ldy sprite_palettes + i * 3 + j
    lda (scratch), y
    sta PPUDATA
    .endrepeat
    .endrepeat
    rts

normal_nmi:
    pha ; Save A register
    lda frame_done
    bne @after_early_return
    txa
    pha
    tya
    pha
    jsr update_audio
    pla
    tay
    pla
    tax
    pla
    rti
@after_early_return:

@vblank_routine:
    inc frame_done ; Set back to 0
    pla ; Restore A register, not really needed
    lda #$02 ; Push sprites to OAM
    sta OAMDMA

@push_vram_updates:
    tsx
    stx scratch
    ldx #$FF
    txs
    @pop_loop:
    pla
    beq @end_pop_loop
    tax
    pla
    sta PPUCTRL
    pla
    sta PPUADDR
    pla
    sta PPUADDR
    @loop:
    pla
    sta PPUDATA
    dex
    bne @loop
    jmp @pop_loop
    @end_pop_loop:
    ldx scratch
    txs
    lda #$00
    sta $0100
    sta vram_buffer_index
    jsr push_palettes_to_ppu

    @after_update_palettes:
    bit PPUSTATUS ; Set scroll
    lda x_scroll
    eor x_scroll_offset
    sta PPUSCROLL
    lda y_scroll
    eor y_scroll_offset
    sta PPUSCROLL

    lda current_ppu_mask
    sta PPUMASK

    lda current_ppu_ctrl
    sta PPUCTRL

    jsr update_audio

    ldy game_state
    lda GameLoopJumpTableHigh, y
    pha
    lda GameLoopJumpTableLow, y
    pha
    rts

intro_logic:
    inc frame_count
    lda intro_stage
    bne :+
    lda frame_count
    cmp #80
    bcs :+
    dec frame_done
    rti
    :
    jsr rand
    @check_sprite_0_clear:
    bit PPUSTATUS
    bvs @check_sprite_0_clear
    @check_sprite_0:
    bit PPUSTATUS
    bvc @check_sprite_0
    lda level_flags ; Use this byte as the scroll for the bottom half of the screen
    sta PPUSCROLL
    lda current_ppu_ctrl
    and #%11111110
    sta PPUCTRL
    inc x_scroll
    inc x_scroll
    inc x_scroll
    inc x_scroll
    dec level_flags
    dec level_flags
    dec level_flags
    dec level_flags
    lda x_scroll
    cmp #$B0
    bcc :+
    lda frame_count
    and #%00000011
    bne :+
    inc brightness
    :
    lda frame_count
    cmp #160
    bcs :+
    dec frame_done
    rti
    :
    update_nmi title_screen_setup_nmi
    rti

title_screen_logic:
    inc frame_count
    jsr read_controllers
    lda buttons_pressed
    and #BUTTON_START
    beq :+
    jsr init_apu
    lda #$00
    sta scratch + 1
    lda #$04
    sta scratch + 2
    sta scratch + 3
    lda #$0D
    sta scratch
    update_nmi wipe_nmi
    rti
    :
    lda frame_count
    and #%00011111
    bne @after_handle_text
    lda #11
    sta $0100
    lda #$00 ; Set VRAM address increment to horizontal
    sta $0101
    lda #$22
    sta $0102
    lda #$CA
    sta $0103
    lda frame_count
    and #%00100000
    bne @draw_press_start
    ldy #11
    lda #$06
    :
    sta $0103, y
    dey
    bne :-
    jmp @after_handle_text
    @draw_press_start:
    ldy #$00
    :
    lda PressStartString, y
    beq :+
    sta $0104, y
    iny
    jmp :-
    :
    @after_handle_text:
    ldy #$04
    ldx #$00
    @draw_star_loop:
    txa
    lsr
    lda object_y_positions, x
    sbc object_variables_0, x
    sbc #$02
    sta object_y_positions, x
    sta OAMBUFFER, y
    iny
    inc object_variables_1, x
    lda object_variables_1, x
    asl
    asl
    asl
    asl
    bcc :+
    lda #$D1
    jmp @after_determine_star_sprite
    :
    lda #$D3
    @after_determine_star_sprite:
    sta OAMBUFFER, y
    iny
    lda object_variables_1, x
    and #%00011000
    lsr
    lsr
    lsr
    ora #%00100000
    sta OAMBUFFER, y
    iny
    lda object_x_positions, x
    sta OAMBUFFER, y
    iny
    inx
    cpx #$10
    bcc @draw_star_loop
    dec frame_done
    rti

opening_logic:
    lda screen_fading
    beq @screen_not_fading
    dec brightness
    lda brightness
    cmp #$F8
    bcs :+
    lda #$00
    sta screen_fading
    jmp (where_to_go_after_fade_out)
    @screen_not_fading:
    jsr read_controllers
    lda buttons_pressed
    and #BUTTON_START
    beq :+
    lda #$01
    sta screen_fading
    lda #<load_level
    sta where_to_go_after_fade_out
    lda #>load_level
    sta where_to_go_after_fade_out + 1
    :
    lda is_drawing_line
    bne @draw_line
    dec character_draw_timer
    bne :+
    inc is_drawing_line
    lda #4
    sta character_draw_timer
    :
    jmp @after_draw_character
    @draw_line:
    ldx current_opening_line
    cpx #$04
    bcs @after_draw_character
    ldy current_line_character
    dec character_draw_timer
    bne @after_draw_character
    lda OpeningLinePointersLow, x
    sta scratch
    lda OpeningLinePointersHigh, x
    sta scratch + 1
    lda (scratch), y
    bne :+
    dec is_drawing_line
    inc current_opening_line
    lda #30
    sta character_draw_timer
    lda #$00
    sta current_line_character
    jmp @after_draw_character
    :
    sta $104
    tya
    clc
    adc OpeningStringLocationsLow, x
    sta $103
    lda OpeningStringLocationsHigh, x
    adc #$00
    sta $102
    lda #$01
    sta $100
    lda #$00
    sta $101
    sta $105
    iny
    sty current_line_character
    lda #4
    sta character_draw_timer
    @after_draw_character:
    jsr rand
    dec shake_timer
    bne :+
    lda #200
    sta shake_timer
    sec
    rol shake_mask
    lda shake_mask
    cmp #%00000111
    bcc :+
    lda #$01
    sta screen_fading
    lda #<load_level
    sta where_to_go_after_fade_out
    lda #>load_level
    sta where_to_go_after_fade_out + 1
    :
    lda seed
    and shake_mask
    bit seed
    bmi :+
    sta scratch
    lda #$00
    sec
    sbc scratch
    :
    clc
    adc #$08
    sta x_scroll
    lda seed + 1
    and shake_mask
    bit seed + 1
    bmi :+
    sta scratch
    lda #$00
    sec
    sbc scratch
    :
    cmp #240
    bcc :+
    sec
    sbc #$10
    :
    sta y_scroll
    @return:
    dec frame_done
    rti

reload_level:
    update_nmi load_level
    rti

gameplay_logic:
    lda dramatic_pause_timer
    beq @no_dramatic_pause
    inc frame_count
    lda dramatic_pause_timer
    cmp #10
    bcc :+
    jsr rand
    lda seed
    and #%00000001
    sta x_scroll_offset
    lda seed + 1
    and #%00000001
    sta y_scroll_offset
    jmp :++
    :
    lda #$00
    sta x_scroll_offset
    sta y_scroll_offset
    :
    dec dramatic_pause_timer
    bne :+
    ldy #Songs::DEATH_SOUND
    jsr play_song
    lda #120
    sta respawn_timer
    lda #<reload_level
    sta where_to_go_after_fade_out
    lda #>reload_level
    sta where_to_go_after_fade_out + 1
    jmp @build_sprites
    :
    jmp @build_sprites
    @no_dramatic_pause:
    lda player_has_no_control
    bne :+
    jsr read_controllers
    jmp :++
    :
    lda #$00
    sta controller_input
    sta controller_input_prev
    sta buttons_pressed
    sta buttons_released
    :
    lda respawn_timer
    beq :+
    dec respawn_timer
    bne :+
    lda #$FF
    sta screen_fading
    :
    lda game_paused
    beq @game_not_paused
    lda buttons_pressed
    and #BUTTON_START
    bne :+
    dec frame_done
    rti
    :
    dec game_paused
    lda current_ppu_ctrl
    ora #%00100000
    sta current_ppu_ctrl
    jsr unpause_audio
    jmp @after_check_pause_button
    @game_not_paused:
    inc frame_count
    lda screen_fading
    beq @screen_not_fading
    bmi @fade_out
    @fade_in:
    inc brightness
    lda brightness
    bpl :+
    jmp @after_check_pause_button
    :
    lda #$00
    sta screen_fading
    jmp @after_check_pause_button
    @fade_out:
    dec brightness
    lda brightness
    cmp #$F8
    bcs @after_check_pause_button
    lda #$00
    sta screen_fading
    jmp (where_to_go_after_fade_out)
    @screen_not_fading:
    lda buttons_pressed
    and #BUTTON_START
    beq @after_check_pause_button
    inc game_paused
    jsr pause_audio
    ldy #$77
    lda #$68
    ldx #$00
    sty OAMBUFFER
    stx OAMBUFFER + 2
    sta OAMBUFFER + 3
    clc
    adc #$08
    sty OAMBUFFER + 4
    stx OAMBUFFER + 6
    sta OAMBUFFER + 7
    adc #$08
    sty OAMBUFFER + 8
    stx OAMBUFFER + 10
    sta OAMBUFFER + 11
    adc #$08
    sty OAMBUFFER + 12
    stx OAMBUFFER + 14
    sta OAMBUFFER + 15
    adc #$08
    sty OAMBUFFER + 16
    stx OAMBUFFER + 18
    sta OAMBUFFER + 19
    adc #$08
    sty OAMBUFFER + 20
    stx OAMBUFFER + 22
    sta OAMBUFFER + 23
    adc #$08
    ldy #$01
    ldx #$00
    :
    lda PauseString, x
    beq @after_write_pause_string
    sta OAMBUFFER, y
    inx
    iny
    iny
    iny
    iny
    jmp :-
    @after_write_pause_string:
    lda current_ppu_ctrl
    and #%11011111 ; Set sprite size to 8x8
    sta current_ppu_ctrl
    lda #$FF
    dey
    jmp @start_ff_fill_loop
    @after_check_pause_button:

    lda buttons_pressed
    and #BUTTON_SELECT
    beq :++
    lda current_level
    clc
    adc #$01
    cmp NumLevels
    bcc :+
    lda #$00
    :
    sta current_level
    update_nmi load_level
    rti
    :

    lda buttons_pressed
    and #BUTTON_UP
    beq :+
    lda #$01
    sta player_hp
    :

    lda frame_count ; Shuffle palette for computer level
    and #%00000011
    cmp #$00
    bne :+
    lda current_level
    cmp #$01
    bne :+
    ldx background_palettes + 6
    lda background_palettes + 7
    sta background_palettes + 6
    lda background_palettes + 8
    sta background_palettes + 7
    stx background_palettes + 8
    lda level_flags
    and #LIGHTS_OFF
    bne :+
    ldx background_palettes + 9
    lda background_palettes + 10
    sta background_palettes + 9
    lda background_palettes + 11
    sta background_palettes + 10
    stx background_palettes + 11
    :

    ; Step code for each object
    ldx #$00
    @start_step_code_loop:
    lda object_ids, x
    beq @end_step_code_loop ; Skip object 0 (invalid)
    cmp NumObjects
    bcs @end_step_code_loop ; Skip objects with indices that are out of bounds
    tay
    lda ObjectStepPointersLow, y
    sta scratch
    lda ObjectStepPointersHigh, y
    sta scratch + 1
    jsr dynamic_jump
    @end_step_code_loop:
    inx
    cpx #$10
    bcc @start_step_code_loop

    lda #$00
    sta skip_light_switch_collision

    lda light_fade_timer ; Handle fading lights out
    beq @after_handle_light_fade
    sec
    sbc #$01
    bne @store_new_light_fade_timer
    lda level_flags
    and #LIGHTS_OFF
    bne @lights_turning_off
    inc brightness
    beq @store_new_light_fade_timer
    lda #LIGHT_SWITCH_FADE_LENGTH
    jmp @store_new_light_fade_timer
    @lights_turning_off:
    lda #$00
    ldx brightness
    dex
    stx brightness
    cpx #$FC
    bcc @store_new_light_fade_timer
    lda #LIGHT_SWITCH_FADE_LENGTH
    @store_new_light_fade_timer:
    sta light_fade_timer
    @after_handle_light_fade:

    jsr handle_scroll
    jsr spawn_objects_after_scroll
    @build_sprites:
    ; Build sprites
    ldx #$00
    ldy player_hp
    beq @after_build_health_bar
    ldx #$04
    lda #$10
    sta OAMBUFFER
    sta OAMBUFFER + 3
    lda #$02
    sta OAMBUFFER + 2
    cpy #$01
    bne :+
    lda #$23
    sta OAMBUFFER + 1
    jmp @after_build_health_bar
    :
    lda #$21
    sta OAMBUFFER + 1
    cpy #$02
    beq @after_build_health_bar
    ldx #$08
    lda #$20
    sta OAMBUFFER + 4
    lda #$02
    sta OAMBUFFER + 6
    lda #$10
    sta OAMBUFFER + 7
    cpy #$03
    bne :+
    lda #$23
    sta OAMBUFFER + 5
    jmp @after_build_health_bar
    :
    lda #$21
    sta OAMBUFFER + 5
    cpy #$04
    beq @after_build_health_bar
    ldx #$0C
    lda #$30
    sta OAMBUFFER + 8
    lda #$02
    sta OAMBUFFER + 10
    lda #$10
    sta OAMBUFFER + 11
    cpy #$05
    bne :+
    lda #$23
    sta OAMBUFFER + 9
    jmp @after_build_health_bar
    :
    lda #$21
    sta OAMBUFFER + 9
    @after_build_health_bar:
    stx oam_offset ; Number of bytes in OAM we've used so far
    stx scratch + 2 ; Flag for if we've made any sprites
    ldx #$00
    jsr build_sprite
    lda frame_count
    and #$0F
    bne :+
    clc
    adc #$07
    :
    sta scratch + 3 ; Index to start from
    tax
    @start_build_sprite_loop:
    jsr build_sprite
    txa
    clc
    adc #$07
    and #$0F
    bne :+
    clc
    adc #$07
    :
    cmp scratch + 3
    beq :+
    tax
    jmp @start_build_sprite_loop ; Loop until we reach the one we started on
    :
    ldy oam_offset
    bne :+
    lda scratch + 2
    bne @after_ff_fill_loop
    :
    lda #$FF
    @start_ff_fill_loop:
    sta OAMBUFFER, y
    iny
    iny
    iny
    iny
    bne @start_ff_fill_loop
    @after_ff_fill_loop:

    dec frame_done ; Set to 255
    rti

build_sprite:
    @start_build_sprite_loop:
    lda object_ids, x
    bne :+
    jmp @end_build_sprite_loop ; Don't draw object of index 0
    :
    lda object_flags, x
    and #OBJECT_IS_HIDDEN
    beq :+
    jmp @end_build_sprite_loop ; Skip if it's hidden
    :
    lda object_current_metasprites, x
    cmp NumMetaSprites ; Check if the index is out of bounds
    bcc :+
    jmp @end_build_sprite_loop
    :
    tay
    lda MetaSpritePointersLow, y
    sta scratch
    lda MetaSpritePointersHigh, y
    sta scratch + 1
    ldy #$00
    lda (scratch), y
    sta scratch + 4 ; Store number of sprites
    asl
    asl
    sec
    sbc #$01
    clc
    adc oam_offset
    bcc :+
    rts ; Don't try to do more than 64 sprites
    :
    iny
    lda (scratch), y
    sta scratch + 14 ; Store width
    iny
    lda (scratch), y
    sta scratch + 15 ; Store height
    stx scratch + 5 ; Store current object index
    ldx #$00
    @start_single_sprite_loop:
    iny
    lda (scratch), y
    sta scratch + 7 ; Store sprite index
    iny
    lda (scratch), y
    sta scratch + 8 ; Store sprite x offset
    iny
    lda (scratch), y
    sta scratch + 9 ; Store sprite y offset
    iny
    lda (scratch), y
    sta scratch + 10 ; Store sprite attributes
    sty scratch + 13 ; Store current index
    lda scratch + 8
    stx scratch + 6 ; Store current sprite index
    ldx scratch + 5
    lda object_flags, x
    and #OBJECT_FLIPPED_H
    beq :+
    lda scratch + 14
    sec
    sbc scratch + 8 ; Change x position if flipped
    sec
    sbc #8
    sta scratch + 8
    :
    lda object_x_page_subpixels, x
    lsr
    lsr
    lsr
    sta scratch + 11
    lda object_x_positions, x
    sta scratch + 12
    lda scratch + 8
    cmp #%10000000
    bcs @negative_x_offset
    ; clc
    adc scratch + 12
    sta scratch + 12
    lda scratch + 11
    adc #$00
    sta scratch + 11
    jmp @after_add_offset
    @negative_x_offset:
    clc
    adc scratch + 12
    sta scratch + 12
    lda scratch + 11
    sbc #$00
    sta scratch + 11
    @after_add_offset:
    cmp current_page
    bcs :+
    jmp @end_single_sprite_loop ; Skip if this sprite is on the previous page
    :
    bne @check_sprite_on_next_page
    lda scratch + 12
    sec
    sbc x_scroll
    bcs :+
    jmp @end_single_sprite_loop ; Skip if this sprite is behind the screen
    :
    jmp @after_determine_x_position
    @check_sprite_on_next_page:
    sec
    sbc #$01
    cmp current_page
    beq :+
    jmp @end_single_sprite_loop ; Skip if this sprite is not on the next page
    :
    lda scratch + 12
    sec
    sbc x_scroll
    bcc :+
    jmp @end_single_sprite_loop ; Skip if this sprite is beyond the screen
    :
    @after_determine_x_position:
    sta scratch + 8 ; Store sprite x offset
    lda scratch + 9
    lda object_flags, x
    and #OBJECT_FLIPPED_V
    beq :+
    lda scratch + 15
    sec
    sbc scratch + 9 ; Change y position if flipped
    sec
    sbc #16
    sta scratch + 9
    :
    lda object_y_positions, x
    clc
    adc scratch + 9
    bcs :+
    cmp #240
    bcc :++
    :
    adc #15
    :
    cmp y_scroll
    bcs :+
    sbc #15
    :
    clc ; Account for one-pixel offset
    sbc y_scroll
    ldy oam_offset
    sta OAMBUFFER, y ; Store y position in OAM
    iny
    lda scratch + 7
    sta OAMBUFFER, y ; Store sprite index in OAM
    iny
    lda object_flags, x
    and #%11100000
    eor scratch + 10
    sta OAMBUFFER, y ; Store attributes in OAM
    iny
    lda scratch + 8
    sta OAMBUFFER, y ; Store x position in OAM
    iny
    sty oam_offset
    lda #$01
    sta scratch + 2
    @end_single_sprite_loop:
    ldy scratch + 13
    ldx scratch + 6
    inx
    cpx scratch + 4
    bcs :+
    jmp @start_single_sprite_loop
    :
    ldx scratch + 5
    @end_build_sprite_loop:
    rts

.macro burn_12_and_two_thirds_cycles
.scope
        clc
        lda scratch + 1
        adc #170
        sta scratch + 1
        bcs continue
continue:
.endscope
.endmacro

wipe_nmi:
    lda #$02 ; Push sprites to OAM
    sta OAMDMA
    @do_wipe:
    inc scratch
    inc scratch
    inc scratch
    inc scratch
    lda #%00001110
    sta PPUMASK
    lda #%10110001
    sta PPUCTRL
    ldy #$0E
    :
    dey
    bne :-
    ldx scratch
    :
    ldy #$13
    :
    dey
    bne :-
    burn_12_and_two_thirds_cycles
    dex
    bne :--
    lda scratch
    cmp #$86
    bcc :+
    lda #GameState::OPENING
    sta game_state
    update_nmi opening_setup_nmi
    lda #%00010000
    sta NOISEVOLUME
    dec frame_done
    rti
    :
    lda #%10110000
    sta PPUCTRL
    lda #%00011110
    sta PPUMASK
    @check_sprite_0:
    bit PPUSTATUS
    bvc @check_sprite_0
    lda #%10110001
    sta PPUCTRL
    ldy #$10
    :
    dey
    bne :-
    lda #%00001110
    sta PPUMASK
    dec OAMBUFFER
    dec OAMBUFFER
    dec OAMBUFFER
    dec OAMBUFFER
    lda #%00011111
    sta NOISEVOLUME
    lda scratch + 2
    clc
    adc #$60
    sta scratch + 2
    lda scratch + 3
    adc #$00
    sta scratch + 3
    sta NOISEPERIOD
    lda scratch + 2
    sta NOISELENGTH
	rti

intro_setup_nmi:
    inc frame_done
    lda #%00011001
    sta current_ppu_ctrl
    sta PPUCTRL
    lda current_ppu_mask
    and #%11100111
    sta current_ppu_mask
    sta PPUMASK
    jsr push_palettes_to_ppu
    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    lda #$06
    ldy #$0F
    :
    ldx #$40
    :
    sta PPUDATA
    dex
    bne :-
    dey
    bne :--
    lda #$24
    sta PPUADDR
    lda #$00
    sta PPUADDR
    lda #$D4
    ldy #$0F
    :
    ldx #$40
    :
    sta PPUDATA
    dex
    bne :-
    dey
    bne :--
    lda #$23
    sta PPUADDR
    lda #$C0
    sta PPUADDR
    lda #$00
    ldx #$40
    :
    sta PPUDATA
    dex
    bne :-
    lda #$27
    sta PPUADDR
    lda #$C0
    sta PPUADDR
    lda #$55
    ldx #$40
    :
    sta PPUDATA
    dex
    bne :-
    lda #$23
    sta PPUADDR
    lda #$EA
    sta PPUADDR
    lda #%01010101
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    @draw_logo:
    lda #$21
    sta PPUADDR
    lda #$00
    sta PPUADDR
    ldy #$00
	ldx #$00
    @draw_logo_loop:
	lda LogoTileLayout, y
	sta scratch
	bmi @lit
	beq @after_draw_logo
	iny
	lda LogoTileLayout, y
	sty scratch + 1
	tay
    :
	lda OAMBUFFER, y
	sta OAMBUFFER, x
	sta PPUDATA
	iny
	inx
	dec scratch
	bpl :-
	ldy scratch + 1
	iny
	jmp @draw_logo_loop
    @lit:
	iny
    :
	lda LogoTileLayout, y
	sta OAMBUFFER,x
	sta PPUDATA
	iny
	inx
	inc scratch
	bne :-
	jmp @draw_logo_loop
    @after_draw_logo:
    lda #$FF
    ldy #$00
    :
    sta OAMBUFFER, y
    dey
    bne :-
    lda current_ppu_ctrl
    ora #%00000100
    sta PPUCTRL
    lda #$21
    sta PPUADDR
    lda #$A0
    sta PPUADDR
    lda #$D4
    sta OAMBUFFER + 1
    ldx #$11
    :
    sta PPUDATA
    dex
    bne :-
    ldy #Songs::TITLE_THEME
    jsr play_song
    ldx #$01
    lda #103
    sta OAMBUFFER
    lda #$01
    sta OAMBUFFER + 2
    lda #$00
    sta OAMBUFFER + 3
    sta x_scroll
    lda #$FC
    sta split_scroll_position
    lda current_ppu_ctrl
    ora #%10000000
    sta current_ppu_ctrl
    bit PPUSTATUS
    sta PPUCTRL
    lda current_ppu_mask
    ora #%00011000
    sta current_ppu_mask
    update_nmi normal_nmi
    dec frame_done
    rti

title_screen_setup_nmi:
    jsr update_audio
    lda #%10011001
    sta current_ppu_ctrl
    bit PPUSTATUS
    sta PPUCTRL
    lda current_ppu_mask
    and #%11100111
    sta current_ppu_mask
    sta PPUMASK
    lda #$06
    sta background_palettes + 5
    lda #$00
    sta x_scroll
    sta brightness
    sta frame_count
    sta OAMBUFFER + 2
    sta OAMBUFFER + 3
    lda #238
    sta OAMBUFFER
    lda #$D5
    sta OAMBUFFER + 1
    lda #$08
    ldx #$00
    clc
    :
    sta object_x_positions, x
    adc #$10
    inx
    cpx #$10
    bcc :-
    lda seed
    sta scratch
    lda seed + 1
    sta scratch
    ldx #$00
    :
    lsr scratch
    ror scratch + 1
    lda #$00
    adc #$00
    sta object_variables_0, x
    inx
    cpx #$10
    bcc :-
    ldx #$00
    :
    jsr rand
    lda seed
    sta object_y_positions, x
    lda seed + 1
    sta object_variables_1, x
    inx
    cpx #$10
    bcc :-
    lda #BUTTON_START
    sta controller_input_prev
    sta controller_input
    lda current_ppu_ctrl
    and #%11111110
    ora #%00100000
    sta current_ppu_ctrl
    lda current_ppu_mask
    ora #%00011000
    sta current_ppu_mask
    lda #GameState::TITLE_SCREEN
    sta game_state
    update_nmi normal_nmi
    jmp title_screen_logic

opening_setup_nmi:
    lda current_ppu_ctrl ; Disable NMI and set increment
    and #%01111011
    sta current_ppu_ctrl
    sta PPUCTRL 
    lda current_ppu_mask
    and #%11100111
    sta current_ppu_mask
    sta PPUMASK
    lda #$3F    ; Clear other nametable
    sta PPUADDR
    lda #$00
    sta current_opening_line
    sta current_line_character
    sta shake_mask
    sta PPUADDR
    lda #$06
    sta background_color
    sta PPUDATA
    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    lda #$D4
    ldy #$0F
    :
    ldx #$40
    :
    sta PPUDATA
    dex
    bne :-
    dey
    bne :--
    lda #$23
    sta PPUADDR
    lda #$C0
    sta PPUADDR
    lda #$55
    ldx #$40
    :
    sta PPUDATA
    dex
    bne :-

    lda #$01
    sta is_drawing_line
    lda #5
    sta character_draw_timer
    lda #140
    sta shake_timer

    lda current_ppu_mask
    ora #%00001000 ; Enable background rendering
    sta current_ppu_mask

    lda current_ppu_ctrl ; Enable NMI
    ora #%10000000
    sta current_ppu_ctrl
    bit PPUSTATUS
    sta PPUCTRL

    jsr init_apu
    ldy #Songs::ALARM_SOUND
    jsr play_song

    update_nmi normal_nmi
    rti

.include "audio_engine.s"

dynamic_jump:
    jmp (scratch)

; Clobbers A, X, Y, 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12
handle_scroll:
    lda #$FF
    sta scratch + 12 ; It will stay this value if we didn't scroll
    lda object_ids ; Check if slot 0 is the player
    cmp #$02
    beq :+
    rts ; Return if it's not the player
    :
    lda player_flags
    and #PLAYER_IS_DEAD
    beq :+
    rts
    :
    lda object_y_positions
    adc #$07 + 120
    bcs :+
    cmp #240
    bcc :++
    :
    adc #15
    :
    sta y_scroll
    ldx current_level ; Store this for later
    lda LevelLengths, x
    sta scratch + 2
    lda x_scroll 
    lsr ; We care about 8 pixel intervals, so 3 right shifts
    lsr
    lsr
    sta scratch ; Store scroll before
    lda object_x_page_subpixels ; Calculate center of player
    lsr
    lsr
    lsr
    sta scratch + 9
    lda object_x_positions 
    sec
    sbc #128 - 8
    sta scratch + 8
    lda scratch + 9
    sbc #$00
    bcs :+
    lda #$00
    sta scratch + 8
    sta scratch + 9
    lda current_page
    bne @scroll_left
    lda x_scroll
    bne @scroll_left
    rts 
    :
    sta scratch + 9
    lda current_page
    cmp scratch + 9
    bcc @scroll_right
    bne @scroll_left
    lda x_scroll
    cmp scratch + 8
    bcc @scroll_right
    bne @scroll_left
    rts ; No scroll
    @scroll_left:
    lda #$00
    sta scratch + 12 ; Store that we're scrolling left
    lda scratch + 8
    sec
    sbc x_scroll
    cmp #(256 - SCROLL_SPEED)
    bcs :+
    lda #(256 - SCROLL_SPEED)
    :
    clc
    adc x_scroll
    sta x_scroll
    bcs @not_pressing_left
    dec current_page
    lda current_ppu_ctrl ; Switch to the other nametable
    eor #$00000001
    sta current_ppu_ctrl
    jmp @not_pressing_left
    @scroll_right:
    lda #$01
    sta scratch + 12 ; Store that we're scrolling right
    lda current_page ; Check if we're already at the end
    dec scratch + 2
    cmp scratch + 2
    bcc :+
    rts ; Return early if we're already at the right edge
    :
    inc scratch + 2
    lda scratch + 8
    sec
    sbc x_scroll
    cmp #SCROLL_SPEED
    bcc :+
    lda #SCROLL_SPEED
    :
    clc
    adc x_scroll
    sta x_scroll
    bcc @not_pressing_left
    lda current_ppu_ctrl ; Switch to the other nametable
    eor #$00000001
    sta current_ppu_ctrl
    inc current_page ; Handle overflow
    inc current_page
    lda current_page
    cmp scratch + 2 ; Check if we reached right edge
    bcc @not_at_edge
    dec current_page 
    lda #$00 ; Set scroll to end if we did
    sta x_scroll
    rts ; I think it should be okay to return since we don't need to load anything
    @not_at_edge:
    dec current_page
    @not_pressing_left:
    ldx current_page
    lda x_scroll ; Check if our scroll crossed an 8-pixel boundary
    lsr
    lsr
    lsr
    cmp scratch
    bne @load_column
    rts ; Return early if not
    @load_column:
    ldy scratch + 12
    beq @will_scroll_left
    inx
    clc
    adc #7
    cmp #32
    bcc :+
    sbc #32
    inx
    ldy #$00
    :    
    jmp @after_determine_scroll_direction
    @will_scroll_left:
    ldy #$01
    dex
    clc
    adc #24
    cmp #32
    bcc :+
    sbc #32
    inx
    ldy #$00
    :
    @after_determine_scroll_direction:
    sty scratch + 3
    sta scratch + 4 ; Store column index
    cpx scratch + 2 ; Check if we went out of bounds
    bcc :+
    rts ; Return early if we did
    :
    ldy vram_buffer_index
    lda #30 ; One column of tiles
    sta $0100, y 
    iny
    lda #%00000100 ; Set VRAM address increment to vertical
    sta $0100, y
    iny 
    lda scratch + 4
    sta $0101, y ; Store lower half of PPU address
    lda current_ppu_ctrl ; Check base nametable address
    and #%00000001
    eor scratch + 3
    beq :+
    lda #$24
    jmp :++
    :
    lda #$20
    :
    sta $0100, y
    iny
    iny
    sty vram_buffer_index

    ldy current_level
    lda LevelTilePointersLow, y
    sta scratch
    lda LevelTilePointersHigh, y
    sta scratch + 1
    lda #$00
    sta scratch + 5
    clc
    txa ; Get metametatile index
    asl ; Each page has 64 meta meta tiles
    rol scratch + 5
    asl
    rol scratch + 5
    asl
    rol scratch + 5
    asl
    rol scratch + 5
    asl
    rol scratch + 5
    asl
    rol scratch + 5
    adc scratch
    sta scratch
    lda scratch + 5
    adc scratch + 1
    sta scratch + 1
    lda scratch + 4
    and #%11111100
    asl
    adc scratch
    sta scratch
    lda scratch + 1 ; I don't think this should cause a carry?
    adc #$00 ; But better safe than sorry
    sta scratch + 1
    lda scratch + 4
    and #%00000011
    tay
    beq @column_0
    dey
    beq @column_1
    dey
    beq @column_2
    jmp load_column_3
    @column_0:
    jmp load_column_0
    @column_1:
    jmp load_column_1
    @column_2:
    jmp load_column_2

.macro load_column_macro FirstMetaTile, SecondMetaTile, FirstTile, SecondTile
    ldy #$00
    @loop:
    lda (scratch), y
    sty scratch + 6
    ldy vram_buffer_index
    tax
    stx scratch + 7
    lda FirstMetaTile, x
    sta scratch + 5
    tax
    lda FirstTile, x
    sta $0100, y
    iny
    ldx scratch + 5
    lda SecondTile, x
    sta $0100, y
    iny
    ldx scratch + 7
    lda SecondMetaTile, x
    sta scratch + 5
    tax
    lda FirstTile, x
    sta $0100, y
    iny
    ldx scratch + 5
    lda SecondTile, x
    sta $0100, y
    iny
    sty vram_buffer_index
    ldy scratch + 6
    iny
    cpy #7
    bcc @loop
    lda (scratch), y ; Last one gets handled separately
    ldy vram_buffer_index
    tax
    lda FirstMetaTile, x
    sta scratch + 5
    tax
    lda FirstTile, x
    sta $0100, y
    iny
    ldx scratch + 5
    lda SecondTile, x
    sta $0100, y
    iny
    sty vram_buffer_index
.endmacro

load_column_0:
    load_column_macro MetaMetaTilesTopLeft, MetaMetaTilesBottomLeft, MetaTilesTopLeft, MetaTilesBottomLeft
    lda #$00
    sta $0100, y
    rts

load_column_1:
    load_column_macro MetaMetaTilesTopLeft, MetaMetaTilesBottomLeft, MetaTilesTopRight, MetaTilesBottomRight
    lda #$00
    sta $0100, y
    rts

load_column_2:
    load_column_macro MetaMetaTilesTopRight, MetaMetaTilesBottomRight, MetaTilesTopLeft, MetaTilesBottomLeft
    lda #$00
    sta $0100, y
    rts

load_column_3:
    load_column_macro MetaMetaTilesTopRight, MetaMetaTilesBottomRight, MetaTilesTopRight, MetaTilesBottomRight
    ; Load attributes
    lda #2 ; Pair of attributes >:L
    sta $0100, y 
    sta $0100 + 6, y 
    sta $0100 + 12, y 
    sta $0100 + 18, y 
    iny
    lda #%00000100 ; Set VRAM address increment to vertical
    sta $0100, y
    sta $0100 + 6, y 
    sta $0100 + 12, y 
    sta $0100 + 18, y 
    iny 
    lda scratch + 4
    lsr
    lsr
    clc
    adc #$C0
    sta $0101, y ; Store lower half of PPU address
    adc #$08
    sta $0101 + 6, y
    adc #$08
    sta $0101 + 12, y
    adc #$08
    sta $0101 + 18, y
    lda current_ppu_ctrl ; Check base nametable address
    and #%00000001
    eor scratch + 3
    beq :+
    lda #$27
    jmp :++
    :
    lda #$23
    :
    sta $0100, y
    sta $0100 + 6, y 
    sta $0100 + 12, y 
    sta $0100 + 18, y 
    iny
    iny
    sty vram_buffer_index 
    ldy #$00
    .repeat 2
    .repeat 4, i
    lda (scratch), y
    sty scratch + 6
    ldy vram_buffer_index
    tax
    lda MetaMetaTileAttributes, x
    sta $0100 + i * 6, y
    .if i < 3
    ldy scratch + 6
    iny
    .endif
    .endrepeat
    iny
    sty vram_buffer_index
    ldy scratch + 6
    iny
    .endrepeat
    ldy vram_buffer_index
    tya
    clc
    adc #18
    tay
    sty vram_buffer_index
    lda #$00
    sta $0100, y
    rts

; Scroll direction in $12
spawn_objects_after_scroll:
    lda scratch + 12
    bpl :+
    rts ; If the scroll direction is $FF, no scrolling occured
    :
    beq @scrolled_left
    @scrolled_right:
    ldy #$00
    lda (right_object_pointer), y
    bne :+
    jmp @update_left_pointer ; Return early if we're at the terminator
    :
    sta scratch + 4 ; Store object ID
    iny
    lda (right_object_pointer), y ; Load page number
    sta scratch + 1
    iny
    lda (right_object_pointer), y ; Load X position
    sta scratch
    lda x_scroll
    sec
    sbc scratch
    sta scratch
    lda current_page
    sbc scratch + 1
    cmp #$FE
    bcc @is_off_screen_right
    bne @is_on_screen_right
    lda scratch
    cmp #256 - 64
    bcs @is_on_screen_right
    @is_off_screen_right:
    jmp @update_left_pointer
    @is_on_screen_right:
    lda scratch + 4
    ldy right_object_index
    jsr try_spawn_object
    cpx #$FF
    beq @increment_right_pointer
    lda #$00
    sta object_y_page_subpixels, x
    ldy #$01
    lda (right_object_pointer), y
    asl
    asl
    asl
    sta object_x_page_subpixels, x
    iny
    lda (right_object_pointer), y
    sta object_x_positions, x
    iny
    lda (right_object_pointer), y
    sta object_y_positions, x
    @increment_right_pointer:
    lda right_object_pointer
    clc
    adc #$04
    sta right_object_pointer
    lda right_object_pointer + 1
    adc #$00
    sta right_object_pointer + 1
    inc right_object_index
    jmp @scrolled_right
    @scrolled_left:
    ldy #$00
    lda (left_object_pointer), y
    bne :+
    jmp @update_right_pointer ; Return early if we're at the terminator
    :
    sta scratch + 4 ; Store object ID
    iny
    lda (left_object_pointer), y ; Load page number
    sta scratch + 1
    iny
    lda (left_object_pointer), y ; Load X position
    sta scratch
    lda x_scroll
    sec
    sbc scratch
    sta scratch
    lda current_page
    sbc scratch + 1
    bne @is_off_screen_left
    lda scratch
    cmp #64
    bcc @is_on_screen_left
    @is_off_screen_left:
    jmp @update_right_pointer
    @is_on_screen_left:
    lda scratch + 4
    ldy left_object_index
    jsr try_spawn_object
    cpx #$FF
    beq @decrement_left_pointer
    lda #$00
    sta object_y_page_subpixels, x
    ldy #$01
    lda (left_object_pointer), y
    asl
    asl
    asl
    sta object_x_page_subpixels, x
    iny
    lda (left_object_pointer), y
    sta object_x_positions, x
    iny
    lda (left_object_pointer), y
    sta object_y_positions, x
    @decrement_left_pointer:
    lda left_object_pointer
    sec
    sbc #$04
    sta left_object_pointer
    lda left_object_pointer + 1
    sbc #$00
    sta left_object_pointer + 1
    dec left_object_index
    jmp @scrolled_left
    @update_left_pointer:
    ldy #$04
    lda (left_object_pointer), y
    bne :+
    rts
    :
    iny
    lda (left_object_pointer), y ; Load page number
    sta scratch + 1
    iny
    lda (left_object_pointer), y ; Load X position
    sta scratch
    lda x_scroll
    sec
    sbc scratch
    sta scratch
    lda current_page
    sbc scratch + 1
    bmi @is_on_screen_left_2
    lda scratch
    cmp #64
    bcc @is_on_screen_left_2
    @is_off_screen_left_2:
    inc left_object_index
    lda left_object_pointer
    clc
    adc #$04
    sta left_object_pointer
    lda left_object_pointer + 1
    adc #$00
    sta left_object_pointer + 1
    jmp @update_left_pointer
    @is_on_screen_left_2:
    rts
    @update_right_pointer:
    lda x_scroll
    clc
    adc #64
    sta scratch + 2
    lda current_page
    adc #$01
    sta scratch + 3
    @update_right_pointer_after_init:
    dec right_object_index
    ldy #$00
    lda right_object_pointer
    sec
    sbc #$04
    sta right_object_pointer
    lda right_object_pointer + 1
    sbc #$00
    sta right_object_pointer + 1
    lda (right_object_pointer), y
    bne :+
    rts
    :
    iny
    lda (right_object_pointer), y ; Load page number
    sta scratch + 1
    iny
    lda (right_object_pointer), y ; Load X position
    sta scratch
    lda scratch + 1
    cmp scratch + 3
    bcc @is_on_screen_right_2
    lda scratch
    cmp scratch + 2
    bcc @is_on_screen_right_2
    @is_off_screen_right_2:
    jmp @update_right_pointer_after_init
    @is_on_screen_right_2:
    inc right_object_index
    lda right_object_pointer
    clc
    adc #$04
    sta right_object_pointer
    lda right_object_pointer + 1
    adc #$00
    sta right_object_pointer + 1
    rts

; Clobbers A
read_controllers:
    lda controller_input
    sta controller_input_prev
    lda #$01
    sta JOY1
    sta controller_input
    lsr
    sta JOY1
    @loop:
    lda JOY1
    lsr
    rol controller_input
    bcc @loop
    lda controller_input_prev
    eor #$FF
    and controller_input
    sta buttons_pressed
    lda controller_input
    eor #$FF
    and controller_input_prev
    sta buttons_released
    rts

; Clobbers A, X, Y, 00, 01, 02, 03, 04, 05, 06, 07, 08, 09
load_level:
    lda current_level
    cmp NumLevels
    bcc :+
    brk ; Go to crash handler if we try to load an invalid level
    :
    lda #$00
    ldx #$0F
    :
    sta object_ids, x
    dex
    bne :-
    sta level_flags
    sta light_fade_timer
    sta skip_light_switch_collision
    sta scratch + 9 ; Current column number
    sta scratch + 4
    sta current_page ; Reset scroll-related variables
    sta x_scroll
    sta y_scroll
    lda #$F7
    sta brightness
    inc screen_fading
    lda #PLAYER_OBJECT
    ldx #$00
    jsr spawn_object_without_spawn_flag
    ldx current_level
    lda current_ppu_ctrl
    lda #$20 ; Get ready to update nametable
    sta scratch + 3
    lda #$23 ; Get ready to update attributes
    sta scratch + 7
    lda #$C0
    sta scratch + 8
    lda current_ppu_ctrl
    and #%01111100 ; Set scroll to top left and disable NMI
    ora #%00000100 ; Set PPU increment to down
    sta current_ppu_ctrl
    sta PPUCTRL
    lda current_ppu_mask
    and #%11100111 ; Disable rendering
    sta current_ppu_mask
    sta PPUMASK

    lda LevelBackgroundColors, x
    sta background_color
    lda LevelBackgroundPalette0Color0, x
    sta background_palettes
    lda LevelBackgroundPalette0Color1, x
    sta background_palettes + 1
    lda LevelBackgroundPalette0Color2, x
    sta background_palettes + 2
    lda LevelBackgroundPalette1Color0, x
    sta background_palettes + 3
    lda LevelBackgroundPalette1Color1, x
    sta background_palettes + 4
    lda LevelBackgroundPalette1Color2, x
    sta background_palettes + 5
    lda LevelBackgroundPalette2Color0, x
    sta background_palettes + 6
    lda LevelBackgroundPalette2Color1, x
    sta background_palettes + 7
    lda LevelBackgroundPalette2Color2, x
    sta background_palettes + 8
    lda LevelBackgroundPalette3Color0, x
    sta background_palettes + 9
    lda LevelBackgroundPalette3Color1, x
    sta background_palettes + 10
    lda LevelBackgroundPalette3Color2, x
    sta background_palettes + 11

    lda #$32
    sta sprite_palettes
    lda #$12
    sta sprite_palettes + 1
    lda #$02
    sta sprite_palettes + 2
    lda #$34
    sta sprite_palettes + 3
    lda #$14
    sta sprite_palettes + 4
    lda #$04
    sta sprite_palettes + 5
    lda #$36
    sta sprite_palettes + 6
    lda #$16
    sta sprite_palettes + 7
    lda #$06
    sta sprite_palettes + 8
    lda #$20
    sta sprite_palettes + 9
    lda #$16
    sta sprite_palettes + 10
    lda #$12
    sta sprite_palettes + 11

    lda LevelTilePointersLow, x
    sta scratch
    lda LevelTilePointersHigh, x
    sta scratch + 1
    bit PPUSTATUS

    ; First load the tiles of the column of metametatiles into a buffer
    ; Update attributes along the way
    @load_column:
    ldx #$07
    ldy #$00
    @start_load_loop:
    lda scratch + 7
    sta PPUADDR
    lda scratch + 8
    sta PPUADDR
    clc
    adc #$08
    sta scratch + 8
    bcc :+
    inc scratch + 7
    :

    lda (scratch), y ; Load metametatile index
    stx scratch + 2
    tax
    sta scratch + 5
    lda MetaMetaTileAttributes, x ; Load attribute for current metametatile
    sta PPUDATA
    sty scratch + 6
    tya
    asl ; Multiply by 4 to get the index because each metametatile is 4x4 tiles
    asl
    tay

    lda MetaMetaTilesTopLeft, x ; Load metatile index
    tax
    lda MetaTilesTopLeft, x ; Load tile index
    sta tile_buffer_1, y
    lda MetaTilesBottomLeft, x
    sta tile_buffer_1 + 1, y
    lda MetaTilesTopRight, x
    sta tile_buffer_2, y
    lda MetaTilesBottomRight, x
    sta tile_buffer_2 + 1, y
    ldx scratch + 5
    lda MetaMetaTilesTopRight, x ; Load metatile index
    tax
    lda MetaTilesTopLeft, x ; Load tile index
    sta tile_buffer_3, y
    lda MetaTilesBottomLeft, x
    sta tile_buffer_3 + 1, y
    lda MetaTilesTopRight, x
    sta tile_buffer_4, y
    lda MetaTilesBottomRight, x
    sta tile_buffer_4 + 1, y
    ldx scratch + 5
    lda MetaMetaTilesBottomLeft, x ; Load metatile index
    tax
    lda MetaTilesTopLeft, x ; Load tile index
    sta tile_buffer_1 + 2, y
    lda MetaTilesBottomLeft, x
    sta tile_buffer_1 + 3, y
    lda MetaTilesTopRight, x
    sta tile_buffer_2 + 2, y
    lda MetaTilesBottomRight, x
    sta tile_buffer_2 + 3, y
    ldx scratch + 5
    lda MetaMetaTilesBottomRight, x ; Load metatile index
    tax
    lda MetaTilesTopLeft, x ; Load tile index
    sta tile_buffer_3 + 2, y
    lda MetaTilesBottomLeft, x
    sta tile_buffer_3 + 3, y
    lda MetaTilesTopRight, x
    sta tile_buffer_4 + 2, y
    lda MetaTilesBottomRight, x
    sta tile_buffer_4 + 3, y

    ldx scratch + 2
    ldy scratch + 6
    iny
    dex
    beq :+
    jmp @start_load_loop
    :
    lda scratch + 7 ; Do the last metametatile on its own since it's half as high
    sta PPUADDR
    lda scratch + 8
    sta PPUADDR
    sec
    sbc #$37
    sta scratch + 8
    bcs :+
    dec scratch + 7
    :
    lda (scratch), y 
    stx scratch + 2
    tax
    sta scratch + 5
    lda MetaMetaTileAttributes, x ; Load attribute for current metametatile
    sta PPUDATA
    sty scratch + 6
    tya
    asl
    asl
    tay

    lda MetaMetaTilesTopLeft, x ; Load metatile index
    tax
    lda MetaTilesTopLeft, x ; Load tile index
    sta tile_buffer_1, y
    lda MetaTilesBottomLeft, x
    sta tile_buffer_1 + 1, y
    lda MetaTilesTopRight, x
    sta tile_buffer_2, y
    lda MetaTilesBottomRight, x
    sta tile_buffer_2 + 1, y
    ldx scratch + 5
    lda MetaMetaTilesTopRight, x ; Load metatile index
    tax
    lda MetaTilesTopLeft, x ; Load tile index
    sta tile_buffer_3, y
    lda MetaTilesBottomLeft, x
    sta tile_buffer_3 + 1, y
    lda MetaTilesTopRight, x
    sta tile_buffer_4, y
    lda MetaTilesBottomRight, x
    sta tile_buffer_4 + 1, y

    lda scratch + 3 ; Transfer contents of buffer into VRAM
    sta PPUADDR
    lda scratch + 4
    sta PPUADDR
    ldy #$00
    :
    lda tile_buffer_1, y
    sta PPUDATA
    iny
    cpy #30
    bne :-
    inc scratch + 4
    bne :+
    inc scratch + 3
    :
    lda scratch + 3
    sta PPUADDR
    lda scratch + 4
    sta PPUADDR
    ldy #$00
    :
    lda tile_buffer_2, y
    sta PPUDATA
    iny
    cpy #30
    bne :-
    inc scratch + 4
    bne :+
    inc scratch + 3
    :
    lda scratch + 3
    sta PPUADDR
    lda scratch + 4
    sta PPUADDR
    ldy #$00
    :
    lda tile_buffer_3, y
    sta PPUDATA
    iny
    cpy #30
    bne :-
    inc scratch + 4
    bne :+
    inc scratch + 3
    :
    lda scratch + 3
    sta PPUADDR
    lda scratch + 4
    sta PPUADDR
    ldy #$00
    :
    lda tile_buffer_4, y
    sta PPUDATA
    iny
    cpy #30
    bne :-
    inc scratch + 4
    bne :+
    inc scratch + 3
    :
    lda scratch
    clc
    adc #$08
    sta scratch
    bcc :+
    inc scratch + 1
    :
    inc scratch + 9
    lda scratch + 9
    cmp #$08
    bcs @after_eighth_iter
    jmp @load_column
    @after_eighth_iter:
    bne :+
    lda #$24
    sta scratch + 3
    lda #$00
    sta scratch + 4
    lda #$27
    sta scratch + 7
    lda #$C0
    sta scratch + 8
    jmp @load_column
    :
    cmp #$0A
    beq :+
    jmp @load_column
    :

    lda #$00 ; Clear object flags
    sta player_has_no_control
    ldx #32
    :
    dex
    sta object_spawned_flags, x
    sta object_dead_flags, x
    bne :-
    sta right_object_index
    lda #$FF
    sta left_object_index

    ldx current_level ; Load objects near the beginning
    lda LevelObjectListPointersLow, x
    sta right_object_pointer
    sec
    sbc #$04
    sta left_object_pointer
    lda LevelObjectListPointersHigh, x
    sta right_object_pointer + 1
    sbc #$00
    sta left_object_pointer + 1
    
    @start_object_load_loop:
    ldy #$00
    lda (right_object_pointer), y
    beq @after_load_objects_loop ; End if we find the terminator
    sta scratch + 2; Store object index
    iny
    lda (right_object_pointer), y
    cmp #$02
    bcs @after_load_objects_loop ; Stop once we get objects that are too far to the right
    iny
    sta scratch + 3
    cmp #$01
    beq @object_on_second_page
    lda (right_object_pointer), y
    jmp @load_object_y_position
    @object_on_second_page:
    lda (right_object_pointer), y
    cmp #64
    bcs @after_load_objects_loop
    @load_object_y_position:
    sta scratch + 4
    iny
    lda (right_object_pointer), y
    sta scratch + 5
    ldy right_object_index
    lda scratch + 2
    jsr try_spawn_object
    ; It can be presumed that this will never fail since the slots should be empty
    ; If it does fail, then we will corrupt memory here
    lda scratch + 3
    asl
    asl
    asl
    sta object_x_page_subpixels, x
    lda scratch + 4
    sta object_x_positions, x
    lda scratch + 5
    sta object_y_positions, x
    inc right_object_index
    lda right_object_pointer
    clc
    adc #$04
    sta right_object_pointer
    lda right_object_pointer + 1
    adc #$00
    sta right_object_pointer + 1
    jmp @start_object_load_loop

    @after_load_objects_loop:

    jsr init_apu

    ldy #Songs::TITLE_THEME
    jsr play_song

    lda #GameState::GAMEPLAY
    sta game_state
    update_nmi normal_nmi
    lda current_ppu_mask
    ora #%00011000 ; Turn rendering back on at next NMI
    sta current_ppu_mask
    lda PPUSTATUS
    lda current_ppu_ctrl
    ora #%10100000 ; Turn NMI back on
    and #%11101111
    sta current_ppu_ctrl
    bit PPUSTATUS
    sta PPUCTRL
    jmp gameplay_logic

; Page in 10, X position in 11, Y position in 12
; Clobbers A, X, Y, 9, 13, 14, 15
; Returns collision of tile in A
test_collision:
    ldx current_level
    lda LevelTilePointersLow, x
    sta scratch + 14
    lda LevelTilePointersHigh, x
    sta scratch + 15
    lda #$00
    sta scratch + 9
    lda scratch + 10
    cmp LevelLengths, x ; Make everything offscreen solid
    bcc :+
    lda #$0F
    rts
    :
    clc
    asl ; Each page has 64 meta meta tiles
    rol scratch + 9
    asl
    rol scratch + 9
    asl
    rol scratch + 9
    asl
    rol scratch + 9
    asl
    rol scratch + 9
    asl
    rol scratch + 9
    clc
    adc scratch + 14
    sta scratch + 14
    lda scratch + 15
    adc scratch + 9
    sta scratch + 15
    lda scratch + 12
    lsr
    lsr
    lsr
    lsr
    lsr
    sta scratch + 9
    lda scratch + 11
    lsr
    lsr
    and #%11111000
    clc
    adc scratch + 9
    tay
    lda (scratch + 14), y
    tax
    lda scratch + 11
    and #$1F
    cmp #$10
    bcs @right_of_meta_meta_tile
    lda scratch + 12
    and #$1F
    cmp #$10
    bcs @bottom_left_of_meta_meta_tile
    lda MetaMetaTilesTopLeft, x
    jmp @after_get_meta_tile
    @bottom_left_of_meta_meta_tile:
    lda MetaMetaTilesBottomLeft, x
    jmp @after_get_meta_tile
    @right_of_meta_meta_tile:
    lda scratch + 12
    and #$1F
    cmp #$10
    bcs @bottom_right_of_meta_meta_tile
    lda MetaMetaTilesTopRight, x
    jmp @after_get_meta_tile
    @bottom_right_of_meta_meta_tile:
    lda MetaMetaTilesBottomRight, x
    @after_get_meta_tile:
    tax
    lda MetaTileCollision, x
    pha
    and #COLLISION_ONLY_WHEN_LIGHTS_ON
    beq :+
    lda level_flags
    and #LIGHTS_OFF
    beq :+
    pla
    lda #$00
    rts
    :
    pla
    rts

; Object index in X
play_animation:
    lda object_animations_ids, x
    cmp NumAnimations ; Bounds check
    bcc :+
    rts
    :
    lda object_animation_timers, x ; Check timer for current frame
    bne @same_animation_frame ; If not 0, just decrease the timer
    ldy object_animations_ids, x
    inc object_animations_frames, x ; Else go to the next frame
    lda AnimationLengths, y
    sta scratch + 2 ; Store animation length
    and #%01111111 ; Remove loop bit
    cmp object_animations_frames, x
    bne @did_not_reach_animation_end
    lda scratch + 2 ; Check if animation loops
    cmp #%10000000
    bcc @no_loop
    lda #$01
    sta object_animations_frames, x
    @no_loop:
    dec object_animations_frames, x
    @did_not_reach_animation_end:
    ldy object_animations_ids, x
    lda AnimationFrameLengthPointersLow, y ; Set animation timer for new frame
    sta scratch
    lda AnimationFrameLengthPointersHigh, y
    sta scratch + 1
    lda AnimationFramePointersLow, y ; Set metasprite for new frame
    sta scratch + 2
    lda AnimationFramePointersHigh, y
    sta scratch + 3
    ldy object_animations_frames, x
    lda (scratch), y
    sta object_animation_timers, x
    lda (scratch + 2), y
    sta object_current_metasprites, x
    rts
    @same_animation_frame:
    sec
    sbc #$01
    sta object_animation_timers, x
    rts

; Object index in X, animation ID in y
init_animation:
    lda AnimationFrameLengthPointersLow, y ; Set animation timer for new frame
    sta scratch + 8
    lda AnimationFrameLengthPointersHigh, y
    sta scratch + 9
    lda AnimationFramePointersLow, y ; Set metasprite for new frame
    sta scratch + 10
    lda AnimationFramePointersHigh, y
    sta scratch + 11
    lda #$00
    tay
    sta object_animations_frames, x
    lda (scratch + 8), y
    sta object_animation_timers, x
    lda (scratch + 10), y
    sta object_current_metasprites, x
    rts

; Object index in X, object ID in A, object level index in Y
; Clobbers 0 and 1
spawn_object:
    sta object_ids, x
    sty scratch
    stx scratch + 1
    tya
    lsr
    lsr
    lsr ; Divide by 8 to find byte index
    tax
    lda scratch
    and #%00000111 ; Find position in byte
    tay
    lda #$01
    :
    dey
    bmi @after_get_bit_mask
    asl
    jmp :-
    @after_get_bit_mask:
    sta scratch
    and object_spawned_flags, x
    beq :+
    lda #$00
    ldx scratch + 1
    sta object_ids, x
    ldx #$FF
    rts
    :
    lda scratch
    and object_dead_flags, x
    beq :+
    lda #$00
    ldx scratch + 1
    sta object_ids, x
    ldx #$FF
    rts
    :
    lda scratch
    ora object_spawned_flags, x
    sta object_spawned_flags, x
    ldx scratch + 1
    ldy object_ids, x
    lda ObjectInitPointersLow, y
    sta scratch
    lda ObjectInitPointersHigh, y
    sta scratch + 1
    jmp (scratch)

spawn_object_without_spawn_flag:
    tay
    sta object_ids, x
    lda ObjectInitPointersLow, y
    sta scratch
    lda ObjectInitPointersHigh, y
    sta scratch + 1
    jmp (scratch)

; Object ID in A, object level index in Y
; If successful, returns object index in X
; Else returns $FF in X
; Clobbers 0 and 1
try_spawn_object:
    pha
    ldx #$01
    :
    lda object_ids, x
    beq @found_empty_slot
    inx
    cpx #$10
    bcc :-
    pla
    ldx #$FF
    rts
    @found_empty_slot:
    tya
    sta object_indices, x
    pla
    jmp spawn_object

; Object index in X
; Clobbers $15, A, Y
despawn_object:
    lda object_indices, x
    stx scratch + 15
    tay
    lsr
    lsr
    lsr
    tax
    tya
    and #%00000111
    tay
    lda #$01
    :
    dey
    bmi @after_get_bit_mask
    asl
    jmp :-
    @after_get_bit_mask:
    eor #$FF
    and object_spawned_flags, x
    sta object_spawned_flags, x
    ldx scratch + 15
    rts

kill_object:
    lda object_indices, x
    stx scratch + 15
    tay
    lsr
    lsr
    lsr
    tax
    tya
    and #%00000111
    tay
    lda #$01
    :
    dey
    bmi @after_get_bit_mask
    asl
    jmp :-
    @after_get_bit_mask:
    tay
    ora object_dead_flags, x
    sta object_dead_flags, x
    tya
    eor #$FF
    and object_spawned_flags, x
    sta object_spawned_flags, x
    ldx scratch + 15
    rts

; Object 1 in X
load_object_collision:
    lda object_x_positions, x
    sta collision_buffer
    lda object_x_page_subpixels, x
    lsr
    lsr
    lsr
    sta collision_buffer + 1
    lda object_y_positions, x
    sta collision_buffer + 4
    
    lda object_ids, x
    tax
    
    lda ObjectHitboxXOffsets, x
    clc
    adc collision_buffer
    sta collision_buffer
    lda #$00
    adc collision_buffer + 1
    sta collision_buffer + 1
    lda ObjectHitboxWidths, x
    clc
    adc collision_buffer
    sta collision_buffer + 2
    lda #$00
    adc collision_buffer + 1
    sta collision_buffer + 3
    lda ObjectHitboxYOffsets, x
    clc
    adc collision_buffer + 4
    bcs @wrap_around_y1
    cmp #240
    bcc @no_wrap_y1
    @wrap_around_y1:
    adc #15
    @no_wrap_y1:
    sta collision_buffer + 4
    clc
    adc ObjectHitboxHeights, x
    bcs @wrap_around_y2
    cmp #240
    bcc @no_wrap_y2
    @wrap_around_y2:
    adc #15
    sta collision_buffer + 5
    lda #$01
    sta collision_wrap_flag
    rts
    @no_wrap_y2:
    sta collision_buffer + 5
    lda #$00
    sta collision_wrap_flag
    rts

; Object 2 in Y
test_object_collision:
    lda object_x_positions, y
    sta collision_buffer + 6
    lda object_x_page_subpixels, y
    lsr
    lsr
    lsr
    sta collision_buffer + 7
    lda object_y_positions, y
    sta collision_buffer + 10
    lda object_ids, y
    tay
    lda ObjectHitboxXOffsets, y
    clc
    adc collision_buffer + 6
    sta collision_buffer + 6
    lda #$00
    adc collision_buffer + 7
    sta collision_buffer + 7

    lda collision_buffer + 3
    cmp collision_buffer + 7
    beq :+
    bcs :++
    lda #$00
    rts
    :
    lda collision_buffer + 2
    cmp collision_buffer + 6
    bcs :+
    lda #$00
    rts
    :

    lda ObjectHitboxWidths, y
    clc
    adc collision_buffer + 6
    sta collision_buffer + 8
    lda #$00
    adc collision_buffer + 7
    sta collision_buffer + 9

    lda collision_buffer + 9
    cmp collision_buffer + 1
    beq :+
    bcs :++
    lda #$00
    rts
    :
    lda collision_buffer + 8
    cmp collision_buffer
    bcs :+
    lda #$00
    rts
    :

    lda ObjectHitboxYOffsets, y
    clc
    adc collision_buffer + 10
    bcs @wrap_around_y1
    cmp #240
    bcc @no_wrap_y1
    @wrap_around_y1:
    adc #15
    @no_wrap_y1:
    sta collision_buffer + 10
    clc
    adc ObjectHitboxHeights, y
    bcs @wrap_around_y2
    cmp #240
    bcc @no_wrap_y2
    @wrap_around_y2:
    ldy collision_wrap_flag
    beq :+
    lda #$01
    rts
    :
    adc #15
    sta collision_buffer + 11
    jmp @wrap_check
    @no_wrap_y2:
    sta collision_buffer + 11
    ldy collision_wrap_flag
    bne @wrap_check

    lda collision_buffer + 5
    cmp collision_buffer + 10
    bcs :+
    lda #$00
    rts
    :

    lda collision_buffer + 11
    cmp collision_buffer + 4
    bcs :+
    lda #$00
    rts
    :

    lda #$01
    rts
    @wrap_check:
    lda collision_buffer + 5
    cmp collision_buffer + 10
    bcc :+
    lda #$01
    rts
    :

    lda collision_buffer + 11
    cmp collision_buffer + 4
    bcs :+
    lda #$00
    rts
    :

    lda #$01
    rts

; Object index in X
; Clobbers 14, 15
check_object_on_screen:
    lda object_x_page_subpixels, x
    lsr
    lsr
    lsr
    sta scratch + 15
    lda x_scroll
    sec
    sbc object_x_positions, x
    sta scratch + 14
    lda current_page
    sbc scratch + 15
    bmi @object_to_right
    bne @is_off_screen
    lda scratch + 14
    cmp #64
    bcs @is_off_screen
    lda #$01
    rts
    @object_to_right:
    cmp #$FE
    bcc @is_off_screen
    bne @is_on_screen
    lda scratch + 14
    cmp #256 - 64
    bcc @is_off_screen
    @is_on_screen:
    lda #$01
    rts
    @is_off_screen:
    lda #$00
    rts

crash_handler:
    sei
    sta scratch + 1
    beq @zero_flag_set
    bmi @minus_flag_set
    lda #$00
    beq @after_get_zero_minus_flags
    @minus_flag_set:
    lda #%10000000
    bne @after_get_zero_minus_flags
    @zero_flag_set:
    bmi @zero_and_minus_flags_set
    lda #%00000010
    bne @after_get_zero_minus_flags
    @zero_and_minus_flags_set:
    bmi @zero_and_minus_flags_set
    lda #%10000010
    @after_get_zero_minus_flags:
    bcc @carry_flag_not_set
    ora #$01
    @carry_flag_not_set:
    sta scratch + 5
    lda #%00011000 ; Disable NMI
    sta PPUCTRL
    lda #%00000110
    sta PPUMASK ; Disable rendering
    stx scratch + 2
    sty scratch + 3
    tsx
    stx scratch + 4
    crash_handler_after_preserve_vars:
    bit $2002
    @vblankwait1:
    bit $2002
    bpl @vblankwait1
    @vblankwait2:
    bit $2002
    bpl @vblankwait2

    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    lda #$06
    ldy #$08
    :
    ldx #$00
    :
    sta PPUDATA
    dex
    bne :-
    dey
    bne :--

    lda #$23
    sta PPUADDR
    lda #$C0
    sta PPUADDR
    lda #$00
    ldx #$40
    :
    sta PPUDATA
    dex
    bne :-

    lda #$20
    sta PPUADDR
    lda #$62
    sta PPUADDR
    ldx #$00
    clc
    :
    lda CrashMessage, x
    beq :+
    sta PPUDATA
    inx
    jmp :-
    :
    lda #$20
    sta PPUADDR
    lda #$82
    sta PPUADDR
    inx
    :
    lda CrashMessage, x
    beq :+
    sta PPUDATA
    inx
    jmp :-
    :
    lda #$21
    sta PPUADDR
    lda #$02
    sta PPUADDR
    inx
    :
    lda CrashMessage, x
    beq :+
    sta PPUDATA
    inx
    jmp :-
    :

    lda #$21
    sta PPUADDR
    lda #$22
    sta PPUADDR
    ldx #$00
    @dump_stack_new_line:
    ldy #14
    @dump_stack:
    lda $100, x
    sta scratch
    lsr
    lsr
    lsr
    lsr
    clc
    adc #$DC
    sta PPUDATA
    lda scratch
    and #$0F
    adc #$DC
    sta PPUDATA
    inx
    beq @after_stack_dump
    dey
    bne @dump_stack
    lda #$06
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    jmp @dump_stack_new_line
    @after_stack_dump:

    jsr init_apu

    lda #$20
    sta PPUADDR
    lda #$C2
    sta PPUADDR
    lda #$E6
    sta PPUDATA
    ldy #$06
    sty PPUDATA
    lda scratch + 1
    jsr print_hex
    sty PPUDATA
    sty PPUDATA
    lda #$FD
    sta PPUDATA
    sty PPUDATA
    lda scratch + 2
    jsr print_hex
    sty PPUDATA
    sty PPUDATA
    lda #$FE
    sta PPUDATA
    sty PPUDATA
    lda scratch + 3
    jsr print_hex
    sty PPUDATA
    sty PPUDATA
    lda #$F8
    sta PPUDATA
    sty PPUDATA
    lda scratch + 4
    jsr print_hex
    sty PPUDATA
    sty PPUDATA
    lda #$F5
    sta PPUDATA
    sty PPUDATA
    lda scratch + 5
    jsr print_hex
    
    lda #$20
    sta PPUADDR
    lda #$22
    sta PPUADDR
    ldx #$00
    :
    lda VersionNumber, x
    beq :+
    sta PPUDATA
    inx
    jmp :-
    :

    bit PPUSTATUS ; Clear v-blank flag
    :
    bit PPUSTATUS ; Wait until v-blank
    bpl :-

    lda #$3F ; Reset palettes
    sta PPUADDR
    lda #$01
    sta PPUADDR
    lda #$20
    sta PPUDATA
    lda #$0F
    ldx #30
    :
    sta PPUDATA
    dex
    bne :-
    
    lda #$00
    sta PPUSCROLL
    sta PPUSCROLL

    lda #%00011000
    sta PPUCTRL
    lda #%00001110
    sta PPUMASK
    jmp forever

print_hex:
    sta scratch
    lsr
    lsr
    lsr
    lsr
    clc
    adc #$DC
    sta PPUDATA
    lda scratch
    and #$0F
    adc #$DC
    sta PPUDATA
    rts

.include "light_switch.s"
.include "player.s"
.include "electric_gate.s"

.segment "RODATA"

NULL_OBJECT = 0
LIGHT_SWITCH_OBJECT = 1
PLAYER_OBJECT = 2
ELECTRIC_GATE_OBJECT = 3

NumObjects:
    .byte $04
.define ObjectStepPointers \
    $0000, \
    light_switch_step, \
    player_step, \
    electric_gate_step
ObjectStepPointersLow:
    .lobytes ObjectStepPointers
ObjectStepPointersHigh:
    .hibytes ObjectStepPointers

.define ObjectInitPointers \
    $0000, \
    light_switch_init, \
    player_init, \
    electric_gate_init
ObjectInitPointersLow:
    .lobytes ObjectInitPointers
ObjectInitPointersHigh:
    .hibytes ObjectInitPointers

ObjectHitboxXOffsets:
    .byte $00 ; Null object
    .byte $00 ; Light switch
    .byte $03 ; Player
    .byte $03 ; Electric gate

ObjectHitboxYOffsets:
    .byte $00 ; Null object
    .byte $00 ; Light switch
    .byte $02 ; Player
    .byte $00 ; Electric gate

ObjectHitboxWidths:
    .byte $00 ; Null object
    .byte $08 ; Light switch
    .byte 10 ; Player
    .byte $08 ; Electric gate

ObjectHitboxHeights:
    .byte $00 ; Null object
    .byte $10 ; Light switch
    .byte 11 ; Player
    .byte 48 ; Electric gate

.enum MetaSprite
    Test0
    Test1
    PlayerIdle
    PlayerWalk0
    PlayerWalk1
    PlayerJump
    PlayerHurt
    LightSwitch0
    LightSwitch1
    LightSwitch2
    LightSwitch3
    LightSwitch4
    ElectricGateOff
    ElectricGateOn0
    ElectricGateOn1
    ElectricGateOn2
    ElectricGateOn3
    ElectricGateOn4
    ElectricGateOn5
    ElectricGateOn6
    ElectricGateOn7
    Teleport0
    Teleport1
    Teleport2
    Teleport3
    Teleport4
    Teleport5
    Teleport6
    Teleport7
    Teleport8
    Teleport9
    Teleport10
    Teleport11
    Teleport12
    Teleport13
    Teleport14
    Teleport15
.endenum

; Sprite layout structure:
; 1 byte for the number of sprites, 1 byte for width in pixels, 1 byte for height in pixels
; For each sprite, 1 byte for index, 1 byte for x offset, 1 byte for y offset, and 1 byte for attributes
NumMetaSprites:
    .byte 37
.define MetaSpritePointers \
    TestMetaSprite0, \
    TestMetaSprite1, \
    PlayerIdleSprite, \
    PlayerWalkSprite0, \
    PlayerWalkSprite1, \
    PlayerJumpSprite, \
    PlayerHurtSprite, \
    LightSwitchSprite0, \
    LightSwitchSprite1, \
    LightSwitchSprite2, \
    LightSwitchSprite3, \
    LightSwitchSprite4, \
    ElectricGateOff, \
    ElectricGateOn0, \
    ElectricGateOn1, \
    ElectricGateOn2, \
    ElectricGateOn3, \
    ElectricGateOn4, \
    ElectricGateOn5, \
    ElectricGateOn6, \
    ElectricGateOn7, \
    Teleport0, \
    Teleport1, \
    Teleport2, \
    Teleport3, \
    Teleport4, \
    Teleport5, \
    Teleport6, \
    Teleport7, \
    Teleport8, \
    Teleport9, \
    Teleport10, \
    Teleport11, \
    Teleport12, \
    Teleport13, \
    Teleport14, \
    Teleport15
MetaSpritePointersLow:
    .lobytes MetaSpritePointers
MetaSpritePointersHigh:
    .hibytes MetaSpritePointers

TestMetaSprite0:
    .byte $04 ; Num sprites
    .byte $10 ; Width
    .byte $20 ; Height

    .byte $01       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $03       ; Index
    .byte $08       ; X offset
    .byte $00       ; Y offset
    .byte %00000001 ; Attributes

    .byte $05       ; Index
    .byte $00       ; X offset
    .byte $10       ; Y offset
    .byte %00000010 ; Attributes

    .byte $07       ; Index
    .byte $08       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

TestMetaSprite1:
    .byte $04 ; Num sprites
    .byte $10 ; Width
    .byte $20 ; Height

    .byte $09       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $08       ; X offset
    .byte $00       ; Y offset
    .byte %00000001 ; Attributes

    .byte $0D       ; Index
    .byte $00       ; X offset
    .byte $10       ; Y offset
    .byte %00000010 ; Attributes

    .byte $0F       ; Index
    .byte $08       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

PlayerIdleSprite:
    .byte $02 ; Num sprites
    .byte $10 ; Width
    .byte $10 ; Height

    .byte $11       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $13       ; Index
    .byte $08       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

PlayerWalkSprite0:
    .byte $02 ; Num sprites
    .byte $10 ; Width
    .byte $10 ; Height

    .byte $15       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $17       ; Index
    .byte $08       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

PlayerWalkSprite1:
    .byte $02 ; Num sprites
    .byte $10 ; Width
    .byte $10 ; Height

    .byte $19       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1B       ; Index
    .byte $08       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

PlayerJumpSprite:
    .byte $02 ; Num sprites
    .byte $10 ; Width
    .byte $10 ; Height

    .byte $1D       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $08       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

PlayerHurtSprite:
    .byte $02 ; Num sprites
    .byte $10 ; Width
    .byte $10 ; Height

    .byte $25       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $27       ; Index
    .byte $08       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

LightSwitchSprite0:
    .byte $01 ; Num sprites
    .byte $08 ; Width
    .byte $10 ; Height

    .byte $01       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000010 ; Attributes

LightSwitchSprite1:
    .byte $01 ; Num sprites
    .byte $08 ; Width
    .byte $10 ; Height

    .byte $03       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000010 ; Attributes

LightSwitchSprite2:
    .byte $01 ; Num sprites
    .byte $08 ; Width
    .byte $10 ; Height

    .byte $05       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000010 ; Attributes

LightSwitchSprite3:
    .byte $01 ; Num sprites
    .byte $08 ; Width
    .byte $10 ; Height

    .byte $03       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %10000010 ; Attributes

LightSwitchSprite4:
    .byte $01 ; Num sprites
    .byte $08 ; Width
    .byte $10 ; Height

    .byte $01       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %10000010 ; Attributes

ElectricGateOff:
    .byte $04 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

ElectricGateOn0:
    .byte $07 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $10       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

ElectricGateOn1:
    .byte $07 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

ElectricGateOn2:
    .byte $07 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $20       ; Y offset
    .byte %01000000 ; Attributes

ElectricGateOn3:
    .byte $07 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $20       ; Y offset
    .byte %01000000 ; Attributes

ElectricGateOn4:
    .byte $07 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $20       ; Y offset
    .byte %10000000 ; Attributes

ElectricGateOn5:
    .byte $07 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $20       ; Y offset
    .byte %10000000 ; Attributes

ElectricGateOn6:
    .byte $07 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0B       ; Index
    .byte $04       ; X offset
    .byte $20       ; Y offset
    .byte %10000000 ; Attributes

ElectricGateOn7:
    .byte $07 ; Num sprites
    .byte $10 ; Width
    .byte $30 ; Height

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte (256 - 16)  ; Y offset
    .byte %10000000 ; Attributes

    .byte $07       ; Index
    .byte $00       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $09       ; Index
    .byte $08       ; X offset
    .byte $20       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %11000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %11000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $20       ; Y offset
    .byte %11000000 ; Attributes

Teleport0:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0B       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $00       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $0D       ; Index
    .byte $0C       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $0C       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $18       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $18       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0D       ; Index
    .byte $0B       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $0B       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

Teleport1:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0B       ; Index
    .byte $01       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $01       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $0D       ; Index
    .byte $11       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $11       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $17       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $17       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0D       ; Index
    .byte $06       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $06       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

Teleport2:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $0B       ; Index
    .byte $15       ; X offset
    .byte $00       ; Y offset
    .byte %01000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $15       ; X offset
    .byte $10       ; Y offset
    .byte %01000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $15       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $15       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0B       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

Teleport3:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0D       ; Index
    .byte $07       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $07       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $0B       ; Index
    .byte $17       ; X offset
    .byte $00       ; Y offset
    .byte %01000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $17       ; X offset
    .byte $10       ; Y offset
    .byte %01000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $11       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $11       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0B       ; Index
    .byte $01       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $01       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

Teleport4:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0B       ; Index
    .byte $0C       ; X offset
    .byte $00       ; Y offset
    .byte %01000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $0C       ; X offset
    .byte $10       ; Y offset
    .byte %01000011 ; Attributes

    .byte $0D       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %10000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $00       ; X offset
    .byte $10       ; Y offset
    .byte %10000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $18       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $18       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0B       ; Index
    .byte $0C       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $0C       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

Teleport5:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0B       ; Index
    .byte $11       ; X offset
    .byte $00       ; Y offset
    .byte %01000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $11       ; X offset
    .byte $10       ; Y offset
    .byte %01000011 ; Attributes

    .byte $0D       ; Index
    .byte $01       ; X offset
    .byte $00       ; Y offset
    .byte %10000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $01       ; X offset
    .byte $10       ; Y offset
    .byte %10000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $17       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $17       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

    .byte $0B       ; Index
    .byte $07       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $07       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

Teleport6:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0D       ; Index
    .byte $15       ; X offset
    .byte $00       ; Y offset
    .byte %01000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $15       ; X offset
    .byte $10       ; Y offset
    .byte %01000011 ; Attributes

    .byte $0B       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $15       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $15       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

Teleport7:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0D       ; Index
    .byte $17       ; X offset
    .byte $00       ; Y offset
    .byte %01000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $17       ; X offset
    .byte $10       ; Y offset
    .byte %01000011 ; Attributes

    .byte $0B       ; Index
    .byte $07       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $07       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $11       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $11       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0D       ; Index
    .byte $01       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $01       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

Teleport8:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0B       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $00       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $0D       ; Index
    .byte $0B       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $0B       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $18       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $18       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0D       ; Index
    .byte $0C       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $0C       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

Teleport9:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0B       ; Index
    .byte $01       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $01       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $0D       ; Index
    .byte $11       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $11       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $17       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $17       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0D       ; Index
    .byte $07       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $07       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

Teleport10:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0D       ; Index
    .byte $02       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $02       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $0B       ; Index
    .byte $15       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $15       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $16       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $16       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0B       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %11000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %11000000 ; Attributes

Teleport11:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0D       ; Index
    .byte $06       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $06       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $0B       ; Index
    .byte $17       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $17       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $12       ; X offset
    .byte $00       ; Y offset
    .byte %10000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $12       ; X offset
    .byte $10       ; Y offset
    .byte %10000000 ; Attributes

    .byte $0B       ; Index
    .byte $01       ; X offset
    .byte $00       ; Y offset
    .byte %11000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $01       ; X offset
    .byte $10       ; Y offset
    .byte %11000000 ; Attributes

Teleport12:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0D       ; Index
    .byte $FF       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $FF       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $0B       ; Index
    .byte $0C       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $0C       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $0C       ; X offset
    .byte $00       ; Y offset
    .byte %11000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $0C       ; X offset
    .byte $10       ; Y offset
    .byte %11000000 ; Attributes

    .byte $0D       ; Index
    .byte $19       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $19       ; X offset
    .byte $10       ; Y offset
    .byte %00000000 ; Attributes

Teleport13:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0D       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %11000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $00       ; X offset
    .byte $10       ; Y offset
    .byte %11000011 ; Attributes

    .byte $0B       ; Index
    .byte $11       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $11       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0B       ; Index
    .byte $07       ; X offset
    .byte $00       ; Y offset
    .byte %11000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $07       ; X offset
    .byte $10       ; Y offset
    .byte %11000000 ; Attributes

    .byte $0D       ; Index
    .byte $18       ; X offset
    .byte $00       ; Y offset
    .byte %00000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $18       ; X offset
    .byte $10       ; Y offset
    .byte %00000000 ; Attributes

Teleport14:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0B       ; Index
    .byte $03       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $03       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $0D       ; Index
    .byte $16       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $16       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $02       ; X offset
    .byte $00       ; Y offset
    .byte %11000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $02       ; X offset
    .byte $10       ; Y offset
    .byte %11000000 ; Attributes

    .byte $0B       ; Index
    .byte $15       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $15       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

Teleport15:
    .byte $0A ; Num sprites
    .byte $20 ; Width
    .byte $20 ; Height

    .byte $0B       ; Index
    .byte $07       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0B       ; Index
    .byte $07       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $0D       ; Index
    .byte $18       ; X offset
    .byte $00       ; Y offset
    .byte %00000011 ; Attributes
    
    .byte $0D       ; Index
    .byte $18       ; X offset
    .byte $10       ; Y offset
    .byte %00000011 ; Attributes

    .byte $1D       ; Index
    .byte $08       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $1F       ; Index
    .byte $10       ; X offset
    .byte $08       ; Y offset
    .byte %00000000 ; Attributes

    .byte $0D       ; Index
    .byte $00       ; X offset
    .byte $00       ; Y offset
    .byte %11000000 ; Attributes
    
    .byte $0D       ; Index
    .byte $00       ; X offset
    .byte $10       ; Y offset
    .byte %11000000 ; Attributes

    .byte $0B       ; Index
    .byte $11       ; X offset
    .byte $00       ; Y offset
    .byte %01000000 ; Attributes
    
    .byte $0B       ; Index
    .byte $11       ; X offset
    .byte $10       ; Y offset
    .byte %01000000 ; Attributes

.enum
    ANIM_PLAYER_IDLE
    ANIM_PLAYER_WALK
    ANIM_PLAYER_JUMP
    ANIM_PLAYER_HURT
    ANIM_LIGHT_SWITCH_DOWN
    ANIM_LIGHT_SWITCH_UP
    ANIM_ELECTRIC_GATE_OFF
    ANIM_ELECTRIC_GATE_ON
    ANIM_TELEPORT
.endenum

NumAnimations:
    .byte $09
.define AnimationFramePointers \
    AnimPlayerIdleFrames, \
    AnimPlayerWalkFrames, \
    AnimPlayerJumpFrames, \
    AnimPlayerHurtFrames, \
    AnimLightSwitchDownFrames, \
    AnimLightSwitchUpFrames, \
    AnimElectricGateOffFrames, \
    AnimElectricGateOnFrames, \
    AnimTeleportFrames
AnimationFramePointersLow:
    .lobytes AnimationFramePointers
AnimationFramePointersHigh:
    .hibytes AnimationFramePointers

.define AnimationFrameLengthPointers \
    AnimPlayerIdleLengths, \
    AnimPlayerWalkLengths, \
    AnimPlayerJumpLengths, \
    AnimPlayerHurtLengths, \
    AnimLightSwitchDownLengths, \
    AnimLightSwitchUpLengths, \
    AnimElectricGateOffLengths, \
    AnimElectricGateOnLengths, \
    AnimTeleportLengths
AnimationFrameLengthPointersLow:
    .lobytes AnimationFrameLengthPointers
AnimationFrameLengthPointersHigh:
    .hibytes AnimationFrameLengthPointers

; Highest bit determines whether animation loops or not
AnimationLengths:
    .byte 1         ; Player idle
    .byte 128 + 4   ; Player walk
    .byte 2         ; Player jump
    .byte 1         ; Player hurt
    .byte 5         ; Light switch down
    .byte 5         ; Light switch up
    .byte 1         ; Electric gate off
    .byte 128 + 8   ; Electric gate on
    .byte 128 + 16  ; Teleport

AnimPlayerIdleFrames:
    .byte MetaSprite::PlayerIdle

AnimPlayerIdleLengths:
    .byte $FF

AnimPlayerWalkFrames:
    .byte MetaSprite::PlayerWalk0, MetaSprite::PlayerIdle, MetaSprite::PlayerWalk1, MetaSprite::PlayerIdle

AnimPlayerWalkLengths:
    .byte $08, $08, $08, $08

AnimPlayerJumpFrames:
    .byte MetaSprite::PlayerWalk0, MetaSprite::PlayerJump

AnimPlayerJumpLengths:
    .byte $01, $00

AnimPlayerHurtFrames:
    .byte MetaSprite::PlayerHurt

AnimPlayerHurtLengths:
    .byte $FF

AnimLightSwitchDownFrames:
    .byte MetaSprite::LightSwitch0, MetaSprite::LightSwitch1, MetaSprite::LightSwitch2, MetaSprite::LightSwitch3, MetaSprite::LightSwitch4

AnimLightSwitchDownLengths:
    .byte $03, $03, $03, $03, $03

AnimLightSwitchUpFrames:
    .byte MetaSprite::LightSwitch4, MetaSprite::LightSwitch3, MetaSprite::LightSwitch2, MetaSprite::LightSwitch1, MetaSprite::LightSwitch0

AnimLightSwitchUpLengths:
    .byte $03, $03, $03, $03, $03

AnimElectricGateOffFrames:
    .byte MetaSprite::ElectricGateOff

AnimElectricGateOffLengths:
    .byte $00

AnimElectricGateOnFrames:
    .byte MetaSprite::ElectricGateOn0, MetaSprite::ElectricGateOn1, MetaSprite::ElectricGateOn2, MetaSprite::ElectricGateOn3 
    .byte MetaSprite::ElectricGateOn4, MetaSprite::ElectricGateOn5, MetaSprite::ElectricGateOn6, MetaSprite::ElectricGateOn7

AnimElectricGateOnLengths:
    .byte $02, $02, $02, $02, $02, $02, $02, $02

AnimTeleportFrames:
    .byte MetaSprite::Teleport0, MetaSprite::Teleport1, MetaSprite::Teleport2, MetaSprite::Teleport3
    .byte MetaSprite::Teleport4, MetaSprite::Teleport5, MetaSprite::Teleport6, MetaSprite::Teleport7
    .byte MetaSprite::Teleport8, MetaSprite::Teleport9, MetaSprite::Teleport10, MetaSprite::Teleport11
    .byte MetaSprite::Teleport12, MetaSprite::Teleport13, MetaSprite::Teleport14, MetaSprite::Teleport15

AnimTeleportLengths:
    .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

MetaTilesTopLeft:
    .byte $00, $00, $0E, $14, $16, $00, $02, $07, $09, $42, $43, $00, $1F, $26, $28, $00, $34, $00, $3E, $00, $1B, $1D, $20, $25, $2E, $30, $31, $30, $2E, $3A, $3C, $3A, $44, $46, $54, $56, $48, $4A, $58, $5A, $63, $65, $64, $64, $6E, $70, $72, $74, $6E, $20, $78, $7A, $91, $6E, $83, $7F, $74, $6E, $20, $8A, $8B, $20, $8A, $6E, $20, $92, $94, $9A, $9C, $A1
MetaTilesTopRight:
    .byte $00, $0D, $0F, $15, $17, $01, $00, $08, $0A, $42, $43, $1E, $00, $27, $29, $33, $00, $3D, $00, $1A, $1C, $00, $20, $00, $2F, $31, $2F, $32, $39, $3B, $39, $32, $45, $47, $55, $57, $49, $4B, $59, $5B, $64, $64, $64, $66, $6F, $71, $73, $75, $76, $77, $79, $75, $75, $82, $84, $85, $75, $80, $89, $80, $75, $75, $75, $74, $75, $93, $95, $9B, $99, $A1
MetaTilesBottomLeft:
    .byte $00, $10, $12, $00, $18, $03, $05, $00, $0B, $43, $43, $00, $24, $2A, $2C, $00, $38, $00, $41, $1A, $20, $22, $20, $20, $2E, $36, $31, $36, $2E, $31, $3F, $31, $4C, $4E, $00, $5D, $50, $52, $5F, $61, $67, $69, $6A, $6C, $7B, $7C, $7C, $7C, $67, $20, $7F, $20, $7C, $67, $70, $88, $74, $67, $8C, $8E, $90, $88, $20, $6E, $8D, $96, $98, $9D, $9F, $00
MetaTilesBottomRight:
    .byte $00, $11, $13, $00, $19, $04, $06, $00, $0C, $43, $43, $23, $00, $2B, $2D, $37, $00, $40, $00, $20, $21, $00, $20, $1B, $35, $31, $35, $32, $31, $3B, $31, $32, $4D, $4F, $5C, $5E, $51, $53, $60, $62, $68, $68, $6B, $6D, $7C, $7C, $7C, $7D, $7E, $77, $80, $81, $7D, $86, $87, $86, $81, $85, $8D, $8F, $81, $81, $81, $86, $75, $97, $99, $9E, $A0, $00

MetaTileCollision:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $0F, $0F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $11

MetaMetaTilesTopLeft:
    .byte $00, $01, $05, $09, $0A, $0B, $0F, $00, $14, $18, $1A, $20, $24, $28, $2A, $2B, $28, $2A, $2A, $35, $37, $37, $2C, $2E, $2E, $2B, $3D, $2F, $24, $20, $29, $28, $3F, $2C, $41, $20, $24, $20, $24, $45, $45
MetaMetaTilesTopRight:
    .byte $00, $02, $06, $09, $0A, $0C, $10, $13, $15, $19, $1B, $21, $25, $29, $29, $25, $29, $29, $2B, $36, $36, $38, $2D, $2D, $34, $21, $25, $21, $25, $21, $2B, $2B, $38, $2F, $42, $2C, $25, $21, $25, $45, $45
MetaMetaTilesBottomLeft:
    .byte $00, $03, $07, $0A, $0A, $0D, $11, $13, $16, $1C, $1E, $22, $26, $2C, $2E, $2F, $30, $32, $32, $39, $3B, $3B, $22, $26, $22, $33, $3E, $22, $26, $2B, $2D, $30, $39, $22, $43, $22, $2A, $28, $29, $22, $26
MetaMetaTilesBottomRight:
    .byte $00, $04, $08, $0A, $0A, $0E, $12, $16, $17, $1D, $1F, $23, $27, $2D, $2D, $27, $31, $31, $33, $3A, $3A, $3C, $23, $27, $23, $23, $27, $23, $28, $23, $2F, $33, $40, $23, $44, $23, $29, $29, $2B, $23, $27

MetaMetaTileAttributes:
    .byte $00, $00, $00, $55, $55, $FF, $55, $AA, $AA, $AA, $AA, $AA, $AA, $00, $00, $88, $00, $00, $00, $00, $00, $00, $A0, $A0, $A0, $88, $88, $A8, $2A, $8A, $00, $00, $00, $A0, $55, $A2, $0A, $0A, $0A, $AF, $AF

NumLevels:
    .byte $02

LevelBackgroundColors:
    .byte $26, $0F

LevelBackgroundPalette0Color0:
    .byte $30, $24

LevelBackgroundPalette0Color1:
    .byte $34, $14

LevelBackgroundPalette0Color2:
    .byte $0F, $04

LevelBackgroundPalette1Color0:
    .byte $2C, $3D

LevelBackgroundPalette1Color1:
    .byte $12, $00

LevelBackgroundPalette1Color2:
    .byte $13, $09

LevelBackgroundPalette2Color0:
    .byte $35, $2A

LevelBackgroundPalette2Color1:
    .byte $25, $1B

LevelBackgroundPalette2Color2:
    .byte $05, $09

LevelBackgroundPalette3Color0:
    .byte $0F, $2C

LevelBackgroundPalette3Color1:
    .byte $15, $1C

LevelBackgroundPalette3Color2:
    .byte $16, $0C

LevelLengths:
    .byte $05, $20
.define LevelTilePointers \
    Level0Tiles, \
    Level1Tiles
LevelTilePointersLow:
    .lobytes LevelTilePointers
LevelTilePointersHigh:
    .hibytes LevelTilePointers

Level0Tiles:
    .byte $00, $00, $00, $00, $00, $00, $03, $04
    .byte $00, $01, $00, $00, $05, $06, $03, $04
    .byte $00, $03, $02, $00, $00, $03, $04, $00
    .byte $02, $00, $03, $00, $07, $03, $00, $00
    .byte $03, $00, $01, $00, $03, $0A, $00, $00
    .byte $00, $00, $00, $03, $00, $00, $00, $03
    .byte $02, $00, $00, $03, $00, $00, $03, $04
    .byte $00, $00, $00, $03, $05, $06, $03, $04
    .byte $04, $04, $04, $04, $00, $00, $03, $04
    .byte $00, $01, $00, $00, $07, $09, $03, $04
    .byte $00, $00, $00, $00, $08, $0A, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $02, $00, $00, $00, $00, $03, $04
    .byte $01, $00, $03, $00, $00, $05, $03, $04
    .byte $00, $00, $00, $03, $00, $00, $00, $03
    .byte $00, $03, $02, $00, $07, $03, $00, $00
    .byte $03, $00, $00, $00, $03, $0A, $00, $00
    .byte $00, $00, $01, $00, $00, $00, $03, $04
    .byte $00, $02, $00, $00, $00, $00, $03, $04
    .byte $00, $00, $00, $00, $05, $06, $03, $04
    .byte $02, $00, $00, $00, $05, $06, $03, $04
    .byte $00, $01, $00, $00, $05, $06, $03, $04
    .byte $00, $00, $00, $00, $07, $09, $03, $04
    .byte $00, $00, $02, $00, $08, $0A, $03, $04
    .byte $00, $00, $00, $00, $05, $06, $03, $04
    .byte $01, $00, $00, $00, $05, $06, $03, $04
    .byte $00, $02, $00, $00, $05, $06, $03, $04
    .byte $00, $00, $00, $00, $00, $00, $03, $04
    .byte $02, $00, $05, $06, $06, $06, $03, $04
    .byte $00, $00, $00, $00, $00, $00, $03, $04
    .byte $02, $00, $01, $00, $07, $09, $03, $04
    .byte $00, $00, $00, $00, $08, $0A, $03, $04
    .byte $00, $02, $00, $00, $07, $09, $03, $04
    .byte $00, $00, $00, $00, $08, $0A, $03, $04
    .byte $01, $00, $02, $00, $07, $09, $03, $04
    .byte $00, $00, $00, $00, $08, $0A, $03, $04
    .byte $00, $00, $00, $00, $07, $09, $03, $04
    .byte $00, $02, $00, $00, $08, $0A, $03, $04
    .byte $00, $00, $01, $00, $00, $00, $03, $04
    .byte $02, $00, $00, $00, $00, $00, $03, $04

Level1Tiles:
    .byte $0C, $0C, $0B, $11, $17, $0C, $0E, $0B
    .byte $0C, $0B, $0B, $11, $17, $0C, $0E, $0C
    .byte $0C, $0D, $0B, $11, $17, $0B, $0E, $0B
    .byte $0C, $0E, $0B, $11, $17, $0C, $0E, $0C
    .byte $0B, $0E, $0C, $11, $17, $0C, $0E, $0C
    .byte $0C, $0E, $0B, $11, $17, $0B, $0E, $0B
    .byte $0B, $0E, $0B, $11, $17, $0B, $0E, $0C
    .byte $0C, $0E, $0C, $11, $17, $0B, $0E, $16
    .byte $0C, $0E, $0C, $11, $17, $0B, $1E, $1B
    .byte $1C, $1E, $0B, $11, $17, $0C, $0B, $0C
    .byte $10, $16, $0C, $11, $17, $0C, $0C, $0B
    .byte $11, $17, $0B, $12, $18, $0C, $0C, $0C
    .byte $12, $18, $0C, $1D, $0D, $20, $20, $21
    .byte $0B, $0C, $0B, $0B, $1E, $1B, $0C, $0C
    .byte $0D, $0C, $0C, $0C, $0C, $0B, $0C, $0B
    .byte $0E, $0B, $0C, $22, $0B, $0C, $0C, $0B
    .byte $0E, $0C, $0C, $0C, $0B, $0C, $0B, $0B
    .byte $0E, $0B, $0C, $0B, $0C, $0B, $0C, $0C
    .byte $0E, $0B, $0C, $0C, $22, $0B, $0C, $0C
    .byte $0E, $0C, $0C, $0B, $0B, $0C, $0B, $0C
    .byte $0E, $0B, $0B, $0D, $0B, $0B, $0C, $0C
    .byte $0E, $0C, $0B, $10, $13, $13, $13, $16
    .byte $0F, $0C, $0B, $12, $15, $15, $15, $18
    .byte $0C, $0C, $0B, $11, $17, $0C, $0B, $0C
    .byte $0C, $0C, $0B, $11, $17, $0B, $0B, $0B
    .byte $16, $0C, $0C, $19, $1B, $0C, $0C, $10
    .byte $17, $0B, $0B, $0C, $0C, $0C, $0C, $11
    .byte $1B, $0B, $0B, $10, $16, $0B, $0C, $19
    .byte $0B, $0B, $0C, $11, $17, $0C, $0B, $0B
    .byte $0C, $0B, $0B, $11, $17, $0B, $0C, $0B
    .byte $0D, $0B, $0C, $11, $17, $0B, $0C, $0B
    .byte $0E, $0C, $0C, $11, $17, $0C, $0C, $0B
    .byte $20, $20, $20, $20, $21, $0C, $0C, $1F
    .byte $17, $0C, $0C, $1D, $22, $0C, $1C, $0E
    .byte $17, $0C, $0B, $0B, $0B, $0B, $22, $0E
    .byte $18, $0B, $25, $16, $0B, $0D, $22, $0E
    .byte $1B, $0B, $22, $18, $0C, $1E, $0B, $0F
    .byte $0C, $0C, $0B, $10, $13, $16, $0C, $0C
    .byte $1C, $22, $0B, $12, $15, $18, $0B, $0B
    .byte $20, $20, $20, $20, $21, $0C, $0B, $1F
    .byte $16, $0C, $0C, $0C, $22, $0B, $0B, $10
    .byte $18, $0C, $0D, $0C, $10, $16, $0B, $12
    .byte $0B, $0C, $1E, $0B, $12, $18, $0B, $0B
    .byte $13, $13, $16, $0C, $0C, $10, $13, $13
    .byte $1A, $1A, $1B, $0C, $0C, $19, $1A, $1A
    .byte $0B, $0C, $0B, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $22, $0C, $0B, $0B, $22, $0B, $0C
    .byte $0B, $0B, $0B, $0B, $0B, $0B, $0C, $0B
    .byte $0B, $0C, $0B, $0C, $0C, $0B, $0B, $0B
    .byte $22, $0C, $0C, $0B, $0B, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0B, $0B, $0B, $0B, $0B
    .byte $0B, $0B, $22, $0B, $0C, $22, $0B, $0B
    .byte $13, $13, $16, $0B, $0B, $0D, $10, $13
    .byte $15, $15, $18, $0B, $0C, $0E, $12, $15
    .byte $0B, $0C, $0B, $0C, $0B, $0E, $0B, $0B
    .byte $0D, $0C, $0C, $0C, $0C, $0F, $0C, $0B
    .byte $0E, $0B, $0C, $0C, $0B, $0C, $0B, $0C
    .byte $0E, $0C, $0C, $0B, $0C, $22, $0C, $0C
    .byte $0E, $0B, $0B, $0B, $0B, $0C, $0B, $0C
    .byte $1E, $0B, $0C, $0C, $22, $0C, $0C, $0C
    .byte $16, $0C, $0C, $0B, $0B, $0C, $0C, $10
    .byte $17, $0B, $0C, $0C, $0B, $0C, $0B, $11
    .byte $18, $0B, $0B, $22, $0B, $0B, $0C, $12
    .byte $0B, $0C, $25, $13, $13, $13, $13, $16
    .byte $0C, $0B, $26, $15, $15, $15, $15, $18
    .byte $16, $0C, $0D, $13, $13, $13, $13, $13
    .byte $1B, $0B, $0E, $1A, $1A, $1A, $1A, $1A
    .byte $21, $0C, $1E, $0C, $0D, $20, $20, $20
    .byte $0C, $0B, $28, $0C, $0E, $0C, $0B, $0B
    .byte $0B, $0B, $27, $0B, $0E, $0C, $0B, $0C
    .byte $0B, $0B, $27, $0B, $0E, $0B, $0C, $0C
    .byte $0C, $0C, $28, $0B, $1E, $0C, $0B, $0C
    .byte $0B, $0C, $10, $13, $16, $0C, $0C, $0B
    .byte $0B, $0B, $19, $1A, $1B, $0B, $0C, $0C
    .byte $0C, $0B, $0B, $0C, $0C, $0B, $0C, $0C
    .byte $0C, $0B, $0C, $0B, $0B, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0C, $0C, $0B, $0B, $0B
    .byte $0B, $0B, $0C, $0C, $0C, $0B, $0C, $0B
    .byte $0C, $0C, $0B, $0C, $0B, $0C, $0B, $0B
    .byte $0B, $0B, $0B, $0C, $0C, $0B, $0B, $0B
    .byte $0B, $0B, $0C, $0B, $0C, $0C, $0B, $0C
    .byte $0B, $0B, $0B, $0B, $0C, $0B, $0B, $0C
    .byte $0C, $0B, $0B, $0B, $0B, $0C, $0C, $0B
    .byte $0C, $0C, $0B, $0B, $0C, $0B, $0B, $0C
    .byte $0B, $0C, $0C, $0B, $0C, $0C, $0B, $0B
    .byte $0C, $0B, $0B, $0C, $0B, $0B, $0C, $0B
    .byte $0B, $0C, $0C, $0B, $0B, $0B, $0B, $0C
    .byte $0C, $0B, $0B, $0C, $0B, $0B, $0B, $0C
    .byte $0B, $0C, $0B, $0C, $0C, $0C, $0C, $0B
    .byte $0B, $0C, $0C, $0C, $0B, $0B, $0C, $0C
    .byte $0B, $0B, $0B, $0C, $0C, $0C, $0B, $0C
    .byte $0C, $0C, $0C, $0B, $0B, $0B, $0B, $0B
    .byte $0B, $0B, $0C, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0B, $0B, $0B, $0C, $0B, $0B
    .byte $0C, $0B, $0C, $0C, $0B, $0C, $0C, $0C
    .byte $0B, $0B, $0B, $0C, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0B, $0B, $0C, $0C, $0C, $0C
    .byte $0B, $0C, $0B, $0C, $0B, $0C, $0C, $0B
    .byte $0B, $0C, $0C, $0C, $0B, $0C, $0C, $0B
    .byte $0B, $0B, $0C, $0C, $0C, $0B, $0B, $0B
    .byte $0C, $0C, $0C, $0C, $0B, $0C, $0B, $0C
    .byte $0B, $0B, $0C, $0B, $0C, $0C, $0C, $0B
    .byte $0C, $0C, $0C, $0B, $0C, $0C, $0B, $0C
    .byte $0C, $0C, $0B, $0B, $0C, $0B, $0B, $0B
    .byte $0B, $0B, $0C, $0B, $0B, $0C, $0B, $0C
    .byte $0B, $0C, $0B, $0B, $0B, $0B, $0B, $0C
    .byte $0C, $0B, $0B, $0C, $0C, $0B, $0B, $0B
    .byte $0B, $0B, $0C, $0B, $0B, $0C, $0B, $0C
    .byte $0C, $0B, $0B, $0C, $0B, $0C, $0C, $0C
    .byte $0C, $0C, $0B, $0C, $0B, $0C, $0B, $0B
    .byte $0C, $0B, $0C, $0C, $0B, $0B, $0C, $0B
    .byte $0C, $0B, $0C, $0B, $0C, $0C, $0B, $0C
    .byte $0C, $0B, $0C, $0C, $0B, $0C, $0C, $0C
    .byte $0B, $0C, $0B, $0C, $0B, $0C, $0C, $0B
    .byte $0B, $0C, $0B, $0B, $0B, $0B, $0C, $0C
    .byte $0C, $0B, $0B, $0C, $0C, $0C, $0C, $0C
    .byte $0B, $0C, $0C, $0C, $0B, $0B, $0B, $0B
    .byte $0C, $0C, $0C, $0C, $0B, $0C, $0C, $0B
    .byte $0B, $0B, $0B, $0B, $0B, $0C, $0B, $0B
    .byte $0C, $0C, $0C, $0B, $0C, $0B, $0B, $0C
    .byte $0B, $0B, $0C, $0B, $0C, $0C, $0C, $0C
    .byte $0B, $0C, $0C, $0B, $0C, $0C, $0B, $0B
    .byte $0B, $0B, $0B, $0B, $0C, $0B, $0B, $0C
    .byte $0B, $0C, $0B, $0C, $0B, $0B, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0B, $0C, $0C, $0C
    .byte $0C, $0B, $0C, $0C, $0B, $0C, $0B, $0C
    .byte $0B, $0C, $0B, $0B, $0B, $0C, $0B, $0B
    .byte $0C, $0C, $0C, $0C, $0B, $0B, $0C, $0C
    .byte $0B, $0C, $0B, $0C, $0C, $0B, $0C, $0B
    .byte $0C, $0B, $0C, $0C, $0B, $0B, $0B, $0B
    .byte $0C, $0C, $0C, $0B, $0B, $0B, $0C, $0B
    .byte $0B, $0C, $0B, $0B, $0B, $0B, $0C, $0B
    .byte $0B, $0C, $0B, $0B, $0C, $0C, $0B, $0B
    .byte $0C, $0C, $0C, $0C, $0C, $0B, $0C, $0C
    .byte $0B, $0B, $0B, $0B, $0C, $0B, $0C, $0C
    .byte $0B, $0C, $0B, $0C, $0C, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0C, $0C, $0B, $0C, $0B
    .byte $0C, $0C, $0B, $0C, $0B, $0B, $0C, $0C
    .byte $0B, $0C, $0C, $0C, $0C, $0C, $0C, $0B
    .byte $0C, $0B, $0C, $0C, $0B, $0B, $0C, $0B
    .byte $0C, $0B, $0C, $0B, $0B, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0B, $0C, $0B, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0B
    .byte $0B, $0C, $0C, $0B, $0B, $0C, $0C, $0B
    .byte $0C, $0B, $0C, $0B, $0B, $0C, $0C, $0C
    .byte $0C, $0C, $0B, $0C, $0B, $0C, $0B, $0B
    .byte $0B, $0B, $0B, $0B, $0B, $0B, $0C, $0C
    .byte $0C, $0B, $0C, $0B, $0B, $0C, $0C, $0B
    .byte $0B, $0C, $0B, $0C, $0C, $0C, $0B, $0C
    .byte $0B, $0C, $0C, $0C, $0B, $0C, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0B, $0C, $0B, $0B
    .byte $0C, $0B, $0C, $0C, $0C, $0C, $0B, $0B
    .byte $0C, $0B, $0C, $0C, $0C, $0B, $0C, $0B
    .byte $0B, $0B, $0C, $0B, $0B, $0C, $0B, $0C
    .byte $0B, $0B, $0C, $0C, $0B, $0C, $0B, $0B
    .byte $0C, $0B, $0C, $0B, $0B, $0B, $0B, $0B
    .byte $0C, $0C, $0B, $0B, $0C, $0B, $0B, $0B
    .byte $0C, $0B, $0B, $0C, $0B, $0C, $0C, $0C
    .byte $0B, $0C, $0B, $0B, $0B, $0B, $0C, $0C
    .byte $0B, $0C, $0B, $0B, $0C, $0C, $0C, $0C
    .byte $0C, $0C, $0B, $0B, $0B, $0C, $0B, $0C
    .byte $0B, $0C, $0B, $0B, $0B, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0C, $0C, $0C, $0C, $0B
    .byte $0C, $0C, $0B, $0B, $0C, $0B, $0C, $0C
    .byte $0B, $0B, $0C, $0B, $0C, $0B, $0C, $0B
    .byte $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0C
    .byte $0B, $0B, $0B, $0B, $0C, $0B, $0C, $0C
    .byte $0B, $0B, $0B, $0C, $0B, $0B, $0B, $0C
    .byte $0C, $0B, $0C, $0C, $0C, $0B, $0C, $0B
    .byte $0B, $0C, $0C, $0B, $0B, $0B, $0C, $0B
    .byte $0B, $0C, $0C, $0C, $0B, $0B, $0C, $0C
    .byte $0C, $0B, $0B, $0C, $0B, $0B, $0C, $0B
    .byte $0B, $0B, $0C, $0C, $0C, $0B, $0C, $0C
    .byte $0C, $0B, $0B, $0C, $0B, $0C, $0B, $0C
    .byte $0B, $0C, $0C, $0C, $0B, $0B, $0B, $0B
    .byte $0B, $0C, $0C, $0B, $0C, $0C, $0B, $0B
    .byte $0C, $0B, $0C, $0B, $0C, $0B, $0B, $0C
    .byte $0C, $0B, $0B, $0B, $0C, $0B, $0B, $0C
    .byte $0C, $0B, $0B, $0B, $0C, $0B, $0C, $0B
    .byte $0C, $0C, $0C, $0B, $0C, $0C, $0B, $0B
    .byte $0B, $0C, $0C, $0C, $0C, $0B, $0C, $0B
    .byte $0B, $0B, $0C, $0C, $0C, $0C, $0B, $0C
    .byte $0C, $0B, $0B, $0B, $0C, $0B, $0C, $0B
    .byte $0C, $0C, $0C, $0C, $0C, $0B, $0C, $0B
    .byte $0B, $0B, $0B, $0C, $0B, $0B, $0C, $0C
    .byte $0C, $0C, $0B, $0B, $0B, $0B, $0C, $0B
    .byte $0B, $0B, $0B, $0C, $0C, $0B, $0C, $0B
    .byte $0C, $0B, $0C, $0B, $0B, $0B, $0C, $0C
    .byte $0B, $0B, $0B, $0B, $0C, $0B, $0B, $0C
    .byte $0B, $0B, $0B, $0B, $0C, $0B, $0C, $0B
    .byte $0C, $0C, $0B, $0C, $0B, $0C, $0C, $0B
    .byte $0C, $0B, $0C, $0C, $0B, $0C, $0B, $0B
    .byte $0B, $0B, $0C, $0B, $0C, $0C, $0B, $0B
    .byte $0C, $0C, $0B, $0B, $0B, $0C, $0B, $0C
    .byte $0C, $0B, $0C, $0C, $0B, $0C, $0B, $0B
    .byte $0C, $0C, $0B, $0B, $0C, $0B, $0B, $0C
    .byte $0C, $0B, $0B, $0B, $0C, $0C, $0B, $0C
    .byte $0B, $0B, $0C, $0C, $0C, $0C, $0B, $0C
    .byte $0C, $0C, $0C, $0B, $0C, $0B, $0B, $0B
    .byte $0C, $0B, $0B, $0C, $0C, $0C, $0C, $0B
    .byte $0B, $0B, $0C, $0B, $0C, $0C, $0B, $0C
    .byte $0B, $0C, $0C, $0C, $0C, $0C, $0C, $0B
    .byte $0B, $0C, $0B, $0C, $0B, $0C, $0B, $0B
    .byte $0B, $0C, $0C, $0C, $0C, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0C, $0B, $0B, $0B, $0C
    .byte $0C, $0B, $0B, $0C, $0C, $0C, $0B, $0C
    .byte $0C, $0C, $0C, $0C, $0B, $0B, $0B, $0B
    .byte $0B, $0B, $0C, $0C, $0B, $0C, $0B, $0C
    .byte $0C, $0B, $0B, $0C, $0B, $0B, $0B, $0C
    .byte $0B, $0B, $0B, $0B, $0B, $0C, $0B, $0C
    .byte $0B, $0C, $0C, $0C, $0B, $0C, $0B, $0B
    .byte $0C, $0B, $0C, $0C, $0C, $0C, $0B, $0B
    .byte $0C, $0C, $0B, $0B, $0B, $0B, $0B, $0B
    .byte $0B, $0B, $0B, $0B, $0B, $0B, $0C, $0B
    .byte $0C, $0B, $0B, $0B, $0C, $0C, $0C, $0B
    .byte $0B, $0C, $0C, $0C, $0C, $0B, $0B, $0C
    .byte $0B, $0B, $0B, $0C, $0C, $0B, $0C, $0C
    .byte $0C, $0B, $0C, $0B, $0B, $0B, $0B, $0C
    .byte $0B, $0C, $0C, $0B, $0B, $0B, $0C, $0C
    .byte $0C, $0C, $0C, $0C, $0C, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0B, $0B, $0B, $0C, $0B
    .byte $0B, $0B, $0C, $0C, $0C, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0B, $0B, $0C, $0B, $0C
    .byte $0C, $0C, $0C, $0C, $0B, $0B, $0B, $0C
    .byte $0B, $0B, $0B, $0C, $0C, $0B, $0C, $0C
    .byte $0C, $0C, $0B, $0C, $0B, $0B, $0B, $0C
    .byte $0C, $0B, $0C, $0B, $0B, $0C, $0C, $0B
    .byte $0C, $0C, $0C, $0C, $0C, $0B, $0B, $0B
    .byte $0B, $0C, $0B, $0C, $0B, $0B, $0C, $0C
    .byte $0C, $0B, $0C, $0B, $0B, $0C, $0B, $0C
    .byte $0C, $0C, $0C, $0B, $0B, $0C, $0B, $0B
    .byte $0B, $0C, $0B, $0B, $0B, $0C, $0C, $0C
    .byte $0C, $0C, $0B, $0C, $0C, $0C, $0C, $0B
    .byte $0C, $0C, $0C, $0B, $0B, $0C, $0B, $0B
    .byte $0C, $0C, $0C, $0C, $0B, $0C, $0B, $0C
    .byte $0C, $0B, $0C, $0C, $0C, $0B, $0C, $0B
    .byte $0C, $0C, $0B, $0B, $0B, $0B, $0B, $0C
    .byte $0C, $0B, $0B, $0B, $0B, $0C, $0B, $0C
    .byte $0B, $0C, $0C, $0B, $0C, $0B, $0B, $0C
    .byte $0C, $0B, $0C, $0B, $0B, $0B, $0B, $0B
    .byte $0B, $0B, $0C, $0C, $0C, $0C, $0B, $0B
    .byte $0C, $0C, $0C, $0C, $0C, $0B, $0C, $0C
    .byte $0B, $0B, $0B, $0B, $0B, $0C, $0B, $0C
    .byte $0B, $0B, $0C, $0B, $0C, $0B, $0C, $0C
    .byte $0C, $0C, $0B, $0C, $0B, $0B, $0B, $0C
    .byte $0C, $0C, $0B, $0C, $0B, $0B, $0C, $0C
    .byte $0B, $0B, $0C, $0B, $0C, $0C, $0B, $0B
    .byte $0B, $0C, $0C, $0C, $0C, $0B, $0C, $0C
    .byte $0C, $0C, $0C, $0B, $0B, $0C, $0B, $0C
    .byte $0C, $0C, $0C, $0C, $0B, $0B, $0B, $0C
    .byte $0C, $0C, $0C, $0B, $0C, $0C, $0C, $0B
    .byte $0B, $0B, $0B, $0C, $0C, $0C, $0B, $0C
    .byte $0C, $0B, $0B, $0B, $0C, $0B, $0C, $0C
    .byte $0B, $0C, $0B, $0B, $0B, $0C, $0C, $0B
    .byte $0B, $0C, $0C, $0C, $0C, $0C, $0C, $0B
    .byte $0C, $0C, $0B, $0B, $0B, $0C, $0C, $0B

.define LevelObjectListPointers \
    Level0ObjectList, \
    Level1ObjectList
LevelObjectListPointersLow:
    .lobytes LevelObjectListPointers
LevelObjectListPointersHigh:
    .hibytes LevelObjectListPointers

    .byte $00, $00, $00, $00 ; Terminator
Level0ObjectList:
    .byte $01, $00, $20, $20 ; ID, Page, X Position, Y Position
    .byte $01, $00, $80, $20
    .byte $01, $00, $F0, $40
    .byte $01, $01, $60, $60
    .byte $01, $02, $10, $20
    .byte $01, $02, $10, $30
    .byte $01, $02, $10, $40
    .byte $01, $02, $10, $50
    .byte $01, $02, $80, $20
    .byte $01, $03, $20, $20
    .byte $01, $03, $40, $20
    .byte $01, $03, $B0, $20
    .byte $01, $04, $50, $20
    .byte $00, $00, $00, $00 ; Terminator
Level1ObjectList:
    .byte ELECTRIC_GATE_OBJECT, $00, $C0, $E0 ; ID, Page, X Position, Y Position
    .byte LIGHT_SWITCH_OBJECT, $00, $F0, $08
    .byte LIGHT_SWITCH_OBJECT, $00, $F0, $48
    .byte ELECTRIC_GATE_OBJECT, $01, $60, $30
    .byte LIGHT_SWITCH_OBJECT, $01, $84, $48
    .byte LIGHT_SWITCH_OBJECT, $04, $84, $C8
    .byte ELECTRIC_GATE_OBJECT, $05, $28, $B0
    .byte ELECTRIC_GATE_OBJECT, $08, $28, $10
    .byte LIGHT_SWITCH_OBJECT, $08, $54, $D0
    .byte $00, $00, $00, $00 ; Terminator

TitleScreenPalette:
    .byte $0F, $3C, $2C, $0F, $20, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $31, $11, $0F, $33, $13, $0F, $35, $15, $0F, $37, $17, $0F

.enum GameState
    INTRO
    TITLE_SCREEN
    OPENING
    GAMEPLAY
.endenum

.define GameLoopJumpTable \
    intro_logic - 1, \
    title_screen_logic - 1, \
    opening_logic - 1, \
    gameplay_logic - 1

GameLoopJumpTableLow:
    .lobytes GameLoopJumpTable

GameLoopJumpTableHigh:
    .hibytes GameLoopJumpTable

.include "song_list.s"
.include "title_theme.s"
.include "silence_song.s"
.include "death_sound.s"
.include "alarm_sound.s"
.include "sound_effects.s"

.macro asciizoffset Str, Off
   .repeat .strlen(Str), I
      .byte .strat(Str, I) + Off
   .endrep
   .byte 0
.endmacro

.macro asciioffset Str, Off
   .repeat .strlen(Str), I
      .byte .strat(Str, I) + Off
   .endrep
.endmacro

CrashMessage:
    asciizoffset "A FATAL ERROR HAS OCCURRED", $A5
    asciizoffset "PLEASE REPORT THIS ISSUE", $A5
    asciizoffset "STACK DUMP", $A5

VersionNumber:
    asciioffset "V", $A5
    asciizoffset "00", $AC

PauseString:
    asciizoffset "PAUSED", $A5

PressStartString:
    asciizoffset "PRESS START", $A5

OpeningLine0:
    asciizoffset "WARNING", $A5

OpeningLine1:
    asciizoffset "GRAVITATIONAL ANOMALY DETECTED", $A5

OpeningLine2:
    asciizoffset "WARP DRIVE DYSFUNCTIONAL", $A5

OpeningLine3:
    asciizoffset "COLLISION IMMINENT", $A5

.define OpeningLinePointers \
    OpeningLine0, \
    OpeningLine1, \
    OpeningLine2, \
    OpeningLine3

OpeningLinePointersHigh:
    .hibytes OpeningLinePointers ; Could optimize these out since they're all the same

OpeningLinePointersLow:
    .lobytes OpeningLinePointers

.define OpeningStringLocations \
    $212D, \
    $21A2, \
    $21E5, \
    $2228

OpeningStringLocationsHigh:
    .hibytes OpeningStringLocations

OpeningStringLocationsLow:
    .lobytes OpeningStringLocations

LogoTileLayout:
	.byte $f3, $06, $06, $06, $d9, $d5, $d5, $d5, $db, $d9, $db, $06, $d9, $db ; 13 literals
	.byte $05, $03 ; 6 backrefs
	.byte $08, $0e ; 9 backrefs
	.byte $02, $00 ; 3 backrefs
	.byte $02, $1e ; 3 backrefs
	.byte $fe, $d8, $da ; 2 literals
	.byte $05, $1f ; 6 backrefs
	.byte $fe, $d8, $da ; 2 literals
	.byte $0c, $27 ; 13 backrefs
	.byte $08, $38 ; 9 backrefs
	.byte $02, $08 ; 3 backrefs
	.byte $07, $01 ; 8 backrefs
	.byte $0d, $04 ; 14 backrefs
	.byte $19, $1c ; 26 backrefs
	.byte $07, $5e ; 8 backrefs
	.byte $04, $3e ; 5 backrefs
	.byte $09, $4d ; 10 backrefs
	.byte $0d, $09 ; 14 backrefs
	.byte $09, $38 ; 10 backrefs
	.byte $27, $a3 ; 40 backrefs
	.byte $05, $73 ; 6 backrefs
	.byte $02, $96 ; 3 backrefs
	.byte $03, $d1 ; 4 backrefs
	.byte $12, $94 ; 19 backrefs
	.byte $05, $42 ; 6 backrefs
	.byte $fc, $db, $06, $d5, $d7 ; 4 literals
	.byte $0a, $6d ; 11 backrefs
	.byte $0f, $c2 ; 16 backrefs
	.byte $02, $0c ; 3 backrefs
	.byte $ff, $d5 ; 1 literal
	.byte $03, $ef ; 4 backrefs
	.byte $19, $da ; 26 backrefs
	.byte $fe, $d6, $d5 ; 2 literals
	.byte $05, $f6 ; 6 backrefs
	.byte $0f, $bd ; 16 backrefs
	.byte $02, $1a ; 3 backrefs
	.byte $ff, $da ; 1 literal
	.byte $04, $d5 ; 5 backrefs
	.byte $06, $82 ; 7 backrefs
	.byte $04, $5a ; 5 backrefs
	.byte $00 ; terminator

.segment "CHARS"
    .incbin "bg.bin"
    .incbin "sprites.bin"