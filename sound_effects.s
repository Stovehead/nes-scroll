.pushseg
.segment "RODATA"

.enum SFX
    LANDING
    POWER_OFF
    POWER_ON
.endenum

.define SoundEffectPointers \
    SfxLanding, \
    SfxPowerOff, \
    SfxPowerOn

SoundEffectPointersLow:
    .lobytes SoundEffectPointers

SoundEffectPointersHigh:
    .hibytes SoundEffectPointers

SfxLanding:
    .byte SET_VOLUME, %00000111
    .byte SET_SEPARATION, 0
    .byte PLAY_NOTE, 8, 1
    .byte PLAY_NOTE, 9, 1
    .byte END_SFX

SfxPowerOff:
    .byte SET_VOLUME, %11000000
    .byte SET_SEPARATION, 0
    .byte PLAY_NOTE, Note::A2, 1
    .byte PLAY_NOTE, Note::Af2, 1
    .byte PLAY_NOTE, Note::G2, 1
    .byte PLAY_NOTE, Note::Gf2, 1
    .byte PLAY_NOTE, Note::F2, 1
    .byte PLAY_NOTE, Note::E2, 1
    .byte PLAY_NOTE, Note::Ef2, 1
    .byte PLAY_NOTE, Note::D2, 1
    .byte PLAY_NOTE, Note::Df2, 1
    .byte PLAY_NOTE, Note::C2, 1
    .byte PLAY_NOTE, Note::B1, 1
    .byte PLAY_NOTE, Note::Bf1, 1
    .byte PLAY_NOTE, Note::A1, 1
    .byte PLAY_NOTE, Note::Af1, 1
    .byte PLAY_NOTE, Note::G1, 1
    .byte PLAY_NOTE, Note::Gf1, 1
    .byte PLAY_NOTE, Note::F1, 1
    .byte PLAY_NOTE, Note::E1, 1
    .byte PLAY_NOTE, Note::Ef1, 2
    .byte PLAY_NOTE, Note::D1, 2
    .byte PLAY_NOTE, Note::C1, 2
    .byte PLAY_NOTE, Note::B0, 4
    .byte END_SFX

SfxPowerOn:
    .byte SET_VOLUME, %11000000
    .byte SET_SEPARATION, 0
    .byte PLAY_NOTE, Note::B0, 4
    .byte PLAY_NOTE, Note::C1, 2
    .byte PLAY_NOTE, Note::D1, 2
    .byte PLAY_NOTE, Note::Ef1, 2
    .byte PLAY_NOTE, Note::E1, 1
    .byte PLAY_NOTE, Note::F1, 1
    .byte PLAY_NOTE, Note::Gf1, 1
    .byte PLAY_NOTE, Note::G1, 1
    .byte PLAY_NOTE, Note::Af1, 1
    .byte PLAY_NOTE, Note::A1, 1
    .byte PLAY_NOTE, Note::Bf1, 1
    .byte PLAY_NOTE, Note::B1, 1
    .byte PLAY_NOTE, Note::C2, 1
    .byte PLAY_NOTE, Note::Df2, 1
    .byte PLAY_NOTE, Note::D2, 1
    .byte PLAY_NOTE, Note::Ef2, 1
    .byte PLAY_NOTE, Note::E2, 1
    .byte PLAY_NOTE, Note::F2, 1
    .byte PLAY_NOTE, Note::Gf2, 1
    .byte PLAY_NOTE, Note::G2, 1
    .byte PLAY_NOTE, Note::Af2, 1
    .byte PLAY_NOTE, Note::A2, 1
    .byte END_SFX

.popseg