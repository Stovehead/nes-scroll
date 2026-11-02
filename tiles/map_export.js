tiled.registerMapFormat("chaosloop", {
	name: "Chaos Loop map",
	extension: "bin",

	write: (map, fileName) => {
        const layer = map.layerAt(0);

        var file = new BinaryFile(fileName, BinaryFile.WriteOnly);
        let column = new Uint8Array(layer.height);

        for (let x = 0; x < layer.width; ++x) {

            for (let y = 0; y < layer.height; ++y) {
                const tile = layer.tileAt(x, y);
                column[y] = tile.id;
            }
            file.write(column.buffer);
        }
        file.commit();
    }
});
