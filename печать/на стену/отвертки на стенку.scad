$fn=50;
ts=1.5;

kv=9.95;//размер ячейкм
dd=18;//растояние между ячейками
tst=1.8;//толщина стенки = сетки
dot=3;//for sanorez
hn=4;//h nogi
dno=kv*1.7;//d fix

dotv=6;
lot=15;
step=20;
coun=7;

dk=kv*1.7;
dv=kv*0.9;

all();


module fix(){
    difference(){
        union(){
            translate([(dd+kv)/2,0,ts/2])cube([ dd+kv,kv/2, ts],true);
            translate([0,0,ts/2+ts+tst])rotate([0,0,45])cube([ kv-0.2,kv-0.2, ts],true);
            cylinder(ts, dk/2, dk/2);
            translate([0,0,0])cylinder(ts+tst, dv/2, dv/2);
            //translate([0,0,-(ts+hn)+0.1])cylinder((ts+hn), dv/2, dv/2);
            //translate([0,0,-(ts+hn)+0.1-ts])cylinder(ts, dno/2, dno/2);
            translate([dd+kv,0,0]){
                translate([0,0,(2*ts+tst)/2])rotate([0,0,0])cube([ kv-0.2,kv-0.2, 2*ts+tst],true);
                cylinder(ts, dk/2, dk/2);
            }
        }
        translate([0,0,-0.1])cylinder((ts+tst)*2, dot/2, dot/2);
    }
}

module all(){
    //difference(){
        line();
    //    translate([-step/2-ts*3,0,kv])rotate([0,-90,0])minus();
    //}
    translate([-step+2*ts+ts/2,0,ts+dk/2])rotate([0,-90,0])fix();
}    
    
    
module minus(){
    translate([0,0,(2*ts+tst)/2])rotate([0,0,0])cube([ kv-0.2,kv-0.2, 2*ts+tst],true);
    translate([dd+kv,0,(2*ts+tst)/2])rotate([0,0,0])cube([ kv-0.2,kv-0.2, 2*ts+tst],true);
}


module line(){
    difference(){
        union(){
            translate([coun*step/2-step/4,0,ts/2])cube([ coun*step+step+step/4,dk+3*ts, ts],true);
            translate([0,(dk+3*ts)/2-ts/2,(dd+kv/2)/2])cube([ step*2-step/4,ts, (dd+kv/2)],true);
            translate([0,-((dk+3*ts)/2-ts/2),(dd+kv/2)/2])cube([ step*2-step/4,ts, (dd+kv/2)],true);
            translate([-step+2*ts,0,(dd*2+kv*1)/2])cube([ ts,dk+3*ts, (dd*2+kv*1)],true);
            translate([coun*step/2,0,lot/2])cube([ coun*step,ts, lot],true);
            for (as=[0:1:coun]){
                translate([as*step,0,0])cylinder(lot, dotv/2+ts, dotv/2+ts);
            }
        }
        for (as=[0:1:coun]){
            translate([as*step,0,-1])cylinder(lot*2, dotv/2, dotv/2);
        }
    }
}