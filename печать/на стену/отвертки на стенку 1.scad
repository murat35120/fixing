$fn=50;
ts=2;

kv=9.95;//размер ячейкм
kv1=kv-0.5;
dd=18;//растояние между ячейками
tst=1.8;//толщина стенки = сетки
dot=3;//for sanorez
hn=4;//h nogi
dno=kv*1.7;//d fix

mot=15; //длина стоек от стены
smr=3;//диаметр самореза
dsm=10;//длина под саморез

dotv=4.5;
lot=10;
step=30;
coun=3;

dk=kv*1.7;
dv=kv*0.9;


smart=[74,12,10];

sm();
translate([0,smart.x,0])nv();//новый фикстатор

module sm(){
    difference(){
        translate([(dd+kv),0,0])difference(){
            translate([0,0,(smart.y+2*ts)/2])cube([ (dd+kv)*2+kv*2+10,smart.x+2*ts, smart.y+2*ts],true);
            translate([ts+0.1,0,(smart.y+2*ts)/2])cube([ (dd+kv)*2+kv*2+10,smart.x, smart.y],true);
            translate([ts+0.1,0,(smart.y+2*ts)/2+2*ts])cube([ (dd+kv)*2+kv*2+10,smart.x-smart.z, smart.y+4*ts],true);
            translate([ts+0.1,0,(smart.y+2*ts)/2+2*ts])cube([ (dd+kv)*2+kv*2+4*ts+10,smart.x/2, smart.y+4*ts],true);
        }
        translate([-kv+ts+smr/2,0,-0.1])rotate([0,0,0])cylinder(ts+0.2, smr/2, smr/2+ts);
        translate([(dd+kv)*2+kv-ts-smr/2,0,-0.1])rotate([0,0,0])cylinder(ts+0.2, smr/2, smr/2+ts);
}
}




module nv(){
    difference(){
        union(){
            translate([-kv+ts/2,mot/2,kv1/2])cube([ ts,mot, kv1],true);
            translate([-kv+(ts*2+smr)/2,mot-dsm/2,kv1/2])cube([ ts*2+smr,dsm, kv1],true);
            translate([(dd+kv)*2+kv-ts/2,mot/2,kv1/2])cube([ ts,mot, kv1],true);
            translate([(dd+kv)*2+kv-ts/2-(ts*2+smr)/2,mot-dsm/2,kv1/2])cube([ ts*2+smr,dsm, kv1],true);
            translate([0,0,kv1/2])rotate([90,0,0]){
                translate([(dd+kv),0,ts/2])cube([ (dd+kv)*2+kv*2,kv1, ts],true);
                translate([0,0,0])krk();
                translate([dd+kv,0,0])stp();
                translate([(dd+kv)*2,0,0])krk();
            }
        }
        translate([-kv+ts+smr/2,0,kv1/2])rotate([-90,0,0])cylinder(dsm*10+mot, smr/2, smr/2);
        translate([(dd+kv)*2+kv-ts-smr/2,0,kv1/2])rotate([-90,0,0])cylinder(dsm*10+mot, smr/2, smr/2);
    }
}

// ((dd+kv)*2+kv-ts-smr/2)-(-kv+ts+smr/2)

//all1();

module all1(){
    difference(){
        union(){
            translate([0,(dk+3*ts)/2,0])line1();
            translate([0,-(dk+3*ts)/2,0])line1();
        }
        translate([+step/2,0,-1])cylinder(ts*4, smr/2+0.2, smr/2+0.2);
        translate([((dd+kv)*2+kv-ts-smr/2)-(-kv+ts+smr/2)+step/2,0,-1])cylinder(ts*4, smr/2+0.2, smr/2+0.2);
    }
}


//krk();
module krk(){
    translate([0,0,ts/2+ts+tst])cube([ kv1,kv1, ts],true);  
    translate([-kv1/4,0,(ts+tst)/2])cube([ kv1/2,kv1, ts+tst],true);   
}

module stp(){
    //translate([0,0,ts/2+ts+tst])cube([ kv1,kv1, ts],true);  
    translate([-kv1/4-kv1/2+1,0,(ts+tst+ts)/2])cube([ kv1/2,kv1, ts+tst+ts],true);   
}


module line1(){
    intersection(){
        difference(){
            union(){
                translate([coun*step/2,0,ts/2])cube([ coun*step+step+step/4,dk+3*ts, ts],true);
                translate([coun*step/2,0,(lot*0.7)/2])cube([ coun*step+step+step/4,ts, lot*0.7],true);
                for (as=[0:1:coun]){
                    translate([as*step,0,0])rotate([0,45,0])cylinder(lot*2, dotv/2+ts, dotv/2+ts);
                }
            }
            for (as=[0:1:coun]){
                translate([as*step,0,0])rotate([0,45,0])translate([0,0,-dotv/2])cylinder(lot*4, dotv/2, dotv/2);
            }
        }
       translate([coun*step/2,0,lot])cube([ 2*(coun*step+step+step/4),(dk+3*ts)*2, lot*2],true); 
    }
}








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
//line();
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