$fn=50;
ts=4;
ts2=10;
ts1=ts+4;

rigel=[[28.8,27.9],[194.2,163]];
otv_start=[[6.4,6.4],[171.4,172.1]];
otv_line=[[6.4,6.4],[171.3,172.1],[140.7,178.2],[318.0, 360]];
otv_line_stop=[[6.4,6.4],[159.5,153.3]];
otv_stop=[[6.4,6.4],[158.5,149.5]];
otv_flex=[[3.5,3.5],[158.4,154.2],[165.5,149.5],[0,34.5]];
otv_otv=[[4.2,4.2],[175,154.7]];
otv_hvost_kr=[[12.9,12.9],[145.8,149.3]];
otv_hvost=[[22.5,12.9],[135,149.3]];
hvost=[[31.4,21.8],[139.6,149.3]];
zub=[[13,33.3],[174.3,165.7]];
skos1=[[12.5,26],[161.5,151.3],[161.5,151.3],[360,309]];
skos2=[[12.5,29.7],[164.8,166.7],[164.8,166.7],[360,326]];

rotate([180,0,0])translate([-rigel.y.x,-rigel.y.y,0])all();


module all(){
    translate([rigel.y.x,rigel.y.y,-ts2/2])cube([rigel.x.x,rigel.x.y,ts2],true);
    translate([0,0,-ts])difference(){
        out();
        translate([0,0,-1])in ();
    }
    
}

module out(){
    
    translate([rigel.y.x,rigel.y.y,ts/2])cube([rigel.x.x,rigel.x.y,ts],true);
    translate([hvost.y.x+1,hvost.y.y,ts/2])cube([hvost.x.x+2,hvost.x.y,ts],true);
    translate([zub.y.x,zub.y.y,ts/2])cube([zub.x.x,zub.x.y,ts],true);
    translate([skos1.y.x+2,skos1.y.y,ts/2])rotate([0,0,skos1[3].y])cube([skos1.x.x,skos1.x.y,ts],true);
    translate([skos2.y.x,skos2.y.y,ts/2])rotate([0,0,skos2[3].y])cube([skos2.x.x,skos2.x.y,ts],true);
}
//translate([-rigel.y.x,-rigel.y.y,0])in();
module in (){
translate([otv_start.y.x,otv_start.y.y,0])cylinder(ts1,otv_start.x.x/2,otv_start.x.y/2);
translate([otv_line_stop.y.x,otv_line_stop.y.y,0])cylinder(ts1,otv_line_stop.x.x/2,otv_line_stop.x.y/2);    
translate([otv_stop.y.x,otv_stop.y.y,0])cylinder(ts1,otv_stop.x.x/2,otv_stop.x.y/2);
translate([otv_otv.y.x,otv_otv.y.y,0])cylinder(ts1,otv_otv.x.x/2,otv_otv.x.y/2);
translate([otv_hvost_kr.y.x,otv_hvost_kr.y.y,0])cylinder(ts1,otv_hvost_kr.x.x/2,otv_hvost_kr.x.y/2);
translate([otv_hvost.y.x,otv_hvost.y.y,ts1/2])cube([otv_hvost.x.x,otv_hvost.x.y,ts1],true);

function dd_x(point,centre)=centre.x-point.x;
function dd_y(point,centre)=centre.y-point.y;
function rad (x,y)= sqrt(x*x+y*y);


dx=dd_x(otv_line.y,otv_line.z);
dy=dd_y(otv_line.y,otv_line.z);
radius_line= rad (dx,dy);
translate([otv_line.z.x,otv_line.z.y,0])rotate([0,0,atan(dy/dx)])rotate_extrude (angle=otv_line[3].x-otv_line[3].y)translate([radius_line-otv_line.x.x/2,0,0])square(size = [otv_line.x.x, ts1], center = false);

dx1=dd_x(otv_flex.y,otv_flex.z);
dy1=dd_y(otv_flex.y,otv_flex.z);
radius_flex= rad (dx1,dy1);
translate([otv_flex.z.x,otv_flex.z.y,0]) rotate([0,0,180])rotate_extrude (angle=-(otv_flex[3].y-otv_flex[3].x))translate([radius_flex-otv_flex.x.x/2,0,0])square(size = [otv_flex.x.x,ts1], center = false);
    
}   
    