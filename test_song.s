.pushseg
.segment "RODATA"

TestSongPulse1:
    .byte SET_VOLUME, %01001111
    .byte SET_SEPARATION, $02
    @loop:
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::C4, 20
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::E4, 40
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::D4, 40
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::G4, 20
    .byte PLAY_NOTE, Note::G4, 40
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::C4, 20
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::E4, 20
    .byte PLAY_NOTE, Note::D4, 20
    .byte PLAY_NOTE, Note::C4, 40
    .byte PLAY_REST, 40
    .byte GOTO_LOOP
    .addr @loop

TestSongPulse2:
    .byte SET_VOLUME, %10001000
    .byte SET_SEPARATION, $00
    @loop:
    .byte PLAY_NOTE, Note::C4, 20
    .byte PLAY_REST, 60
    .byte PLAY_NOTE, Note::C4, 20
    .byte PLAY_REST, 60
    .byte PLAY_NOTE, Note::B3, 20
    .byte PLAY_REST, 60
    .byte PLAY_NOTE, Note::C4, 20
    .byte PLAY_REST, 60
    .byte PLAY_NOTE, Note::C4, 20
    .byte PLAY_REST, 60
    .byte PLAY_NOTE, Note::C4, 20
    .byte PLAY_REST, 60
    .byte PLAY_NOTE, Note::B3, 20
    .byte PLAY_REST, 60
    .byte PLAY_NOTE, Note::A3, 40
    .byte PLAY_REST, 40
    .byte GOTO_LOOP
    .addr @loop

TestSongTriangle:
    .byte SET_VOLUME, %11000000
    .byte SET_SEPARATION, $00
    @loop:
    .byte PLAY_NOTE, Note::E4, 80
    .byte PLAY_NOTE, Note::C4, 80
    .byte PLAY_NOTE, Note::B3, 80
    .byte PLAY_NOTE, Note::C4, 80
    .byte PLAY_NOTE, Note::E4, 80
    .byte PLAY_NOTE, Note::C4, 80
    .byte PLAY_NOTE, Note::B3, 80
    .byte PLAY_NOTE, Note::C4, 40
    .byte PLAY_REST, 40
    .byte GOTO_LOOP
    .addr @loop

TestSongNoise:
    .byte SET_VOLUME, %00001000
    @loop:
    .byte SET_SEPARATION, 40
    .byte PLAY_NOTE, 8, 40
    .byte PLAY_NOTE, 10, 40
    .byte SET_SEPARATION, 20
    .byte PLAY_NOTE, 8, 20
    .byte PLAY_NOTE, 10, 20
    .byte PLAY_NOTE, 8, 20
    .byte SET_SEPARATION, 10
    .byte PLAY_NOTE, 10, 10
    .byte PLAY_NOTE, 10, 10
    .byte SET_SEPARATION, 40
    .byte PLAY_NOTE, 8, 40
    .byte SET_SEPARATION, 20
    .byte PLAY_NOTE, 8, 20
    .byte PLAY_NOTE, 10, 20
    .byte PLAY_NOTE, 8, 20
    .byte PLAY_NOTE, 10, 20
    .byte PLAY_NOTE, 10, 20
    .byte PLAY_NOTE, 10, 20
    .byte GOTO_LOOP
    .addr @loop

.popseg