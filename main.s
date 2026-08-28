.feature line_continuations +

PPUCTRL = $2000
PPUMASK = $2001
PPUSTATUS = $2002
OAMADDR = $2003
OAMDATA = $2004
PPUSCROLL = $2005
PPUADDR = $2006
PPUDATA = $2007
APUDMC = $4010
OAMDMA = $4014
JOY1 = $4016
JOY2 = $4017
APUFRAMECOUNTER = $4017
OAMBUFFER = $0200
BUTTON_A =      %10000000
BUTTON_B =      %01000000
BUTTON_SELECT = %00100000
BUTTON_START =  %00010000
BUTTON_UP =     %00001000
BUTTON_DOWN =   %00000100
BUTTON_LEFT =   %00000010
BUTTON_RIGHT =  %00000001
WILL_LOAD_LEVEL = 0
LEVEL_READY = 1
LEVEL_LOADED = 2
SCROLL_SPEED = 2
OBJECT_FLIPPED_V =      %10000000
OBJECT_FLIPPED_H =      %01000000
OBJECT_IS_PRIORITY =    %00100000
OBJECT_IS_HIDDEN =      %00010000

.zeropage
    scratch: .res $10
    frame_done: .res 1
    frame_count: .res 1
    background_color: .res 1
    background_palettes: .res 12
    sprite_palettes: .res 12
    current_page: .res 1
    x_scroll: .res 1
    y_scroll: .res 1
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
    object_variables_0: .res $10
    object_variables_1: .res $10
    object_variables_2: .res $10
    object_variables_3: .res $10
    object_variables_4: .res $10
    object_variables_5: .res $10
    object_variables_6: .res $10
    tile_buffer_1: .res 30
    tile_buffer_2: .res 30
    tile_buffer_3: .res 30
    tile_buffer_4: .res 30

.segment "HEADER"  
    .byte $4E, $45, $53, $1A    ; iNES header identifier
    .byte 2                     ; 2x 16KB PRG code
    .byte 1                     ; 1x  8KB CHR data
    .byte $01, $00              ; mapper 0, vertical mirroring

.segment "VECTORS"
    .addr nmi
    .addr reset
    .addr 0

.segment "STARTUP"

.segment "CODE"

reset:
    sei        ; ignore IRQs
    cld        ; disable decimal mode
    ldx #$40
    stx $4017  ; disable APU frame IRQ
    ldx #$ff
    txs        ; set stack pointer to $01ff
    inx        ; now X = 0
    stx $2000  ; disable NMI
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
@load_palettes:
    lda #$26
    sta background_color
    lda #$20
    sta background_palettes
    lda #$34
    sta background_palettes + 1
    lda #$0F
    sta background_palettes + 2
    lda #$1C
    sta background_palettes + 3
    lda #$13
    sta background_palettes + 4
    lda #$12
    sta background_palettes + 5
    lda #$35
    sta background_palettes + 6
    lda #$05
    sta background_palettes + 7
    lda #$25
    sta background_palettes + 8
    lda #$15
    sta background_palettes + 9
    lda #$16
    sta background_palettes + 10
    lda #$0F
    sta background_palettes + 11
    lda #$01
    sta sprite_palettes
    lda #$12
    sta sprite_palettes + 1
    lda #$22
    sta sprite_palettes + 2
    lda #$04
    sta sprite_palettes + 3
    lda #$14
    sta sprite_palettes + 4
    lda #$24
    sta sprite_palettes + 5
    lda #$06
    sta sprite_palettes + 6
    lda #$16
    sta sprite_palettes + 7
    lda #$26
    sta sprite_palettes + 8
    lda #$09
    sta sprite_palettes + 9
    lda #$19
    sta sprite_palettes + 10
    lda #$29
    sta sprite_palettes + 11

    ldx #$00 ; Init OAM
    lda #$FF
    :
    sta OAMBUFFER, x
    inx
    bne :-

    lda #$00 ; Is this necessary?
    sta OAMADDR

    lda PPUSTATUS ; Clear VRAM
    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    ldy #$08
    :
    ldx #$00
    :
    sta PPUDATA
    dex
    bne :-
    dey
    bne :--

    lda #%00011110  ; Enable rendering
    sta current_ppu_mask

    dec frame_done

    lda #%10100000	; Enable NMI and set sprite size
    sta current_ppu_ctrl
    sta PPUCTRL

    lda #$01
    ldx #$00
    :
    sta object_ids, x
    inx
    cpx #16
    bcc :-
    lda #$08
    ldx #$00
    :
    sta object_x_page_subpixels, x
    inx
    cpx #16
    bcc :-
    lda #$00
    ldx #$00
    :
    sta object_x_positions, x
    clc
    adc #$20
    cmp #$80
    bcc :+
    lda #$00
    :
    inx
    cpx #16
    bcc :--
    lda #$08
    ldx #$00
    :
    sta object_y_positions, x
    inx
    sta object_y_positions, x
    inx
    sta object_y_positions, x
    inx
    sta object_y_positions, x
    clc
    adc #$40
    inx
    cpx #16
    bcc :-
    lda #$01
    ldx #$01
    :
    sta object_animations_ids, x
    inx
    inx
    cpx #16
    bcc :-
    lda #OBJECT_FLIPPED_H
    sta object_flags + 4
    sta object_flags + 5
    sta object_flags + 6
    sta object_flags + 7
    lda #OBJECT_FLIPPED_V
    sta object_flags + 8
    sta object_flags + 9
    sta object_flags + 10
    sta object_flags + 11
    lda #OBJECT_FLIPPED_H + OBJECT_FLIPPED_V
    sta object_flags + 12
    sta object_flags + 13
    sta object_flags + 14
    sta object_flags + 15

forever:
    jmp forever

nmi:
    pha ; Save A register
    lda frame_done
    bne @after_early_return
    pla
    rti
@after_early_return:

@vblank_routine:
    lda game_state ; Check if we load level
    bne :+
    jmp load_level
    :
    inc frame_done ; Set back to 0
    pla ; Restore A register, not really needed
    lda #$02 ; Push sprites to OAM
    sta OAMDMA

@push_vram_updates:
    tsx
    stx scratch
    ldx #$FF
    txs
    @pop_slide:
    pla
    beq @end_pop_slide
    tax
    pla
    sta PPUCTRL
    bit PPUSTATUS
    pla
    sta PPUADDR
    pla
    sta PPUADDR
    @loop:
    pla
    sta PPUDATA
    dex
    bne @loop
    jmp @pop_slide
    @end_pop_slide:
    ldx scratch
    txs
    lda #$00
    sta $0100
    sta vram_buffer_index

@push_palettes_to_ppu:
    lda current_ppu_ctrl
    and #%11111011 ; Set PPU increment to right
    sta current_ppu_ctrl
    sta PPUCTRL
    lda PPUSTATUS
    lda #$3F
    sta PPUADDR
    lda #$01
    sta PPUADDR
    .repeat 4, i
    .if i <> 0
    sta PPUDATA
    .endif
    lda background_palettes + i * 3
    sta PPUDATA
    lda background_palettes + i * 3 + 1
    sta PPUDATA
    lda background_palettes + i * 3 + 2
    sta PPUDATA
    .endrepeat
    lda background_color
    .repeat 4, i
    sta PPUDATA
    lda sprite_palettes + i * 3
    sta PPUDATA
    lda sprite_palettes + i * 3 + 1
    sta PPUDATA
    lda sprite_palettes + i * 3 + 2
    sta PPUDATA
    .endrepeat

    bit PPUSTATUS ; Set scroll
    lda x_scroll
    sta PPUSCROLL
    lda y_scroll
    sta PPUSCROLL

    lda current_ppu_mask
    sta PPUMASK

    lda current_ppu_ctrl
    sta PPUCTRL

game_logic:
    inc frame_count
    jsr read_controllers

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

    jsr handle_scroll

    ; Build sprites
    lda #$00
    sta oam_offset ; Number of bytes in OAM we've used so far
    sta scratch + 2 ; Flag for if we've made any sprites
    lda frame_count
    and #$0F
    sta scratch + 3 ; Index to start from
    tax
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
    lda object_animations_ids, x
    cmp NumSpriteLayouts ; Check if the index is out of bounds
    bcc :+
    jmp @end_build_sprite_loop
    :
    tay
    lda SpriteLayoutPointersLow, y
    sta scratch
    lda SpriteLayoutPointersHigh, y
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
    jmp @after_finish_build_sprites ; Don't try to do more than 64 sprites
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
    eor scratch + 10
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
    eor scratch + 10
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
    bcc :+
    jmp @end_single_sprite_loop ; Skip if this sprite ended up off screen
    :
    sec
    sbc #$01 ; Account for the 1 pixel vertical offset
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
    txa
    clc
    adc #$07
    and #$0F
    cmp scratch + 3
    beq :+
    tax
    jmp @start_build_sprite_loop ; Loop until we reach the one we started on
    :
    @after_finish_build_sprites:
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

dynamic_jump:
    jmp (scratch)

; Clobbers A, X, Y, 00, 01, 02, 03, 04, 05, 06, 07
handle_scroll:
    ldx current_level ; Store this for later
    lda LevelLengths, x
    sta scratch + 2
    lda x_scroll 
    lsr ; We care about 8 pixel intervals, so 3 right shifts
    lsr
    lsr
    sta scratch ; Store scroll before
    lda controller_input
    and #BUTTON_RIGHT
    beq @not_pressing_right
    lda #$01
    sta scratch + 4 ; Store that we're scrolling right
    lda current_page ; Check if we're already at the end
    dec scratch + 2
    cmp scratch + 2
    bcc :+
    rts ; Return early if we're already at the right edge
    :
    inc scratch + 2
    lda x_scroll
    clc
    adc #SCROLL_SPEED
    sta x_scroll
    bcc @no_overflow
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
    @no_overflow:
    jmp @not_pressing_left
    @not_pressing_right:
    lda controller_input
    and #BUTTON_LEFT
    beq @not_pressing_left
    lda #$00
    sta scratch + 4 ; Store that we're scrolling left
    lda x_scroll
    sec
    sbc #SCROLL_SPEED
    sta x_scroll
    bcs @not_pressing_left
    lda current_page
    bne @decrement_page ; Check if we reached left edge of screen
    lda #$00
    sta x_scroll
    rts ; Early return because nothing needs to be loaded
    @decrement_page:
    dec current_page
    lda current_ppu_ctrl ; Switch to the other nametable
    eor #$00000001
    sta current_ppu_ctrl
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
    ldy scratch + 4
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
    

; Level number in A register
; Clobbers A, X, Y, 00, 01, 02, 03, 04, 05, 06, 07, 08, 09
load_level:
    sta current_level
    tax
    lda current_ppu_ctrl
    lda #$20 ; Get ready to update nametable
    sta scratch + 3
    lda #$00
    sta scratch + 4
    lda #$23 ; Get ready to update attributes
    sta scratch + 7
    lda #$C0
    sta scratch + 8
    lda #$00
    sta scratch + 9 ; Current column number
    sta current_page ; Reset scroll-related variables
    sta x_scroll
    sta y_scroll
    lda current_ppu_ctrl
    and #%01111100 ; Set scroll to top left and disable NMI
    ora #%00000100 ; Set PPU increment to down
    sta current_ppu_ctrl
    sta PPUCTRL
    lda current_ppu_mask
    and #%11100111 ; Disable rendering
    sta current_ppu_mask
    sta PPUMASK
    lda LevelTilePointersLow, x
    sta scratch
    lda LevelTilePointersHigh, x
    sta scratch + 1

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


    lda #LEVEL_LOADED
    sta game_state
    lda current_ppu_mask
    ora #%00011000 ; Turn rendering back on at next NMI
    sta current_ppu_mask
    lda PPUSTATUS
    lda current_ppu_ctrl
    ora #%10000000 ; Turn NMI back on
    sta current_ppu_ctrl
    sta PPUCTRL
    pla
    rti

; Object index in X
player_step:
    rts

NumObjects:
    .byte $02
.define ObjectStepPointers \
    $0000, \
    player_step
ObjectStepPointersLow:
    .lobytes ObjectStepPointers
ObjectStepPointersHigh:
    .hibytes ObjectStepPointers

; Sprite layout structure:
; 1 byte for the number of sprites, 1 byte for width in pixels, 1 byte for height in pixels
; For each sprite, 1 byte for index, 1 byte for x offset, 1 byte for y offset, and 1 byte for attributes
NumSpriteLayouts:
    .byte $02
.define SpriteLayoutPointers \
    TestSpriteLayout0, \
    TestSpriteLayout1
SpriteLayoutPointersLow:
    .lobytes SpriteLayoutPointers
SpriteLayoutPointersHigh:
    .hibytes SpriteLayoutPointers

TestSpriteLayout0:
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

TestSpriteLayout1:
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

MetaTilesTopLeft:
    .byte $00, $00, $0E, $14, $16, $00, $02, $07, $09, $42, $43, $00, $1F, $26, $28, $00, $34, $00, $3E, $00, $1B, $1D, $20, $25, $2E, $30, $31, $30, $2E, $3A, $3C, $3A
MetaTilesTopRight:
    .byte $00, $0D, $0F, $15, $17, $01, $00, $08, $0A, $42, $43, $1E, $00, $27, $29, $33, $00, $3D, $00, $1A, $1C, $00, $20, $00, $2F, $31, $2F, $32, $39, $3B, $39, $32
MetaTilesBottomLeft:
    .byte $00, $10, $12, $00, $18, $03, $05, $00, $0B, $43, $43, $00, $24, $2A, $2C, $00, $38, $00, $41, $1A, $20, $22, $20, $20, $2E, $36, $31, $36, $2E, $31, $3F, $31
MetaTilesBottomRight:
    .byte $00, $11, $13, $00, $19, $04, $06, $00, $0C, $43, $43, $23, $00, $2B, $2D, $37, $00, $40, $00, $20, $21, $00, $20, $1B, $35, $31, $35, $32, $31, $3B, $31, $32

MetaMetaTilesTopLeft:
    .byte $00, $01, $05, $09, $0A, $0B, $0F, $00, $14, $18, $1A
MetaMetaTilesTopRight:
    .byte $00, $02, $06, $09, $0A, $0C, $10, $13, $15, $19, $1B
MetaMetaTilesBottomLeft:
    .byte $00, $03, $07, $0A, $0A, $0D, $11, $13, $16, $1C, $1E
MetaMetaTilesBottomRight:
    .byte $00, $04, $08, $0A, $0A, $0E, $12, $16, $17, $1D, $1F

MetaMetaTileAttributes:
    .byte $00, $00, $00, $55, $55, $FF, $55, $AA, $AA, $AA, $AA

LevelLengths:
    .byte $05
.define LevelTilePointers \
    Level0Tiles
LevelTilePointersLow:
    .lobytes LevelTilePointers
LevelTilePointersHigh:
    .hibytes LevelTilePointers

Level0Tiles:
    .byte $00, $00, $00, $00, $00, $00, $03, $04
    .byte $00, $01, $00, $00, $05, $06, $03, $04
    .byte $00, $00, $02, $00, $00, $00, $03, $04
    .byte $02, $00, $00, $00, $07, $09, $03, $04
    .byte $00, $00, $01, $00, $08, $0A, $03, $04
    .byte $00, $00, $00, $00, $00, $00, $03, $04
    .byte $02, $00, $00, $00, $00, $00, $03, $04
    .byte $00, $00, $00, $05, $06, $06, $03, $04
    .byte $00, $00, $02, $00, $00, $00, $03, $04
    .byte $00, $01, $00, $00, $07, $09, $03, $04
    .byte $00, $00, $00, $00, $08, $0A, $03, $04
    .byte $00, $00, $00, $00, $00, $00, $03, $04
    .byte $00, $02, $00, $00, $00, $00, $03, $04
    .byte $01, $00, $00, $00, $00, $05, $03, $04
    .byte $00, $00, $00, $00, $00, $00, $03, $04
    .byte $00, $00, $02, $00, $07, $09, $03, $04
    .byte $02, $00, $00, $00, $08, $0A, $03, $04
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


.segment "CHARS"
    .incbin "bg.bin"
    .incbin "sprites.bin"