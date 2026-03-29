$fn=8;




ts=2; // толщина стенки
tp=1;//диаметр жилы
tpr=1.7;//диаметр провода
trb=[2,tp,2.5];//внешний, внутренний высота
knt=[12,7.8, 7.5];//высота до центра, толщина, высота стопора
lin=[3.5,knt.x+trb.x,1.5];//ширина, длина, толщина

step=5;
kk=3;

//translate([0, 0,lin.z+knt.y/2]) cube([ts,step,knt.y],true);

//all();
module all(){
    difference(){
        union(){
            translate([-step/2+step*kk/2, trb.x/2-lin.y/2,ts+knt.y]) cube([step*kk,lin.y,ts],true);
            translate([-step/2+step*kk/2, -ts/2-knt.x,(2*ts+knt.y)/2]) cube([step*kk,ts,ts+knt.y],true);
            //translate([-step/2+step*kk/2, -ts/2-knt.z,ts+knt.y-knt.y/6]) cube([step*kk,ts,ts+knt.y/3],true);
            translate([-step/2+step*kk/2, -lin.y/2-knt.x,ts/2]) cube([step*kk,lin.y,ts],true);
            for(a=[0:1:kk-1]){
                translate([a*step, 0,0])pin();
            }
        }
        for(a=[0:1:kk-1]){
            translate([a*step, -(knt.x+3*ts/2),0])cylinder(trb.z*2,trb.y/2,trb.y/2);
        }
    }
}


all_2();
module all_2(){
    difference(){
        union(){
            for(a=[0:1:kk-1]){
                translate([0,0,a*step])pin2();
            }
            hh=step*kk;
            translate([knt.y+ts/2, 0, hh/2]) cube([ts,knt.x*2,hh],true);
            translate([knt.y/2, -ts/2, hh/2]) cube([knt.y+ts+lin.z,ts,hh],true);
        }
        for(a=[0:1:kk-1]){
            translate([0,0,a*step])pin3();
        }
        for(a=[0:1:kk-1]){
            translate([0,0,a*step])pin4();
        }
    }
}




module pin4(){
    translate([knt.x/2,-ts-0.1,step/2])cube([knt.x*2,tp,tp],true);;
}

module pin3(){
    translate([knt.y+ts,-knt.x/2-ts,step/2])cube([tpr,knt.x,tpr],true);;
}


module pin2(){
    translate([-lin.z,knt.x,step/2])rotate([0,90,0])pin();
}

module pin1(){
    translate([0,0,lin.z])rotate([0,180,0])pin();
}

module pin(){
    difference(){
        union(){
            cylinder(trb.z+lin.z,trb.x/2,trb.x/2);
            translate([0, trb.x/2-lin.y/2,lin.z/2]) cube(lin,true);
        }
        translate([0,0,-0.1])cylinder(trb.z*2,trb.y/2,trb.y/2);
        translate([0,-(trb.x/2+trb.y),-0.1])cylinder(trb.z*2,trb.y/2,trb.y/2);
    }
}





