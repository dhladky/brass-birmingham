// "David Hladky" <mrakomo(at)gmail.com> 

use <scad-commons/holes.scad>

wall=1.5;

industryHeight=49;
industryTokenSize=27;
industryFingerHole=10;

playerTokenDiameter=43;
playerTokenThickness=2.5;

railTokenWidht=17.5;
railTokenLength=30;
railHeight=30; // height of all rail/ship tokens column 
railFingerSpace=7; // space for fingers between rail tokens
railHolderTop=16; 


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

difference() {
 cube([boxSizeX, boxSizeY, $holes_bottom_part_top]);
 
 // hole for rail/ship token holders
 cubic_hole(position=[railPartOuterX, wall], size=[2*wall+railTokenWidht, boxSizeY-2*wall], depth=railTokenLength); 

 playerPositionX=railPartOuterX-playerTokenThickness; 
 // holes for the player token   
 cubic_hole(position=[playerPositionX, wall+railHeight+1.5*railFingerSpace], size=[2*playerTokenThickness+2*wall+railTokenWidht, playerTokenDiameter], depth=playerTokenDiameter+1, centerY=true);    

 cubic_hole(position=[playerPositionX, boxSizeY-( wall+railHeight+1.5*railFingerSpace)], size=[2*playerTokenThickness+2*wall+railTokenWidht, playerTokenDiameter], depth=playerTokenDiameter+1, centerY=true); 
    
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
 
module railBottomHolder(railPartInnerY) {
    difference() {
        translate([railPartOuterX, railPartInnerY-wall, $holes_bottom_part_top-railTokenLength-wall])
          cube([2*wall+railTokenWidht,2*wall+railHeight, railHolderTop+wall]);
        
       cubic_hole(position=[railPartInnerX, railPartInnerY], size=[railTokenWidht,railHeight], depth=railTokenLength);
       
    }
} 

module industry_left(positionY) {
    cubic_hole(position=[wall, wall+positionY], size=[industryTokenSize,industryTokenSize]);
    
    translate([-1, positionY+wall+ (industryTokenSize-industryFingerHole)/2,-1])
       cube([wall+2, industryFingerHole , $holes_bottom_part_top+2]);
   
    translate([wall, positionY+wall+industryTokenSize/2,-1])
       cylinder(d=industryFingerHole, h=$holes_bottom_part_top+2, center=true);
    
}

module industry_right(positionY) {
    cubic_hole(position=[boxSizeX-wall-industryTokenSize, wall+positionY], size=[industryTokenSize,industryTokenSize]);
    
    translate([boxSizeX-1-wall, positionY+wall+ (industryTokenSize-industryFingerHole)/2,-1])
       cube([wall+2, industryFingerHole , $holes_bottom_part_top+2]);
   
    translate([boxSizeX-1-wall, positionY+wall+industryTokenSize/2,-1])
       cylinder(d=industryFingerHole, h=$holes_bottom_part_top+2, center=true);
}
