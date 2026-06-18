$fn=30;
ts=2;


ugol=[10+0.5+1,15+0.5+1,2+0.4];//размеры уголка высота/ширина/толщина
pole=[80,80,ts];// [20,30,ts];;//размеры поля
stk=[ts,10,6*ts];//размеры стойки 
stl=[ts*3+stk.x, ts*3+stk.y, stk.z];//размеры столба

fp=[stk.x-0.2,stk.y-0.4,ugol.y];//форма прижимной пласитны 

hz=10;
hx=4.5;
dlh=10;
hh=100;


test01();
translate([0,pole.y+ts*3,0])test00();

//translate([0,0,ts/2])cube(pole,true);

module test00(){
    rotate([0,90,0])translate([-stl.x/2,0,0]){
        rotate([0,0,180])difference(){
            union(){
                translate([0,0,(fp.z+5*ts)/2])cube([ stl.x,ugol.y+2*ts, fp.z+5*ts],true);
                translate([ts/2-stl.x/2,0,hh/2])cube([ ts,pole.y, hh],true);
                translate([stl.x/2-stl.x/2,0,-stl.x/2+hh])cube([ stl.x,ts, stl.x],true);
            }
            translate([0,0,(fp.z-5*ts)])ug();
        }
        translate([0,0,ts])cube([ stl.x, pole.y, ts*2],true);
    }
}


module test01(){
    rotate([0,90,0])translate([-stl.x/2,0,0]){
        rotate([0,0,180])difference(){
            union(){
                translate([0,0,(fp.z+5*ts)/2])cube([ stl.x,ugol.y+2*ts, fp.z+5*ts],true);
                translate([ts/2-stl.x/2,0,hh/2])cube([ ts,pole.y, hh],true);
                translate([stl.x/2-stl.x/2,0,-stl.x/2+hh])cube([ stl.x,ts, stl.x],true);
            }
            translate([0,0,(fp.z-5*ts)])rotate([0,0,180])ug();
        }
        translate([0,0,ts])cube([ stl.x, pole.y, ts*2],true);
    }
}



module ug(){
    translate([0,ugol.y/2-ugol.z/2,ugol.x/2+ts*3])cube([pole.x*2,ts,ugol.x],true);
    translate([0,0,ugol.x/2+ts*3+ugol.x/2-ugol.z/2])cube([pole.x*2+4*ts,ugol.y,ts],true);
    translate([0,ugol.y/2-ugol.z/2-ts+0.1,ugol.x/2+ts*2+ugol.x/2-ugol.z/2+0.1])cube([pole.x*2+4*ts,ts,ts],true);
}

