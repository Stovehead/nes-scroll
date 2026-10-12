.pushseg
.segment "RODATA"

TitleThemePulse1:
    .byte SET_VOLUME, %01001000
    .byte SET_SEPARATION, $02
    .byte PLAY_NOTE, Note::F3, 80
    .byte PLAY_NOTE, Note::Bf3, 80
    @loop:
    .byte PLAY_NOTE, Note::F3, 20
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::F3, 20
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::F3, 20
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 40
    .byte PLAY_NOTE, Note::G3, 40
    .byte PLAY_NOTE, Note::F3, 20
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::F3, 20
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::F3, 20
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::A3, 20
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::G3, 40
    .byte PLAY_REST, 10
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::D4, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::A3, 40
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::D4, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::C4, 10
    .byte PLAY_NOTE, Note::A3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::Bf3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::F3, 40
    .byte GOTO_LOOP
    .addr @loop

TitleThemePulse2:
    .byte SET_VOLUME, %01001000
    .byte SET_SEPARATION, $02
    .byte PLAY_NOTE, Note::C3, 80
    .byte PLAY_NOTE, Note::F3, 80
    @loop:
    .byte PLAY_NOTE, Note::C3, 20
    .byte PLAY_NOTE, Note::F3, 60
    .byte PLAY_NOTE, Note::C3, 20
    .byte PLAY_NOTE, Note::G3, 60
    .byte PLAY_NOTE, Note::C3, 20
    .byte PLAY_NOTE, Note::F3, 60
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::Bf2, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::B2, 10
    .byte PLAY_NOTE, Note::C3, 20
    .byte PLAY_NOTE, Note::F3, 60
    .byte PLAY_NOTE, Note::C3, 20
    .byte PLAY_NOTE, Note::G3, 60
    .byte PLAY_NOTE, Note::C3, 20
    .byte PLAY_NOTE, Note::F3, 60
    .byte PLAY_NOTE, Note::F3, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::Bf2, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::B2, 10
    .byte PLAY_NOTE, Note::C3, 40
    .byte PLAY_NOTE, Note::Bf2, 40
    .byte PLAY_NOTE, Note::A2, 40
    .byte PLAY_NOTE, Note::G2, 40
    .byte PLAY_NOTE, Note::D3, 40
    .byte PLAY_NOTE, Note::A2, 40
    .byte PLAY_NOTE, Note::G2, 40
    .byte PLAY_NOTE, Note::C3, 40
    .byte PLAY_NOTE, Note::C3, 40
    .byte PLAY_NOTE, Note::Bf2, 40
    .byte PLAY_NOTE, Note::A2, 40
    .byte PLAY_NOTE, Note::G2, 40
    .byte PLAY_NOTE, Note::D3, 40
    .byte PLAY_NOTE, Note::A2, 40
    .byte PLAY_NOTE, Note::G2, 40
    .byte PLAY_NOTE, Note::C3, 40
    .byte GOTO_LOOP
    .addr @loop

TitleThemeTriangle:
    .byte SET_VOLUME, %11000000
    .byte SET_SEPARATION, $00
    .byte PLAY_REST, 160
    @loop:
    .byte PLAY_NOTE, Note::F2, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::F2, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::F2, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::F2, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::G2, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::G2, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::G2, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::G2, 10
    .byte PLAY_NOTE, Note::D3, 10
    .byte PLAY_NOTE, Note::A2, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::A2, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::A2, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::A2, 10
    .byte PLAY_NOTE, Note::E3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte PLAY_NOTE, Note::C3, 10
    .byte PLAY_NOTE, Note::G3, 10
    .byte GOTO_LOOP
    .addr @loop

TitleThemeNoise:
    .byte SET_VOLUME, %00001000
    .byte SET_SEPARATION, 10
    .byte PLAY_REST, 80
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_REST, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_REST, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_NOTE, 8, 10
    @loop:
    .byte PLAY_NOTE, 10, 10
    .byte PLAY_NOTE, 10, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_NOTE, 11, 10
    .byte PLAY_NOTE, 11, 10
    .byte PLAY_NOTE, 8, 10
    .byte PLAY_NOTE, 8, 10
    .byte GOTO_LOOP
    .addr @loop

.popseg