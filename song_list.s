.pushseg
.segment "RODATA"

.enum Songs
    SILENCE
    TITLE_THEME
    DEATH_SOUND
    ALARM_SOUND
.endenum

NumSongs:
    .byte $04

.define SongPulse1Pointers \
    SilenceSongPulse1, \
    TitleThemePulse1, \
    DeathSoundPulse1, \
    AlarmSoundPulse1

SongPulse1PointersLow:
    .lobytes SongPulse1Pointers

SongPulse1PointersHigh:
    .hibytes SongPulse1Pointers

.define SongPulse2Pointers \
    SilenceSongPulse2, \
    TitleThemePulse2, \
    DeathSoundPulse2, \
    AlarmSoundPulse2

SongPulse2PointersLow:
    .lobytes SongPulse2Pointers

SongPulse2PointersHigh:
    .hibytes SongPulse2Pointers

.define SongTrianglePointers \
    SilenceSongTriangle, \
    TitleThemeTriangle, \
    DeathSoundTriangle, \
    SilenceSongTriangle

SongTrianglePointersLow:
    .lobytes SongTrianglePointers

SongTrianglePointersHigh:
    .hibytes SongTrianglePointers

.define SongNoisePointers \
    SilenceSongNoise, \
    TitleThemeNoise, \
    DeathSoundNoise, \
    SilenceSongNoise

SongNoisePointersLow:
    .lobytes SongNoisePointers

SongNoisePointersHigh:
    .hibytes SongNoisePointers
    
.popseg