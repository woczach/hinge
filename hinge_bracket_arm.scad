// =====================================================================
//  Wrap-around bracket for the OTHER hinge leaf (the rotating arm)
//
//  Same idea as hinge_bracket.scad, but for the arm end:
//    - 4 screws, 4.3 clearance, on a 14 x 30 pattern
//      (two 2-hole tabs: 14 across, 30 between the tabs)
//    - no central boss, so the face stays flat
//
//  The 4 screws pass through the bracket wall into the wood.
// =====================================================================

/* [Wood] */
wood_width  = 60;    // across the face the hinge mounts on
wood_depth  = 40;    // thickness, away from that face
clearance   = 0.4;   // slip-fit gap around the wood

/* [Bracket] */
wall        = 4;     // wall thickness
length      = 60;    // along the wood (covers the 50 tall tab span)

/* [Arm mounting] */
hole_dx     = 14;    // screw spacing across the face (per tab)
hole_dz     = 30;    // screw spacing along the length (tab to tab)
hole_d      = 4.3;   // M4 clearance hole

/* [View] */
part        = "assembly";  // [bracket, wood, assembly]
show_wood   = true;

$fn = 64;

// ---------------------------------------------------------------------
outer_x = wood_depth + 2 * wall;
outer_y = wood_width + 2 * wall;

module wood() {
    color("burlywood", 0.75)
        cube([wood_depth, wood_width, length + 120], center = true);
}

module bracket() {
    difference() {
        // outer shell
        cube([outer_x, outer_y, length], center = true);

        // wood cavity, open both ends
        cube([wood_depth + clearance,
              wood_width + clearance,
              length + 2], center = true);

        // 4 screw clearance holes through the mounting wall (+X)
        for (sy = [-1, 1], sz = [-1, 1])
            translate([outer_x / 2, sy * hole_dx / 2, sz * hole_dz / 2])
                rotate([0, 90, 0])
                    cylinder(d = hole_d, h = wall * 3, center = true);
    }
}

// ---------------------------------------------------------------------
if (part == "wood") {
    wood();
} else if (part == "bracket") {
    bracket();
} else {
    bracket();
    if (show_wood) wood();
}
