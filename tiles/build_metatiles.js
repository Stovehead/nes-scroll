var action = tiled.registerAction("BuildMetatiles", function(action) {
    let map = tiled.activeAsset;
    let layer = map.layerAt(0);
    let path = tiled.promptSaveFile();
    let file = new TextFile(path, TextFile.WriteOnly);
    metaTileTopLeft = [];
    metaTileTopRight = [];
    metaTileBottomLeft = [];
    metaTileBottomRight = [];
    metaTilePalettes = [];
    metaTileCollisions = [];
    metaMetaTileTopLeft = [];
    metaMetaTileTopRight = [];
    metaMetaTileBottomLeft = [];
    metaMetaTileBottomRight = [];
    let metatileset = map.tilesets[0];
    let metamap = tiled.open(metatileset.imageFileName).layerAt(0);
    for(let y = 0; y < metamap.height; y += 2) {
        for(let x = 0; x < metamap.width; x += 2) {
            metaTileTopLeft.push(metamap.tileAt(x, y).id);
            metaTileTopRight.push(metamap.tileAt(x + 1, y).id);
            metaTileBottomLeft.push(metamap.tileAt(x, y + 1).id);
            metaTileBottomRight.push(metamap.tileAt(x + 1, y + 1).id);
        }
    }
    for(let i = 0; i < metatileset.tiles.length; i++) {
        metaTilePalettes.push(metatileset.tiles[i].property("palette"));
        let collision = 0;
        if(metatileset.tiles[i].property("collision_top")) {
            collision += 1;
        }
        if(metatileset.tiles[i].property("collision_right")) {
            collision += 2;
        }
        if(metatileset.tiles[i].property("collision_bottom")) {
            collision += 4;
        }
        if(metatileset.tiles[i].property("collision_left")) {
            collision += 8;
        }
        if(metatileset.tiles[i].property("collision_only_when_lights_on")) {
            collision += 16;
        }
        metaTileCollisions.push(collision);
    }
    for(let y = 0; y < map.height; y += 2) {
        for(let x = 0; x < map.width; x += 2) {
            metaMetaTileTopLeft.push(layer.tileAt(x, y).id);
            metaMetaTileTopRight.push(layer.tileAt(x + 1, y).id);
            metaMetaTileBottomLeft.push(layer.tileAt(x, y + 1).id);
            metaMetaTileBottomRight.push(layer.tileAt(x + 1, y + 1).id);
        }
    }
    file.writeLine("MetaTilesTopLeft:");
    file.write("    .byte ");
    for(let i = 0; i < metaTileTopLeft.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaTileTopLeft[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("MetaTilesTopRight:");
    file.write("    .byte ");
    for(let i = 0; i < metaTileTopRight.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaTileTopRight[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("MetaTilesBottomLeft:");
    file.write("    .byte ");
    for(let i = 0; i < metaTileBottomLeft.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaTileBottomLeft[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("MetaTilesBottomRight:");
    file.write("    .byte ");
    for(let i = 0; i < metaTileBottomRight.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaTileBottomRight[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("");

    file.writeLine("MetaTileCollision:");
    file.write("    .byte ");
    for(let i = 0; i < metaTileCollisions.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaTileCollisions[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("");

    file.writeLine("MetaMetaTilesTopLeft:");
    file.write("    .byte ");
    for(let i = 0; i < metaMetaTileTopLeft.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaMetaTileTopLeft[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("MetaMetaTilesTopRight:");
    file.write("    .byte ");
    for(let i = 0; i < metaMetaTileTopRight.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaMetaTileTopRight[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("MetaMetaTilesBottomLeft:");
    file.write("    .byte ");
    for(let i = 0; i < metaMetaTileBottomLeft.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaMetaTileBottomLeft[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("MetaMetaTilesBottomRight:");
    file.write("    .byte ");
    for(let i = 0; i < metaMetaTileBottomRight.length; i++) {
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(metaMetaTileBottomRight[i].toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.writeLine("");
    file.writeLine("MetaMetaTileAttributes:");
    file.write("    .byte ");
    for(let i = 0; i < metaMetaTileTopLeft.length; i++) {
        let attribute = metaTilePalettes[metaMetaTileTopLeft[i]] | (metaTilePalettes[metaMetaTileTopRight[i]] << 2) | (metaTilePalettes[metaMetaTileBottomLeft[i]] << 4) | (metaTilePalettes[metaMetaTileBottomRight[i]] << 6);
        if(i != 0) {
            file.write(", ");
        }
        file.write("$");
        file.write(attribute.toString(16).padStart(2, "0").toUpperCase());
    }
    file.writeLine("");
    file.commit();
});

action.text = "Build Metatiles";
tiled.extendMenu("Map", [
    { action: "BuildMetatiles", before: "MapProperties" }
]);
