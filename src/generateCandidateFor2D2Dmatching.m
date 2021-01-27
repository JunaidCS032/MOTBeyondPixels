% Author: Junaid Ahmed Ansari @ Robotics Research Center, IIIT Hyderabad
% Email : junaid.ansari@research.iiit.ac.in
function generateCandidateFor2D2Dmatching(scoreMat_3D2D, thres, fpath, fno, detectionsQ, detectionsT)
    
    fname = sprintf('%s%06d.txt',fpath,fno);
    fid   = fopen(fname,'w+');
    
    Q_dno = zeros(length(detectionsQ), 1);    
    T_dno = zeros(length(detectionsT), 1);
    
    % save detection numbers into array for speed
    for i = 1:length(detectionsQ)
        Q_dno(i) = detectionsQ{i}.dno;
    end
    
    for i = 1:length(detectionsT)
        T_dno(i) = detectionsT{i}.dno;
    end
    
    % find candidate matches based on 3D2D for 2D2D matching
    for i = 1:length(detectionsQ)
        i
        cand_match = [];
        cand_match = T_dno(find(scoreMat_3D2D(i,:) > thres))        
        cand_match = [detectionsQ{i}.dno; length(cand_match); cand_match]'
        fprintf(fid,'%d ',cand_match); 
        fprintf(fid,'\n');
    end
    
        
    fclose(fid);    
end



