

ts=1.5;

noga=[48,26, 49];
ship=[11.4,1.5];
plt=[10.8,0.9,25.5];


difference(){
    union(){
        minkowski(){
            translate([0,0,noga.z/2]) cube([noga.x-noga.y,0.01,noga.z],true);
            cylinder(0.1, noga.y/2, noga.y/2);
        }
        translate([0,noga.y/2,noga.z/2]) cube([ship.x,ship.y*2,noga.z],true);
    }
    difference(){
        translate([0,0,ts])minkowski(){
            translate([0,0,noga.z]) cube([noga.x-noga.y,0.01,noga.z*2],true);
            cylinder(0.1, noga.y/2-ts, noga.y/2-ts);
        }
        translate([0,noga.y/2-ts,plt.z/2]) cube([ship.x,ship.y*2,plt.z],true);
        translate([0,-(noga.y/2-ts),plt.z/2]) cube([ship.x,ship.y*2,plt.z],true);
    }
}


module wire(){
    union(){
        translate([0,0,12.5]) cylinder(25, 0.9, 0.9, true);
        translate([0,0,25]) cylinder(7, 0.6, 0.6, true);
        translate([0,0,0.5]) cylinder(1.1, 1, 1, true);
    };
};
module pin(){
    union(){
        translate([0,0,14]) cube([5,5.1,28],true);
    }
};
module minus(){
    difference(){ pin();  wire();};
};
//pin();
//wire();
//minus();
module uho(){
    difference(){ cube([10,10,3],true); cylinder(6, 2.5, 2.5, true);};
};
module row(n){
    union() {
      translate([0,-7.5,1.5]) uho();
      for(i=[0:n]){  
        translate([0,i*5,0]){ minus();};
      };
      translate([0,7.5+(n*5),1.5]) uho();
    };
};

//row(8);
//uho();