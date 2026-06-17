$fn=8;




ts=1.5; // толщина стенки
tp=1;//диаметр жилы
tpr=1.7;//диаметр провода
dd=0.3;
pin=[0.65+dd,0.65+dd,11.5];
lin=[10,60,3];//ширина, длина, толщина



//translate([0, 0,lin.z+knt.y/2]) cube([ts,step,knt.y],true);

all();
module all(){
    difference(){
        union(){
            translate([0,lin.y/2,(ts+lin.z)/2]) cube([lin.x+2*ts,lin.y,lin.z+ts],true);
            translate([lin.x/2,0,(ts+lin.z)/2]) rotate([0,0,45])cube([pin.x*6,pin.y*6,lin.z+ts],true);
        }
        translate([0,lin.y/2,(ts+lin.z)/2+ts/2]) cube([lin.x,lin.y*2,lin.z+ts],true);
        translate([lin.x/2,0,(ts+lin.z)/2+ts/2]) rotate([0,0,45])cube([pin.x,pin.z,lin.z+ts],true);

    }
}


