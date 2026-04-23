$fn = 50;

si=[15.2,12.2,3.9];
ln=15.56;
bort=0.2;
spil=0.5;
prz=12.1;
prd=2.5;
zub=[5,1,9];

difference(){
    blk();
    translate([0,-(si.y/2+0.1),si.z/2])rotate([-90,0,0])cylinder(prz, prd/2, prd/2);
}
module blk(){
    translate([0,0,si.z/2])difference(){
        cube(si,true);
        translate([0,0.5,si.z-0.2])cube([si.x-1,si.y,si.z],true);
    }
    nos();
    translate([zub.x/2,-si.y/2+zub.y/2,zub.z/2])cube(zub,true);
}

module nos(){
    translate([0,si.y/2,0])difference(){
        hull(){
            translate([0,0,(si.z-0.5)/2])cube([si.x,0.5,si.z-0.5],true);
            translate([0,-si.x/2+4,0])cylinder(si.z-0.5, si.x/2, si.x/2);
        }
        translate([0,-2*si.x,0])cube([4*si.x,4*si.x,4*si.x],true);
    }
}

