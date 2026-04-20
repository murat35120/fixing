$fn=50;
ts=1.5;

tlk=[16,5,2];//передняя пластина толкателя
opor=[3.7,14.3,9];//опора - ползунок
ship=[1.5,1.5,0.3];//шип
otv=[6.3,6,1.5];// отверстие высота стойки, от переднего края опоры, диаметр

dug();
translate([0,0.25,0])op();


module dug(){
    intersection(){
        translate([0,tlk.y/2,tlk.z/2])cube(tlk,true);
        translate([0,tlk.x,-0.1])scale([0.9,1,1])cylinder(tlk.z*2,tlk.x,tlk.x);
    }
}




module op(){
    difference(){
        union(){
            translate([0,opor.y/2,opor.z/2])cube(opor,true);
            translate([opor.x/2,opor.y/2,opor.z/2])rotate([0,-90,0])cylinder(otv.x,otv.z*3,otv.z);
        }
        translate([opor.x/2+0.1,opor.y/2,opor.z/2])rotate([0,-90,0])cylinder(otv.x+0.2,otv.z*2,otv.z/2);
        translate([0,opor.y,opor.z/2])cube([opor.x*2,ts*2,opor.y/2],true);
    }
}



