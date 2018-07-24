% function to generate a cuboid based on the sz:[l h b], ry, corresponding
% noise and the origin. sz_ub/_lb are the upper and lower bounds on the
% size of the cuboid afte all the operations have gone in to it.
% RETURNS: bounding volume (bvolume) which is the convex hull of the points
% got after applying the yaw and lbh error to the avg car cuboid
% bounds have been applied.
% NOTE: - ry is +ve for counter-clockwise
%       - cuboid is created with facing towards X axis on the X-Z plane i.e.
%         length is in X axis, width in Z axis and Y is for height starting
%         from 0 to sz(y)
        

function [bvolume, k] = getBoundingVolume(center, pts, ry, sigma_3D, sz_ub, sz_lb)

    % 3D points stacked after applying the -ve and +ve yaw error
    
    ry_N = sigma_3D(4,4);        
    centered_pts = pts-repmat(center', size(pts,1),1);  % bring pts to origin to rotate
    
    rot_pts_plus_yaw  = (rotMatY_3D(+ry_N) * centered_pts'  )';
    rot_pts_minus_yaw = (rotMatY_3D(-ry_N) * centered_pts'  )';
    
    pts = [centered_pts;
           rot_pts_plus_yaw;
           rot_pts_minus_yaw  ]; 
    
    % get the convex hull of all pts i.e. after error in yaw
    k = convhull(pts(:,1), pts(:,2), pts(:,3));   
    bvolume = pts(k, :);  
    
    % scale the bounding voluem based on the error in the three axis i.e.
    % in l, h, w
    scales = diag(sigma_3D(1:3, 1:3));
    scale_mat = [scales(1) 0 0; 0 scales(2) 0; 0 0 scales(3)];
    bvolume = (scale_mat * bvolume')';
           
    % bound the bvolume by bounds in l,b,and h          
    % apply upper and lower bounds on the newly formed outer bound cuboid
 
    % bound in X
    bvolume(find(bvolume(:,1)>sz_ub(1)), 1) = sz_ub(1);
    bvolume(find(bvolume(:,1)<sz_lb(1)), 1) = sz_lb(1);
    
    % bound in Y
    bvolume(find(bvolume(:,2)>sz_ub(2)), 2) = sz_ub(2);
    bvolume(find(bvolume(:,2)<sz_lb(2)), 2) = sz_lb(2);
    
    % bound in Z
    bvolume(find(bvolume(:,3)>sz_ub(3)), 3) = sz_ub(3);
    bvolume(find(bvolume(:,3)<sz_lb(3)), 3) = sz_lb(3);           
    
    % finally apply the yaw angle of the car to the bvolume
    bvolume = (rotMatY_3D(ry) * bvolume');
    
    %+ repmat(center, 1,size(bvolume,1)))';  
    
    % re-translate the point to its true origin
    bvolume = (bvolume + repmat(center, 1,size(bvolume,2)))';
    
    k = convhull(bvolume);
end


%% OLD CODE OF THE FUNCTION (working) 16/8/17

% % function to generate a cuboid based on the sz:[l h b], ry, corresponding
% % noise and the origin. sz_ub/_lb are the upper and lower bounds on the
% % size of the cuboid afte all the operations have gone in to it.
% % RETURNS: cuboid points and the NEW SIZE after noise has gone in and
% % bounds have been applied.
% % NOTE: - ry is +ve for counter-clockwise
% %       - cuboid is created with facing towards X axis on the X-Z plane i.e.
% %         length is in X axis, width in Z axis and Y is for height starting
% %         from 0 to sz(y)
%         
% 
% function [cuboid_Pts_bbox, cuboid_Pts_cvxhull, new_Sz] = getCuboid(center, sz, ry, sz_N, ry_N, sz_ub, sz_lb)
% 
% 
%     % canonical cuboid in camera like frame with noise added
% 	canonicalCuboid = [-sz(1)/2 - sz_N(1) 	 0 + ((sz_N(2)>0)* (sz_N(2)-sz(2)/2))        -sz(3)/2 - sz_N(3)	;	%1
%                         sz(1)/2	+ sz_N(1)	 0 + ((sz_N(2)>0)* (sz_N(2)-sz(2)/2))        -sz(3)/2 - sz_N(3)	;	%4
%                        -sz(1)/2	- sz_N(1)	 0 + ((sz_N(2)>0)* (sz_N(2)-sz(2)/2))         sz(3)/2 + sz_N(3)  ;	%2
%                         sz(1)/2	+ sz_N(1)    0 + ((sz_N(2)>0)* (sz_N(2)-sz(2)/2))         sz(3)/2 + sz_N(3)  ;	%3
%                         
%                        -sz(1)/2 - sz_N(1)   -sz(2) - ((sz_N(2)>0)* (sz_N(2)-sz(2)/2))    -sz(3)/2 - sz_N(3)	;	%5
%                         sz(1)/2 + sz_N(1)	-sz(2) - ((sz_N(2)>0)* (sz_N(2)-sz(2)/2))    -sz(3)/2 - sz_N(3)	;	%8
%                        -sz(1)/2 - sz_N(1)	-sz(2) - ((sz_N(2)>0)* (sz_N(2)-sz(2)/2))     sz(3)/2 + sz_N(3)	;	%6
%                         sz(1)/2 + sz_N(1)	-sz(2) - ((sz_N(2)>0)* (sz_N(2)-sz(2)/2))     sz(3)/2 + sz_N(3) 		%7
% 	
%         			   ];        
%     
    % cuboid points stacked after doing all the transforms for noise so 
    % that we can form a new cuboid which has all the noise incorporated
%     
%     pts = [canonicalCuboid;
%            (rotMatY_3D(+ry_N) * canonicalCuboid')';
%            (rotMatY_3D(-ry_N) * canonicalCuboid')' ]; 
%     
%     % get the convex hull of all pts i.e. after error in yaw and lbh
%     k = convhull(pts(:,1), pts(:,2), pts(:,3));   
%     cuboid_Pts_cvxhull = pts(k, :);    
%        
%     % TEST.1 - plotting to TEST later to be DELTED
%         pts_pr = (rotMatY_3D(+ry_N) * canonicalCuboid')';
%         pts_mr = (rotMatY_3D(-ry_N) * canonicalCuboid')';
% 
%         figure(1);
%         hold on;
% 
%         drawCuboid(canonicalCuboid, 1, '-g');
%         %drawCuboid(pts_pr, 1, '-b');
%         %drawCuboid(pts_mr, 1, '-r');
%     % TEST.1 ends here...       
%        
%     % find the max and min of all the sides
%     [~, max_idx] = max(pts);
%     [~, min_idx] = min(pts);
%     
%     % make a new cuboid wich is the outer bound of all the three cuboids
%     % constructed above
%     
%     newCuboid = [ pts(min_idx(1),1)     pts(max_idx(2),2)       pts(min_idx(3),3);
%                   pts(max_idx(1),1)     pts(max_idx(2),2)       pts(min_idx(3),3);
%                   pts(min_idx(1),1)     pts(max_idx(2),2)       pts(max_idx(3),3);
%                   pts(max_idx(1),1)     pts(max_idx(2),2)       pts(max_idx(3),3);
%                   
%                   pts(min_idx(1),1)     pts(min_idx(2),2)       pts(min_idx(3),3);
%                   pts(max_idx(1),1)     pts(min_idx(2),2)       pts(min_idx(3),3);
%                   pts(min_idx(1),1)     pts(min_idx(2),2)       pts(max_idx(3),3);
%                   pts(max_idx(1),1)     pts(min_idx(2),2)       pts(max_idx(3),3)
%                 ];
%     % apply upper and lower bounds on the newly formed outer bound cuboid
%     
%     newCuboid_bounded = newCuboid
%     
%     % bound in X
%     newCuboid_bounded(find(newCuboid_bounded(:,1)>sz_ub(1)), 1) = sz_ub(1);
%     newCuboid_bounded(find(newCuboid_bounded(:,1)<sz_lb(1)), 1) = sz_lb(1);
%     
%     % bound in Y
%     newCuboid_bounded(find(newCuboid_bounded(:,2)>sz_ub(2)), 2) = sz_ub(2);
%     newCuboid_bounded(find(newCuboid_bounded(:,2)<sz_lb(2)), 2) = sz_lb(2);
%     
%     % bound in Z
%     newCuboid_bounded(find(newCuboid_bounded(:,3)>sz_ub(3)), 3) = sz_ub(3);
%     newCuboid_bounded(find(newCuboid_bounded(:,3)<sz_lb(3)), 3) = sz_lb(3);
%     
%     % find the new size of the cuboid. Note: size is computed in canonical
%     % frame i.e. before rotating or the size will be affected by rotation
%     [max_val] = max(abs(cuboid_Pts_bbox));        
%     new_Sz = max_val' .* [2.0; 1.0; 2.0];
%     
%     
%     % finally apply the yaw angle of the car to the cuboid and translate it
%     % to the provided center of the cuboid
%     cuboid_Pts_bbox = ((rotMatY_3D(ry) * newCuboid_bounded') + repmat(center, 1,8))';    
%     
%     % TEST.2 - plotting to TEST later to be DELTED        
%         % drawCuboid(cuboid_Pts, 1, '-c');    
%     % TEST.2 ends here...        
%     
% end
