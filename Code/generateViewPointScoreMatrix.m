function [scoreMat_viewpoint] = generateViewPointScoreMatrix(viewPointQ, viewPointT)
   
    vQ = [cos(viewPointQ) sin(viewPointQ)];
    vT = [cos(viewPointT) sin(viewPointT)];
   
    scoreMat_viewpoint = vQ * (vT');
    
end