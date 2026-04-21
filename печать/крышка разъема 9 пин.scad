$fn=50;
ts=1.5;


plt=[31+3, 12.5, 1.3];
kr=15;
otv=2.9;


difference(){
    union(){
        translate([0,0,ts/2])cube([ plt.x,kr, ts],true);
        translate([0,kr/2,(plt.z+ts)/2])cube([ plt.x,ts,plt.z+ts],true);
        translate([plt.x/2-otv,kr/2-ts-plt.z,(plt.z+ts)/2])cube([ otv*2,ts,plt.z+ts],true);
        translate([-(plt.x/2-otv),kr/2-ts-plt.z,(plt.z+ts)/2])cube([ otv*2,ts,plt.z+ts],true);
        translate([plt.x/2-otv,0,0])cylinder(plt.y/2+ts,otv,otv);
        translate([-(plt.x/2-otv),0,0])cylinder(plt.y/2+ts,otv,otv);
        translate([plt.x/4,otv-kr/2,0])cylinder(plt.y/2+ts,otv,otv);
        translate([-(plt.x/4),otv-kr/2,0])cylinder(plt.y/2+ts,otv,otv);
        translate([-(plt.x/4),otv-kr/2,plt.y/2])cylinder(otv,otv,otv/2);
    }
    translate([plt.x/2-otv,0,-0.1])cylinder(plt.y,otv/2,otv/2);
    translate([-(plt.x/2-otv),0,-0.1])cylinder(plt.y,otv/2+0.3,otv/2+0.3);
    translate([-(plt.x/2-otv),0,-0.1])cylinder(otv,otv,otv/2);
    translate([(plt.x/4),otv-kr/2,plt.y/2])cylinder(otv,otv/2,otv);
}

