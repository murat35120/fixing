$fn=30;
ts=2;


ugol=[10+0.5+1,15+0.5+1,2+0.4];//размеры уголка высота/ширина/толщина
pole=[150,80,ts];// [20,30,ts];;//размеры поля
stk=[ts,10,6*ts];//размеры стойки 
stl=[ts*3+stk.x, ts*3+stk.y, stk.z];//размеры столба

fp=[stk.x-0.2,stk.y-0.4,50];//форма прижимной пласитны 

hz=10;
hx=4.5;
dlh=10;

//translate([fp.z,0,0])test00(); //опоры уголка
//translate([fp.z+stl.y+4*ts,0,0])test00(); //опоры уголка
//test_un(); //левая прижимная пластина
//translate([0,-fp.z,0])test_un1();//правая прижимнная пластина



//un();
module un(){
    form();  
    translate([0,fp.z-hz/2-hz/2,hz/2])cube([pole.y-3*ts,ts,hz],true);    
}


module form(){
    
    difference(){
        translate([0,fp.z/2,fp.x/2])cube([pole.y-3*ts-0.5,fp.z,fp.x],true);
        //translate([0,stl.z/2-0.1,0])cube([pole.y-fp.y*2-3*ts,stl.z,fp.x*3],true);
    }
}

//test00();
module test00(){
    rotate([0,90,0])translate([-stl.x/2,0,0]){rotate([0,0,180])difference(){
            translate([0,0,(ugol.x+5*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+5*ts],true);
            translate([0,0,0])ug();
        }
        translate([0,0,ts/2])cube([ stl.x, pole.y, ts],true);
    }
}

z5rl();
translate([0,-pole.y,0])z5rR();
module z5rl(){
    z5=[26,1,2.5];
    translate([ugol.y/2+ts/2,stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([-(ugol.y/2+ts/2),stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([0,dlh,0]){
        translate([z5.x/2+ts/2,fp.z-hz/2-hz/2,(hz-ts)/2])cube([8+ts,ts,hz/2+ts],true);
        translate([z5.x/2+ts/2,fp.z-hz/2-hz/2,(hz-ts)/2])cube([ts,hz,hz/2+ts],true);
        translate([-(z5.x/2+ts/2),fp.z-hz/2-hz/2+z5.y,(hz-ts)/2])cube([8+ts,ts,hz/2+ts],true);
        translate([-(z5.x/2+ts/2),fp.z-hz/2-hz/2,(hz-ts)/2])cube([ts,hz,hz/2+ts],true);
    }
    difference(){
        translate([0,dlh,0])form();
        translate([0,(ugol.x+4*ts-ts+0.5)/2-0.1,0])cube([pole.y+fp.y*2,ugol.x+4*ts-ts+0.5,fp.x*3],true);
       // translate([0,fp.z-hz/2,hz])cube([z5.x-8,hz*2,hz*4],true);
    }
    rotate([0,0,-90])translate([-ts*2,0,stl.x/2])rotate([0,-90,0])difference(){
        translate([0,0,(ugol.x+2*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+2*ts],true);
        translate([0,0,-2*ts])ug();
        
    }
}
module z5rR(){
    z5=[26,1,2.5];
    translate([ugol.y/2+ts/2,stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([-(ugol.y/2+ts/2),stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
        translate([0,dlh,0]){
            translate([z5.x/2+ts/2,fp.z-hz/2-hz/2+z5.z,(hz-ts)/2])cube([8+ts,ts,hz/2+ts],true);
            translate([z5.x/2+ts/2,fp.z-hz/2-hz/2,(hz-ts)/2])cube([ts,hz,hz/2+ts],true);
            translate([-(z5.x/2+ts/2),fp.z-hz/2-hz/2,(hz-ts)/2])cube([8+ts,ts,hz/2+ts],true);
            translate([-(z5.x/2+ts/2),fp.z-hz/2-hz/2,(hz-ts)/2])cube([ts,hz,hz/2+ts],true);
        }
    difference(){
        translate([0,dlh,0])form();
        translate([0,(ugol.x+4*ts-ts+0.5)/2-0.1,0])cube([pole.y+fp.y*2,ugol.x+4*ts-ts+0.5,fp.x*3],true);
    }
    translate([0,0,stl.x])rotate([180,0,-90])translate([-ts*2,0,stl.x/2])rotate([0,-90,0])difference(){
        translate([0,0,(ugol.x+2*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+2*ts],true);
        translate([0,0,-2*ts])ug();
    }
}
module test_un(){
    translate([ugol.y/2+ts/2,stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([-(ugol.y/2+ts/2),stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    difference(){
        un();
        translate([0,(ugol.x+4*ts-ts+0.5)/2-0.1,0])cube([pole.y+fp.y*2,ugol.x+4*ts-ts+0.5,fp.x*3],true);
    }
    rotate([0,0,-90])translate([-ts*2,0,stl.x/2])rotate([0,-90,0])difference(){
        translate([0,0,(ugol.x+2*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+2*ts],true);
        translate([0,0,-2*ts])ug();
    }
}
module test_un1(){
    translate([ugol.y/2+ts/2,stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([-(ugol.y/2+ts/2),stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    difference(){
        un();
        translate([0,(ugol.x+4*ts-ts+0.5)/2-0.1,0])cube([pole.y+fp.y*2,ugol.x+4*ts-ts+0.5,fp.x*3],true);
    }
    translate([0,0,stl.x])rotate([180,0,-90])translate([-ts*2,0,stl.x/2])rotate([0,-90,0])difference(){
        translate([0,0,(ugol.x+2*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+2*ts],true);
        translate([0,0,-2*ts])ug();
    }
}



//ug();
module ug(){
    translate([0,ugol.y/2-ugol.z/2,ugol.x/2+ts*3])cube([pole.x*2,ts,ugol.x],true);
    translate([0,0,ugol.x/2+ts*3+ugol.x/2-ugol.z/2])cube([pole.x*2+4*ts,ugol.y,ts],true);
    translate([0,ugol.y/2-ugol.z/2-ts+0.1,ugol.x/2+ts*2+ugol.x/2-ugol.z/2+0.1])cube([pole.x*2+4*ts,ts,ts],true);
}

