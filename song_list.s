.pushseg
.segment "RODATA"

NumSongs:
    .byte $03

.define SongPulse1Pointers \
    SilenceSongPulse1, \
    TitleThemePulse1, \
    DeathSoundPulse1

SongPulse1PointersLow:
    .lobytes SongPulse1Pointers

SongPulse1PointersHigh:
    .hibytes SongPulse1Pointers

.define SongPulse2Pointers \
    SilenceSongPulse2, \
    TitleThemePulse2, \
    DeathSoundPulse2

SongPulse2PointersLow:
    .lobytes SongPulse2Pointers

SongPulse2PointersHigh:
    .hibytes SongPulse2Pointers

.define SongTrianglePointers \
    SilenceSongTriangle, \
    TitleThemeTriangle, \
    DeathSoundTriangle

SongTrianglePointersLow:
    .lobytes SongTrianglePointers

SongTrianglePointersHigh:
    .hibytes SongTrianglePointers

.define SongNoisePointers \
    SilenceSongNoise, \
    TitleThemeNoise, \
    DeathSoundNoise

SongNoisePointersLow:
    .lobytes SongNoisePointers

SongNoisePointersHigh:
    .hibytes SongNoisePointers
    
.popseg