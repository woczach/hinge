// =====================================================================
//  CORNER CAP with a chipboard socket (same wood as the arm corner cap)
//
//  Pushes onto the END of the rectangular wood, wraps all four sides and
//  closes the end. On top of the closed end sits a socket for chipboard:
//  a 19 mm wide, 20 mm deep slot, so the panel edge slides in along the
//  wood axis and is screwed through the socket jaws.
//
//  The socket starts at the full cap width and tapers to the mouth with
//  a concave "sail" curve, so it blends into the cap instead of forming
//  a blunt step.
//
//  Wood 40 x 51, same as hinge_bracket_arm_corner.scad.
//  No hinge interface: this cap only holds the panel.
// =====================================================================

/* [Wood] */
wood_width  = 40;    // Y
wood_depth  = 51;    // X
clearance   = 0;     // slip-fit gap

/* [Cap] */
wall        = 2;     // wall thickness
cap_thick   = 2;     // end plate thickness
body_len    = 60;    // how far the cap runs down the wood

/* [Panel socket] */
slot_w      = 19;    // slot width = panel thickness + clearance
slot_depth  = 20;    // insertion depth of the panel edge
slot_axis   = "X";   // [X, Y] panel thickness direction
slot_offset = 0;     // shift of the slot from centre
jaw_top     = 5;     // jaw thickness at the socket mouth
sail_seg    = 32;    // sail curve segments

/* [Panel screws]  (through the socket jaws into the panel) */
panel_screws   = true;
panel_screw_d  = 4.3;  // wood screw clearance
panel_screw_dy = 20;   // spacing across the panel face
panel_screw_z  = 10;   // from the socket mouth down to the screw row

/* [Locking] */
side_screws = true;  // extra screws through the -X wall into the wood
side_d      = 4;
side_dz     = 30;    // spacing of the back holes, stacked vertically (Z)

/* [View] */
part        = "assembly";  // [cap, wood, panel, assembly]
show_wood   = false;
show_panel  = false;

$fn = 64;

// ---------------------------------------------------------------------
outer_x = wood_depth + 2 * wall;
outer_y = wood_width + 2 * wall;

// z = 0 at the open bottom, z = body_len at the closed end face
z_end_plate = body_len - cap_thick;
socket_top  = body_len + slot_depth;

// socket dimensions: full width at the cap end, narrower at the mouth
thick_outer = slot_axis == "X" ? outer_x : outer_y;
through_len = slot_axis == "X" ? outer_y : outer_x;
base_half   = thick_outer / 2;
top_half    = slot_w / 2 + jaw_top;
sail_angle  = 90;

screw_z = socket_top - panel_screw_z;

function sail_x(sign, t) =
    let(base = sign * base_half,
        top  = slot_offset + sign * top_half)
    base + (top - base) * sin(t * sail_angle);

function sail_z(t) = body_len + t * slot_depth;

module wood() {
    translate([0, 0, z_end_plate - 100])
        color("burlywood", 0.75)
            cube([wood_depth, wood_width, 200], center = true);
}

module panel() {
    // chipboard edge sitting in the socket, continuing past the end
    color("sandybrown", 0.85)
        translate([slot_axis == "X" ? slot_offset : 0,
                   slot_axis == "Y" ? slot_offset : 0,
                   body_len + 60])
            if (slot_axis == "X")
                cube([slot_w - 1, 200, 120], center = true);
            else
                cube([200, slot_w - 1, 120], center = true);
}

module socket_local() {
    x_in_pos = slot_offset + slot_w / 2;
    x_in_neg = slot_offset - slot_w / 2;

    // +X jaw: inner face, base, concave sail, top
    right_pts = concat(
        [[x_in_pos, body_len]],
        [for (i = [0 : sail_seg])
            let(t = i / sail_seg)
                [sail_x(1, t), sail_z(t)]],
        [[x_in_pos, socket_top]]
    );

    // -X jaw: base, concave sail, top, inner face
    left_pts = concat(
        [[sail_x(-1, 0), body_len]],
        [for (i = [1 : sail_seg])
            let(t = i / sail_seg)
                [sail_x(-1, t), sail_z(t)]],
        [[x_in_neg, socket_top]],
        [[x_in_neg, body_len]]
    );

    rotate([90, 0, 0])
        linear_extrude(height = through_len, center = true) {
            polygon(right_pts);
            polygon(left_pts);
        }
}

module corner_cap() {
    difference() {
        union() {
            // walls + closed end
            translate([0, 0, body_len / 2])
                cube([outer_x, outer_y, body_len], center = true);

            // full-width socket with sail taper above the closed end
            rotate([0, 0, slot_axis == "X" ? 0 : 90])
                socket_local();
        }

        // inner pocket, open at the bottom (z = 0)
        translate([0, 0, (z_end_plate - 1) / 2])
            cube([wood_depth + clearance,
                  wood_width + clearance,
                  z_end_plate + 1], center = true);

        // panel screws through the socket jaws
        if (panel_screws)
            rotate([0, 0, slot_axis == "X" ? 0 : 90])
                for (sy = [-1, 1])
                    translate([0, sy * panel_screw_dy / 2, screw_z])
                        rotate([0, 90, 0])
                            cylinder(d = panel_screw_d,
                                     h = thick_outer + 2, center = true);

        // locking screws through the -X wall, stacked vertically
        if (side_screws)
            for (sz = [-1, 1])
                translate([-outer_x / 2, 0, body_len / 2 + sz * side_dz / 2])
                    rotate([0, 90, 0])
                        cylinder(d = side_d, h = wall + 15);
    }
}

// ---------------------------------------------------------------------
if (part == "wood") {
    wood();
} else if (part == "panel") {
    panel();
} else if (part == "cap") {
    corner_cap();
} else {
    corner_cap();
    if (show_wood) wood();
    if (show_panel) panel();
}
