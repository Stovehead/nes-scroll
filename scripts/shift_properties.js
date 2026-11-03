var action = tiled.registerAction("ShiftProperties", function(action) {
    let tileset = tiled.activeAsset;
    let dialog = new Dialog("Shift Properties");
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
    if(shift > 0) {
        for(let i = to - 1 + shift; i >= from + shift; i--) {
            let tilea = tileset.findTile(i + shift);
            if(!tilea)
                continue;
            let tileb = tileset.findTile(i);
            if(!tileb)
                continue;
            tilea.setProperties(tileb.properties());
        }
    }
    else {
        for(let i = from + shift; i < to + shift; i++) {
            tileset.tile(i + shift).setProperties(tileset.tile(i).properties());
        }
    }
    return;
});

action.text = "Shift Properties";
tiled.extendMenu("Tileset", [
    { action: "ShiftProperties", before: "TilesetProperties" }
]);
