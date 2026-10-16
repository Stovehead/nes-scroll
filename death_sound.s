.pushseg
.segment "RODATA"

DeathSoundPulse1:
    .byte SET_VOLUME, %10001000
    .byte SET_SEPARATION, $00
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::Gf3, 20
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::F3, 20
    .byte PLAY_NOTE, Note::Ef3, 10
    .byte PLAY_NOTE, Note::E3, 40
    .byte GOTO_LOOP
    .addr SilenceSongLoop

DeathSoundPulse2:
    .byte SET_VOLUME, %10001000
    .byte SET_SEPARATION, $00
    .byte PLAY_NOTE, Note::Ef3, 10
    .byte PLAY_NOTE, Note::D3, 20
    .byte PLAY_NOTE, Note::B2, 10
    .byte PLAY_NOTE, Note::D3, 20
    .byte PLAY_NOTE, Note::Bf2, 10
    .byte PLAY_NOTE, Note::B2, 40
    .byte GOTO_LOOP
    .addr SilenceSongLoop

DeathSoundTriangle:
    .byte SET_VOLUME, %11000000
    .byte SET_SEPARATION, $02
    .byte PLAY_NOTE, Note::E2, 20
    .byte PLAY_NOTE, Note::E2, 20
    .byte PLAY_NOTE, Note::E2, 20
    .byte PLAY_NOTE, Note::E2, 50
    .byte GOTO_LOOP
    .addr SilenceSongLoop

DeathSoundNoise:
    .byte SET_VOLUME, %00001000
    .byte SET_SEPARATION, 10
    .byte PLAY_NOTE, 7, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_NOTE, 9, 10
    .byte PLAY_NOTE, 9, 10
    .byte PLAY_NOTE, 9, 10
    .byte PLAY_NOTE, 10, 10
    .byte PLAY_NOTE, 10, 10
    .byte PLAY_NOTE, 10, 10
    .byte PLAY_NOTE, 10, 10
    .byte PLAY_NOTE, 10, 10
    .byte PLAY_NOTE, 10, 10
    .byte GOTO_LOOP
    .addr SilenceSongLoop

.popseg