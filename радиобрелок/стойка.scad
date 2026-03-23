$fn=30;
size=[3.8+0.3,0.5,5];//размер шрифта

difference(){
    cylinder(size.z, size.x/2+size.y, size.x/2+size.y); 
    translate([0,0,-0.1])cylinder(size.z*2, size.x/2, size.x/2); 
}


