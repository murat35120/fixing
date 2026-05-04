$fn=4;
ts=3;
tl=1;

//шприц
di=40;//диаметр внутри
li=136;//длина внутри
hv=9;//зазор между винтами
ugol=59;
from=0;



//ersh_n();
module ersh_n(){
   // dd=6;
    translate([0,-li/2,0]){
        //translate([0,li,pow(3,1/2)*ts/4])rotate([90,45,0])cylinder(li,ts/2,ts/2); 
        translate([0,li/2,ts/2])cube([ts,li,ts],true);
        translate([0,-3/2,ts/2])cube([2*ts,3,ts],true);
    }

}
//kit();
module kit(){

    translate([40,0,0])vint_2(-ugol, 2*ts,di*0.8);
    translate([40,15,0])vint_2(-ugol, 2*ts, di*0.85);
    translate([40,30,0])vint_2(-ugol, 2*ts, di*0.9);
    translate([40,45,0])vint_2(-ugol, 2*ts, di*0.95);
    translate([40,60,0])vint_2(-ugol, 2*ts, di*0.95);
    translate([40,75,0])vint_2(-ugol, 2*ts, di*0.95);
    translate([40,-15,0])vint_2(-ugol, 2*ts, di);
    translate([40,-30,0])vint_2(-ugol, 2*ts, di);

}
translate([40,0,0])vint_2(-ugol, 2*ts, di*0.8);
translate([40,20,0])vint_2(-ugol, 2*ts, di*0.8);
translate([40,40,0])vint_2(-ugol, 2*ts, di*0.8);
translate([40,60,0])vint_2(-ugol, 2*ts, di*0.8);
//translate([40,0,0])vint_n(45, 3*ts);
module vint_2(aa, rr, ll){ //угол, размер(ширина), сдвиг от центра, длина лопостей, старт
    asd=from*ll;
    hh=hv/2+cos(aa)*rr;
    $fn=50;
    if(from==0){
        vint_n(aa, rr, ll);
    }else{
        intersection(){
            vint_n(aa, rr, ll);
            cylinder(20,asd/2,asd/2);
        }
        intersection(){
            difference(){
                cylinder(20,ll/2,ll/2);
                translate([0,0,-1])cylinder(22,asd/2,asd/2);
            }
            vint_n(-aa, rr, ll);
        }
        intersection(){
            difference(){
                translate([0,0,0])cylinder(hh,asd/2+tl/2,asd/2+tl/2);
                translate([0,0,-1])cylinder(22,asd/2-tl/2,asd/2-tl/2);
            }
            translate([0,0,hh/2])cube([di,rr,hh],true);
        }
    }
    
}
//vint_n(-ugol, 3*ts, di);
module vint_n(aa, rr, ll){ //угол, размер(ширина),  длина лопостей
    $fn=4;
    ddd=0.2;
    hh=hv/2+cos(aa)*rr;
    sdv=rr/2-cos(aa)*rr/2;
    intersection(){
        difference(){
            union(){
                //cylinder(hh,ts,ts);
                translate([0,0,rr/2])cube([ts*2,ts*2,rr],true);
                translate([di/4,0,rr/2-sdv])rotate([aa,0,0])cube([di/2,tl,rr],true);
                translate([-(di/4),0,rr/2-sdv])rotate([-aa,0,0])cube([di/2,tl,rr],true);
            }
            //translate([0,0,-1])cylinder(2*hh,ts/2+ddd,ts/2+ddd);
            translate([0,0,rr/2-1])cube([ts+ddd,ts+ddd,rr*2],true);
        }
        union(){
            $fn=50;
            cylinder(20,ll/2,ll/2); 
        }
    }
}

prh();
module prh(){
    ddd=0.2;
    $fn=6;
    difference(){
        cylinder(15,5,5);
        cube([ts+ddd,ts+ddd,40],true);
    }
}
