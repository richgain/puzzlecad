include <puzzlecad.scad>

$burr_scale = 32;
$burr_inset = 0.11;
$burr_bevel = 0.6;
$post_rotate = [0, 45, 0];

burr_plate([
    ["x{components=z+}","x{components=z-,connect={dmz-y-,dmz-y+}}"],
    ["x{components=z+}","x{components=z-,connect=dfz-x-}"],
    ["x{components=z+}","x{components=z-,connect=dfz-x-}"]
]);