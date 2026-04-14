$fn=30;
ts=2;


ugol=[10+0.5,15+0.5,2+0.4];//размеры уголка высота/ширина/толщина
pole=[150,80,ts];// [20,30,ts];;//размеры поля
stk=[ts,10,6*ts];//размеры стойки 
stl=[ts*3+stk.x, ts*3+stk.y, stk.z];//размеры столба
z5r=45;//
z5r_net=[59,40];//

fp=[stk.x-0.2,stk.y-0.4,50];//форма прижимной пласитны 

hz=10;
hx=4.5;

//test01();
test00();


//all();
//translate([0,0,5*ts])rotate([0,0,90])
//list1();
//test();
//test1();
//test_net();
//test_un1();

module list1(){
    difference(){
        list();
        translate([0,(stl.z+2*ts)/2-0.1,0])cube([ugol.y+2*ts,stl.z+2*ts,fp.x*3],true);
    }
}


module list(){
    form();
    translate([0,fp.z-hz/2-ts,hz/2])cube([hx,hz,hz],true);
}

//form();
//un();
module un(){
    form();
    //translate([z5r_net.y/2+ts/2,fp.z-hz/2-ts,hz/2])cube([ts,hz,hz],true);  
    translate([0,fp.z-hz/2-hz/2,hz/2])cube([pole.y-3*ts,ts,hz],true); 
    //translate([-(z5r_net.y/2+ts/2),fp.z-hz/2-ts,hz/2])cube([ts,hz,hz],true);
    //translate([-(z5r_net.y/2+ts/2),fp.z-hz/2-hz/2,hz/2])cube([hz,ts,hz],true);   
}


module net(){
    form();
    translate([z5r_net.y/2+ts/2,fp.z-hz/2-ts,hz/2])cube([ts,hz,hz],true);  
    translate([z5r_net.y/2+ts/2,fp.z-hz-ts-ts/2,hz/2])cube([hz,ts,hz],true); 
    translate([-(z5r_net.y/2+ts/2),fp.z-hz/2-ts,hz/2])cube([ts,hz,hz],true);
    translate([-(z5r_net.y/2+ts/2),fp.z-hz-ts-ts/2,hz/2])cube([hz,ts,hz],true);   
}
//net1();
module net1(){
    form();
    translate([8,fp.z-hz/4-ts,hz/2])cube([ts,hz/2,hz],true);  
    //translate([z5r_net.y/2+ts/2,fp.z-hz/2-hz/2,hz/2])cube([hz,ts,hz],true); 
    translate([-(z5r_net.y/4),fp.z-hz/2-ts,hz/2])cube([ts,hz,hz],true);
    //translate([-(z5r_net.y/2+ts/2),fp.z-hz/2-hz/2,hz/2])cube([hz,ts,hz],true);   
}
//form();
module form(){
    
    difference(){
        translate([0,fp.z/2,fp.x/2])cube([pole.y-3*ts-0.5,fp.z,fp.x],true);
        translate([0,stl.z/2-0.1,0])cube([pole.y-fp.y*2-3*ts,stl.z,fp.x*3],true);
    }
}



module test1(){
    translate([ugol.y/2+ts/2,stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([-(ugol.y/2+ts/2),stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    difference(){
        list();
        translate([0,(ugol.x+4*ts-ts+0.5)/2-0.1,0])cube([pole.y+fp.y*2,ugol.x+4*ts-ts+0.5,fp.x*3],true);
    }
    translate([0,0,stl.x])rotate([180,0,-90])translate([-ts*2,0,stl.x/2])rotate([0,-90,0])difference(){
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

module test(){
    translate([ugol.y/2+ts/2,stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([-(ugol.y/2+ts/2),stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    difference(){
        list();
        translate([0,(ugol.x+4*ts-ts+0.5)/2-0.1,0])cube([pole.y+fp.y*2,ugol.x+4*ts-ts+0.5,fp.x*3],true);
    }
    rotate([0,0,-90])translate([-ts*2,0,stl.x/2])rotate([0,-90,0])difference(){
        translate([0,0,(ugol.x+2*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+2*ts],true);
        translate([0,0,-2*ts])ug();
    }
}
//test00();

module test00(){
    rotate([0,90,0])translate([-stl.x/2,0,0]){rotate([0,0,180])difference(){
            translate([0,0,(ugol.x+5*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+5*ts],true);
            translate([0,0,0])ug();
        }
        translate([-1*stl.x/2,0,ts/2])cube([ stl.x*2, pole.y, ts],true);
    }
}


module test01(){
    rotate([0,90,0])translate([-stl.x/2,0,0]){difference(){
            translate([0,0,(ugol.x+5*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+5*ts],true);
            translate([0,0,0])ug();
        }
        translate([-1*stl.x/2,0,ts/2])cube([ stl.x*2, pole.y, ts],true);
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

module test_net1(){
    translate([ugol.y/2+ts/2,stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([-(ugol.y/2+ts/2),stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    difference(){
        net1();
        translate([0,(ugol.x+4*ts-ts+0.5)/2-0.1,0])cube([pole.y+fp.y*2,ugol.x+4*ts-ts+0.5,fp.x*3],true);
    }
    translate([0,0,stl.x])rotate([180,0,-90])translate([-ts*2,0,stl.x/2])rotate([0,-90,0])difference(){
        translate([0,0,(ugol.x+2*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+2*ts],true);
        translate([0,0,-2*ts])ug();
    }
}
module test_net(){
    translate([ugol.y/2+ts/2,stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    translate([-(ugol.y/2+ts/2),stl.x/2+ugol.x+4*ts,stl.x/2])cube([ ts,stl.x, stl.x],true);
    difference(){
        net();
        translate([0,(ugol.x+4*ts-ts+0.5)/2-0.1,0])cube([pole.y+fp.y*2,ugol.x+4*ts-ts+0.5,fp.x*3],true);
    }
    rotate([0,0,-90])translate([-ts*2,0,stl.x/2])rotate([0,-90,0])difference(){
        translate([0,0,(ugol.x+2*ts)/2])cube([ stl.x,ugol.y+2*ts, ugol.x+2*ts],true);
        translate([0,0,-2*ts])ug();
    }
}



module all(){
    difference(){
        plf();
        ug();
    }
}

module plf(){
    translate([0,0,pole.z/2])cube(pole,true);
    translate([pole.x/2-ugol.y/2,0,(ugol.x+4*ts)/2])cube([ ugol.y,ugol.y+2*ts, ugol.x+4*ts],true);
    translate([-(pole.x/2-ugol.y/2),0,(ugol.x+4*ts)/2])cube([ ugol.y,ugol.y+2*ts, ugol.x+4*ts],true);
    //translate([pole.x/4,0,0])stolb();
    //translate([pole.x/4-z5r-ts,0,0])stolb();
    //translate([pole.x/4-z5r_net-ts,0,0])stolb();
}

module stolb(){
    difference(){
        union(){
            translate([0,pole.y/2-stl.y/2,stl.z/2])cube(stl,true);
            translate([0,-(pole.y/2-stl.y/2),stl.z/2])cube(stl,true); 
        }
            translate([0,pole.y/2-stl.y/2,stl.z/2+ts])cube(stk,true);
            translate([0,-(pole.y/2-stl.y/2),stl.z/2+ts])cube(stk,true); 
    }
}


module ug(){
    translate([0,ugol.y/2-ugol.z/2,ugol.x/2+ts*3])cube([pole.x*2,ts,ugol.x],true);
    translate([0,0,ugol.x/2+ts*3+ugol.x/2-ugol.z/2])cube([pole.x*2+4*ts,ugol.y,ts],true);
    translate([0,ugol.y/2-ugol.z/2-ts+0.1,ugol.x/2+ts*2+ugol.x/2-ugol.z/2+0.1])cube([pole.x*2+4*ts,ts,ts],true);
}

