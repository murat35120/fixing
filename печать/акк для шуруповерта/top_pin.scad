

ts=1.5;

noga=[48,26, 49];//форма
ship=[10.5,1.5]; //шип на акк
plt=[11.3+0.5,0.9,25.5];//размер платки = контакта
ky=22.5; //толщика по контактам
rx=8; //ширина выреса для ламели
rz=17; //ширина выреса для ламели

//intersection(){
    union(){
       all();
       // translate([ship.x/2+ts*2,noga.y/2-3,noga.z-30-2])fix1();
       // translate([-(ship.x/2+ts*2),noga.y/2-3,noga.z-30-2])fix1();
       // translate([ship.x/2+ts*2,-(noga.y/2-3),noga.z-30-2])rotate([0,0,180])fix1();
       // translate([-(ship.x/2+ts*2),-(noga.y/2-3),noga.z-30-2])rotate([0,0,180])fix1();
    }
   // translate([0,0,5]) cube([noga.x*2,noga.y*2,10],true);
//}


module fix(){
    linear_extrude(20, scale =2.5)    square([2,5], true);
    translate([0,0,10])cube([2,5,40],true);
}
//fix1();
module fix1(){
    //linear_extrude(20, scale =2.5)    square([2,5], true);
    translate([0,0.5,0])cube([2,5,30],true);
    translate([1,-2,0])rotate([0,-90,0])linear_extrude(2) polygon(points=[[0,0],[40,0],[40,5],[30,5],[30,10],[10,5],[0,5]]);
}

module all(){
    difference(){
        union(){
            minkowski(){
                translate([0,0,(noga.z+5)/2]) cube([noga.x-noga.y,0.01,noga.z+5],true);
                cylinder(0.1, noga.y/2, noga.y/2);
            }
            translate([0,noga.y/2,(noga.z+5)/2]) cube([ship.x,ship.y*2,noga.z+5],true);
        }
        difference(){
            translate([0,0,ts])minkowski(){
                translate([0,0,noga.z]) cube([noga.x-noga.y,0.01,noga.z*2],true);
                cylinder(0.1, noga.y/2-ts, noga.y/2-ts);
            }
            translate([0,noga.y/2-ts,plt.z/2]) cube([ship.x+ts*2,ship.y*2+plt.y,plt.z],true);
            translate([0,-(noga.y/2-ts),plt.z/2]) cube([ship.x+ts*2,ship.y*2+plt.y,plt.z],true);
        }
        translate([0,ky/2-plt.y/2,plt.z/2-0.1]) cube(plt,true);
        translate([0,-(ky/2-plt.y/2),plt.z/2-0.1]) cube(plt,true);
        translate([0,ky/2+ts,rz/2-0.1])  cube([rx,ship.y*5,rz],true);
        translate([0,-(ky/2+ts),rz/2-0.1])  cube([rx,ship.y*5,rz],true);
        translate([0,ky/2+ts,(plt.z+5)/2-0.1])  cube([rx/3,ship.y*5,plt.z+5],true);
        translate([0,-(ky/2+ts),(plt.z+5)/2-0.1])  cube([rx/3,ship.y*5,plt.z+5],true);
        //translate([ship.x/2+ts*2,0,noga.z])  cube([rx/2,noga.y*2,40],true);
        //translate([-(ship.x/2+ts*2),0,noga.z])  cube([rx/2,noga.y*2,40],true);
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