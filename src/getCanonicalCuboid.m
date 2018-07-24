% generates points for a cuboid in camera like frame i.e. Z facing forward, X to the right and Y downwards
function canonicalCuboid = getCanonicalCuboid(sz)
    
    canonicalCuboid = [-sz(1)/2 	sz(2)/2  -sz(3)/2;	%1
                        sz(1)/2     sz(2)/2  -sz(3)/2;	%4
                       -sz(1)/2     sz(2)/2   sz(3)/2;	%2
                        sz(1)/2     sz(2)/2   sz(3)/2;	%3
                        
                       -sz(1)/2    -sz(2)/2  -sz(3)/2;	%5
                        sz(1)/2    -sz(2)/2	 -sz(3)/2;	%8
                       -sz(1)/2    -sz(2)/2	  sz(3)/2;	%6
                        sz(1)/2    -sz(2)/2	  sz(3)/2	%7
	
        			   ];     
end


%% old code

% 
% 	% canonical cuboid in camera like frame
% 	canonicalCuboid = [-avgCuboid_Sz(1)/2 		0                   0				;	%1
%                         avgCuboid_Sz(1)/2		0                   0				;	%4
%                        -avgCuboid_Sz(1)/2		0                   avgCuboid_Sz(3) 	;	%2
%                         avgCuboid_Sz(1)/2		0                   avgCuboid_Sz(3) 	;	%3
%                        -avgCuboid_Sz(1)/2 		-avgCuboid_Sz(2) 	0				;	%5
%                         avgCuboid_Sz(1)/2		-avgCuboid_Sz(2)	0				;	%8
%                        -avgCuboid_Sz(1)/2		-avgCuboid_Sz(2)	avgCuboid_Sz(3) 	;	%6
%                         avgCuboid_Sz(1)/2		-avgCuboid_Sz(2)	avgCuboid_Sz(3) 	;	%7
% 	
%         			   ];