% computes offset to be applied to X i.e. center of bottom line of bbox of
% detections to actually go to the center of the car. This offset should be
% applied only in Z direction.
function [offset] = getOffsetBasedOnYaw(carDim_XZ, yaw)
     %carDim_XZ = [4, 2];
     %yaw = -pi/10;

    car_bottom_plane = [-carDim_XZ(1)/2 -carDim_XZ(2)/2;
                         carDim_XZ(1)/2 -carDim_XZ(2)/2;
                         carDim_XZ(1)/2  carDim_XZ(2)/2;
                        -carDim_XZ(1)/2  carDim_XZ(2)/2];

    rot = [cos(yaw) -sin(yaw); sin(yaw) cos(yaw)];

    car_bottom_plane_rot = (rot*car_bottom_plane')';

    % compute the bounding box of new projected box	
    [~, idx_max] = max(car_bottom_plane_rot);
    [~, idx_min] = min(car_bottom_plane_rot);

    offset = abs(car_bottom_plane_rot(idx_max(2),2) - car_bottom_plane_rot(idx_min(2),2))/2;                 

    %car_bottom_plane_rot = car_bottom_plane_rot';
	%propagated_2D_bbox_F12 = [ car_bottom_plane_rot(1,idx_min(1)) car_bottom_plane_rot(2,idx_max(2));
	%				  	  car_bottom_plane_rot(1,idx_max(1)) car_bottom_plane_rot(2,idx_max(2));
	%		 		  	  car_bottom_plane_rot(1,idx_max(1)) car_bottom_plane_rot(2,idx_min(2));			 		 
	%		 		  	  car_bottom_plane_rot(1,idx_min(1)) car_bottom_plane_rot(2,idx_min(2))]

    %plot(car_bottom_plane_rot(:,1), car_bottom_plane_rot(:,2), '-b')
    %hold on;
    %plot(propagated_2D_bbox_F12(:,1), propagated_2D_bbox_F12(:,2), '-^')
end