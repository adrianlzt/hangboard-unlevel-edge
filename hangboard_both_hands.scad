// Configurable parameters
finger_width = 30;      // Width for each finger position
total_width = finger_width * 4;  // Total width for 4 fingers
base_depth = 60;        // How deep the hangboard is
base_height = 10;       // Minimum height of the base
round_radius = 5;       // Radius for rounded edges

// Frame parameters
frame_thickness = 15;   // Thickness of the frame walls
frame_extension = 20;   // How much the frame extends beyond the climbing surfaces

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

module finger_platform(width, height) {
    make_platform(width, height);
}

module make_platform(width, height) {
    difference() {
        // Main block
        color("skyblue")
            cube([width, base_depth, height]);

        // Concave surface cutout
        translate([width/2, base_depth, height + cylinder_offset])
            rotate([90, 0, 0])
                cylinder(r=cylinder_radius, h=base_depth, $fn=100);
    }
}

// Module for single hand
module single_hand(h2, h3, h4, h5) {
    union() {
        // Individual finger platforms
        translate([-round_radius-3, 0, 0])
            finger_platform(finger_width+round_radius+3, base_height + h2);  // Index

        translate([finger_width, 0, 0])
            finger_platform(finger_width, base_height + h3);  // Middle

        translate([finger_width * 2, 0, 0])
            finger_platform(finger_width, base_height + h4);  // Ring

        translate([finger_width * 3, 0, 0])
            finger_platform(finger_width+round_radius+3, base_height + h5);  // Pinky
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

module frame() {
    translate([-frame_thickness,0,-frame_thickness])
    difference() {
        // Outer frame
        cube([total_width + frame_thickness * 2,
              base_depth,
              total_width + frame_thickness * 2]);

        // Inner cutout
        translate([frame_thickness/2, -1, frame_thickness])
            cube([total_width+frame_thickness,
              base_depth + 2,
                  total_width]);
    }
}

module back() {
    translate([-frame_thickness,60,-frame_thickness])
    cube([total_width + frame_thickness * 2,
        frame_thickness,
        total_width + frame_thickness * 2]);
}

module support_for_holes() {
    rotate([90,0,0])
    translate([total_width/2,
                total_width/2,
                round_radius/2-base_depth + frame_thickness + round_radius])
    difference() {
        //%color("red", 0.3)
        cylinder(h=base_depth + frame_thickness, r=110, center=true);
        //%color("blue", 0.3)
        rotate([-90,0,0])
        cube([total_width + frame_thickness * 2,
            base_depth*2,
            total_width + frame_thickness * 2],
            center=true
            );
    }
}

module holes() {
    rotate([90,0,0])
        translate([-frame_thickness*2,
                    total_width/2,
                    round_radius/2-base_depth + frame_thickness + round_radius])
        cylinder(h=base_depth + frame_thickness*4, r=10, center=true);

    rotate([90,0,0])
    translate([total_width+frame_thickness*2,
                    total_width/2,
                    round_radius/2-base_depth + frame_thickness + round_radius])
        cylinder(h=base_depth + frame_thickness*4, r=10, center=true);
}

module excess_material() {
    cube([total_width*2,base_depth*2,base_depth]);
}

module complete_hangboard() {
    frame();
    back();
    difference() {
        support_for_holes();
        holes();
    }
    two_handed_hangboard();
}

minkowski() {
    difference() {
        complete_hangboard();
        translate([-total_width/2,-10,-base_height*7])
        excess_material();
        translate([-total_width/2,-10,base_height*13])
        excess_material();
    }
    sphere(r=round_radius);
}
