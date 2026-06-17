$fn=50;
ts=2;
tl=0.6;

//шприц
di=20-1.5;//диаметр внутри
do=22;//диаметр снаружи
li=82;//длина внутри
duh=35;//диаметр уха 
huh=2.6;//толщина уха
dno=4.4;//диаметр носика у основания, у конца на % меньше
hno=10;//длина носика
ugol=30;

tn=1;//толщина среза вала
zv=5; //высота центрального диска вала
ze=5; //высота центрального диска ерша
zskr=zv+ze;
dskr=10;//диаметр центрального диска
dval=3+0.4;//диаметр вала привода

f_sh=4.0; //ширина фиксатора
ft=1.5; //основная толщина фиксатора
zbf=2.5+ft;//зуб фиксатора
nfix=10;//нога фиксатора




translate([20,0,0]) disk_z();
ersh();



module disk_z(){
    translate([0,dval/2,zv/2+ze])cube([3,tn,zv],true);
    difference(){
        translate([0,0,0])cylinder(zskr,dskr/2,dskr/2);
        translate([0,0,ze-0.1])cylinder(zv+0.2,dval/2,dval/2);
        translate([0,0,-0.1+ze/2])cube([ts+0.2,ts+0.2,ze+0.2],true);
    }
}




module ersh(){
    ddd=6;
    translate([0,(li-ddd)/2-3,ts/2])cube([ts,li-ddd,ts],true);
    translate([0,0,0])vint();
    translate([0,10,0])vint();
    translate([0,20,0])vint();
    translate([0,30,0])vint();
    translate([0,40,0])vint();
    translate([0,50,0])vint();
    translate([0,60,0])vint();
    //translate([0,70,0])vint();
    //translate([0,80,0])vint();
}

module vint(){
    translate([0,0,ts/2])intersection(){
        union(){
            translate([5*di/12,0,0])rotate([ugol,0,0])cube([di/6,tl,3*ts],true);
            translate([4*di/12,0,0])cube([tl,ts,3*ts],true);
            translate([-5*di/12,0,0])rotate([-ugol,0,0])cube([di/6,tl,3*ts],true);
            translate([-4*di/12,0,0])cube([tl,ts,3*ts],true);
            translate([2*di/12,0,0])rotate([-ugol,0,0])cube([di/3,tl,3*ts],true);
            translate([-2*di/12,0,0])rotate([ugol,0,0])cube([di/3,tl,3*ts],true);
        }
        cube([2*di,li,ts],true); 
    }
}


