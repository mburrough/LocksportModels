// Euro Cylinder Lock Holder
// Useful for impressioning, picking
// (C) 2018 Matt Burrough
// v. 7.0

// Units = mm

blockZ = 59;
blockX = 46;
blockY = 56;

keywayRadius = 8.75;

actuatorLength = 12;
actuatorRadius = 16;

profileRadius = 5.5;
profileHeight = 34;

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
    
    
    // Cutout for actuator 
    translate([blockX/2, keywayRadius+bottomOffset, blockZ/2])
        cylinder(h=actuatorLength, r1=actuatorRadius, r2=actuatorRadius, center=true);   
    
    // Slot for actuator insertion while locked
    //translate([blockX/2-(keywayRadius*2+6)/2, bottomOffset+12.5, 0])
        //cube([keywayRadius*2+6, 11, blockZ/2-actuatorLength/2]);
    translate([blockX/2-(keywayRadius*2)/2, bottomOffset+12.5, 0])
        cylinder(h=blockZ/2-actuatorLength/2, r1=7, r2=7);
    translate([blockX/2+(keywayRadius*2)/2, bottomOffset+12.5, 0])
        cylinder(h=blockZ/2-actuatorLength/2, r1=7, r2=7);
    
        
    // Mounting Screw hole
    translate([-2, profileHeight+bottomOffset-profileRadius,(blockZ/2)])
        rotate(180, [1,0,1])
            cylinder(h=blockX+4, r1=M5ScrewR, r2=M5ScrewR, center=false);
    
    // Screw recess
    //translate([0, profileHeight+bottomOffset-profileRadius,(blockZ/2)])
     //   rotate(180, [1,0,1])
       //     cylinder(h=M5ScrewHeadLen, r1=M5ScrewHeadR, r2=M5ScrewHeadR, center=false);
}

// Slice of actuator profile
//translate([0,-6,0])
//rotate(90,[1,0,0])
//cube([blockX+1,blockY+2,blockZ]);

// Slice of front profile
//translate([0,1,0])
//rotate(90,[1,0,0])
//cube([blockX+1,blockY+2,blockZ-6]);

// Side half
//translate([blockX/2,1,0])
//rotate(90,[1,0,0])
//cube([blockX/2,blockY+2,blockZ+1]);
}
