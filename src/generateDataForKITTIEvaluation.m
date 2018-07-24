function [result_for_kitti_eval] = generateDataForKITTIEvaluation(result_for_kitti_eval, fno, detectionsStruct, detections)

    sz = size(result_for_kitti_eval,1);
    
    for i = 1:length(detectionsStruct)
       
        result_for_kitti_eval(sz+i, 1)   = fno;%detectionsStruct{i}.fno;
        result_for_kitti_eval(sz+i, 2)   = detectionsStruct{i}.dno;
        result_for_kitti_eval(sz+i, 3:6) = detections{fno}(i,1:4);        
        result_for_kitti_eval(sz+i, 7)   = 0.9;        
        
    end
      
end