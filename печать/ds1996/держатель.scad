$fn=50;




ts=1.5; // толщина стенки
tp=1;//диаметр жилы
tpr=1.7;//диаметр провода
dd=0.3;
pin=[0.65+dd,0.65+dd,11.5];
lin=[10,60,3];//ширина, длина, толщина
ds=[16.5,17.5,6,1];




all1();
module all1(){
    difference(){
        translate([0,0,(ds.z+2*ts+2*tp)/2]) cube([ds.y+2*ts,ds.y+2*ts,ds.z+2*ts+2*tp],true);
        translate([-ds.x/5,0,ts]) {
            cylinder(ds.z+tp,ds.x/2,ds.x/2 );
            translate([0,0,ds.z+tp-ts]) cylinder(ts,ds.y/2,ds.y/2 );
            translate([ds.x/2,0,(ds.z+tp)/2]) cube([ds.x,ds.x,ds.z+tp],true);
            translate([ds.x/2,0,(ds.z+tp-ts)+ts/2]) cube([ds.y,ds.y,ts],true);
        }
        translate([0,0,(ds.z+2*ts+2*tp)/2+ts]) cube([ds.y+3*ts,ds.y-4*ts,ds.z+2*ts+2*tp],true);
        translate([4,0,-ts]) cylinder(5*ts,tp/1.5,tp/1.5 );
        translate([-4,0,-ts]) cylinder(5*ts,tp/1.5,tp/1.5 );
        translate([-ds.x/5,ds.y/2+3*ts, (ds.z+tp)/2+ts]) rotate([90,0,0])cylinder(6*ts,tp/2,tp/2 );
        translate([6,ds.y/2+3*ts, (ds.z+tp)/2+ts]) rotate([90,0,0])cylinder(6*ts,tp/2,tp/2 );
        translate([-ds.x/5,-(ds.y/2-3*ts), (ds.z+tp)/2+ts]) rotate([90,0,0])cylinder(6*ts,tp/2,tp/2 );
        translate([6,-(ds.y/2-3*ts), (ds.z+tp)/2+ts]) rotate([90,0,0])cylinder(6*ts,tp/2,tp/2 );  
    }
}


//all();
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


