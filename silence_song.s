.pushseg
.segment "RODATA"

SilenceSongPulse1:
SilenceSongPulse2:
SilenceSongNoise:
    .byte SET_VOLUME, %00000000
    @loop:
    .byte PLAY_REST, 255
    .byte GOTO_LOOP
    .addr @loop

SilenceSongTriangle:
    .byte SET_VOLUME, %10000000
    @loop:
    .byte PLAY_REST, 255
    .byte GOTO_LOOP
    .addr @loop

.popseg