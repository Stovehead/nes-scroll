.pushseg
.segment "RODATA"

AlarmSoundPulse1:
    .byte SET_VOLUME, %00001000
    .byte SET_SEPARATION, $00
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
    @loop:
    .byte PLAY_NOTE, Note::Gs3, 2
    .byte PLAY_NOTE, Note::Ds4, 1
    .byte PLAY_NOTE, Note::E4, 39
    .byte PLAY_NOTE, Note::Cs4, 1
    .byte PLAY_NOTE, Note::Gs3, 37
    .byte GOTO_LOOP
    .addr @loop

.popseg