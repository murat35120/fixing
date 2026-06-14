$fn=50;
ts=1.5;

lenta=[10+0.5,60,3];//размер ячейкм
ddd=0.25;
gzd=[1.5+ddd,2.5+ddd];
hv=20;
hr=ts*2+lenta.z;
ln=15;

difference(){
    hull(){
        translate([0,0,hr/2])cube([lenta.x+ts*2, lenta.y+hv, hr],true);
        translate([0,(lenta.y+hv)/2+ln,hr/2])cube([hr, 1, hr],true);
    }
    translate([0,hv/2-ts,hr/2+ts/2])cube([lenta.x, lenta.y, hr],true);
    translate([0,0,hr/2])cube([gzd.x, lenta.y*5, gzd.x],true);
}

