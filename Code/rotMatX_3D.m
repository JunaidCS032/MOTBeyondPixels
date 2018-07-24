% 3D rotatin about X
function rot_x = rotMatX_3D(tx)
 
      
rot_x = [1			 0			 0;
	   0			 cosd(tx)		-sind(tx);
	   0			 sind(tx)	 	cosd(tx) ];	
	
end      
