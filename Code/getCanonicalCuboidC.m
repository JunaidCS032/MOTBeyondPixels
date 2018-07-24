% this function gets the canonical cuboid in Kitti kind of reference where
% the origin of the cuboid is at the center of lower face of the cube and
% the car i.e. cuboid faces towards X axis. 'yawToNewFrame' rotates the car to new
% frame. 
function canonicalCuboid = getCanonicalCuboidC(avgCuboid_Sz, yawToNewFrame)

	% canonical cuboid in camera like frame
	canonicalCuboid = [-avgCuboid_Sz(1)/2 		0                   -avgCuboid_Sz(3)/2	;	%1
                        avgCuboid_Sz(1)/2		0                   -avgCuboid_Sz(3)/2	;	%4
                       -avgCuboid_Sz(1)/2		0                   avgCuboid_Sz(3)/2   ;	%2
                        avgCuboid_Sz(1)/2		0                   avgCuboid_Sz(3)/2   ;	%3
                        
                       -avgCuboid_Sz(1)/2 		-avgCuboid_Sz(2) 	-avgCuboid_Sz(3)/2	;	%5
                        avgCuboid_Sz(1)/2		-avgCuboid_Sz(2)	-avgCuboid_Sz(3)/2	;	%8
                       -avgCuboid_Sz(1)/2		-avgCuboid_Sz(2)	avgCuboid_Sz(3)/2 	;	%6
                        avgCuboid_Sz(1)/2		-avgCuboid_Sz(2)	avgCuboid_Sz(3)/2 	;	%7
	
        			   ];        
    
    % bring the canonical cuboid from canonical to KITTI car system i.e. car is facing towards X               
    canonicalCuboid = (rotMatY_3D(yawToNewFrame) * canonicalCuboid')';
    
end
