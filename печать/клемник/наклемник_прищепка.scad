$fn=8;

ts=2.5; // толщина стенки
tp=1;//диаметр жилы
tpr=1.7;//диаметр провода
trb=[2,tp,2.5];//внешний, внутренний высота
knt=[20,11, 7.5, 7.8];//высота до центра, толщина, высота стопора
lin=[3.5,knt.x+trb.x,1.3];//ширина, длина, толщина
dkn=2.5;//длина контактной площадки
shp=4.0;//высота шипа
do=3.8;
step=5;//шаг контактов
kk=4;//количество контактов
//прищепка
prk=[8,10,1.5,24,10];//диаметр опоры, ширина,диаметр проволоки, длина плеча,высота половины


alll();
module alll(){
    difference(){
        union(){
            prih();
            translate([0, -step*(kk-1)/2, 0]) {
                for(a=[0:1:kk-1]){
                    translate([0,a*step,0]){
                        translate([lin.y+prk[3],0,0])rotate([0,0,-90])pin_lin();
                        translate([prk[3],0,knt[3]/2])cube([ts,step+1,knt[3]],true);
                        translate([prk[3]-knt[3]/2,0,ts/2])cube([knt[3],step+1,ts],true);
                    }
                }
            }
        }
        for(a=[0:1:kk-1]){
            translate([0,a*step,0]){
                translate([prk[3]-ts,-step*(kk-1)/2,ts])cube([tp,tp,ts*13],true);
                translate([prk[3]-ts-knt[3]/2,-step*(kk-1)/2,ts-tpr/2+0.1])cube([knt[3],tpr,tpr],true);
            }
        }
        translate([prk[3]-ts,0,knt[3]+ts*3/2])cube([ts,prk.y*2,ts*3],true);
        translate([-prk[3]*2+prk[3]-ts/2,0,0]){
            translate([0,step+0.1,tpr/2+prk[4]/3])cube([prk[3]*4,tpr,tpr],true);
            translate([0,step+0.1,tpr/2+2*prk[4]/3])cube([prk[3]*4,tpr,tpr],true);
            translate([0,-step+0.1,tpr/2+prk[4]/3])cube([prk[3]*4,tpr,tpr],true);
            translate([0,-step+0.1,tpr/2+2*prk[4]/3])cube([prk[3]*4,tpr,tpr],true);
        }
        
    }
}


module prih(){
    $fn=50;
    difference(){
        union(){
            translate([0, 0, (prk[4]+prk[0]/2)])rotate([180,0,0])difference(){
                translate([0, 0, (prk[4]+prk[0]/2)/2]) cube([prk[3]*2,prk[1],prk[4]+prk[0]/2],true);
                translate([0, -prk[1]/2-0.5,0])rotate([-90,0,0])cylinder(prk[1]+1,prk[0]/2,prk[0]/2);
                rotate([0,-45,0])translate([prk[3]-prk[0]/2-prk[2]/2, -prk[1]/2-0.5,0])rotate([-90,0,0])cylinder(prk[1]+1,prk[2]/1.3,prk[2]/1.3);
                rotate([0,-12,0])translate([0, 0, -(prk[4]+prk[0]/2)/2]) cube([prk[3]*4,prk[1]*2,prk[4]+prk[0]/2],true);
                rotate([0,10,0])translate([0, 0, -(prk[4]+prk[0]/2)/2]) cube([prk[3]*4,prk[1]*2,prk[4]+prk[0]/2],true);
            }
            difference(){
                translate([prk[3]-prk[1], -2*ts/2, prk[4]]) cube([prk[1]-2,ts,prk[4]*1.4],true);
                translate([prk[3]-prk[1]-(prk[1]-2), -2*ts/2, prk[4]]) rotate([0,5,0])cube([prk[1]-2,ts*2,prk[4]*2],true);
            }
        }
        translate([(prk[3]-prk[1]), 2*ts/2, prk[4]]) cube([prk[1]+1,ts+0.5,prk[4]*1.4],true);
    }
    
}

//all_2();
module all_2(){
    difference(){
        union(){
            for(a=[0:1:kk-1]){
                translate([0,0,a*step])pin2();
            }
            for(a=[0:1:kk-1]){
                translate([knt[3]/2,0,a*step+step/2])ship();
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

module ship(){
    intersection(){
        rotate([-90,0,0])cylinder(shp,do/2,do/2);
        cube([ts,do*4,8],true);
    }
}


module pin4(){
    translate([knt.x/2,-ts-0.1,step/2])cube([knt.x*2,tp,tp],true);;
}

module pin3(){
    translate([knt.y+ts,-knt.x/2-ts,step/2])cube([tpr,knt.x,tpr],true);;
}


module pin2(){
    //translate([-lin.z,knt.x,step/2])rotate([0,90,0])pin();
    translate([-lin.z,knt.x,step/2])rotate([0,90,0])pin_lin();
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
        translate([0, 0,trb.z+lin.z+trb.x/4]) rotate([-45,0,0])cube([trb.x*2,trb.x*2,trb.x/2],true);
    }
}

//pin_lin();
module pin_lin(){
    difference(){
        union(){
            //cylinder(trb.z+lin.z,trb.x/2,trb.x/2);
            translate([0, -trb.z/2+trb.y,(trb.z+lin.z)/2]) cube([lin.x,dkn,trb.z+lin.z],true);
            translate([0, trb.x/2-lin.y/2-0.5,lin.z/2]) cube(lin,true);
        }
        //translate([0,-0.25,-0.1])cylinder(trb.z*2,trb.y/2,trb.y/2);
        translate([0,-0.25,trb.z-0.1])cube([trb.y,trb.y,trb.z*2],true);
        translate([0,-trb.z+0.25,trb.z-0.1])cube([trb.y,trb.y,trb.z*2],true);
        translate([0, 0,trb.z+lin.z+trb.x/4]) rotate([-45,0,0])cube([trb.x*2,trb.x*3,trb.x/2],true);
    }
}
module pin_s(){
    difference(){
        union(){
            cylinder(trb.z+lin.z-trb.x/2,trb.x/2,trb.x/2);
            translate([0, 0,trb.z+lin.z-trb.x/2])sphere(r=trb.x/2);
            translate([0, trb.x/2-lin.y/2,lin.z/2]) cube(lin,true);
        }
        translate([0,0,-0.1])cylinder(trb.z*2,trb.y/2,trb.y/2);
        translate([0,-(trb.x/2+trb.y),-0.1])cylinder(trb.z*2,trb.y/2,trb.y/2);
    }
}




