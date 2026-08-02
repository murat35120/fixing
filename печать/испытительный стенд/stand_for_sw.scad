 //body();


ts=1.5;//толщина стенки
plx=58; //рамер платы по x
ply=39; //рамер платы по y
plz=5.5;//рамер платы по z
bx=125;//рамер корпуса по x
by=135;//рамер корпуса по y
rotv=1.5;//радиус отвверстия для крепления корпуса
dbt=23;//диаметр батарейного отсека 23
cbty=2.5;//центр батарейного отсека от края  по y 2,5
cbtx=12.5;//центр батарейного отсека от края по x 22,5
sts=8;//ширина стоек фиксации
pdz=ts;//толщина подкладки
bandz=plz+ts+pdz;//высота ленты
ugol=8;//

gx=58.2;// размер платы конвертера по x
gy=37.5;//размер платы конвертера по y
gz=14.3;//размер платы конвертера по z
g5=10;// площадка без деталей
gpl=2;// толщина платы конвертера
gplz=4;//толщина платы конвертера сверху

basex=58.5;//58.2 размер z-2 Base по x
basegz=7;//высота зеленого разъема z-2 Base
baselz=4.3;//высота текстолита z-2 Base
usbz=11.3;//11 
usby=12.5;//12.2
usbtx=35.2;//растояние от края платы до дальней части разъема usb

wgc=12;// толщина контакта по центру
wgz=33;//высота стоек фиксации wago
wgy=4;//ширина стоек фиксации wago
wgz2=14.3;//разница высот между 8 и 2
wgr=7;//радиус вокруг уха с отверстием
wgt=1;//толщина стенки цилиндра опоры ваго

kly=20;//размер клеммы по y
klx=17.4;//размер клеммы по x
klz=8;//размер клеммы по z
klc=5;//ширина центральной части клеммы
klw=3.3;//размер щели между контактами

scbz=1.5;//просвет под скобой для фиксации кабеля
scbx=3.5;//длина внутренней части скобы для фиксации кабеля
scby=3.5;//ширина стойки скобы

stz=bandz;//высота стоек фиксации
sppx=6;//ширина пропила в плате
gppy=2;//глубина пропила в плате
//pdz=1;//высота подложки
rbo=12;//радиус батарейного отсека

conx=45;//рамер разъема по x
cony=7.6;//рамер разъема по y
conz=10;//рамер разъема по z
bandx=cony+rotv+ts;//длина боковой части ленты
echo(bandx);
echo(2*(plx/2+rotv+ts));
$fn = 100;

dsh=6+0.5;
dsh2=2;
dsd1=16.3+0.5;
dsd2=17.3+0.5;
rdsz=dsd2+ts;
rdsx=dsd2+2*ts;
rdsy=dsh+2*ts;
dpr=1.3;


body2();
module body2(){
    union(){
        translate ([0,0,ts/2])cube([bx,by,ts], true);
        translate ([0,-2*20,ts/2])squar ();
        translate ([0,-1*20,ts/2])squar ();
        translate ([0,0*20,ts/2])squar ();
        translate ([0,1*20,ts/2])guard (); 
        translate ([0,2*20,ts/2])guard ();
        
        translate ([bx/2-10,5.15*2,ts]) rotate([0,0,90]) klm();  
        translate ([bx/2-10,1*5.15*4+5.15*2,ts]) rotate([0,0,90]) klm(); 
        translate ([bx/2-10,2*5.15*4+5.15*2,ts]) rotate([0,0,90]) klm();
        translate ([bx/2-10,-5.15*2,ts]) rotate([0,0,90]) klm();  
        translate ([bx/2-10,-(1*5.15*4+5.15*2),ts]) rotate([0,0,90]) klm(); 
        translate ([bx/2-10,-(2*5.15*4+5.15*2),ts]) rotate([0,0,90]) klm();
        //translate ([-bx/2+10,1*5.15*4+5.15*2,ts]) rotate([0,0,90]) klm(); 
        translate ([-bx/2+10,by/2-17,ts]) rotate([0,0,90]) klm();
        
        translate ([bx/2-27,10,ts/2])rotate([0,0,90])scoba();
        translate ([bx/2-27,-10,ts/2])rotate([0,0,90])scoba();
        translate ([bx/2-27,-10-20,ts/2])rotate([0,0,90])scoba();
        translate ([-20,by/2-5,ts/2])scoba();
        translate ([20,by/2-5,ts/2])scoba();
        translate ([-20,-by/2+5,ts/2])scoba();
        translate ([20,-by/2+5,ts/2])scoba();
        translate ([-bx/2+10,by/2-17-35,ts/2])scoba();
        translate ([-bx/2+10,by/2-17-20,ts/2])scoba();
       
        translate ([-bx/2+15,-2*20,0])ds();
        translate ([-bx/2+15,-1*20,0])ds();
        translate ([-bx/2+15,0*20,0])ds();
    }
}

//plata ();
module plata (){
    union(){
        translate ([0,(-ply+cony)/2,conz/2+plz])cube([conx,cony,conz], true);
        difference(){
            translate ([0,0,plz/2])cube([plx,ply,plz], true);
            translate ([0,ply/2-1,plz/2])cube([6.2,2.1,4.5], true);
        }
    }
}



module sector(){
translate ([6+ts/2,0,0]) rotate([90,0,180]) rotate_extrude(angle=90, convexity=10) translate ([6+ts/2,0,sts/2])square([ts,sts],true);
}


//squar ();
module squar (){
    union(){

            translate ([(plx-g5)/2,-(plz+conz+ts)/2,sts/2])cube([g5,ts,sts], true);
            translate ([-(plx-g5)/2,-(plz+conz+ts)/2,sts/2])cube([g5,ts,sts], true);
            translate ([(plx-g5)/2,+(plz+conz+ts)/2,sts/2])cube([g5,ts,sts], true);
            translate ([(plx+2*ts)/2,+(plz+conz+2*ts)/2,sts])triangle();
            translate ([(plx+ts)/2,0,sts/2])cube([ts,plz+conz+2*ts,sts], true);
            translate ([-(plx+ts)/2,-((plz+conz-sts)/2-plz),20/2]){
                translate ([-ts,0,-5])cube([ts,sts,10], true);
                cube([ts,sts,20], true);
                translate ([0,0,10]) sector();
            }
    }     
}

module triangle(){
translate ([0,0,ts/2]) linear_extrude(height = ts, center = true, convexity = 10, twist = 0)polygon(points=[[0,0],[-ugol,0],[0,-ugol]]);
}
//guard ();
module guard (){
    rotate([0,0,180])union(){
        translate ([(gx-g5)/2,(gpl+ts)/2,sts/2])cube([g5,ts,sts], true);
        translate ([(gx-g5)/2,-(gpl+ts)/2,sts/2])cube([g5,ts,sts], true);
        translate ([(gx+ts)/2,0,sts/2])cube([ts,gpl+2*ts,sts], true);
        translate ([-(gx+ts)/2,0,(gy+2*ts)/2]){
            cube([ts,gplz+2*ts,gy+2*ts], true);
            translate ([-ts,0,-gy/4-ts])cube([ts,gplz+2*ts,gy/2], true);
            translate ([0,(gplz+ts)/2,gy/2-g5]) cht();
            translate ([0,-(gplz+ts)/2,gy/2-g5]) cht();
            translate ([(g5)/2,0,(gy+ts)/2])cube([g5,gplz+2*ts,ts], true);
        }
        
    }     
}
//z2base ();
module z2base (){
    rotate([0,0,180]) union(){
        translate ([-(basex-g5)/2,usby/2+baselz+ts/2,sts/2])cube([g5,ts,sts], true);
        translate ([-(basex-g5)/2,usby/2-basegz-ts/2,sts/2])cube([g5,ts,sts], true);
        translate ([-(basex+ts)/2,usby/2-basegz-ts/2+(baselz+basegz+ts)/2,sts/2])cube([ts,baselz+basegz+2*ts,sts], true);
        //translate ([(basex)/2,0,usbtx/2])cube([ts,ts,usbtx], true);
        translate ([(basex+ts)/2,0,(usbtx+sts)/2])difference(){
                union(){
                    cube([ts,2*usbz,usbtx+sts], true);
                    translate ([ts,0,-(usbtx+sts)*2/6])cube([ts,2*usbz,(usbtx+sts)/3], true);
                }
                translate ([0,0,-(usbtx+sts)/2+usbtx-usby/2])cube([2*ts,usbz,usby], true);
            }

        
    }     
}


//cht ();
module cht (){
    translate ([0,0,g5]) rotate([0,90,-90])intersection(){
        cylinder(ts,g5,g5, true);
        translate ([0,0,-ts])cube([2*g5,2*g5,2*ts]);
    }
}

//wago();
module wago(){
    translate ([0,(wgc+wgy)/2,(wgz+ts)/2])cube([ts,wgy,wgz+ts], true);
    translate ([0,(wgc+wgy)/2,(wgz+ts)/2])cube([2*sts,ts,wgz+ts], true);
    translate ([0,-(wgc+wgy)/2,(wgz+ts)/2])cube([ts,wgy,wgz+ts], true);
    translate ([0,-(wgc+wgy)/2,(wgz+ts)/2])cube([sts,ts,wgz+ts], true);    
}
//wago1();
module wago1(){
    union(){
        translate ([-ts/2,0,wgz2/2])difference(){
            translate ([0,0,0])cylinder(wgz2,wgr+wgt,wgr+wgt,true);
            translate ([0,0,0])cylinder(wgz2+0.1,wgr,wgr,true);
            translate ([2*wgr,0,0])cube([4*wgr,4*wgr,4*wgz2],true);
        }
        translate ([0,(wgc+wgy)/2,(wgz+ts)/2])cube([2*ts,wgy,wgz+ts], true);
        translate ([0,-(wgc+wgy)/2,(wgz+ts)/2])cube([2*ts,wgy,wgz+ts], true);
        echo("wago x ");
        echo(wgc+wgy);
    }
}





//scoba();
module scoba(){
    translate ([(scbx+scby)/2,0,(scbz+ts)/2])cube([scby,ts,scbz+ts], true);
    translate ([-(scbx+scby)/2,0,(scbz+ts)/2])cube([scby,ts,scbz+ts], true);
    translate ([0,0,scbz+2*ts])cube([scby*2+scbx,ts,2*ts], true);
    //translate ([0,0,(scbz+ts)/2])cube([scbz,2*ts,ts+scbz], true);
}


module reader(){
    rotate([0,-90,0])difference(){
        union(){
            translate ([24,0,0])cylinder(ts,18,18,true);
            translate ([12,0,0])cube([24,36,ts], true);
        }
        translate ([24,0,0])cylinder(2*ts,10,10,true);
    }

}
module klm(){
        union(){
            translate ([0,(kly-klc)/4+klc/2,klz/2])kwo();
            translate ([0,-(kly-klc)/4-klc/2,klz/2])kwo();
        }
} 
module klm2(){
        union(){
            translate ([5.15,(kly-klc)/4+klc/2,klz/2])kwo();
            translate ([5.15,-(kly-klc)/4-klc/2,klz/2])kwo();
            translate ([-5.15,(kly-klc)/4+klc/2,klz/2])kwo();
            translate ([-5.15,-(kly-klc)/4-klc/2,klz/2])kwo();
        }
}
module kwo(){
        difference(){
            cube([klw,(kly-klc)/2,klz], true);
            cube([klw-2,(kly-klc)/2-2,klz+0.1], true);
        }
}
//kwo();
module klmo2(){
        union(){
            translate ([5.15,0,-ts/2])cylinder(ts+0.1,1.75+ts,1.75,true);
            translate ([-5.15,0,-ts/2])cylinder(ts+0.1,1.75+ts,1.75,true);
        }
}
//klm2();
//klmo2();

module ds(){
    difference(){
        translate ([0,0,rdsz/2])cube([rdsx,rdsy,rdsz], true);
        translate ([0,0,-rdsz])cube([dsd1,dsh,rdsz*5], true);
        translate ([0,dsh2/2-dsh/2,-rdsz])cube([dsd2,dsh2,rdsz*5], true);
        translate ([0,-dsh/2,-rdsz])cube([dsd1-4*ts,dsh,rdsz*5], true);
        translate ([0,0,rdsz-ts-dpr/2])rotate([0,90,0])cylinder(rdsz*5,dpr/2,dpr/2,true);
        translate ([0,0,2*ts-dpr/2])rotate([0,90,0])cylinder(rdsz*5,dpr/2,dpr/2,true);
        translate ([0,0,4*ts-dpr/2])rotate([0,90,0])cylinder(rdsz*5,dpr/2,dpr/2,true);
        translate ([-dpr/2,0,3*rdsz/4-dpr/2+ts])rotate([90,0,0])cylinder(rdsz*5,dpr/2,dpr/2,true);
        translate ([-dpr/2,0,1*rdsz/4-dpr/2+ts])rotate([90,0,0])cylinder(rdsz*5,dpr/2,dpr/2,true);
        translate ([dpr/2,0,2*rdsz/4-dpr/2+ts])rotate([90,0,0])cylinder(rdsz*5,dpr/2,dpr/2,true);
    }
}