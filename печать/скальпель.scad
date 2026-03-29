

$fn=3;

sd=10;
sy=60;

hby=10;
hbz=4;
ts=1;

bx=hbz+2;
by=8;


line();
module line(){
    translate([0,0,0])blade1(by);
    translate([10,0,0])blade1(by/2);
    translate([20,0,0])blade(by/2);
    translate([30,0,0])blade(by);

    translate([-10,0,0])blade1(by);
    translate([-30,0,0])blade1(by/2);
    translate([-20,0,0])blade(by/2);
    translate([-40,0,0])blade(by);
}

//pin();
//shr(0.5);
module shr(k){
    rotate_extrude(angle=-180, $fn=50)polygon(points=[[0,0],[0,k*ts], [k*bx/6,k*ts],[k*bx/2,0]]);
}
module pin(){
    difference(){
        translate([0,0,0])rotate([0,-90,0])cylinder(sy, sd/2, sd/2);
        translate([0.1-hby/2,0,0.5])cube([ hby, ts+0.2, hbz+0.2],true);
    }
}

//blade(by);
module blade(l){
    translate([0.7+hbz/2,hby/2-1,ts/2])cube([ hbz,hby, ts,],true);
    rotate([90,0,0])linear_extrude(height = l, center = false, convexity = 10, scale=0.3) polygon(points=[[0,0],[0,2*ts], [bx,0]]);
}
//blade1(by);
module blade1(l){
    translate([0.7+hbz/2,hby/2-1,ts/2])cube([ hbz,hby, ts,],true);
    rotate([90,0,0])linear_extrude(height = l, center = false, convexity = 10, scale=0.3) polygon(points=[[0,0],[bx/3,ts], [2*bx/3,2*ts],[bx,0]]);
    translate([bx*0.3/2,-l,0])shr(0.3);
}

