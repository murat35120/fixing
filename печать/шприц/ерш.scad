$fn=50;
ts=2;
tl=0.6;

//шприц
di=60;//диаметр внутри
do=22;//диаметр снаружи
li=136;//длина внутри
duh=60;//диаметр уха 
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

hv=3;//зазор между винтами

//fix_pr ();
module fix_pr (){
    //translate([ft/2,(ph3[8][1]+fxw+fdoz)/2-fttz-fxw,f_sh/2])cube([ft, ph3[8][1]+fxw+fdoz,f_sh],true);
    //translate([(fog)/2,-ts/2-2,f_sh/2])cube([fog, ts,f_sh],true);
    translate([-ft/2,nfix/2,f_sh/2])cube([ft, nfix,f_sh],true);
    translate([0,-14.5,0])linear_extrude(f_sh)polygon([[0,0],[-ft,0],[-zbf,15],[0,14.5]]);//0.5 вынужденная поправка в связи с ошибкой во втором слое
}


//disk_z();

module disk_z(){
    translate([0,dval/2,zv/2+ze])cube([3,tn,zv],true);
    difference(){
        translate([0,0,0])cylinder(zskr,dskr/2,dskr/2);
        translate([0,0,ze-0.1])cylinder(zv+0.2,dval/2,dval/2);
        translate([0,0,-0.1+ze/2])cube([ts+0.2,ts+0.2,ze+0.2],true);
    }
}


//ersh();

module ersh(){
    translate([0,li/2-3,ts/2])cube([ts,li,ts],true);
    translate([0,0,0])vint();
    translate([0,5,0])vint();
    translate([0,10,0])vint();
    translate([0,15,0])vint();
    translate([0,20,0])vint();
    translate([0,25,0])vint();
    translate([0,30,0])vint();
    translate([0,35,0])vint();
    translate([0,40,0])vint();
    translate([0,45,0])vint();
    translate([0,50,0])vint();
    translate([0,55,0])vint();
    translate([0,60,0])vint();
    //translate([0,65,0])vint();
    //translate([0,70,0])vint();
    //translate([0,80,0])vint();
}
//vint();
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

//ersh_k();

module ersh_k(){
    dd=6;
    translate([0,(li-dd)/2-3,ts/2])cube([ts,(li-dd),ts],true);
    translate([0,0,0])vint1();
    translate([0,10,0])vint1();
    translate([0,20,0])vint1();
    translate([0,30,0])vint1();
    translate([0,40,0])vint1();
    translate([0,50,0])vint1();
    translate([0,60,0])vint1();
    //translate([0,70,0])vint();
    //translate([0,80,0])vint();
}
//cube([di,tl,3*ts],true);
//vint1();
module vint1(){
    translate([0,0,ts/2])intersection(){
        union(){
            translate([3*di/8,0,0])rotate([90,0,0])cube([di/4,tl,3*ts],true);
            translate([di/4,0,0])cube([tl,ts,3*ts],true);
            translate([-3*di/8,0,0])rotate([90,0,0])cube([di/4,tl,3*ts],true);
            translate([-di/4,0,0])cube([tl,ts,3*ts],true);
            translate([1*di/8,0,0])rotate([-ugol,0,0])cube([di/4,tl,3*ts],true);
            translate([-1*di/8,0,0])rotate([ugol,0,0])cube([di/4,tl,3*ts],true);
        }
        cube([2*di,li,ts],true); 
    }
}

ersh_n();
module ersh_n(){
    dd=6;
    translate([0,-(li-dd)/2,0]){
        translate([0,(li-dd)/2-3,ts/2])cube([ts,(li-dd),ts],true);
        translate([0,-3/2,ts/2])cube([2*ts,3,ts],true);
    }

}
kit();
module kit(){
    translate([40,-20,0])vint_n(90, 3*ts);
    translate([40,-10,0])vint_n(0, 3*ts);
    translate([40,0,0])vint_n(-55, 3*ts);
    translate([40,10,0])vint_n(55, 3*ts);
    translate([40,20,0])vint_n(-45, 3*ts);
    translate([40,30,0])vint_n(45, 3*ts);
    translate([40,40,0])vint_n(-45, 3*ts);
    translate([40,50,0])vint_n(45, 3*ts);
    translate([40,-30,0])vint_n(-45, 3*ts);
    translate([40,-40,0])vint_n(45, 3*ts);
    translate([40,-50,0])vint_n(-45, 3*ts);
    translate([40,-60,0])vint_n(45, 3*ts);
}

module vint_n(aa, rr){ //угол, размер(ширина), сдвиг от центра
    ddd=0.2;
    hh=hv/2+cos(aa)*rr;
    sdv=rr/2-cos(aa)*rr/2;
    intersection(){
        union(){
            translate([0,0,hh/2])difference(){
                cube([2*ts,2*ts,hh],true);
                cube([ts+ddd,ts+ddd,2*hh],true);
            }
            translate([di/4+ts,0,rr/2-sdv])rotate([aa,0,0])cube([di/2,tl,rr],true);
            translate([-(di/4+ts),0,rr/2-sdv])rotate([-aa,0,0])cube([di/2,tl,rr],true);
        }
        cylinder(20,di/2,di/2); 
    }
}

