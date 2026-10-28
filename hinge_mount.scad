// =====================================================================
//  Flat mounting plate for the torque hinge (50 x 76 mm plate)
//
//  Same hinge interface as hinge_bracket.scad, but without the
//  wrap-around bracket: just a flat 4 mm plate with the screw holes in
//  the proper places. The 4 hinge screws pass through the plate and
//  bite into the surface below.
//
//  Hinge interface taken from the drawing:
//    - plate 50 x 76
//    - 4 screws on a 30 x 62 pattern, 4.8 clearance
//    - central 32 dia boss recess, 12 dia center hole
// =====================================================================

/* [Plate] */
plate_w     = 50;    // width, matching the hinge plate (X)
plate_h     = 76;    // length, matching the hinge plate (Y)
plate_t     = 4;     // plate thickness

/* [Hinge mounting] */
hole_dx     = 30;    // screw spacing across the plate
hole_dy     = 62;    // screw spacing along the plate
hole_d      = 4.8;   // M4 clearance hole
hub_relief  = true;  // central boss recess + center hole
hub_d       = 32;    // central boss recess diameter
hub_depth   = 5;     // boss recess depth (through the 4 mm plate)
center_d    = 12;    // central through hole

$fn = 64;

module mount() {
    difference() {
        // flat plate, sitting on z = 0
        translate([0, 0, plate_t / 2])
            cube([plate_w, plate_h, plate_t], center = true);

        // 4 hinge screw holes
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * hole_dx / 2, sy * hole_dy / 2, plate_t / 2])
                cylinder(d = hole_d, h = plate_t + 2, center = true);

        if (hub_relief) {
            // central boss recess, cut from the hinge face
            translate([0, 0, plate_t - hub_depth])
                cylinder(d = hub_d, h = hub_depth + 1);

            // central through hole
            translate([0, 0, plate_t / 2])
                cylinder(d = center_d, h = plate_t + 2, center = true);
        }
    }
}

mount();
