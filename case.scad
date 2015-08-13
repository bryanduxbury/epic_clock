// TODO:
// - segment corner alignment is not right. need to specify actual clearance probably
// - set the digit carrier back ever so slightly so the tabs are fully captured

t = 3;
l = 0.005 * 25.4;
k = l / 2;

digit_w = 50;
digit_h = 100;
digit_separation = 5;
section_separation = 10;
gutter = 5;

segment_w = 5;
segment_l = 42.5;

screw_d = 3;

tab_width = 10;

mounting_screw_head_d = 8;
mounting_screw_shaft_d = 4;

closing_screw_shaft_d = 3;

function total_width() = digit_w * 6 
    + 3 * digit_separation 
    + 2 * section_separation 
    + 2 * gutter 
    + 2 * t;

total_depth = digit_w + 2 * t + 10 + 5 + t;
total_height = digit_h + 2 * gutter + 2 * t;

module _e() {
  linear_extrude(height=t, center=true) children();
}

module _corners(dx,dy) {
  for (x=[-1,1], y=[-1,1]) {
    translate([x * dx, y * dy, 0]) children();
  }
}

module _for_digit_positions() {
  assign(sx=digit_separation + section_separation + digit_w * 2)
  assign(dx = digit_separation/2 + digit_w/2)
  for (section=[-1:1], side=[-1,1]) {
    translate([section * sx + side * dx, 0, 0])
    children();
  }
}

module _pcb_blank() {
  color("green")
  difference() {
    cube(size=[50, 100, 1.6], center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (50 / 2 - 2.5), y * (100 / 2 - 2.5), 0]) {
        cylinder(r=3.2/2, h=2, center=true, $fn=12);
      }
    }
  }
}

module _mainboard() {
  _pcb_blank();
  translate([0, 0, 5]) 
  cube(size=[0.7 * 25.4, 1.5 * 25.4, 10], center=true);
  translate([0, -40, 7.5]) 
  cube(size=[0.3 * 25.4, 0.5 * 25.4, 15], center=true);
}

module _pcba() {
  translate([0, 0, -1.6/2]) 
  _pcb_blank();

  _for_segment_positions() {
    for (dx=[-2:2]) {
      translate([dx * 7.5, 0, 1/2]) {
        cube(size=[0.05 * 25.4, 0.08 * 25.4, 1], center=true);
      }
    }
  }
  translate([0, -15, -7.5]) 
  cube(size=[0.3 * 25.4, 0.5 * 25.4, 15], center=true);
}

module _for_segment_positions() {
  positions = [
    [0, 0, 0], 
    [0, 93/2, 0], 
    [0, -93/2, 0], 
    [-25+3.5, -50+26.75, 90],
    [-25+3.5, 50-26.75, 90],
    [25-3.5, -50+26.75, 90],
    [25-3.5, 50-26.75, 90]
  ];
  for (tx=positions) {
    translate([tx[0], tx[1], 0]) 
      rotate([0, 0, tx[2]]) children();
  }
}

module _segment() {
  polygon(points=[
    [segment_w/2, segment_l/2 - segment_w/2],
    [segment_w/2, -(segment_l/2 - segment_w/2)],
    [0, -segment_l/2],
    [-segment_w/2, -(segment_l/2 - segment_w/2)],
    [-segment_w/2, (segment_l/2 - segment_w/2)],
    [0, segment_l/2],
    [segment_w/2, segment_l/2 - segment_w/2]
  ]);
}

module _insert_base() {
  assign(base_w = total_width() - 2 * t)
  assign(base_h = total_height - 2 * t)
  union() {
    square(size=[base_w, base_h], center=true);
    _for_digit_positions() {
      for (y=[-1,1]) {
        translate([0, y * base_h/2, 0]) 
          square(size=[tab_width, t*2], center=true);
      }
    }

    for (x=[-1,1], y=[-1,1]) {
      translate([x * (base_w / 2), y * total_height / 4, 0]) 
        square(size=[t*2, tab_width], center=true);
    }
  }
}

module digit_carrier() {
  assign(base_w = total_width() - 2 * t)
  assign(base_h = total_height - 2 * t)
  difference () {
    _insert_base();

    _for_digit_positions() {
      for (x=[-1,1],y=[-1,1]) {
        translate([x * (digit_w / 2 - 2.5), y * (digit_h / 2 - 2.5), 0]) {
          circle(r=screw_d/2, $fn=36);
        }
      }
      
      _for_segment_positions() {
        rotate([0, 0, 90]) _segment();
      }
    }
  }
}

module side() {
  difference() {
    union() {
      square(size=[total_depth, total_height - 2 * t], center=true);
      for (x=[-1,1], y=[-1,1]) {
        translate([x * total_depth/4, y * (total_height/2 - t), 0]) 
          square(size=[tab_width, t*2], center=true);
      }
    }
    
    translate([-total_depth/2, 0, 0]) 
      square(size=[2*t, total_height - 2 * tab_width], center=true);
      
      for (y=[-1,1]) {
        translate([-total_depth / 2 + t + t/2, y * total_height / 4, 0]) 
          square(size=[t, tab_width], center=true);
        translate([total_depth / 2 - t - t/2, y * total_height / 4, 0]) 
          square(size=[t, tab_width], center=true);
      }
      
  }
}

module face() {
  difference() {
    square(size=[total_width(), total_height], center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * total_width()/2, y * total_height/2, 0]) {
        square(size=[2*tab_width, 2*t], center=true);
        square(size=[2*t, 2*tab_width], center=true);
      }
    }
  }
}

module _top_bottom_base() {
  difference() {
    square(size=[total_width(), total_depth], center=true);
    _for_digit_positions() {
      translate([0, -total_depth/2 + t + t/2, 0]) 
        square(size=[tab_width, t], center=true);
      translate([0, total_depth/2 - t - t/2, 0]) 
        square(size=[tab_width, t], center=true);
    }
    
    translate([0, -total_depth/2, 0]) 
      square(size=[total_width() - 2 * tab_width, 2*t], center=true);

    for (x=[-1,1], y=[-1,1]) {
      translate([x * total_width() / 2, y * total_depth/4, 0]) 
        square(size=[t*2, tab_width], center=true);
    }
  }
}

module top() {
  _top_bottom_base();
}

module bottom() {
  _top_bottom_base();
}

module back() {
  assign(inside_w = total_width() - t * 2)
  assign(inside_h = total_height - t * 2)
  difference() {
    square(size=[total_width()-2*t, total_height-2*t], center=true);    
    _corners(inside_w / 2 - 2 * t - closing_screw_shaft_d/2, inside_h / 2 - 2 * t - closing_screw_shaft_d/2) {
      circle(r=closing_screw_shaft_d/2-l, $fn=36);
    }
  }
}

module back_frame() {
  assign(inside_w = total_width() - t * 2)
  assign(inside_h = total_height - t * 2)
  difference() {
    _insert_base();
    _corners(inside_w / 2 - 2 * t - closing_screw_shaft_d/2, inside_h / 2 - 2 * t - closing_screw_shaft_d/2) {
      circle(r=closing_screw_shaft_d/2-l, $fn=36);
    }
    
    difference() {
      square(size=[total_width() - t*5, total_height - t*5], center=true);
      _corners((total_width() - t*5) / 2, (total_height - t*5) / 2) {
        rotate([0, 0, 45]) square(size=[20, 20], center=true);
      }
    }
  }
}

module _assembled() {
  _for_digit_positions() {
      rotate([90, 0, 0]) _pcba();
  }

  translate([total_width()/2 - t - 1.6, digit_w / 2 + 10, 0]) 
    rotate([90, 0, -90]) 
      _mainboard();
    
  color("gray")
  translate([0, -t/2, 0]) 
    rotate([90, 0, 0]) 
      _e() digit_carrier();

  for (x=[-1,1]) {
    translate([x * (total_width() / 2 - t/2), total_depth/2 - 2*t, 0]) 
    color("blue")
      rotate([90, 0, 90])
        _e()
          side();
  }

  color("orange") translate([0, total_depth/2 - 2*t, total_height/2 - t/2])
    _e() top();
  color("orange") translate([0, total_depth/2 - 2*t, -(total_height/2 - t/2)])
    _e() bottom();
    
  translate([0, total_depth - t * 3 - t/2, 0]) 
    rotate([90, 0, 0]) 
      _e() back_frame();

  color("pink")
    translate([0, total_depth - t * 2 - t/2, 0])
      rotate([90, 0, 0])
        _e() back();
  
  color([0/255, 0/255, 0/255, 0.25]) 
    translate([0, -t * 1.5, 0]) 
      rotate([90, 0, 0]) _e() face();
}

_assembled();

