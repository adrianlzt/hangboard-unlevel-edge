// Configurable parameters
finger_width = 30;      // Width for each finger position
total_width = finger_width * 4;  // Total width for 4 fingers
base_depth = 60;        // How deep the hangboard is
base_height = 20;       // Minimum height of the base
round_radius = 5;       // Radius for rounded edges
use_minkowski = true;   // Toggle to enable/disable rounded edges

// Concave surface parameters
cylinder_radius = 60;  // Larger radius = gentler curve
cylinder_offset = 55;   // How far above the surface to place cylinder

// Heights for each finger position - Right hand
h2_right = 12;  // Index finger height
h3_right = 25;  // Middle finger height
h4_right = 15;  // Ring finger height
h5_right = 10;  // Pinky finger height

// Heights for each finger position - Left hand
h2_left = 12;   // Index finger height
h3_left = 25;   // Middle finger height
h4_left = 15;   // Ring finger height
h5_left = 10;   // Pinky finger height

// Debug flag - set to true to see the cutting objects
debug_view = false;  // Toggle this to see the cutting objects

module finger_platform(width, height) {
    if (use_minkowski) {
        minkowski() { // round edges
            make_platform(width, height);
            sphere(r=round_radius);
        }
    } else {
        make_platform(width, height);
    }
}

module make_platform(width, height) {
    difference() {
        // Main block
        color("skyblue")
            cube([width, base_depth, height]);

        // Concave surface cutout
        if (debug_view) {
            // Show the cutting cylinder in transparent yellow
            %color("yellow", 0.3)
            translate([width/2, base_depth, height + cylinder_offset])
                rotate([90, 0, 0])
                    cylinder(r=cylinder_radius, h=base_depth, $fn=100);
        } else {
            translate([width/2, base_depth, height + cylinder_offset])
                rotate([90, 0, 0])
                    cylinder(r=cylinder_radius, h=base_depth, $fn=100);
        }
    }
}

// Module for single hand
module single_hand(h2, h3, h4, h5) {
    union() {
        // Individual finger platforms
        translate([0, 0, 0])
            finger_platform(finger_width, base_height + h2);  // Index

        translate([finger_width, 0, 0])
            finger_platform(finger_width, base_height + h3);  // Middle

        translate([finger_width * 2, 0, 0])
            finger_platform(finger_width, base_height + h4);  // Ring

        translate([finger_width * 3, 0, 0])
            finger_platform(finger_width, base_height + h5);  // Pinky
    }
}

// Main module for the two-handed hangboard
module two_handed_hangboard() {
    // Right hand (bottom)
    single_hand(h2_right, h3_right, h4_right, h5_right);

    // Left hand (top, rotated 90 degrees)
    translate([0, total_width/2, total_width])
        rotate([0, 180, 180])
            single_hand(h2_left, h3_left, h4_left, h5_left);
}

two_handed_hangboard();
