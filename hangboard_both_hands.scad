include <Round-Anything/polyround.scad>

// Heights for each finger position - Right hand
h2_right = 4;  // Index finger height
h3_right = 15;  // Middle finger height
h4_right = 5;  // Ring finger height
h5_right = 2;  // Pinky finger height

// Heights for each finger position - Left hand
h2_left = 4;   // Index finger height
h3_left = 15;   // Middle finger height
h4_left = 5;   // Ring finger height
h5_left = 2;   // Pinky finger height

finger_width = 25;      // Width for each finger position
base_depth = 30;        // How deep the hangboard is

// Distance between the two h3 surfaces
distance_between_hands = 30;

// To remove the inserts, define an empty list
inserts_depth = [base_depth/2, base_depth/3, base_depth/4];  // Depth of the inserts

// Frame parameters
frame_thickness = 9;   // Thickness of the frame walls
hole_radius = 6;  // Radius of the holes in the frame

// Parameters to create the finger platform concavity
finger_platform_concavity = 35;
finger_platform_concavity_depth = 2;

// Decide to round the edge of the finger platform or not
edge_round_radius = 2;
round_edges_fn = 30;

distance_between_bases = distance_between_hands + h3_right + h3_left;

// The object to be subsctracted from the frame, with "negative fillets" if round is true, to get round edges in the frame.
module insert(width, round=true) {
    right_hand = [h2_right, h3_right, h4_right, h5_right];
    left_hand = [h2_left, h3_left, h4_left, h5_left];

    function finger_points(hand, start, reverse=false) = [
        for (i = [0:3]) let(
            x = (start + (reverse ? -1 : 1) * i) * finger_width,
            h = reverse ? (distance_between_bases - hand[3-i]) : hand[i]
        ) each [
            [x, h, 0],
            [x + (reverse ? -1 : 1) * finger_width/2, h + (reverse ? 1 : -1) * finger_platform_concavity_depth, finger_platform_concavity],
            [x + (reverse ? -1 : 1) * finger_width, h, 0]
        ]
    ];

    radiiPoints = concat(
        finger_points(right_hand, 0),
        finger_points(left_hand, 4, true)
    );

    polyRoundExtrude(radiiPoints, width, (round ? -edge_round_radius : 0), 0, fn=round_edges_fn);
}

// Main structure of the hangboard
module frame() {
  radiiPoints = [
    [-frame_thickness, -frame_thickness, 5],
    [4*finger_width+frame_thickness, -frame_thickness, 5],

    [4*finger_width+frame_thickness*4+hole_radius, distance_between_bases/2, 30],

    [4*finger_width+frame_thickness, distance_between_bases+frame_thickness, 5],
    [-frame_thickness, distance_between_bases+frame_thickness, 5],

    [-frame_thickness*4-hole_radius, distance_between_bases/2, 30],
  ];

  polyRoundExtrude(radiiPoints, base_depth+frame_thickness, edge_round_radius, 0, fn=round_edges_fn);
}

// Two holes to pass the rope
module holes() {
  translate([-hole_radius-frame_thickness, distance_between_bases/2, 0])
    extrudeWithRadius(base_depth+frame_thickness,-1,-1)
      circle(hole_radius);
  translate([+hole_radius+frame_thickness+4*finger_width, distance_between_bases/2, 0])
    extrudeWithRadius(base_depth+frame_thickness,-1,-1)
      circle(hole_radius);
}

// Remove from the frame the insert and the holes
difference() {
  frame();
  holes();
  translate([0,0,frame_thickness])
    insert(width=base_depth);
}

// Optional, create external inserts to reduce the depth of hangboard
for (i  = [0:len(inserts_depth)-1]) {
  translate([0,distance_between_bases*2*(1+i),0])
    insert(width=inserts_depth[i], round=false);
}
