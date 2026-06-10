$fn=50;
ts=6;

ln=260;
stk=[100,60,10];
dd=0.4;
ro=5;

lop=stk.x/1.6;

 translate([0,-stk.y ,0]) all1();
  translate([0,stk.y ,0]) all1();
line();



module all1(){
    translate([0,-stk.y/2+18 ,0]) all();
    translate([-stk.x/2+stk.z/2,9,0])rotate([0,0,-30])translate([lop/2,-stk.z/2,ts/2])cube([lop,stk.z, ts],true);
}

module all(){
    
    difference(){
        translate([0,0,ts/2])cube([stk.x+stk.z,stk.y+stk.z*2, ts],true);
        translate([stk.z,0,ts/2])cube([stk.x+stk.z,stk.y, ts*3],true);
        translate([stk.z*2,stk.z*2,ts/2])cube([stk.x+stk.z,stk.y, ts*3],true);
    }
    translate([-stk.z,-stk.y/2+(ro+2*ts)/2,ts/2])difference(){
        cube([ro+2*ts,ro+2*ts, ts],true);
        cube([ro+dd,ro+dd, ts*3],true);
    }
}    
    



module line(){
    translate([0,0,ro/2])cube([ln,ro, ro],true);
}