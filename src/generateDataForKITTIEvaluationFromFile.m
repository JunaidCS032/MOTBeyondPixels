function [result_for_kitti_eval] = generateDataForKITTIEvaluationFromFile(result_for_kitti_eval, fno, dnos, detections)

    sz = size(result_for_kitti_eval,1);
    
    for i = 1:length(dnos)
       
        result_for_kitti_eval(sz+i, 1)   = fno;
        result_for_kitti_eval(sz+i, 2)   = dnos(i);
        result_for_kitti_eval(sz+i, 3:6) = detections{fno}(i, 1:4);        
        result_for_kitti_eval(sz+i, 7)   = 0.9;        
         
    end       

end