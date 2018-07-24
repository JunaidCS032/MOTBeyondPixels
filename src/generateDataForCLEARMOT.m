function [result] = generateDataForCLEARMOT(result, fno,fs, detectionsStruct)            
    
    % to store id
    result(fno-(fs-1)).trackerData.idxTracks = [];
    result(fno-(fs-1)).trackerData.target = [];
    
    for i = 1:length(detectionsStruct)
       
        % append the id
        result(fno-(fs-1)).trackerData.idxTracks = [result(fno-(fs-1)).trackerData.idxTracks   detectionsStruct{i}.dno];
        
        % add bbox
        bbox = detectionsStruct{i}.bbox;
        bbox = [bbox(1) bbox(2) bbox(3)-bbox(1)+1 bbox(4)-bbox(2)+1];
        result(fno-(fs-1)).trackerData.target(detectionsStruct{i}.dno).bbox = bbox;
        
    end
    
end