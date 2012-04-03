width = 19*25.4;
height = 3*25.4;
depth = 8 * 25.5;

material_thickness = 5;


module port_module() {
  color([128/255, 128/255, 128/255]) translate([0, 0, 0.8]) {
    difference() {
      cube(size=[50, 50, 1.6], center=true);
      for (angle = [0, 90, 180, 270]) {
        rotate([0, 0, angle]) translate([22, 22, 0]) {
          cylinder(r=1.6, h=10, center=true, $fn=16);
        }
      }
    }
  }

  translate([0, -22, 8.8]) {
    color([255/255, 255/255, 255/255]) {
      for (x = [-9, 9]) {
        translate([x, 0, 0]) {
          cube(size=[15.5, 20.9, 16], center=true);
        }
      }
    }
  }
}

module lcd_module() {
  color([128/255, 128/255, 128/255]) {
    difference() {
      cube(size=[100, 1.6, 60], center=true);
      for (x = [-1, 1]) {
        for (y = [-1, 1]) {
          translate([x*93/2, 0, y*55/2]) rotate([90, 0, 0]) cylinder(r=1.5, h=10, center=true);
        }
      }
    }
    translate([0, -1.6 - 9.9/2, 0]) {
      cube(size=[98, 9.9, 39.5], center=true);
    }
  }
}

module pwr_switch() {
  color([128/255, 128/255, 128/255]) {
    translate([0, -1, 0]) cube(size=[15, 2, 21], center=true);
    translate([0, 19.8/2, 0]) cube(size=[13, 19.8, 18.8], center=true);
    translate([0, -1 - 2.5, 0]) cube(size=[9.9, 5, 13], center=true);
  }
}

module pwr_plug() {
  color([128/255, 128/255, 128/255]) {
    cube(size=[20, 25, 25], center=true);
  }
}

module pwr_supply() {
  color([128/255, 128/255, 128/255]) {
    cube(size=[100, 50, 40], center=true);
  }
}

translate([0, 0, -height/2 + material_thickness / 2]) {
  cube([width, depth, material_thickness], center=true);
}

for (angle = [0, 180]) {
  rotate(a=[0,0,angle]) translate([width/2 - material_thickness/2, 0, 0]) {
    cube([material_thickness, depth, height], center=true);
  }
}

for (angle = [0, 180]) {
  rotate(a=[0,0,angle]) translate([0, depth/2 - material_thickness/2, 0]) {
    cube([width, material_thickness, height], center=true);
  }
}

translate([-width/2 + 10 + 25, -depth/2 + material_thickness + 25 + 2, -height/2 + material_thickness + 10]) {
  for (i = [0:5]) {
    translate([i * 52.5, 0, 0]) {
      port_module();
    }
  }
}

translate([-width/2 + 10 + 25 + 6 * 55 + 30, -depth/2 + material_thickness + 9.9+1.6, 0]) lcd_module();

translate([width/2 - material_thickness - 5 - 15/2, -depth/2, 0]) pwr_switch();

translate([width/2 - material_thickness - 10 - 12.5, depth/2 - 10, 0]) pwr_plug();

translate([width/2 - material_thickness - 10 - 25 - 10 - 50, depth/2 - material_thickness - 5 - 25, 0]) pwr_supply();