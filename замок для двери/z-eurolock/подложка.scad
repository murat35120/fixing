
ts=7.5;//толщина стенки
plx=51; //размер замка по x
ply=281; //размер замка по y
plz=4;//высота прокладки
$fn=100;
top=106;
bot=146;
db=36;
cs=ply-plx;//растояние между центрами скругления
lst=top+bot;//растояние междцу стойками крепления
//dtop=16;
dbot=12;
ln=8;
//all ();
//part();
rotate([180,0,45])difference(){
part_top();
translate([plx/2-ln,0,0])rotate([0,45,0])translate([5,0,2*plz])cube([10,ply,4*plz],true);
    //cube([10,ply,4*plz],true);
}
module part_top(){
        linear_extrude(plz, true)all ();
}

module part(){
    difference(){
        all ();
        translate([(plx-ln)/2,0,0])square([ ln,ply],true);
    }
    
}

module all (){
    intersection(){
        union(){
            difference(){
                translate([0,(lst-1*dbot)/2,0])square([ plx-ts,2*dbot],true);  
                translate([0,lst/2,0])circle(d=dbot);
                translate([0,dbot/2+lst/2,0])circle(d=dbot);
            }
            difference(){
                translate([0,-(lst-1*dbot)/2,0])square([ plx-ts,3*dbot],true);  
                translate([0,-lst/2,0])circle(d=dbot);
                translate([0,-(dbot/2+lst/2),0])circle(d=dbot);
            }
        }
        union(){
            translate([0,cs/2,0])circle(d=plx);
            translate([0,-cs/2,0])circle(d=plx);
            square([plx, cs],true);
        }
    }
    difference(){
        union(){
            translate([0,cs/2,0])circle(d=plx);
            translate([0,-cs/2,0])circle(d=plx);
            square([plx, cs],true);
        }
        union(){
            translate([0,cs/2,0])circle(d=plx-2*ts);
            translate([0,-cs/2,0])circle(d=plx-2*ts);
            square([plx-2*ts, cs],true);
        } 
        translate([0,lst/2-top,0])circle(d=db);
    }
}