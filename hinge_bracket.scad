// =====================================================================
//  Wrap-around bracket for the torque hinge (50 x 76 mm plate)
//
//  Slips over a rectangular wood beam. The 4 hinge screws pass through
//  the bracket wall and bite into the wood, so the hinge + bracket are
//  locked in one step.
//
//  Hinge interface taken from the drawing:
//    - plate 50 x 76
//    - 4 screws on a 30 x 62 pattern, 4.5 clearance
//    - central 32 dia boss recess, 12 dia center hole
//
//  Holes sit on a 30 x 62 pattern -> they are 15 mm / 31 mm from center.
// =====================================================================

/* [Wood] */
wood_width  = 49;    // across the face the hinge mounts on
wood_depth  = 39;    // thickness, away from that face
clearance   = 0.0;   // slip-fit gap around the wood

/* [Bracket] */
wall        = 4;     // wall thickness
length      = 86;    // along the wood (must cover the 76 plate)

/* [Hinge mounting] */
plate_w     = 50;    // hinge plate width  (reference / sanity check)
plate_h     = 76;    // hinge plate length (reference / sanity check)
hole_dx     = 30;    // screw spacing across the face
hole_dz     = 62;    // screw spacing along the length
hole_d      = 4.8;   // M4 clearance hole
hub_d       = 32;    // central boss recess diameter
hub_depth   = 3;     // boss recess depth
center_d    = 12;    // central through hole

/* [View] */
part        = "assembly";  // [bracket, wood, assembly]
show_wood   = false;

$fn = 64;

// ---------------------------------------------------------------------
outer_x = wood_depth + 2 * wall;
outer_y = wood_width + 2 * wall;

module wood() {
    // the real beam is 2 m long; shortened here just so the fit is visible
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

        // central boss recess
        translate([outer_x / 2 - hub_depth, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = hub_d, h = hub_depth * 2 + 1);

        // central through hole
        translate([outer_x / 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = center_d, h = wall * 3, center = true);
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
