import png

bg_palette = {
    (0, 0, 0): 0,
    (255, 254, 255): 1,
    (173, 173, 173): 2,
    (79, 79, 79): 3,
}

sprite_palette = {
    (0, 0, 0): 0,
    (255, 254, 255): 1,
    (173, 173, 173): 2,
    (79, 79, 79): 3,
}

large_sprites = True
bg = True
sprites = True

if bg:
    reader = png.Reader(filename='assets/bg.png')
    width, height, pixels, metadata = reader.read()
    pixel_list = list(pixels)

    with open("bg.bin", "wb") as output:
        bytes_left = 4096
        for i in range(0, len(pixel_list[0]), 8 * 4):
            plane1 = bytearray([0, 0, 0, 0, 0, 0, 0, 0])
            plane2 = bytearray([0, 0, 0, 0, 0, 0, 0, 0])
            for j in range(0, 8):
                for k in range(0, 8):
                    color = (pixel_list[j][i + 4 * k], pixel_list[j][i + 4 * k + 1], pixel_list[j][i + 4 * k + 2])
                    index = bg_palette[color]
                    bit1 = index & 1
                    bit2 = (index >> 1) & 1
                    plane1[j] = plane1[j] | (bit1 << (7 - k))
                    plane2[j] = plane2[j] | (bit2 << (7 - k))
            output.write(plane1)
            output.write(plane2)
            bytes_left -= 16
        for _ in range(bytes_left):
            output.write(bytearray([0]))

if sprites:
    reader = png.Reader(filename='assets/sprites.png')
    width, height, pixels, metadata = reader.read()
    pixel_list = list(pixels)

    with open("sprites.bin", "wb") as output:
        bytes_left = 4096
        for i in range(0, len(pixel_list[0]), 8 * 4):
            plane1 = bytearray([0, 0, 0, 0, 0, 0, 0, 0])
            plane2 = bytearray([0, 0, 0, 0, 0, 0, 0, 0])
            for j in range(0, 8):
                for k in range(0, 8):
                    index = 0
                    if pixel_list[j][i + 4 * k + 3] != 0:
                        color = (pixel_list[j][i + 4 * k], pixel_list[j][i + 4 * k + 1], pixel_list[j][i + 4 * k + 2])
                        index = sprite_palette[color]
                    bit1 = index & 1
                    bit2 = (index >> 1) & 1
                    plane1[j] = plane1[j] | (bit1 << (7 - k))
                    plane2[j] = plane2[j] | (bit2 << (7 - k))
            output.write(plane1)
            output.write(plane2)
            bytes_left -= 16
            if large_sprites:
                plane1 = bytearray([0, 0, 0, 0, 0, 0, 0, 0])
                plane2 = bytearray([0, 0, 0, 0, 0, 0, 0, 0])
                for j in range(8, 16):
                    for k in range(0, 8):
                        index = 0
                        if pixel_list[j][i + 4 * k + 3] != 0:
                            color = (pixel_list[j][i + 4 * k], pixel_list[j][i + 4 * k + 1], pixel_list[j][i + 4 * k + 2])
                            index = sprite_palette[color]
                        bit1 = index & 1
                        bit2 = (index >> 1) & 1
                        plane1[j - 8] = plane1[j - 8] | (bit1 << (7 - k))
                        plane2[j - 8] = plane2[j - 8] | (bit2 << (7 - k))
                output.write(plane1)
                output.write(plane2)
                bytes_left -= 16
        for _ in range(bytes_left):
            output.write(bytearray([0]))