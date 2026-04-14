$fn=50;
ts=1.5;

kv=9.95;//размер ячейкм
dd=18;//растояние между ячейками
tst=2.5;//толщина стенки = сетки
dot=3;//for sanorez
hn=4;//h nogi
dno=kv*1.7;//d fix

dk=kv*1.7;
dv=kv*0.9;

rotate([180,0,0])difference(){
    union(){
        translate([(dd+kv)/2,0,ts/2])cube([ dd+kv,kv/2, ts],true);
        translate([0,0,ts/2+ts+tst])rotate([0,0,45])cube([ kv-0.2,kv-0.2, ts],true);
        cylinder(ts, dk/2, dk/2);
        translate([0,0,0])cylinder(ts+tst, dv/2, dv/2);
        translate([0,0,-(ts+hn)+0.1])cylinder((ts+hn), dv/2, dv/2);
        translate([0,0,-(ts+hn)+0.1-ts])cylinder(ts, dno/2, dno/2);
        translate([dd+kv,0,0]){
            translate([0,0,(2*ts+tst)/2])rotate([0,0,0])cube([ kv-0.2,kv-0.2, 2*ts+tst],true);
            cylinder(ts, dk/2, dk/2);
        }
    }
    translate([0,0,-0.1])cylinder((ts+tst)*2, dot/2, dot/2);
}

