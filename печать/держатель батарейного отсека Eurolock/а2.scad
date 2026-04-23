$fn=50;

ts=2;
a1=36;
a2=30;
fp=2.5;
hz=3.5;
dd=[8.5,4];

all1();

module all(){

    translate([hz/2,0,ts/2])cube([hz,a1,ts],true);
    translate([-fp/2,0,ts/2])cube([fp,a2,ts],true);
    translate([(fp+hz)/2-fp,0,ts])cube([fp+hz,a2/2,2*ts],true);

}

module all1(){
    difference(){
        translate([hz/2,0,ts/2])cube([hz,a1,ts],true);
        translate([0,a1/2-dd.x+dd.y/2,ts/2])cube([hz/3,dd.y,ts*2],true);
    }
    
    translate([-fp/2,0,ts/2])cube([fp,a2/2,ts],true);
    translate([(fp+hz)/2-fp,0,ts])cube([fp+hz,a2/2,2*ts],true);

}