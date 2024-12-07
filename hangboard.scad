/* [Finger lengths] */
// Right hand index finger height
h2_right = 13.8;
// Right hand middle finger height
h3_right = 24.8;
// Right hand ring finger height
h4_right = 12.4;
// Right hand pinky finger height. Leave it as 0, as the reference for the rest.
h5_right = 0;

// Left hand index finger height
h2_left = 9.5;
// Left hand middle finger height
h3_left = 20.5;
// Left hand ring finger height
h4_left = 10;
// Left hand pinky finger height. Leave it as 0, as the reference for the rest.
h5_left = 0;

/* [Other settings] */

// Width for each finger position
finger_width = 20; // [5:40]
// How deep the hangboard is
base_depth = 30; // [5:60]

// Distance between the two middle fingers surfaces
distance_between_hands = 20;

/* [Inserts] */

// Create inserts to reduce the depth of the hangboard?
create_inserts = "no";  // [yes,no]

// Depth of the inserts. To remove the inserts, define an empty list
inserts_depth = [base_depth/2, base_depth/3, base_depth/4];

/* [Advanced settings] */

// Thickness of the frame walls
frame_thickness = 9; // [5:15]

// Radius of the holes in the frame
hole_diameter = 8; // [4:12]
hole_radius = hole_diameter/2;

// Extra space between index finger and lateral wall
extra_index_finger_space = 2;

finger_platform_concavity_depth = 2;

distance_between_bases = distance_between_hands + h3_right + h3_left;

// The object to be subsctracted from the frame, with "negative fillets"
module insert(width, corner_radius=5) {
    right_hand = [h2_right, h3_right, h4_right, h5_right];
    left_hand = [h2_left, h3_left, h4_left, h5_left];

    // (start == 0 ? start-1 : start) is a workaround to avoid the "for" loop to start at 0
    function finger_points(hand, start, reverse=false) =
        [for (i = [0:3])
            for (j = [0:2])
                (j == 0) ?
                    // The i==0 condition is to add the extra space between the index finger and the lateral wall
                    [(start + (reverse ? -1 : 1) * i) * finger_width - ((i == 0 && !reverse) ? extra_index_finger_space : 0),
                    reverse ? (distance_between_bases - hand[3-i]) : hand[i],
                    ] :
                // j == 1 is the middle point of the finger
                (j == 1) ?
                    [(start + (reverse ? -1 : 1) * i) * finger_width + (reverse ? -1 : 1) * finger_width/2,
                    (reverse ? (distance_between_bases - hand[3-i]) : hand[i]) + (reverse ? 1 : -1) * finger_platform_concavity_depth,
                    ] :
                    // The i==3 condition is to add the extra space between the index finger and the lateral wall
                    [(start + (reverse ? -1 : 1) * i) * finger_width + (reverse ? -1 : 1) * finger_width - ((i == 3 && reverse) ? extra_index_finger_space : 0),
                    reverse ? (distance_between_bases - hand[3-i]) : hand[i],
                    ]
        ];

    radiiPoints = concat(
        finger_points(right_hand, 0),
        finger_points(left_hand, 4, true)
    );

    linear_extrude(height=width)
      offset(r = corner_radius)
        offset(r = -corner_radius)
          polygon(radiiPoints);
}

// Main structure of the hangboard
module frame(corner_radius = 20) {
  radiiPoints = [
    [-frame_thickness, -frame_thickness], // bottom left
    [4*finger_width+frame_thickness, -frame_thickness], // bottom right
    [4*finger_width+frame_thickness*2+hole_diameter, distance_between_bases/2], // right middle
    [4*finger_width+frame_thickness, distance_between_bases+frame_thickness], // top right
    [-frame_thickness, distance_between_bases+frame_thickness], // top left
    [-frame_thickness*2-hole_diameter, distance_between_bases/2], // left middle
  ];

  linear_extrude(height=base_depth+frame_thickness)
    offset(r = corner_radius)
      offset(r = -corner_radius)
        polygon(radiiPoints);
}

// Hole to pass the rope
module hole() {
  linear_extrude(height=base_depth+frame_thickness+0.2)
    circle(hole_radius);
}

// Remove from the frame the insert and the holes
difference() {
  frame();
  translate([-hole_radius-frame_thickness, distance_between_bases/2, 0])
    hole();
  translate([+hole_radius+frame_thickness+4*finger_width, distance_between_bases/2, 0])
    hole();
  translate([0,0,frame_thickness+0.1])
    insert(width=base_depth+0.1);
}

// Optional, create external inserts to reduce the depth of hangboard
if (create_inserts == "yes") {
  for (i  = [0:len(inserts_depth)-1]) {
    translate([0,distance_between_bases*2*(1+i),0])
      insert(width=inserts_depth[i]);
  }
}
