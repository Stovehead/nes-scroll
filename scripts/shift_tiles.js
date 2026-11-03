var action = tiled.registerAction("ShiftTiles", function(action) {
    let map = tiled.activeAsset;
    let dialog = new Dialog("Shift Tiles");
    let from = 0;
    let to = 0;
    let shift = 0;
    let fromBox = dialog.addNumberInput("From");
    let toBox = dialog.addNumberInput("To");
    let shiftBox = dialog.addNumberInput("Shift Amount");
    fromBox.decimals = 0;
    toBox.decimals = 0;
    shiftBox.decimals = 0;
    toBox.maximum = 256;
    shiftBox.maximum = 256;
    shiftBox.minimum = -256;
    fromBox.valueChanged.connect(function(value) { from = value; });
    toBox.valueChanged.connect(function(value) { to = value; });
    shiftBox.valueChanged.connect(function(value) { shift = value; });
    let applyButton = dialog.addButton("Apply");
    applyButton.clicked.connect(function() {dialog.accept()});
    let result = dialog.exec();
    if(result == Dialog.Rejected) {
        return;
    }
    let layer = map.layerAt(0);
    let layerEdit = layer.edit();
    for (let x = 0; x < layer.width; ++x) {
        for (let y = 0; y < layer.height; ++y) {
            let tile = layer.tileAt(x, y);
            if(!tile)
                continue;
            if(tile.id < from || tile.id >= to)
                continue;
            layerEdit.setTile(x, y, tile.tileset.tile(tile.id + shift));
        }
    }
    layerEdit.apply();
    return;
});

action.text = "Shift Tiles";
tiled.extendMenu("Map", [
    { action: "ShiftTiles", before: "MapProperties" }
]);
