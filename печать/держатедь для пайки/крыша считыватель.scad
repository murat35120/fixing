$fn=30;
ts=2;


ugol=[10+0.5+1,15+0.5+1,2+0.4];//размеры уголка высота/ширина/толщина
pole=[80,80,ts];// [20,30,ts];;//размеры поля
stk=[ts,10,6*ts];//размеры стойки 
stl=[ts*3+stk.x, ts*3+stk.y, stk.z];//размеры столба

fp=[stk.x-0.2,stk.y-0.4,50];//форма прижимной пласитны 

hz=10;
hx=4.5;
dlh=10;

plt=42;
step=5;
pin=[9, step*7+1.5, 12];
botr=9+ts;
prk=[20,15,pin.z*3];

all();
module all(){
    difference(){
        union(){
            translate([0,0,ts/2])cube(pole,true);
            translate([plt/2-pin.x+ts/2+0.1,0,botr/2])cube([pin.x+ts,pin.y-ts,botr],true);
            translate([pole.x/2,0,3*ts/2])cube([3*ts,pole.y, 3*ts],true);
            translate([-pole.x/2,0,3*ts/2])cube([3*ts,pole.y, 3*ts],true);
            translate([plt/2-pin.x-pin.x/2-step/2+0.1,-(-step+ts/2),botr/2])cube([step, ts,botr],true);
            translate([plt/2-pin.x-pin.x/2-step/2+0.1,-step*3,botr/2])cube([step, ts,botr],true);
            translate([plt/2-pin.x-pin.x/2-step*3,-step*3,botr/2])cube([step, ts,botr],true);
            translate([plt/2-pin.x-pin.x/2-step*3,2.5*step,botr/2])cube([step, ts,botr],true);
        }
        translate([pole.x/2,0,3*ts/2])cube([stl.x*2+ts,ts+0.6, 4*ts],true);
        translate([-pole.x/2,0,3*ts/2])cube([stl.x*2+ts,ts+0.6, 4*ts],true);
        translate([pole.x/2,0,ts-0.1])cube([ts+0.6,pole.y+ts, ts*2],true);
        translate([-pole.x/2,0,ts-0.1])cube([ts+0.6,pole.y+ts, ts*2],true);
        translate([plt/2-pin.x,0,ts+pin.z/2])cube(pin,true);
        translate([plt/2-pin.x,2.5*step,0])cube(prk,true);//отверстие для прищепки
    }
    translate([plt/2-pin.x,-pin.y/2-step/2+step/4,botr/2])cube([ts,step/2, botr],true);
    translate([plt/2-pin.x,pin.y/2+step/2,botr/2])cube([ts,step, botr],true);
}

//test00();
module test00(){
    rotate([0,90,0])translate([-stl.x/2,0,0]){rotate([0,0,180])difference(){
            translate([0,0,(fp.z+5*ts)/2])cube([ stl.x,ugol.y+2*ts, fp.z+5*ts],true);
            translate([0,0,(fp.z-5*ts)])ug();
        }
        translate([0,0,ts])cube([ stl.x, pole.y, ts*2],true);
    }
}



//ug();
module ug(){
    translate([0,ugol.y/2-ugol.z/2,ugol.x/2+ts*3])cube([pole.x*2,ts,ugol.x],true);
    translate([0,0,ugol.x/2+ts*3+ugol.x/2-ugol.z/2])cube([pole.x*2+4*ts,ugol.y,ts],true);
    translate([0,ugol.y/2-ugol.z/2-ts+0.1,ugol.x/2+ts*2+ugol.x/2-ugol.z/2+0.1])cube([pole.x*2+4*ts,ts,ts],true);
}

