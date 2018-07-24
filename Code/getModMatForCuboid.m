% outputs a matrix for point modification (+/-) in the same order of the canonical cuboid to be added directly
% to the cuboid matrix. Remeber the order is maintained here so the canonical cuboid should be used for this
function modMat = getModMatForCuboid(avgCuboid_N, carYaw)
	
	modMat   	=       [-avgCuboid_N(1)		avgCuboid_N(2)		-avgCuboid_N(3)	;	%1
				     avgCuboid_N(1)		avgCuboid_N(2)		-avgCuboid_N(3)	;	%4
				    -avgCuboid_N(1)		avgCuboid_N(2)		avgCuboid_N(3) 	;	%2
				     avgCuboid_N(1)		avgCuboid_N(2)		avgCuboid_N(3) 	;	%3
				    -avgCuboid_N(1)		-avgCuboid_N(2) 	-avgCuboid_N(3)	;	%5
				     avgCuboid_N(1)		-avgCuboid_N(2)	-avgCuboid_N(3)	;	%8
				    -avgCuboid_N(1)		-avgCuboid_N(2)	avgCuboid_N(3) 	;	%6
				     avgCuboid_N(1)		-avgCuboid_N(2)	avgCuboid_N(3) 	;	%7
				     ];		
                 
    modMat = (rotMatY_3D(carYaw) * modMat')';
end
