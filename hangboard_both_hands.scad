// Configurable parameters
finger_width = 25;      // Width for each finger position
base_depth = 40;        // How deep the hangboard is
base_height = 5;       // Minimum height of the base
round_radius = 5;       // Radius for rounded edges
// Distance between the two h3 surfaces
distance_between_hands = 30;

// Frame parameters
frame_thickness = 15;   // Thickness of the frame walls
frame_extension = 20;   // How much the frame extends beyond the climbing surfaces
frame_holes_radius = 9;  // Radius of the holes in the frame

// Heights for each finger position - Right hand
h2_right = 2;  // Index finger height
h3_right = 15;  // Middle finger height
h4_right = 5;  // Ring finger height
h5_right = 0;  // Pinky finger height

// Heights for each finger position - Left hand
h2_left = 2;   // Index finger height
h3_left = 15;   // Middle finger height
h4_left = 5;   // Ring finger height
h5_left = 0;   // Pinky finger height

// Decide to round the piece or not
round_edges = false;

// Concave surface parameters
cylinder_radius = 60;  // Larger radius = gentler curve
cylinder_offset = 55;   // How far above the surface to place cylinder

total_width = finger_width * 4;  // Total width for 4 fingers
total_height = base_height + h3_right + h3_left + distance_between_hands;
frame_circle_radius = total_width;

%echo("Size of the hangboard: ", frame_circle_radius*2, " x ", total_height+2*frame_thickness, " x ", base_depth+frame_thickness);

module finger_platform(width, height) {
    difference() {
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
    translate([0, base_depth, base_height+h3_right+h3_left+distance_between_hands])
        rotate([0, 180, 180])
            single_hand(h2_left, h3_left, h4_left, h5_left);
}

module frame() {
    translate([-frame_thickness,0,-frame_thickness])
    difference() {
        // Outer frame
        cube([total_width + frame_thickness * 2,
              base_depth,
              total_height + frame_thickness * 2]);

        // Inner cutout
        translate([frame_thickness, -1, frame_thickness])
            cube([total_width,
              base_depth + 2,
                  total_height]);
    }
}

module back() {
    translate([-frame_thickness,base_depth,-frame_thickness])
    cube([total_width + frame_thickness * 2,
        frame_thickness,
        total_height + frame_thickness * 2]);
}

module support_for_holes() {
    difference() {
        rotate([90,0,0])
        translate([total_width/2,total_height/2,-(base_depth+frame_thickness)/2])
        cylinder(h=base_depth+frame_thickness, r=frame_circle_radius, center=true);

        union() {
          rotate([-90,0,0])
          translate([-frame_circle_radius,frame_thickness,0])
          cube([frame_circle_radius*3, frame_circle_radius, base_depth+frame_thickness]);

          rotate([-90,0,0])
          translate([-frame_circle_radius,-total_height-frame_thickness-frame_circle_radius,0])
          cube([frame_circle_radius*3, frame_circle_radius, base_depth+frame_thickness]);

          cube([total_width, base_depth+frame_thickness, total_height]);
        }
    }
}

module holes() {
    rotate([90,0,0])
    translate([
        -(frame_circle_radius-total_width/2)/2,
        total_height/2,
        -base_depth/2])
    cylinder(h=base_depth*2, r=frame_holes_radius, center=true);

    rotate([90,0,0])
    translate([
        total_width+(frame_circle_radius-total_width/2)/2,
        total_height/2,
        -base_depth/2])
    cylinder(h=base_depth*2, r=frame_holes_radius, center=true);
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

if (round_edges) {
    minkowski() {
        complete_hangboard();
        sphere(r=round_radius);
    }
} else {
    complete_hangboard();
}
