.pushseg
.segment "RODATA"

NumSongs:
    .byte $01

.define SongPulse1Pointers \
    TestSongPulse1

SongPulse1PointersLow:
    .lobytes SongPulse1Pointers

SongPulse1PointersHigh:
    .hibytes SongPulse1Pointers

.define SongPulse2Pointers \
    TestSongPulse2

SongPulse2PointersLow:
    .lobytes SongPulse2Pointers

SongPulse2PointersHigh:
    .hibytes SongPulse2Pointers

.define SongTrianglePointers \
    TestSongTriangle

SongTrianglePointersLow:
    .lobytes SongTrianglePointers

SongTrianglePointersHigh:
    .hibytes SongTrianglePointers

.define SongNoisePointers \
    TestSongNoise

SongNoisePointersLow:
    .lobytes SongNoisePointers

SongNoisePointersHigh:
    .hibytes SongNoisePointers
    
.popseg