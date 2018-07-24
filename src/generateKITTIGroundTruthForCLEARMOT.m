function gt = generateKITTIGroundTruthForCLEARMOT(tracklets, fs, fe)
    
    gt = [];
    
    for i = fs:fe   
        
        gt_f = [];
        cnt = 1;
        for j = 1:length(tracklets{i})
       
            % only if car and not dont-care
            if(strcmp(tracklets{i}(j).type,'Car') )
                           
                % add bbox
                bbox = [tracklets{i}(j).x1 tracklets{i}(j).y1 tracklets{i}(j).x2 tracklets{i}(j).y2];                                        
                gt_f(cnt,:) = [ double(tracklets{i}(j).id)+1 bbox(1) bbox(2) bbox(3) bbox(4) ]  ;                                                    
                cnt = cnt + 1;
            end
            
        end
        gt{i-(fs-1)} = gt_f;
        
    end

end

% 
% 
%   for i = 1:length(tracklets)
%        
%         % to store id
%         result(i).trackerData.idxTracks = [];
%         
%         for j = 1:length(tracklets{i})
%        
%             % only if car and not dont-care
%             if(strcmp(tracklets{i}(j).type,'Car'))
%             
%                 % append the id
%                 result(i).trackerData.idxTracks = [result(i).trackerData.idxTracks   tracklets{i}(j).id+1];
% 
%                 % add bbox
%                 bbox = [tracklets{i}(j).x1 tracklets{i}(j).y1 tracklets{i}(j).x2 tracklets{i}(j).y2]; 
%                 bbox = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
%                 result(i).trackerData.target(tracklets{i}(j).id+1).bbox = bbox;
%                 
%             end
%             
%         end
%         
%     end