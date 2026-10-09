.pushseg
.segment "RODATA"

NumSongs:
    .byte $02

.define SongPulse1Pointers \
    SilenceSongPulse1, \
    TestSongPulse1

SongPulse1PointersLow:
    .lobytes SongPulse1Pointers

SongPulse1PointersHigh:
    .hibytes SongPulse1Pointers

.define SongPulse2Pointers \
    SilenceSongPulse2, \
    TestSongPulse2

SongPulse2PointersLow:
    .lobytes SongPulse2Pointers

SongPulse2PointersHigh:
    .hibytes SongPulse2Pointers

.define SongTrianglePointers \
    SilenceSongTriangle, \
    TestSongTriangle

SongTrianglePointersLow:
    .lobytes SongTrianglePointers

SongTrianglePointersHigh:
    .hibytes SongTrianglePointers

.define SongNoisePointers \
    SilenceSongNoise, \
    TestSongNoise

SongNoisePointersLow:
    .lobytes SongNoisePointers

SongNoisePointersHigh:
    .hibytes SongNoisePointers
    
.popseg