$fn=50;
ts=1.5; //толщина стенки

<<<<<<< HEAD:печать/держатель катушки с припоем/держатель катушки1.scad
kat=[18, 65, 57+ts*2];//размер ячейкм
val=4; //толщина вала
nit=1; //диаметр припоя
fix=8; 
ddd=0.3; //поправка на погрешность печати

=======
kat=[18.5, 60, 56+ts*2];//размер ячейкм
val=4;
nit=1;
fix=8;
ddd=0.3;
//hk=kat.y*2/3;
>>>>>>> a50ebd55dc488fc43c47e5192d83e6e2d9d5b090:печать/держатель катушки с припоем/держатель катушки.scad
hk=kat.y/2+2*val+ts*2;





bas();
translate([0, kat.y+2*ts,0])fiix();
translate([0, -kat.y-2*ts,0])fiix();
translate([kat.y,0,0]) vall();

module bas(){
    intersection(){
        difference(){
            kor();
           minus(); 
           nitt();
        }
        translate([-(kat.z+10)/2,0,0])rotate([0,90,0])cylinder(kat.z+10, kat.y*2/3, kat.y*2/3);
    }
}

//kor();
module kor(){
    minkowski(){
        translate([0,0,ts/2])cube([kat.z+ts*3-val*2, kat.y+ts+val*2, ts],true);
        cylinder(0.01, val, val);
    }
    translate([(ts+kat.z/2),0,hk/2])cube([ts,kat.y,hk],true);
    translate([-(ts+kat.z/2),0,hk/2])cube([ts,kat.y,hk],true);
    translate([0,kat.y/2,hk/2])cube([(ts+kat.z/2)*2+ts, ts,hk],true);
    translate([0,-kat.y/2,hk/2])cube([(ts+kat.z/2)*2+ts, ts,hk],true);
}    
   
     
module minus(){
    translate([0,0,hk-val+0.1])cube([  kat.y*2, val, val*2],true);
}


module nitt(){
    $fn=3;
   translate([0,kat.y,kat.y/3]) scale([1,1,4])rotate([90,-30,0])cylinder(kat.y*2, nit, nit);
}



module vall(){
    lval=(ts+kat.z/2)*2-ts-2;
    translate([0,0,val/2])cube([val,lval,val],true);
    translate([0,lval/2,0])line();
    translate([0,-lval/2,0])line();
    translate([0,lval/2-fix-val/4-ts,val/2])cube([val*2,val/2,val],true);
    translate([0,-(lval/2-fix-val/4-ts),val/2])cube([val*2,val/2,val],true);
    
}
//line();
module line(){
       translate([0,ts*4,val/2])rotate([90,0,0])cylinder(ts*8, val/2-ddd/2, val/2-ddd/2);
}


module fiix(){
    difference(){
        union(){
            difference(){
                union(){
                    cylinder(ts, kat.x/2+fix, kat.x/2+fix);
                    cylinder(fix+ts, kat.x/2, kat.x/2);
                }
                translate([0,0,ts])cylinder(fix+ts, kat.x/2-ts, kat.x/2-ts);
            }
            translate([0,0,(fix+ts)/2])cube([  val+2*ts, val+2*ts, fix+ts],true);
        }
       translate([0,0,(fix+ts)/2])cube([  val+ddd, val+ddd, fix*3],true);
    }
}