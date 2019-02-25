// Euro Cylinder Lock Holder
// Useful for impressioning, picking
// (C) 2018 Matt Burrough
// v. 7.1 (7A)

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

   module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
       
       // preview unfolded (do not include in your function
       z = 0.08;
       separation = 2;
       border = .2;
       translate([0,w+separation,0])
           cube([l,w,z]);
       translate([0,w+separation+w+border,0])
           cube([l,h,z]);
       translate([0,w+separation+w+border+h+border,0])
           cube([l,sqrt(w*w+h*h),z]);
       translate([l+border,w+separation+w+border+h+border,0])
           polyhedron(
                   points=[[0,0,0],[h,0,0],[0,sqrt(w*w+h*h),0], [0,0,z],[h,0,z],[0,sqrt(w*w+h*h),z]],
                   faces=[[0,1,2], [3,5,4], [0,3,4,1], [1,4,5,2], [2,5,3,0]]
                   );
       translate([0-border,w+separation+w+border+h+border,0])
           polyhedron(
                   points=[[0,0,0],[0-h,0,0],[0,sqrt(w*w+h*h),0], [0,0,z],[0-h,0,z],[0,sqrt(w*w+h*h),z]],
                   faces=[[1,0,2],[5,3,4],[0,1,4,3],[1,2,5,4],[2,0,3,5]]
                   );
       }

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
    difference() {
        translate([blockX/2-(keywayRadius*2+8)/2, bottomOffset+12.5, 0])
        cube([keywayRadius*2+6, 12, blockZ/2-actuatorLength/2]);
        translate([blockX/2-(keywayRadius*2+8)/2, bottomOffset+18.5, blockZ/2-actuatorLength/2])
        rotate(90,[0,1,0])
        prism(blockZ/2-actuatorLength/2, 6, 6);
        
        translate([blockX/2+(keywayRadius*2+8)/2, bottomOffset+18.5, 0])
        rotate(270,[0,1,0])
        prism(blockZ/2-actuatorLength/2, 6, 6);
    }
    
        
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
