% Multi-Object tracking code for our ICRA paper: 
% "Beyond Pixels: Leveraging Geometry and Shape Cues for Online Multi-Object Tracking" 
% 
% Other open source codes used: 
%      "munkres.m"  by Yi Cao; see the file for more info.                   
%      "distinguishable_colors.m" by Timothy E. Holy" see file for info
%
% Author: Junaid Ahmed Ansari @ Robotics Research Center, IIIT Hyderabad
% Email : junaid.ansari@reseatch.iiit.ac.in


addpath('../third_party');

warning('off','all')
clear ;

         % 33  32  22  vp
all_wts = [0.6 0.4 0.2 0.0];
       
% Using : code by Timothy E. Holy 
dcolors = distinguishable_colors(800);

for ww = 1:size(all_wts,1)
    
    c33 = all_wts(ww,1);
    c32 = all_wts(ww,2);
    c22 = all_wts(ww,3);
    cvp = all_wts(ww,4);       
            
    % road plane normal and camera height
    n =  [0; 1; 0];
    h =  1.72;
    
    % average car parameters in meters [l, h, w];
    avgCar_Sz = [4.3; 2; 2];
    sz_ub     = [34; 31.5; 31.5];
    sz_lb     = [-34; -31.5; -31.5];
      
    K_all     = load('../Data/calib/calib_all_train.txt');
       
    angleMap = containers.Map([ 90:270 90:-1:0 360:-1:270], [0:-1:-180 0:90 90:180]);
        
    hungarian_association = true;
    
    detectionsQ_dnos = [];
    detectionsT_dnos = [];

    % KITTI Train sequence numbers
    for s = [1]
        
        
        seqNo = s;                       
    
        result_for_kitti_eval = [];
        
        total_detecions = 0;
        
        %% SETUP PARAMETERS

        image_path     = sprintf('../Data/images/image_02/train/%04d',seqNo);      
        pose_path      = sprintf('../Data/ORBSLAM_pose/train/%04d/KITTITrajectoryComplete_new',seqNo);              
        K             = [ K_all(seqNo+1,1:3); K_all(seqNo+1,5:7); K_all(seqNo+1,9:11)];
        
        
        % struct which holds the basic attributes of an avg. car
        params_carCuboid = struct('avg_Sz',         avgCar_Sz,    ...
                                  'sz_ub',          sz_ub,        ...
                                  'sz_lb',          sz_lb         ...
                                  );
        
        params_2D3D      = struct('K',              K,            ...
                                  'n',              n,            ...
                                  'h',              h             ...
                                 );
        
        detection       = struct( 'dno',            -1.0,         ...       
                                  'bbox',           zeros(4,1),   ...
                                  'sigma_2D',       zeros(3,3),   ...       
                                  'yaw',            0.0,          ...
                                  'bvolume',        [],           ...       
                                  'bvolume_proj',   [],           ...       
                                  'k',              [],           ...       
                                  'origin',         zeros(3,1),   ...
                                  'start_frame',    -1.0,         ...
                                  'end_frame',      -1.0,         ...
                                  'sigma_3D',       zeros(4,4)    ...
                                );
                        
        num_matches = 0;
        num_false_positive = 0;                
        
        %% SETUP STRUCTS
        global_id = 1;
        
        %% LOAD DATA :
        
        % load camera pose (Monocular ORBSLAM) 
        pose = load(pose_path);      
        
        %load all detections cell array - variable name 'detections'
        load(sprintf('../Data/RRC_Detections_mat/train/%04d/detections.mat', seqNo));
        
        % feautes_2D2D. These features were extracted from our Keypoint Network
        load(sprintf('../Data/Features2D_mat/train/%04d/features_2_2D2D.mat', seqNo));               
        
        start_fno = 1;
        end_fno   = 25;%size(pose,1); 
                     
        %% RUN SCORING
        first_time = 1;
        tempDQ = [];
       
        figure(1);
        
        for i = 1:end_fno - 1
            
            disp(sprintf('Seq<%02d> | frame : %04d', seqNo, i));
            
            if(first_time)
                num_detectionsQ = size(detections{i},1);
            end
            
            num_detectionsT = size(detections{i+1},1);
            
            if(first_time)
                detectionsQ = cell(num_detectionsQ);
            end
            
            detectionsT = cell(num_detectionsT);
            
            if(first_time)
                %detectionsQ_dno = zeros(1,num_detectionsQ);
                % load the detections in to the query and train struct cell arrays x1 y1 x2 y2 confidence ID
                for j = 1:num_detectionsQ
                    
                    detectionsQ{j}              = detection; % emtpy detection struct                    
                    detectionsQ{j}.dno          = global_id;
                    detectionsQ{j}.bbox         = detections{i}(j,1:4);
                    detectionsQ{j}.yaw          = deg2rad(-90) ;                   
                    detectionsQ{j}.sigma_3D     = [1.3 0 0 0; 0 1.1 0 0; 0 0 1.1 0; 0 0 0 deg2rad(0)];
                    %detectionsQ_dno(j)          = global_id;
                    
                    global_id = global_id + 1;  % increment the global ID
                end
            end
            
            % load the detections in to the query and train struct cell arrays x1 y1 x2 y2 confidence ID
            for j = 1:num_detectionsT
                
                detectionsT{j} = detection; % emtpy detection struct
                
                detectionsT{j}.dno          = -1;     % will be given after association
                detectionsT{j}.bbox         = detections{i+1}(j,1:4);
                detectionsT{j}.yaw          = deg2rad(-90) ;
                detectionsT{j}.sigma_3D     = [1.3 0 0 0; 0 1.1 0 0; 0 0 1.1 0; 0 0 0 deg2rad(0)]; % heuristical sigma
                %1.6, 1.1, 1.1 : 0.8 0.1 0.1
            end
            
            
            % extract motion
            motion = [-(pose(i+1,11)-pose(i,11));
                      -(pose(i+1,12)-pose(i,12));
                      -(pose(i+1,13)-pose(i,13));
                        deg2rad(0)];
                        
            % scale the motion             
            motion(1:3,1) =  motion(1:3,1).*(1.72/44);
            
            % propagat detections from current frame to next with
            % uncertainty in motion and heading
            
            [detectionsQ, detectionsT] = propagateDetections(detectionsQ,       ...
                                                             detectionsT,       ...
                                                             params_2D3D,       ...
                                                             params_carCuboid,  ...
                                                             motion             ...
                                                             );
            
            % compute score matrix 
            [scoreMat_3D3D, scoreMat_3D2D] = generateScoreMatrices(detectionsQ, detectionsT);
            [scoreMat_2D2D]                = generate2D2DScoreMatrix(features_2D2D{i}, features_2D2D{i+1});
            
            %normalize scoreMat2D2D from -1:1 to 0:1    
            max2D2D       = max(scoreMat_2D2D');
            max2D2D       = repmat(max2D2D', 1, size(scoreMat_2D2D,2));
            min2D2D       = min(scoreMat_2D2D');
            min2D2D       = repmat(min2D2D', 1, size(scoreMat_2D2D,2));
            scoreMat_2D2D = (scoreMat_2D2D - min2D2D) ./ (max2D2D-min2D2D +0.0000001) ;
            
            scoreMat_viewpoint = zeros(size(scoreMat_3D3D));                     
            
            scoreMat_all = [];
            
            % normalize the scoreMat_2D2D only if it is not empty
            if(~isempty(scoreMat_2D2D))                           
                
                scoreMat_3D2D_mask = (scoreMat_3D2D > 0);
                scoreMat_2D2D = scoreMat_2D2D .* scoreMat_3D2D_mask;
                
                scoreMat_all =  c33*scoreMat_3D3D + c32*scoreMat_3D2D + c22*scoreMat_2D2D + cvp*scoreMat_viewpoint;
                
            else
                
                scoreMat_all = c33*scoreMat_3D3D + c32*scoreMat_3D2D + cvp*scoreMat_viewpoint;
            end                        
                       
            %[max_score, max_score_idx] = max(scoreMat_all');
                        
            imshow(sprintf('%s/%06d%s',image_path,(i-1)+1,'.png'));
            hold on;
            
            
            if(hungarian_association)
                
                % find association using Hungarian
                % Using: Yi Cao's code (refere the munkres.m file)
                [assign, cost]=  munkres(-scoreMat_all);
                
                % give IDs to the  Ts based on assignment or give new ID
                
                for ii = 1:length(assign)
                    
                    % ADD: scoreMat_all(ii,assign(ii)) > 0.005 , to handle
                    % death and birth issues. Not very useful though.
                    if(assign(ii) > 0 && scoreMat_all(ii,assign(ii)) > 0.0   )
                        detectionsT{assign(ii)}.dno = detectionsQ{ii}.dno;
                    end
                end
                
            end
            
            if(~hungarian_association)
                
                for ii = 1:length(detectionsQ)
                    ii
                    scoreQT = scoreMat_all(ii,:);
                    [max_v, max_id] = max(scoreQT)
                    
                    % if max value above some threshold associate and give same ID
                    if(max_v > 0.15)
                        % give the Q's id to matching T
                        detectionsT{max_id}.dno = detectionsQ{ii}.dno;
                        
                    end
                    
                end
            end
            
            %         for kk = 1:length(detectionsQ)
            %
            %              plot(detectionsQ{kk}.bvolume_proj(:,1), detectionsQ{kk}.bvolume_proj(:,2), '-sc', 'linewidth',3);
            %         end
            
            
            for kk = 1:length(detectionsT)
                tbbox = detectionsT{kk}.bbox;
                myprect = [tbbox(1) tbbox(2);
                           tbbox(3) tbbox(2);
                           tbbox(3) tbbox(4);
                           tbbox(1) tbbox(4);
                           tbbox(1) tbbox(2) ];
                       
                if(detectionsT{kk}.dno > 0)
                    
                    fill(myprect(:,1), myprect(:,2),dcolors(detectionsT{kk}.dno,:),'FaceAlpha',0.4, 'edgecolor', dcolors(detectionsT{kk}.dno,:), 'linewidth',2);
                    
                else
                    
                    fill(myprect(:,1), myprect(:,2),'k','FaceAlpha',0.5);
                    
                end
                
                
            end
            
            
            for ii = 1:length(detectionsT)
                
                if(detectionsT{ii}.dno == -1)
                    detectionsT{ii}.dno = global_id;
                    global_id = global_id + 1;
                end                                

                % plotRectFromBbox(detectionsT{ii}.bbox,2,  'y'    ,2);
                text( detectionsT{ii}.bbox(1)+4, detectionsT{ii}.bbox(2)-10,          ...
                      sprintf('%d',detectionsT{ii}.dno), 'color', 'k',                ...
                      'backgroundcolor','w', 'FontWeight','bold'                      ...
                    );                                  
                
            end                                              
            
             text(1, 20, ...
                  sprintf('Number of Detections: %04d',length(detectionsT)), 'color', 'k',                ...
                  'backgroundcolor','w'                                                                   ...
                 );  
            
            if(first_time)
                result_for_kitti_eval = generateDataForKITTIEvaluation(result_for_kitti_eval, i, detectionsQ, detections)           ;
            end
            
            result_for_kitti_eval = generateDataForKITTIEvaluation(result_for_kitti_eval, i+1, detectionsT, detections) ;
            
            
            first_time  = 0;
            tempDQ      = detectionsQ;
            detectionsQ = detectionsT;            
                        
            pause(0.1)            
            
            hold off;          
        end        
        
        % save the results to file
        dlmwrite(sprintf('../results/train/%04d.txt', seqNo ),result_for_kitti_eval,' ');
                
    end
    
end



