// Units = mm

blockZ = 59;
blockX = 46;
blockY = 56;

//** REV7BA: changing the actuator insertion cutout to a sector of the inner actuator rotation space.

keywayRadius = 8.75;    //*** REV 7AE

actuatorLength = 12;
actuatorRadius = 16;

profileRadius = 5.25;   //*** REV 7AE
profileHeight = 33.7;    //*** REV 7AE

M5ScrewR = 6/2;
M5ScrewHeadLen = 5;
M5ScrewHeadR = 9/2;

bottomOffset = 15;

difference(){
    rotate(90,[1,0,0])
    difference(){
        // Outer Block
            cube([blockX, blockY, blockZ]);    

        // Profile:
        // Plug circle of profile face
        translate([blockX/2, keywayRadius+bottomOffset, 0])
            cylinder(h=blockZ, r1=keywayRadius, r2=keywayRadius, center=false);
        
        // Mid-section of profile face
        translate([blockX/2-profileRadius,keywayRadius+bottomOffset,0])
            cube([profileRadius*2, profileHeight-keywayRadius-profileRadius, blockZ], false);
    
        // Top arch of profile face
        translate([blockX/2, profileHeight+bottomOffset-profileRadius, 0])
            cylinder(h=blockZ, r1=profileRadius, r2=profileRadius, center=false);
    
        // inner cutout for actuator: enables full rotation of actuator/plug while lock is installed
        translate([blockX/2, keywayRadius+bottomOffset, blockZ/2])
            cylinder(h=actuatorLength, r1=actuatorRadius, r2=actuatorRadius, center=true);   
    
        // New Slot for actuator insertion while locked   //*** Rev 7BA: matching a sector of the inner cutout for actuator rotation
        translate([blockX/2, keywayRadius+bottomOffset, 0])
            intersection(){
                cylinder(blockZ/2-actuatorLength/2, r=actuatorRadius);  //we take the same cylinder as for the inner cutout (albeit with simplified notation)...
                union(){                                                //but we intersect it with the union of two cubes that are rotated to form a 120 degree angle.
                    rotate([0,0,45-15]) 
                         cube([actuatorRadius,actuatorRadius,blockZ/2-actuatorLength/2]);
                    rotate([0,0,45+15]) 
                         cube([actuatorRadius,actuatorRadius,blockZ/2-actuatorLength/2]);
                }
            }
    
        // Mounting Screw hole
        translate([-2, profileHeight+bottomOffset-profileRadius-1,(blockZ/2)])  //*** REV 7AF: moving the hole down a notch
            rotate(180, [1,0,1])
                cylinder(h=blockX+4, r1=M5ScrewR, r2=M5ScrewR, center=false);
    
    } 
}