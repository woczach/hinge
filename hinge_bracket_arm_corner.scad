// =====================================================================
//  CORNER CAP for the other hinge leaf (the rotating arm)
//
//  Pushes onto the END of the rectangular wood, wraps all four sides
//  and closes the end, so the whole end corner is covered. The arm
//  leaf mounts on the SIDE face (screws go in from that face, through
//  the wall, into the wood).
//
//  Arm leaf pattern (from drawing): 4 x Ø4.3 on a 14 x 30 grid.
// =====================================================================

/* [Wood] */
wood_width  = 39;    // Y
wood_depth  = 49;    // X
clearance   = 0;   // slip-fit gap

/* [Cap] */
wall        = 2;     // wall thickness
cap_thick   = 2;     // end plate thickness
body_len    = 60;    // how far the cap runs down the wood

/* [Arm mounting]  (on the +X side wall) */
hole_dx     = 14;    // screw spacing across (Y)
hole_dz     = 30;    // screw spacing along the wood (Z)
hole_d      = 4.3;   // M4 clearance hole
hole_center = 30;    // pattern centre, measured from the closed end

/* [Locking] */
side_screws = true;  // extra screws through the -X wall into the wood
side_d      = 4;
side_dy     = 30;

/* [View] */
part        = "assembly";  // [cap, wood, assembly]
show_wood   = false;

$fn = 64;

// ---------------------------------------------------------------------
outer_x = wood_depth + 2 * wall;
outer_y = wood_width + 2 * wall;

// z = 0 at the open bottom, z = body_len at the closed end face
z_end_plate = body_len - cap_thick;

module wood() {
    translate([0, 0, z_end_plate - 100])
        color("burlywood", 0.75)
            cube([wood_depth, wood_width, 200], center = true);
}

module corner_cap() {
    difference() {
        // solid block: walls + closed end
        translate([0, 0, body_len / 2])
            cube([outer_x, outer_y, body_len], center = true);

        // inner pocket, open at the bottom (z = 0)
        translate([0, 0, (z_end_plate - 1) / 2])
            cube([wood_depth + clearance,
                  wood_width + clearance,
                  z_end_plate + 1], center = true);

        // 4 arm screw holes through the +X side wall
        for (sy = [-1, 1], sz = [-1, 1])
            translate([outer_x / 2,
                       sy * hole_dx / 2,
                       (body_len - hole_center) + sz * hole_dz / 2])
                rotate([0, 90, 0])
                    cylinder(d = hole_d, h = wall * 3, center = true);

        // optional locking screws through the -X wall
        if (side_screws)
            for (sy = [-1, 1])
                translate([-outer_x / 2, sy * side_dy / 2, body_len / 2])
                    rotate([0, 90, 0])
                        cylinder(d = side_d, h = wall + 15);
    }
}

// ---------------------------------------------------------------------
if (part == "wood") {
    wood();
} else if (part == "cap") {
    corner_cap();
} else {
    corner_cap();
    if (show_wood) wood();
}
