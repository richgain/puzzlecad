include <puzzlecad.scad>

box_puzzle_border = 6;

$burr_inset = 0.125;
$burr_bevel = 1;
$unit_beveled = true;
$burr_scale = 17;

dim = $burr_scale * 3 + box_puzzle_border * 2 + $burr_inset * 2;
height = $burr_scale * 3 + box_puzzle_border + $burr_inset * 2;

mid = box_puzzle_border / 2 + 0.5;
far = dim - mid;
    
*box();
*pieces();
*cap();

module box() {
    render(convexity = 2)
    difference() {
        beveled_cube([dim, dim, height]);
        translate([box_puzzle_border, box_puzzle_border, box_puzzle_border])
        cube([
            $burr_scale * 3 + $burr_inset * 2,
            $burr_scale * 3 + $burr_inset * 2,
            $burr_scale * 4
        ]);
     }
     
     translate([0, 0, height])
     connector(1.8, 2.0);
}

module pieces() {
    burr_plate([
        ["xx{connect=mz+x+,clabel=C}"],
        ["x.|x{connect=fz+y-,clabel=B}."],
        ["x{connect=mz+y-,clabel=B}xx{connect=fy+z+,clabel=C}"],
        ["x.|x{connect=fz+y-,clabel=A}."],
        ["x{connect=mz+y-,clabel=A}xx|..x"],
        ["xxx|..x", "x..|..."],
        ["xxx|..x"],
        [".x|xx"],
        ["xx"]
    ], $plate_width = 160);
}

module cap() {
    render(convexity = 2)
    difference() {
        beveled_cube([dim, dim, box_puzzle_border]);
        translate([box_puzzle_border, box_puzzle_border, 
        -0.01
        ])
        
        cube([
            $burr_scale * 2 + 2 * $burr_inset,
            $burr_scale * 2 + 2 * $burr_inset,
            box_puzzle_border * 2
        ]);
        
        translate([
            box_puzzle_border + $burr_scale - $burr_inset, 
            box_puzzle_border + $burr_scale - $burr_inset,
           -0.01
        ])
      
        cube([
            $burr_scale * 2 + 2 * $burr_inset,
            $burr_scale * 2 + 2 * $burr_inset,
            box_puzzle_border * 2
        ]);

        connector(2.0, 2.15);
    }
}

module connector(radius, height) {
    translate([mid, mid, 0]) cylinder(r = radius, h = height, $fn = 32);
    translate([mid, far, 0]) cylinder(r = radius, h = height, $fn = 32);
    translate([far, far, 0]) cylinder(r = radius, h = height, $fn = 32);
    translate([far, mid, 0]) cylinder(r = radius, h = height, $fn = 32);
}
