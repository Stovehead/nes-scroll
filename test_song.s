.pushseg
.segment "RODATA"

TestSongPulse1:
    .byte SET_VOLUME, %01001111
    .byte SET_SEPARATION, $02
    @loop:
    .byte PLAY_NOTE, Note::D2, 7
    .byte PLAY_NOTE, Note::D2, 8
    .byte PLAY_NOTE, Note::D3, 7
    .byte PLAY_REST, 8
    .byte PLAY_NOTE, Note::A2, 7
    .byte PLAY_REST, 15
    .byte PLAY_NOTE, Note::Gs2, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::G2, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::F2, 15
    .byte PLAY_NOTE, Note::D2, 8
    .byte PLAY_NOTE, Note::F2, 7
    .byte PLAY_NOTE, Note::G2, 8
    .byte PLAY_NOTE, Note::C2, 7
    .byte PLAY_NOTE, Note::C2, 8
    .byte PLAY_NOTE, Note::D3, 7
    .byte PLAY_REST, 8
    .byte PLAY_NOTE, Note::A2, 7
    .byte PLAY_REST, 15
    .byte PLAY_NOTE, Note::Gs2, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::G2, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::F2, 15
    .byte PLAY_NOTE, Note::D2, 8
    .byte PLAY_NOTE, Note::F2, 7
    .byte PLAY_NOTE, Note::G2, 8
    .byte PLAY_NOTE, Note::B1, 7
    .byte PLAY_NOTE, Note::B1, 8
    .byte PLAY_NOTE, Note::D3, 7
    .byte PLAY_REST, 8
    .byte PLAY_NOTE, Note::A2, 7
    .byte PLAY_REST, 15
    .byte PLAY_NOTE, Note::Gs2, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::G2, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::F2, 15
    .byte PLAY_NOTE, Note::D2, 8
    .byte PLAY_NOTE, Note::F2, 7
    .byte PLAY_NOTE, Note::G2, 8
    .byte PLAY_NOTE, Note::Bf1, 7
    .byte PLAY_NOTE, Note::Bf1, 8
    .byte PLAY_NOTE, Note::D3, 7
    .byte PLAY_REST, 8
    .byte PLAY_NOTE, Note::A2, 7
    .byte PLAY_REST, 15
    .byte PLAY_NOTE, Note::Gs2, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::G2, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::F2, 15
    .byte PLAY_NOTE, Note::D2, 8
    .byte PLAY_NOTE, Note::F2, 7
    .byte PLAY_NOTE, Note::G2, 8
    .byte GOTO_LOOP
    .addr @loop

TestSongPulse2:
    .byte SET_VOLUME, %01001111
    .byte SET_SEPARATION, $03
    .byte PLAY_REST, 120
    .byte PLAY_REST, 120
    .byte PLAY_REST, 120
    .byte PLAY_REST, 120
    @loop:
    .byte PLAY_NOTE, Note::D1, 15
    .byte PLAY_NOTE, Note::D1, 15
    .byte PLAY_NOTE, Note::D1, 7
    .byte PLAY_NOTE, Note::D1, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::D1, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::D1, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::D1, 8
    .byte PLAY_NOTE, Note::D1, 7
    .byte PLAY_NOTE, Note::D1, 8
    .byte PLAY_NOTE, Note::D1, 15
    .byte PLAY_NOTE, Note::C1, 15
    .byte PLAY_NOTE, Note::C1, 15
    .byte PLAY_NOTE, Note::C1, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_NOTE, Note::C1, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_NOTE, Note::C1, 15
    .byte PLAY_NOTE, Note::B0, 15
    .byte PLAY_NOTE, Note::B0, 15
    .byte PLAY_NOTE, Note::B0, 7
    .byte PLAY_NOTE, Note::B0, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::B0, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::B0, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::B0, 8
    .byte PLAY_NOTE, Note::B0, 7
    .byte PLAY_NOTE, Note::B0, 8
    .byte PLAY_NOTE, Note::B0, 15
    .byte PLAY_NOTE, Note::Bf0, 15
    .byte PLAY_NOTE, Note::Bf0, 15
    .byte PLAY_NOTE, Note::Bf0, 7
    .byte PLAY_NOTE, Note::Bf0, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_REST, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_NOTE, Note::C1, 7
    .byte PLAY_NOTE, Note::C1, 8
    .byte PLAY_NOTE, Note::C1, 15
    .byte GOTO_LOOP
    .addr @loop

TestSongTriangle:
    .byte SET_VOLUME, %10000000
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