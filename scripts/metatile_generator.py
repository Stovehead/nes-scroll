tiles = [1,1,2,3,6,7,10,10,11,11,12,13,16,17,1,20,21,22,25,26,27,28,33,34,37,38,41,42,43,42,44,38,41,42,43,42,43,44,54,55,56,55,56,57,45,46,47,46,47,53,44,34,62,38,48,34,37,38,33,34,42,44,41,44,64,57,45,48,66,67,33,45,37,38,33,34,37,38,1,1,4,5,8,9,11,11,11,11,14,15,18,19,20,23,23,24,29,30,31,32,35,36,39,40,45,46,47,46,48,40,49,50,51,50,51,52,58,59,60,59,60,61,35,36,39,40,35,36,52,36,63,40,35,36,39,41,44,36,46,48,49,52,58,65,35,36,68,69,35,36,43,42,41,42,42,44]
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