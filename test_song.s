.pushseg
.segment "RODATA"

TestSongPulse1:
    .byte SET_VOLUME, %01001111
    .byte SET_SEPARATION, $01
    @loop:
    .byte PLAY_NOTE, $20, 60
    .byte PLAY_NOTE, $21, 60
    .byte PLAY_NOTE, $22, 60
    .byte PLAY_NOTE, $23, 60
    .byte PLAY_NOTE, $24, 60
    .byte PLAY_NOTE, $25, 60
    .byte GOTO_LOOP
    .addr @loop

TestSongPulse2:
    .byte SET_VOLUME, %01001111
    .byte SET_SEPARATION, $01
    @loop:
    .byte PLAY_REST, 60
    .byte GOTO_LOOP
    .addr @loop

TestSongTriangle:
    .byte SET_VOLUME, %11000000
    .byte SET_SEPARATION, $00
    @loop:
    .byte PLAY_NOTE, $20, 120
    .byte PLAY_NOTE, $22, 120
    .byte PLAY_NOTE, $24, 120
    .byte GOTO_LOOP
    .addr @loop

TestSongNoise:
    .byte SET_VOLUME, %00001111
    .byte SET_SEPARATION, $00
    @loop:
    .byte PLAY_REST, 60
    .byte GOTO_LOOP
    .addr @loop

.popseg