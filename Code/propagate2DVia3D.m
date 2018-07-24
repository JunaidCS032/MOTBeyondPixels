% returns the convex hull points of the error propagated and projected 2D points to frame 2
% cuboidX_prop_2D_F2 - propagation of 2D in F1 to 2D in F2 via 3D {  2D_F1 -> 3D_F1 + N -> 3D_F2 + N -> 2D_F2 }
function [propagated_2D_bbox_F12, propagated_2D_kh_F12, cuboidX_3D_F2_N] = propagate2DVia3D(x, h, K, n, ry, avgCuboid_Sz, avgCuboid_N, Tcam_F12)
	
	% canonical cuboid in camera like frame
    %canonicalCuboid = getCanonicalCuboid(avgCuboid_Sz);
	cuboidX_3D_F1_N = getCuboidForCar(x, h, K, n, avgCuboid_Sz, avgCuboid_N, ry); %getCanonicalCuboid(avgCuboid_Sz);    
	%cuboidX_3D_F1   = canonicalCuboid + repmat(X', 8, 1);% cuboidX;       								% dtranslate canonical cuboid to the car location		
	%cuboidX_3D_F1_N = cuboidX_3D_F1 + getModMatForCuboid(avgCuboid_N(1,:));		% blot the 3D cuboid based on noise from 2D to 3D
	cuboidX_3D_F2   = inv(Tcam_F12) * [cuboidX_3D_F1_N ones(8,1)]';		 		% transform the noise cuboid to 2nd frame	
	
	cuboidX_3D_F2_N = cuboidX_3D_F2(1:3,:)' + getModMatForCuboid(avgCuboid_N(2,:),ry); 	% blot the 3D cuboid based on noise from 3D 1 
																   	% frame to 2 frame	
	
	cuboidX_2D_F2 = K * cuboidX_3D_F2_N'								   	% project to image
	cuboidX_2D_F2 = cuboidX_2D_F2(1:2,:) ./ repmat(cuboidX_2D_F2(3,:), 2,1);
	
	cuboidX_2D_F2(1:2,:)'
	% compute the bounding box of new projected box	
	[~, idx_max] = max(cuboidX_2D_F2(1:2,:)')
	[~, idx_min] = min(cuboidX_2D_F2(1:2,:)')
	
	propagated_2D_bbox_F12 = [ cuboidX_2D_F2(1,idx_min(1)) cuboidX_2D_F2(2,idx_max(2));
					  	  cuboidX_2D_F2(1,idx_max(1)) cuboidX_2D_F2(2,idx_max(2));
			 		  	  cuboidX_2D_F2(1,idx_max(1)) cuboidX_2D_F2(2,idx_min(2));			 		 
			 		  	  cuboidX_2D_F2(1,idx_min(1)) cuboidX_2D_F2(2,idx_min(2))];

	k = convhull(cuboidX_2D_F2(1,:), cuboidX_2D_F2(2,:));						% find convex hull for the projected point
	propagated_2D_kh_F12 = [cuboidX_2D_F2(1,k); cuboidX_2D_F2(2,k)]';	 	

	cuboidX_3D_F2_N = K*cuboidX_3D_F1_N';
    cuboidX_3D_F2_N = cuboidX_3D_F2_N(1:2,:) ./ repmat(cuboidX_3D_F2_N(3,:), 2, 1);
	
	%X
end


