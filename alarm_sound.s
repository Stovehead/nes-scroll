.pushseg
.segment "RODATA"

AlarmSoundPulse1:
    .byte SET_VOLUME, %00001000
    .byte SET_SEPARATION, $00
    .byte PLAY_REST, 2
    @loop:
    .byte PLAY_NOTE, Note::C4, 1
    .byte PLAY_NOTE, Note::Cs4, 39
    .byte PLAY_NOTE, Note::As3, 1
    .byte PLAY_NOTE, Note::F3, 39
    .byte GOTO_LOOP
    .addr @loop

AlarmSoundPulse2:
    .byte SET_VOLUME, %00001000
    .byte SET_SEPARATION, $00
    .byte PLAY_REST, 2
    @loop:
    .byte PLAY_NOTE, Note::Gs3, 2
    .byte PLAY_NOTE, Note::Ds4, 1
    .byte PLAY_NOTE, Note::E4, 39
    .byte PLAY_NOTE, Note::Cs4, 1
    .byte PLAY_NOTE, Note::Gs3, 37
    .byte GOTO_LOOP
    .addr @loop

AlarmSoundNoise:
    .byte SET_VOLUME, %00000010
    .byte SET_SEPARATION, $00
    .byte PLAY_REST, 2
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00000011
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00000100
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00000101
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00000110
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00000111
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00001000
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00001001
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00001010
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00001011
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00001100
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00001101
    .byte PLAY_NOTE, 14, 60
    .byte SET_VOLUME, %00001110
    .byte PLAY_NOTE, 14, 60
    @loop:
    .byte SET_VOLUME, %00001111
    .byte PLAY_NOTE, 14, 60
    .byte GOTO_LOOP
    .addr @loop

.popseg