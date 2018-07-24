% 3D rotatin about Y
function rot_y = rotMatY_3D(ty) 

	rot_y = [cos(ty)	 0.0		sin(ty);
	         0.0		 	 1.0		0.0;
		    -sin(ty)	 0.0		cos(ty) ];
		  
end	
