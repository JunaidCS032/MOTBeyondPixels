% function which generates CUBOID for a vehicle with provided avg size
function [cuboid_3D_N] = getCuboidForCar(x, h, K, n, avgCuboid_Sz, avgCuboid_N, carYaw)
	
	% canonical cuboid in camera like frame
	cuboidCanonical = getCanonicalCuboidC(avgCuboid_Sz);		
    
    % offset according to the yaw of car using Ellipse as the model
    ptOnEllipse = [(avgCuboid_Sz(3)/2)* cos(pi + carYaw);
                   (avgCuboid_Sz(1)/2)* sin(pi + carYaw)];
               
    X = (h * inv(K) * x) / (n' * inv(K) * x) +;						 		   % compute 3D or car origin using mobileye formula	 
    
    
	cuboidCanonical_t = rotMatY_3D(-carYaw) * cuboidCanonical';						   % -carYaw because our Y is downwards		
	cuboid_3D   = cuboidCanonical_t' + repmat(X', 8, 1);								  		   % translate canonical cuboid to the car location		
    %(rotMatZ_3D(-carYaw) * getModMatForCuboid(avgCuboid_N(1,:))')'
    cuboid_3D_N = cuboid_3D + (rotMatY_3D(-carYaw) * getModMatForCuboid(avgCuboid_N(1,:),carYaw)')';  % blot the 3D cuboid based on noise from 2D to 3D
	
	
	% test code
	%figure(2);
	%drawCuboid(cuboid_3D_N, 2,'-r');%(:,1), cuboid_3D_N(:,2), cuboid_3D_N(:,3), '-*k')
	%hold on;
	%drawCuboid(cuboid_3D,2, '-y');%plot3(cuboid_3D(:,1), cuboid_3D(:,2), cuboid_3D(:,3), '-*k')
	%surf(cuboidCanonical_t);	
end

