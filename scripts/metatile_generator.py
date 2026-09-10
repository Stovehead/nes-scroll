tiles = [1,1,1,14,15,16,21,22,23,24,1,2,3,1,8,9,10,11,67,67,68,68,1,31,32,1,39,40,41,42,1,52,53,1,1,62,63,1,1,27,28,29,30,1,33,33,38,1,47,48,49,50,50,48,49,51,47,58,59,60,61,58,59,51,1,1,17,18,19,20,1,1,25,26,4,5,6,7,1,1,12,13,68,68,68,68,1,36,37,1,43,44,45,46,1,56,57,1,1,65,66,1,27,33,33,34,35,1,33,33,33,28,47,54,55,50,50,54,55,51,47,50,50,60,64,50,50,51]

for i in range(len(tiles)):
    tiles[i] -= 1

i = 0
while i < len(tiles) // 2:
    print(f"${tiles[i]:02x}".upper(), end="")
    if i < len(tiles) // 2 - 2:
        print(", ", end="")
    i += 2
print()

i = 1
while i < len(tiles) // 2:
    print(f"${tiles[i]:02x}".upper(), end="")
    if i < len(tiles) // 2 - 1:
        print(", ", end="")
    i += 2
print()

i = len(tiles) // 2
while i < len(tiles):
    print(f"${tiles[i]:02x}".upper(), end="")
    if i < len(tiles) - 2:
        print(", ", end="")
    i += 2
print()

i = len(tiles) // 2 + 1
while i < len(tiles):
    print(f"${tiles[i]:02x}".upper(), end="")
    if i < len(tiles) - 1:
        print(", ", end="")
    i += 2
print()