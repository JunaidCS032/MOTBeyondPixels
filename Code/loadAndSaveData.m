clear

detection_folder = 'detections_rrc_test';

savepath_detection = sprintf('/home/junaid/Research@IIITH/ICRA_18_MOT/data/KITTI_TEST_SEQ/%s_mat',detection_folder);

for i = [0:28]
    
    seqNo = i
    
    detections_path    = sprintf('/home/junaid/Research@IIITH/ICRA_18_MOT/data/KITTI_TEST_SEQ/%s/%02d/',detection_folder,seqNo);
    
    num_frames = length(dir(detections_path)) - 2
        
    %load all detections in 'detections' cell array
    detections = cell(num_frames,1);
    for i = 1 : num_frames
        detections{i} = load(sprintf('%s/%06d.txt',detections_path,i-1));
    end    
                    
    save(sprintf('%s/%s_%02d', savepath_detection, 'detections_rrc_test',seqNo), 'detections');    
    
end