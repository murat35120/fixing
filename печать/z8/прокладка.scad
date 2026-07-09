$fn=100;
ts=1;

diametr=[20.57,24.5,18.5];//размер ячейкм
height=3.5;






bas();


module bas(){
    difference(){
        union(){
           translate([0,0,0])cylinder(ts, diametr.y/2, diametr.y/2);
           translate([0,0,0])cylinder(height, diametr.x/2, diametr.x/2); 
        }
         translate([0,0,-0.1])cylinder(height*2, diametr.z/2, diametr.z/2);    
    }
        
}




