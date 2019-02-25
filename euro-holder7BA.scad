// Units = mm

blockZ = 59;
blockX = 46;
blockY = 56;

//** REV7AB: 0.1mm clearance from nominal at each inside face, centered actuator box and moved it higher, made prisms bigger to avoid overhang
//** REV7AC: 0.15mm clearance from nominal at each inside face, moving the bottom edge of the actuator insertion box down a bit for more clearance near the sleeve
//** REV7AD: even more clearance for cylinder height, probably to account for extra filament being deposited by printing the bridge closure without support.
//** REV7AE: even more clearance needed to account for machine non-straightness and unexpectedly larger size of other cylinders (+1mm on each edge that touches the cylinder)
//** REV7AF: moving the screw mounting hole down a bit so it aligns with the thread of an inserted core.
//** REV7AG: cleaning up code
//** -------
//** REV7BA: changing the actuator insertion cutout to a sector of the inner actuator rotation space.

//keywayRadius = 8.75;    //*** REV 7A (8.5 nominal, actual core measures 8.4)
//keywayRadius = 8.6;    //*** REV 7AB
//keywayRadius = 8.65;    //*** REV 7AC
keywayRadius = 8.75;    //*** REV 7AE

actuatorLength = 12;
actuatorRadius = 16;

//profileRadius = 5.5;   //*** REV 7A (5.0 nominal, actual core measures 4.9)
//profileRadius = 5.5;   //*** REV 7AB
//profileRadius = 5.15;   //*** REV 7AC
profileRadius = 5.25;   //*** REV 7AE

//profileHeight = 34;    //*** REV 7A (33.0 nominal, actual core measures 32.9 at highest mutilated spot, probably machined to 32.8)
//profileHeight = 33.2;    //*** REV 7AB
//profileHeight = 33.3;    //*** REV 7AC
//profileHeight = 33.5;    //*** REV 7AD
profileHeight = 33.7;    //*** REV 7AE

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
} // module prism

module sector(h, d, a1, a2) {
    if (a2 - a1 > 180) {
        difference() {
            cylinder(h=h, d=d);
            translate([0,0,-0.5]) sector(h+1, d+1, a2-360, a1); 
        }
    } else {
        difference() {
            cylinder(h=h, d=d);
            rotate([0,0,a1]) translate([-d/2, -d/2, -0.5])
                cube([d, d/2, h+1]);
            rotate([0,0,a2]) translate([-d/2, 0, -0.5])
                cube([d, d/2, h+1]);
        }
    }
} 

difference(){
    rotate(90,[1,0,0])
    difference(){
        // Outer Block
        union() {
            cube([blockX, blockY, blockZ]);
            translate([blockX+20, 0, 0])
            intersection(){
                cylinder(blockZ/2-actuatorLength/2, r=actuatorRadius);
                union(){
                    rotate([0,0,45-15]) 
                         cube([actuatorRadius,actuatorRadius,blockZ/2-actuatorLength/2]);
                    rotate([0,0,45+15]) 
                         cube([actuatorRadius,actuatorRadius,blockZ/2-actuatorLength/2]);
                }
            }

        }    

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
    
/*        // Slot for actuator insertion while locked  //*** Used to be in place for Rev 7A*, but replaced by different design in Rev 7B*
        difference() {
            //translate([blockX/2-(keywayRadius*2+8)/2, bottomOffset+12.5, 0])   //*** Rev 7AA
            //translate([blockX/2-(keywayRadius*2+6)/2, bottomOffset+12.5+2, 0])  //*** Rev 7AB: centering box, and moving it up a bit to avoid overhang
            translate([blockX/2-(keywayRadius*2+6)/2, bottomOffset+12.5+1, 0])  //***Rev 7AC: making box a bit higher and moving it down by the same amount, for better actuator clearance near the sleeve
                //cube([keywayRadius*2+6, 11, blockZ/2-actuatorLength/2]);  //***Rev 7AA
                cube([keywayRadius*2+6, 12, blockZ/2-actuatorLength/2]);  //***Rev 7AC: making box a bit higher and moving it down by the same amount, for better actuator clearance near the sleeve
        
            //translate([blockX/2-(keywayRadius*2+8)/2, bottomOffset+18.5, blockZ/2-actuatorLength/2]) //*** Rev 7AA
            translate([blockX/2-(keywayRadius*2+7)/2, bottomOffset+18.5, blockZ/2-actuatorLength/2])  //*** Rev 7AB: move prisms further out 
                rotate(90,[0,1,0])
                    //prism(blockZ/2-actuatorLength/2, 6, 6);  //*** REV 7AA
                    prism(blockZ/2-actuatorLength/2, 8, 8);  //*** REV 7AB: make prisms bigger to avoid overhang
        
            //translate([blockX/2+(keywayRadius*2+8)/2, bottomOffset+18.5, 0])  //*** REV 7AA
            translate([blockX/2+(keywayRadius*2+7)/2, bottomOffset+18.5, 0])  //*** Rev 7AB: move prisms further out
                rotate(270,[0,1,0])
                    //prism(blockZ/2-actuatorLength/2, 8, 8);  //*** Rev 7AA
                    prism(blockZ/2-actuatorLength/2, 8, 8);  //*** REV 7AB: make prisms bigger to avoid overhang
        } //difference
*/
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


        //****TODO ABOVE: sector****
    
        // Mounting Screw hole
        //translate([-2, profileHeight+bottomOffset-profileRadius,(blockZ/2)])
        translate([-2, profileHeight+bottomOffset-profileRadius-1,(blockZ/2)])  //*** REV 7AF: moving the hole down a notch
            rotate(180, [1,0,1])
                cylinder(h=blockX+4, r1=M5ScrewR, r2=M5ScrewR, center=false);
    
        // Screw recess
        //translate([0, profileHeight+bottomOffset-profileRadius,(blockZ/2)])
            //rotate(180, [1,0,1])
                //cylinder(h=M5ScrewHeadLen, r1=M5ScrewHeadR, r2=M5ScrewHeadR, center=false);
    } //difference

    // Slice of actuator profile
    //translate([0,-6,0])
        //rotate(90,[1,0,0])
            //cube([blockX+1,blockY+2,blockZ]);

    // Slice of front profile
    //translate([0,1,0])
        //rotate(90,[1,0,0])
            //cube([blockX+1,blockY+2,blockZ-6]);

    // Rear Slice  //*** Rev 7AA: an upright slice of the rear profile for fitting. 
    //translate([0,-5,0])
        //rotate(90,[1,0,0])
            //cube([blockX,blockY+2,blockZ+1]);
} //difference
