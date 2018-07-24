% params_carCuboid : struct having average car size : [length; height; width];
%                    upper bound in size
%                    lower bound in size
% params_2D3D   : struct containing parameters for converting a projection of
%                 ground point to its corresponding 3D point using K, n, h
% detections1/2 : array of struct containing bbox, car's yaw, and covariance
%                 matrix of the detection i.e. diag(sigma_x, sigma_y,
%                 sigma_yaw);
%                 detection for both the frames i.e. 1 and 2
% matchResult   : an array of struct of size of number of bbox in bbox1 i.e.
%                 num_rows in bbox1 matrix. every struct element containts:
%                 scores2D - vector of size num_row of bbox2 having 2D2D
%                           match scores
%                 scores3D - vector of size num_row of bbox2 having 3D3D
%                           match scores
%                 covariance2D - cell array of covarience matrices for every
%                               bbox in bbox1 when was propagated to the
%                               other frame via 3D
% detection_3D_F2 : array of structs of type detection_3D to hold the 3D
%                   pts of all the detections in F2 so that it can be
%                   reused later.
function [matchResult, detection_3D_F2] = matchBoundingBoxes(detections1, detections2, params_2D3D, params_carCuboid)

    len1 = length(detections1);
    len2 = length(detections2);
    
    for i = 1:len1
        
        x1 = [detections1(i).bbox(1) + (detections1(i).bbox(3) - detections1(i).bbox(1))/2 ;
              detections1(i).bbox(4);
              1.0];
        X1 = (params_2D3D.h * inv(params_2D3D.K) * x1) / (params_2D3D.n' * inv(params_2D3D.K) * x1);
        
        % apply offset which is a function of yaw and get car's origin (remember approx.)
        offset_Z = getOffsetBasedOnYaw([params_carCuboid.avg_Sz(1); params_carCuboid.avg_Sz(3)], detections1.yaw);        
        carOrigin = X1 + [0; 0; offset_Z];
        
        % make the car cuboid at the origin
        [cuboid_Pts, new_Sz] = getCuboid(carOrigin, params_carCuboid, detections1.yaw, ... 
                                         detections1.sigma_bbox, detections1.sigma_yaw, ...
                                         params_carCuboid.sz_ub, params_carCuboid.sz_lb ...
                                        );
        
        for j = 1:len2
            
                
            
            
        end
    end
    
  %x = [bbox(1) + (bbox(3) - bbox(1))/2 ; bbox(4); 1];
end