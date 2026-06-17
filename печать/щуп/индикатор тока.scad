$fn=8;




ts=1.5; // толщина стенки
tp=1;//диаметр жилы
tpr=1.7;//диаметр провода
dd=0.4;
pin=[0.65+dd,0.65+dd,11.5];
lin=[10,60,3];//ширина, длина, толщина
hs=5+ts;
step=4.75+2*tp;
lnog=20;
tub=tp+ts*2;
sdv=(step+2*ts)/2-ts/2-tp;

    difference(){
        union(){
            translate([0,-lnog/2,ts/2]) cube([step+2*ts,lnog/1,ts],true);
            translate([0,0,ts/2]) rotate([0,0,45])cube([(step+2*ts)/1.41,(step+2*ts)/1.41,ts],true);
            translate([sdv,lnog/4-0.1,tub/2]) cube([tub,lnog/2,tub],true);
            translate([(step+2*ts)/2,-lnog/2,ts]) cube([ts,lnog/1,ts*2],true);
            translate([-(step+2*ts)/2,-lnog/2,ts]) cube([ts,lnog/1,ts*2],true);
        }
        translate([sdv,0,ts+tp/2]) cube([tp,lnog*3,tp],true);
    }

//all();
module all(){
    difference(){
        union(){
            translate([0,lin.y/2,(ts+lin.z)/2]) cube([lin.x+2*ts,lin.y,lin.z+ts],true);
            translate([0,0,hs/2]) cube([lin.x+2*ts,pin.y*6,hs],true);
        }
        translate([0,lin.y,(ts+lin.z)/2+ts/2]) cube([lin.x,lin.y*2,lin.z+ts],true);
        translate([step/2,pin.y*3,pin.z+ts]) cube([pin.x,pin.y*6,pin.z*2],true);
        translate([-step/2,pin.y*3,pin.z+ts]) cube([pin.x,pin.y*6,pin.z*2],true);
    }
}


