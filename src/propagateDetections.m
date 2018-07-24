% Function which propagates and adds noise to the 3D points and popoulates
% other variables of the structs passed to the function
% motion = [trans, rot_yaw_theta]
function [detectionsQ, detectionsT] = propagateDetections(detectionsQ, detectionsT, params_2D3D, params_carCuboid, motion, first_time)        
    
%% for all detections in Query propagate the box to 3D box in F2 frame  
    
    for i = 1:length(detectionsQ)                        
        
        b1Q = [];
        B1Q = [];
        bvolumeQ1 = [];
        
        % check if the detection is first time i.e. we have to start with
        % the canonical cuboid. Else we already have the cuboid.
        
        if(length(detectionsQ{i}.bvolume) == 0 )
            %disp(sprintf('first_time - id :%d\n',detectionsQ{i}.dno));
            canonicalCuboid = getCanonicalCuboid( params_carCuboid.avg_Sz);   

            % find center of the bounding box bottom line
            b1Q = [detectionsQ{i}.bbox(1) + (detectionsQ{i}.bbox(3) - detectionsQ{i}.bbox(1))/2 ;
                  detectionsQ{i}.bbox(4);
                  1.0];

            % project it to 3D
            B1Q = (params_2D3D.h * inv(params_2D3D.K) * b1Q) / (params_2D3D.n' * inv(params_2D3D.K) * b1Q);

            % apply offset which is a function of yaw and get car's origin (remember approx.)
            offset_Z = getOffsetBasedOnYaw([params_carCuboid.avg_Sz(1); params_carCuboid.avg_Sz(3)], detectionsQ{i}.yaw);        

            % car's origin in Query Frame
            B1Q = B1Q + [0; 0; offset_Z];

            % translate canonical cuboid
            canonicalCuboid = canonicalCuboid + repmat(B1Q', 8,1);

            % BOUNDING VOLUME IN QUERY FRAME                
            [bvolumeQ1, k1] = getBoundingVolume(B1Q, canonicalCuboid, detectionsQ{i}.yaw, ... 
                                                detectionsQ{i}.sigma_3D, ...
                                                params_carCuboid.sz_ub, params_carCuboid.sz_lb ...
                                               );  
                                           
            bvolumeQ1 = bvolumeQ1 - repmat([0 params_carCuboid.avg_Sz(2)/2 0], size(bvolumeQ1,1), 1);  
        else
           
            B1Q = detectionsQ{i}.origin;
            bvolumeQ1 = detectionsQ{i}.bvolume;
            
        end
        
        % TODO
             % propagate noise and find new noise .... for now same noise             
        %                       
        
        % car's origin in Train frame
        B2Q = motion(1:3) + B1Q ;
        bvolumeQ1 = bvolumeQ1 + repmat(motion(1:3)', size(bvolumeQ1,1),1);
        % CUBOID IN TRAIN FRAME        
        
        %dummy_sigma = eye(4,4);
        %dumm_sigma(4,4) = 0;
        
        [bvolumeQ2, k2] = getBoundingVolume(B2Q, bvolumeQ1, motion(4), ... 
                                             detectionsQ{i}.sigma_3D, ...
                                             params_carCuboid.sz_ub, params_carCuboid.sz_lb ...
                                            );                 
        
       % bvolumeQ2 = bvolumeQ2 - repmat([0 params_carCuboid.avg_Sz(2)/2 0], size(bvolumeQ2,1), 1);    % offset the h/2 as car ar to be on road             
        
        % compute projection of bvolume and store in bvolume_proj variable
        bvolume_proj = (params_2D3D.K*bvolumeQ2')';
        bvolume_proj(:,1:3) = bvolume_proj(:,1:3)./repmat(bvolume_proj(:,3), 1,3);
        kbvolume_proj = convhull(bvolume_proj(:,1:2));
        bvolume_proj = bvolume_proj(kbvolume_proj,:);
        
        % update the fields of the structure
        
        detectionsQ{i}.bvolume = bvolumeQ2;             
        detectionsQ{i}.bvolume_proj = bvolume_proj;
        detectionsQ{i}.yaw  = detectionsQ{i}.yaw+motion(4); 
        detectionsQ{i}.origin  = B2Q;        
        detectionsQ{i}.k = k2;       
        
                        
    end
    
    
    
    
    %% for all detections in Train propagate the box to 3D box in its frame    
    
    for i = 1:length(detectionsT)

        canonicalCuboid = getCanonicalCuboid( params_carCuboid.avg_Sz);   
        
        % find center of the bounding box bottom line
        b1T = [detectionsT{i}.bbox(1) + (detectionsT{i}.bbox(3) - detectionsT{i}.bbox(1))/2 ;
              detectionsT{i}.bbox(4);
              1.0];
        
        % project it to 3D
        B1T = (params_2D3D.h * inv(params_2D3D.K) * b1T) / (params_2D3D.n' * inv(params_2D3D.K) * b1T);
        
        % apply offset which is a function of yaw and get car's origin (remember approx.)
        offset_Z = getOffsetBasedOnYaw([params_carCuboid.avg_Sz(1); params_carCuboid.avg_Sz(3)], detectionsT{i}.yaw);        
        
        % car's origin in Query Frame
        B1T = B1T + [0; 0; offset_Z];
        
        % translate canonical cuboid
        canonicalCuboid = canonicalCuboid + repmat(B1T', 8,1);
        
        % BOUNDING VOLUME IN QUERY FRAME                
        [bvolumeT1, k1] = getBoundingVolume(B1T, canonicalCuboid, detectionsT{i}.yaw, ... 
                                            detectionsT{i}.sigma_3D, ...
                                            params_carCuboid.sz_ub, params_carCuboid.sz_lb ...
                                           );                        
        % update the fields of the structure
        detectionsT{i}.origin  = B1T;        
        detectionsT{i}.k = k1;
       
        detectionsT{i}.bvolume = bvolumeT1 - repmat([0 params_carCuboid.avg_Sz(2)/2 0], size(bvolumeT1,1), 1);    % offset the h/2 as car ar to be on road             ;                 
        
        bvolume_proj = detectionsT{i}.bvolume;
        bvolume_proj = (params_2D3D.K*bvolume_proj')';
        bvolume_proj(:,1:3) = bvolume_proj(:,1:3)./repmat(bvolume_proj(:,3), 1,3);
        kbvolume_proj = convhull(bvolume_proj(:,1:2));
        bvolume_proj = bvolume_proj(kbvolume_proj,:);
        
        detectionsT{i}.bvolume_proj = bvolume_proj;
    end    
    
    
end