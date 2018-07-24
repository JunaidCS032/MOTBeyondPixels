% 3D rotatin about Z
function rot_z = rotMatZ_3D(tz) 

	rot_z = [cos(tz)	-sin(tz)			0;
		     sin(tz)	 cos(tz)			0;
		     0			 0			   	1 ];
end      
