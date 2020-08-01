// "David Hladky" <mrakomo(at)gmail.com> 

use <scad-commons/holes.scad>

printBottom=true;
printCover=true;

wall=1.3;
cover_tolerance=0.4; // the cover should extend the bottom by this on each side
cover_side = 15;

industryHeight=49;
industryTokenSize=27;
industryFingerHole=14;

playerTokenDiameter=43;
playerTokenThickness=2.5;

railTokenWidht=17.5;
railTokenLength=32;
railHeight=30; // height of all rail/ship tokens column 
railFingerSpace=7; // space for fingers between rail tokens
railHolderTop=16; 

//$line_width=0.3;
$holes_bottom_part_top=wall+industryHeight;
$holes_bottom_thickness=wall;

boxSizeX=2*wall+2*industryTokenSize+2*wall+2*playerTokenThickness+2*wall+railTokenWidht;
boxSizeY=2*wall+5*railFingerSpace+4*railHeight;

maxBoxSizeX=87; // space in the box
assert(boxSizeX<maxBoxSizeX);

railPartOuterX=wall+industryTokenSize+wall+playerTokenThickness;
railPartInnerX=railPartOuterX+wall;

woodenHoleBigSize= (boxSizeY - 7*wall -4* industryTokenSize)/2;
woodenTokensSize= 17;

assert(woodenHoleBigSize>woodenTokensSize);


if(printCover) {
  innerSizeX=boxSizeX + 2*cover_tolerance;
  innerSizeY=boxSizeY + 2*cover_tolerance;  
  
  outerSizeX = innerSizeX+2*wall ;
  outerSizeY=  innerSizeY+2*wall;
  outerSizeZ= cover_side+wall;
  difference() {  
      cube([outerSizeX, outerSizeY, outerSizeZ]);
      
      translate([wall, wall, wall])
        cube([innerSizeX, innerSizeY, outerSizeZ]); 
  }
  
  echo("Cover:");
  echo(x=outerSizeX, y=outerSizeY, z=outerSizeZ);
}


if(printBottom) {
translate([-100, 0, 0]) {
    difference() {
     cube([boxSizeX, boxSizeY, $holes_bottom_part_top]);
     
     // hole for rail/ship token holders
     cubic_hole(position=[railPartOuterX, wall], size=[2*wall+railTokenWidht, boxSizeY-2*wall], depth=railTokenLength); 

     playerPositionX=railPartOuterX-playerTokenThickness; 
     // holes for the player token   
     cubic_hole(position=[playerPositionX, wall+railHeight+1.5*railFingerSpace], size=[playerTokenThickness+1, playerTokenDiameter], depth=playerTokenDiameter+1, centerY=true);    
     cubic_hole(position=[playerPositionX, boxSizeY-( wall+railHeight+1.5*railFingerSpace)], size=[playerTokenThickness+1, playerTokenDiameter], depth=playerTokenDiameter+1, centerY=true); 
        
     cubic_hole(position=[boxSizeX-playerPositionX-playerTokenThickness-1, wall+railHeight+1.5*railFingerSpace], size=[playerTokenThickness+1, playerTokenDiameter], depth=playerTokenDiameter+1, centerY=true);    
     cubic_hole(position=[boxSizeX-playerPositionX-playerTokenThickness-1, boxSizeY-( wall+railHeight+1.5*railFingerSpace)], size=[playerTokenThickness+1, playerTokenDiameter], depth=playerTokenDiameter+1, centerY=true); 
//        
     // wooden token holes   
     // left
     hole(position=[wall, wall], size=[industryTokenSize, woodenHoleBigSize], depth=woodenTokensSize);
     hole(position=[wall, wall+woodenHoleBigSize/2], size=[industryTokenSize, woodenHoleBigSize/2], depth=woodenTokensSize+3, centerY=true);
        
     hole(position=[wall, boxSizeY-wall-woodenHoleBigSize], size=[industryTokenSize, woodenHoleBigSize], depth=woodenTokensSize);
     hole(position=[wall, boxSizeY-wall-woodenHoleBigSize/2], size=[industryTokenSize, woodenHoleBigSize/2], depth=woodenTokensSize+3, centerY=true);

     //right   
     hole(position=[boxSizeX-industryTokenSize-wall, wall], size=[industryTokenSize, woodenHoleBigSize], depth=woodenTokensSize);
     hole(position=[boxSizeX-industryTokenSize-wall, wall+woodenHoleBigSize/2], size=[industryTokenSize, woodenHoleBigSize/2], depth=woodenTokensSize+3, centerY=true);
        
     hole(position=[boxSizeX-industryTokenSize-wall, boxSizeY-wall-woodenHoleBigSize], size=[industryTokenSize, woodenHoleBigSize], depth=woodenTokensSize);
     hole(position=[boxSizeX-industryTokenSize-wall, boxSizeY-wall-woodenHoleBigSize/2], size=[industryTokenSize, woodenHoleBigSize/2], depth=woodenTokensSize+3, centerY=true);
        
     // industry holes   
       
     for(y=[wall+woodenHoleBigSize:wall+industryTokenSize:boxSizeY-industryTokenSize]) {  
        industry_left(y);   
        industry_right(y);
     }
    }
     

    for(y = [(wall+railFingerSpace) : (railFingerSpace+railHeight):boxSizeY-railHeight]) 
        railBottomHolder(y); 

}}
 
module railBottomHolder(railPartInnerY) {
    difference() {
        translate([railPartOuterX, railPartInnerY-wall, $holes_bottom_part_top-railTokenLength-wall])
          cube([2*wall+railTokenWidht,2*wall+railHeight, railHolderTop+wall]);
        
       cubic_hole(position=[railPartInnerX, railPartInnerY], size=[railTokenWidht,railHeight], depth=railTokenLength, bury=false ) {
          rotate([0,0,90])
            resize([20,10]) 
               import(file = "ship.svg", center = true, dpi = 96) ;           
           
       };
       
    }
} 

module industry_left(positionY) {
    cubic_hole(position=[wall, wall+positionY], size=[industryTokenSize,industryTokenSize]);
    
    translate([-1, positionY+wall+ (industryTokenSize-industryFingerHole)/2,-1])
       cube([wall+1+industryTokenSize/2, industryFingerHole , $holes_bottom_part_top+2]);
   
    translate([wall+industryTokenSize/2, positionY+wall+industryTokenSize/2,-1])
       cylinder(d=industryFingerHole, h=$holes_bottom_part_top+2, center=true);
    
}

module industry_right(positionY) {
    cubic_hole(position=[boxSizeX-wall-industryTokenSize, wall+positionY], size=[industryTokenSize,industryTokenSize]);
    
    translate([boxSizeX-wall-industryTokenSize/2, positionY+wall+ (industryTokenSize-industryFingerHole)/2,-1])
       cube([industryTokenSize, industryFingerHole , $holes_bottom_part_top+2]);
   
    translate([boxSizeX-wall-industryTokenSize/2, positionY+wall+industryTokenSize/2,-1])
       cylinder(d=industryFingerHole, h=$holes_bottom_part_top+2, center=true);
}
