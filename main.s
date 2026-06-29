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

.zeropage
    scratch: .res $10
    frame_done: .res 1
    frame_count: .res 1
    background_color: .res 1
    background_palettes: .res 12
    sprite_palettes: .res 12
    x_scroll: .res 1
    y_scroll: .res 1
    current_ppu_mask: .res 1
    current_ppu_ctrl: .res 1

.segment "HEADER"
  ; .byte "NES", $1A      ; iNES header identifier
  .byte $4E, $45, $53, $1A
  .byte 2               ; 2x 16KB PRG code
  .byte 1               ; 1x  8KB CHR data
  .byte $01, $00        ; mapper 0, vertical mirroring

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

vblank_routine:
    inc frame_done ; Set back to 0
    pla ; Restore A register, not really needed
    lda #$02 ; Push sprites to OAM
    sta OAMDMA

    @push_palettes_to_ppu:
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

.segment "CHARS"
    .incbin "bg.bin"
    .incbin "sprites.bin"