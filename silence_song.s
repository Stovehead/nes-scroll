.pushseg
.segment "RODATA"

SilenceSongPulse1:
SilenceSongPulse2:
SilenceSongNoise:
    .byte SET_VOLUME, %00000000
SilenceSongLoop:
    .byte PLAY_REST, 255
    .byte GOTO_LOOP
    .addr SilenceSongLoop

SilenceSongTriangle:
    .byte SET_VOLUME, %10000000
    .byte GOTO_LOOP
    .addr SilenceSongLoop

.popseg