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

.bss
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
    dec frame_done ; Set to 255
    rti

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