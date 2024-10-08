// Configurable parameters
finger_width = 30;      // Width for each finger position
total_width = finger_width * 4;  // Total width for 4 fingers
base_depth = 60;        // How deep the hangboard is
base_height = 20;       // Minimum height of the base
round_radius = 5;       // Radius for rounded edges

// Concave surface parameters
cylinder_radius = 60;  // Larger radius = gentler curve
cylinder_offset = 55;   // How far above the surface to place cylinder

// Heights for each finger position (can be modified)
h1 = 12;  // Index finger height
h2 = 30;  // Middle finger height
h3 = 20;  // Ring finger height
h4 = 10;  // Pinky finger height

// Debug flag - set to true to see the cutting objects
debug_view = false;  // Toggle this to see the cutting objects

module finger_platform(width, height) {
    minkowski() { // round edges
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
                    // Show the cutting cylinder in transparent yellow
                    translate([width/2, base_depth, height + cylinder_offset])
                        rotate([90, 0, 0])
                            cylinder(r=cylinder_radius, h=base_depth, $fn=100);
            }
        }
        sphere(r=round_radius);
    }
}

// Main module for the hangboard
module hangboard() {
    union() {
        // Individual finger platforms

        translate([0, 0, 0])
            finger_platform(finger_width, base_height + h1);

        translate([finger_width, 0, 0])
            finger_platform(finger_width, base_height + h2);

        translate([finger_width * 2, 0, 0])
            finger_platform(finger_width, base_height + h3);

        translate([finger_width * 3, 0, 0])
            finger_platform(finger_width, base_height + h4);
    }
}

hangboard();
