include <puzzlecad.scad>

// This is a tutorial for puzzlecad, an OpenSCAD library for modeling mechanical puzzles.

// To obtain the latest version of puzzlecad: https://www.thingiverse.com/thing:3198014
// For an overview of interlocking puzzles: http://robspuzzlepage.com/interlocking.htm

// Puzzlecad is (c) 2019-2020 Aaron Siegel and is licensed for use under the
// Creative Commons - Attribution license. A copy of this license is available here:
// https://creativecommons.org/licenses/by/3.0/

// ======================================
// THE TUTORIAL

// This is an interactive puzzlecad tutorial. The text of the tutorial is in the form of
// code comments, interspersed with examples of OpenSCAD code. All of the OpenSCAD code
// is initially commented out with asterisks, suppressing the output. As you work through
// the text, uncomment each code example and press F6 to render it; this will enable you to
// see the effect of each code snippet in real time (and, if you choose, to play around with
// different combinations of parameters).

// Be sure you uncomment just one line at a time! Otherwise, OpenSCAD will render several
// examples one on top of the other, leading to a jumbled mess.

// ======================================
// BASIC USAGE

// The basic puzzlecad command is the burr_piece module, which can be invoked in a variety
// of ways.

// Standard six-piece burr pieces can be generated just by specifying their Kaenel number.
// (See http://robspuzzlepage.com/interlocking.htm for the definition of Kaenel number.)
// Here's the "right-handed offset":

*burr_piece(975);

// (Remember, to see what the output looks like, remove the asterisk at the beginning of the
// preceding snippet and press F6 to render. Then put the asterisk back and move on to the
// next example.)

// General burr pieces are given by strings composed of the characters "x" and ".", where "x"
// signifies a filled location and "." an empty one. The following example is a simple "T"
// shaped piece from Stewart Coffin's Half Hour puzzle. Note how there are 2 substrings of "x"
// and "." characters, separated by a vertical bar "|".

*burr_piece(".x.|xxx");

// Multi-layer burr pieces are given by a vector of strings, one per layer. Here's a more
// complex piece, also from Half Hour. The single "x" in the second string corresponds to the
// single voxel (cube) in the upper layer:

*burr_piece([".xx|xx.", "...|.x."]);

// Sometimes it's convenient to generate all the pieces of a puzzle at once. The handy
// module burr_plate makes this easy to do. Bill Cutler's Burr #305:

*burr_plate([52, 615, 792, 960, 975, 992]);

// burr_plate arranges a whole vector of pieces on a single canvas. Here's all six pieces for
// Half Hour:

*burr_plate([
    ["xxx|.x.", "...|.x."],
    [".xx|xx.", "...|.x."],
    [".x.|xxx", "...|x.."],
    [".x.|xxx"],
    ["x..|xxx"],
    ["x.|xx", "..|.x"]
]);

// puzzlecad provides a range of options for customizing the size and appearance of a puzzle.
// For example, by default, puzzlecad renders pieces with cubes of dimension 11.15 mm. This
// is ideal for six-piece burr puzzles and similarly-sized interlocking puzzles, but for a
// design like Half Hour, it's uncomfortably small. The dimensions can be adjusted with the
// $burr_scale parameter, like so:

*burr_plate([
    ["xxx|.x.", "...|.x."],
    [".xx|xx.", "...|.x."],
    [".x.|xxx", "...|x.."],
    [".x.|xxx"],
    ["x..|xxx"],
    ["x.|xx", "..|.x"]
], $burr_scale = 17);

// Setting $burr_scale = 17 yields a much more comfortable size. It's recommended that you
// always use puzzlecad's $burr_scale parameter to resize a model, rather than (say)
// scaling the pieces up or down in your slicer. Scaling pieces in your slicer will likely
// result in a puzzle that's too loose or too tight; puzzlecad's $burr_scale parameter
// ensures that the pieces scale as desired, without also changing the tolerances.

// Here are some other useful parameters that you can specify in the same way:

// $burr_scale    specifies the size of a voxel (in millimeters). The default is 11.15.

// $burr_inset    specifies how much the edges of each burr piece should be "trimmed back"
//                (also in millimeters). Smaller values give a tighter fit; larger values
//                give a looser fit. The default is 0.07.

// $burr_bevel    specifies how much to bevel the edges. The default is 0.5, which gives a
//                very slight, clean rounding. A value between 1 and 1.5 will better approximate
//                typical beveling used in wood puzzles. A value of 0 gives no beveling
//                (sharp edges).

// $unit_beveled  Setting  $unit_beveled = true  will chamfer each individual cube of each piece.
//                Whether to do this or not is a purely aesthetic decision.

// Here's another rendering of Half Hour - exactly the same puzzle, but with a different look -
// showcasing several of the above options:

*burr_plate([
    ["xxx|.x.", "...|.x."],
    [".xx|xx.", "...|.x."],
    [".x.|xxx", "...|x.."],
    [".x.|xxx"],
    ["x..|xxx"],
    ["x.|xx", "..|.x"]
], $burr_scale = 17, $burr_bevel = 1.3, $unit_beveled = true);

// ======================================
// CONNECTORS

// Many puzzle pieces cannot be printed in one piece without supports, since there is no
// orientation for which they lie completely flat on the print bed. A good example of this is
// the following piece from Stewart Coffin's interlocking design, Coffin's Quartet. No matter
// how it is rotated, some part of it will hang over empty space.

*burr_piece(["x..|xxx|...", "...|..x|..x"]);

// Puzzlecad provides a general mechanism for coping with such pieces, using an idea
// originally due to Richard Gain. Pieces like the above can be printed in two separate components,
// which can then be locked together using "snap joints". Here's what that looks like in practice:

*burr_piece(["x..|xxx|...", "...|..x|..x"], $auto_layout = true);

// After printing, and before attempting to solve the puzzle, the two components of this piece can
// be snapped together. The joints are designed to form a strong, permanent connection. They will
// usually snap cleanly and tightly together, but may sometimes need to be hammered or clamped into
// place (if too tight) or reinforced with a few drops of superglue (if too loose).

// Note that the only change we made was to add a new $auto_layout parameter. Setting
// $auto_layout = true  instructs puzzlecad to do the work of laying out snap joints for you.
// puzzlecad will automatically perform the dissection, rotating pieces so as to minimize the number
// of components.

// You can that the letter "A" is stamped on the visible face of the male joint. (If it's hard to
// see, you might be in preview mode; try pressing F6 to fully render the model.) If you rotate
// the view 180 degrees, you'll see that there's a corresponding letter "A" stamped on the inside
// face of the corresponding female joint. These labels identify which pieces go together, which is
// useful for keeping things straight when printing large puzzles with lots of components and joints.

// ======================================
// MANUALLY LAYING OUT CONNECTORS

// puzzlecad's $auto_layout feature is simple and powerful, but sometimes you'll want to lay out
// snap joints manually, giving you more control over the structure and appearance of the output.
// This can be done by attaching "annotations" to the relevant voxels of the burr piece. The following
// gives the identical result to $auto_layout = true (but without the labels - those need to be
// manually laid out now as well; we'll get to them shortly):

*burr_plate([["x..|xxx{connect=mz+y+}"], ["x{connect=fz+y+}|x"]]);

// That "{connect=mz+y+}" after the final "x" in the first component is an annotation: it tells
// puzzlecad to attach a male connector to the preceding voxel. You can read "mz+y+" as code for
// "render a male connector on the z+ face of the preceding voxel, pointing in the y+ direction."
// Here "z+" and "y+" are standard directional indicators that are used throughout puzzlecad; they
// refers to the positive orientation on OpenSCAD's standard z and y axes. There are six directional
// indicators in all:
// x+, x-, y+, y-, z+, z-
// corresponding one-to-one with the six faces of the cube.
// Likewise, "{connect=fz+y+}" says "render a female connector on the z+ face of the preceding voxel,
// pointing in the y+ direction."

// To add labels, we simply include another annotation "clabel" within the brackets, like so:

*burr_plate([["x..|xxx{connect=mz+y+,clabel=A}"], ["x{connect=fz+y+,clabel=A}|x"]]);

// That "clabel=A" annotation tells puzzlecad to stamp the letter "A" on the connector, on the face
// opposite the pointy tip.

// A huge variety of puzzle shapes can be formed without supports using snap joints. Here's the full
// Coffin's Quartet puzzle, ready for printing:

*burr_plate([
    ["..x|xxx|x{connect=mz+y+,clabel=A}.."], ["x|x", ".|x{connect=fz+y+,clabel=A}"],
    ["x..|xxx|x.x", "...|...|x.."],
    ["x..|xxx{connect=mz+y+,clabel=B}"], ["x{connect=fz+y+,clabel=B}|x"],
    [".x|x{connect=mz+y+,clabel=C}x"], ["x{connect=fz+y+,clabel=C}x|.x"]
    ], $burr_scale = 17, $burr_inset = 0.07, $burr_bevel = 1.3);
    
// Female connectors can print cleanly on the vertical surface of a piece, provided that they point
// up (i.e., the second orientation coordinate is z+). For example:

*burr_piece("x{connect=fy-z+}");

// Because the overhanging surface rises at a 45 degree angle, most printers will be able to
// print it with a smooth surface that maintains a clean, accurate fit. Combining these techniques
// provides a great deal of flexibility in how the puzzle joints are laid out.

// ======================================
// SQUARE CONNECTORS

// An additional type of connector is available in puzzlecad - the "square snap joint". The
// "house-shaped" connectors discussed above are preferred in most cases, but the square joints
// provide slightly more contact surface. They're something of a relic of earlier versions of
// puzzlecad, but they're still there if you want to use them.

// To render a square snap joint, simply omit the second orientation coordinate. Like so:
*burr_plate([["x..|xxx{connect=mz+,clabel=Ay-}"], ["x{connect=fz+,clabel=Ay-}|x"]]);

// Note that you now have to specify an orientation for the clabel; the square connectors are
// symmetric, so it's otherwise ambiguous where to render the label.

// ======================================
// LABELS

// Sometimes it's desirable to print the name of the model on one of the pieces. You can do this
// easily in puzzlecad with the label_text and label_orient annotations. Try the following example:

*burr_piece(
    ["xx{label_text=Half Hour,label_orient=z+x+}x|.x.", "...|.x."],
    $burr_scale = 17, $burr_bevel = 1
    );

// This tells puzzlecad to print the text "Half Hour" centered on the specified voxel, in the z+x+
// orientation. In this case, the "z+x+" orientation means "print the text centered on the z+ face
// of the voxel, running left-to-right in the x+ direction".

// Whether to use labels, and whether to print them on the inside or outside face of the puzzle,
// is an entirely aesthetic decision. Puzzlecad provides several further annotations for fine-tuning
// the appearance of the labels:

// label_scale      font size of the label, *relative* to $burr_scale. The default is 0.4, so that
//                  if (say) $burr_scale = 17, then the label will be printed in 6.8-point font
//                  (6.8 = 17 x 0.4).

// label_hoffset    optional horizontal offset to apply to the label, in units of $burr_scale. This
//                  can be useful for fine-tuning the placement of the label. If label_hoffset is
//                  nonzero, then the label won't be centered on the cell, but will be shifted by
//                  the specified amount. For example, setting label_hoffset = 0.5 will center the
//                  text on the line exactly halfway between the cell and its neighbor to the right.

// label_voffset    optional vertical offset to apply to the label (works the same way as above).

// ======================================
// DIAGONAL GEOMETRY

// Starting with version 2.0, puzzlecad can model pieces whose geometry involves diagonal cuts of
// the cube. This geometry appears frequently in polyhedral puzzle designs, such as those of
// Stewart Coffin, and is sometimes known as "rhombic tetrahedral" geometry. To understand this
// geometry, first picture a cube dissected into six square pyramids, one for each face. Each
// pyramid has a cube face as its base and the interior center of the cube as its "tip". For
// example, uncomment and render the following line:

*burr_piece("x{components=z-}", $burr_scale = 20, $burr_inset = 0);

// That "z-" identifies which of the six pyramids to render. As always, puzzlecad uses the
// symbols x-, x+, y-, y+, z-, and z+ to refer to the six orthogonal directions, so that "z-"
// refers to the bottom face of the cube (the negative direction along the z axis).

// You can also specify multiple components within a single voxel, separated by commas. If
// you do this, you MUST enclose the entire "components" clause within a nested pair of braces,
// as demonstrated by the following example, which renders the z- and x- pyramids side by side:

*burr_piece("x{components={z-,x-}}", $burr_scale = 20, $burr_inset = 0);

// Now, each of the six square pyramids can be further dissected into four tetrahedra by cutting
// them along the base diagonals. Those tetrahedra are referenced with a pair of direction
// symbols, for example, z-x-. You can think of the composite symbol z-x- as meaning "the
// tetrahedron on the x- edge of the z- pyramid". Here's what it looks like:

*burr_piece("x{components=z-x-}", $burr_scale = 20, $burr_inset = 0);

// The following picture shows all four "z-" tetrahedra, with a gap between them. It's very
// helpful in visualizing the tetrahedral dissection:

*union() {
    $burr_scale = 20;
    $burr_inset = 0;
    translate([2, 0, 0])  burr_piece("x{components=z-y-}");
    translate([0, 2, 0])  burr_piece("x{components=z-x-}");
    translate([2, 14, 0]) burr_piece("x{components=z-y+}");
    translate([14, 2, 0]) burr_piece("x{components=z-x+}");
}

// Pyramids and rhombic tetrahedra can be combined within a single components block, in any
// combination. For a fully-baked example, here's one of the pieces from the classic "star
// puzzle":

*burr_piece([
    "x{components={y+z+,z+y+}}|x{components={z+,y-z+,y+z+}}|x{components={y-z+,z+y-}}",
    "x{components=z-y+}|x{components=z-}|x{components=z-y-}"
], $burr_scale = 32, $burr_inset = 0);

// Note the larger value of $burr_scale being used here. $burr_scale will always refer to the edge
// length of the enveloping cube, for consistency with rectilinear models, so with default values
// of $burr_scale, the individual pyramids (and especially tetrahedra) will come out very small.

// Pieces modeled with diagonal geometry will often be laid out in an orientation that is not
// suited to printing. puzzlecad provides the convenient $post_rotate option to copy with this.
// If $post_rotate is specified, then after rendering, puzzlecad will apply that rotation each piece.
// (Of course, this could also be done using the OpenSCAD rotate primitive; but if you use
// $post_rotate, then puzzlecad will take it into account when laying out a burr plate and choose
// an intelligent layout.)

// Here's the previous piece, rotated into a friendlier orientation:

*burr_piece([
    "x{components={y+z+,z+y+}}|x{components={z+,y-z+,y+z+}}|x{components={y-z+,z+y-}}",
    "x{components=z-y+}|x{components=z-}|x{components=z-y-}"
], $burr_scale = 32, $burr_inset = 0, $post_rotate = [0, 45, 0]);

// That [0, 45, 0] is standard OpenSCAD notation for "rotate 45 degrees around the y axis".

// I find it easiest to model puzzles in their "natural" orientation, then add $post_rotate at
// the end.

// ======================================
// DIAGONAL JOINTS

// Puzzles with diagonal geometry can have snap joints too! To put a joint on a rhombic face (one
// of the faces of a square pyramid in the cube dissection discussed above), use the "connect=df"
// (female) and "connect=dm" (male) annotations, with tetrahedral coordinates just as before.
// It's easiest to see with an example; here's a stripped-down version of the "star puzzle" piece
// mentioned above, with female snap connectors on the end:

*burr_piece([
    "x{components=y+z+,connect=dfy+z+}|x{components={z+,y-z+,y+z+}}|x{components=y-z+,connect=dfy-z+}",
    "..|x{components=z-}|.."
], $burr_scale = 32, $burr_inset = 0);

// And, a corresponding tetrahedral tip:

*burr_piece([
    "x{components=y+z+}|x{components=y-z+,connect=dmy-z+}"
], $burr_scale = 32, $burr_inset = 0);

// Putting these together gives the components for Stewart Coffin's Sirius puzzle. (Now we're
// using a nonzero $burr_inset, to get a functional finished form; the rendering will take a little
// longer, since applying insets to diagonal geometry is relatively slow.)

*burr_plate([
    ["x{components=y+z+,connect=dfy+z+}|x{components={z+,y-z+,y+z+}}|x{components=y-z+,connect=dfy-z+}",
     "..|x{components=z-}|.."],
    ["x{components=y+z+}|x{components=y-z+,connect=dmy-z+}"],
    ["x{components=y+z+}|x{components=y-z+,connect=dmy-z+}"]
], $burr_scale = 32, $burr_inset = 0.11, $burr_bevel = 0.6, $post_rotate = [0, 45, 0]);

// In this particular case, the pieces are printable without snap joints, but printing in multiple
// components allows for much more creative color arrangements. This is the basis for Stewart
// Coffin's Sirius puzzle and many of his subsequent designs.
// If you want to print a copy Sirius, visit the Thingiverse page for instructions:
// https://www.thingiverse.com/thing:4122252

// Finally, the "clabel" annotation can be used to add identifying marks to the joints, just as in
// the rectilinear case.

// ======================================
// 2D AND TRAY PUZZLES

// All of the above models are composed of adjoined cubes ("polycubes") that assemble or interlock
// to form a three-dimensional rectilinear shape. Another common puzzle type is the "tray-packing"
// puzzle, in which a set of two-dimensional pieces must be fitted into a flat opening. Puzzlecad
// provides built-in support for models of this type.

// It's particularly easy to model polyominoes in puzzlecad; just specify $burr_scale as a *vector*
// rather than a single number. Here's the L-Pentomino as an example. Setting $burr_scale to
// [16, 16, 5.6] will yield polyominoes out of 16 mm squares, with a 5.6 mm thickness:

*burr_piece("xxxx|x...", $burr_scale = [16, 16, 5.6]);

// Insets and beveling will be applied just as in the three-dimensional case, with all the usual
// options available ($burr_inset, $burr_bevel, etc).

// For two-dimensional puzzle pieces other than polyominoes, you can use the more general module
// beveled_prism, which takes a polygon as input and generates the corresponding prism, with
// appropriate beveling of the edges. (Make sure the vertices of the polygon wind clockwise, or
// you'll get an error.)

*beveled_prism([[0, 0], [0, 32], [16, 0]], height = 5.6);

// beveled_prism will honor the $burr_bevel parameter, but you'll need to do the scaling and apply
// insets (as appropriate) manually.

// To model trays, puzzlecad provides the convenient module packing_tray, which is highly
// customizable with lots of options. Let's start with an example; this is the actual tray for
// Stewart Coffin's classic design Four Fit:

*packing_tray(
    opening_width = 13 / sqrt(5),
    opening_depth = 11 / sqrt(5),
    piece_holder_spec = [".x|.x|xx|.x"],
    finger_wedge = [2, 2],
    render_as_lid = false,
    title = "Four Fit",
    subtitles = ["Stewart Coffin", "STC #217"],
    $tray_scale = 16
);

// puzzlecad will determine the optimal overall dimensions for the tray based on the supplied
// parameters. If render_as_lid is set to true, then a tray *lid* will be generated rather than the
// tray itself (try it!)
    
// Here's a summary of all the parameters for packing_tray:

// opening_width         the dimensions of the rectangular cavity in the tray, in units of
// opening_depth         $tray_scale

// piece_holder_spec     (optional) an ordinary burr piece specification; if specified, generates
//                       a separate opening that can be used to hold one of the pieces, for
//                       convenient storage when the puzzle is not in use

// finger_wedge          (optional) generates a disc-shaped cavity centered at the specified
//                       coordinates of piece_holder_spec, for ease of removal of the stored piece

// render_as_lid         (optional) if set to true, then a tray *lid* will be generated rather than a
//                       *tray*.

// title                 (optional) if specified, then the title and/or subtitle will be imprinted on
// subtitles             the surface of the tray lid.

// opening_polygon       use in place of opening_width and opening_depth; generates an arbitrary
//                       polygon for the opening, rather than a rectangle

// opening_polygons      use in place of opening_width and opening_depth; generates several (possibly
//                       disconnected) openings. this should be given as a vector of polygons

// piece_holder_polygon  use in place of piece_holder_spec; generates an arbitrary polygon for the
//                       piece holder, rather than a polyomino

// $tray_scale           

// $tray_padding

// $tray_opening_height

// $tray_opening_border

// $piece_holder_buf
