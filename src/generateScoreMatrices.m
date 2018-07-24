% This functions, when given the detectionsQ and detectionsT 
% (after propagation step) gives the 3D3D and 3D2D intesection
% area score
function [scoreMatrix_3D3D, scoreMatrix_3D2D] = generateScoreMatrices(detectionsQ, detectionsT)

    % score_3D2D   = get3D2DMatchScore(detectionsT(1).bbox, detectionsQ(1).bvolume_proj);
    % score_3D3D = get3D3DMatchScore(detectionsT(2).bvolume, detectionsQ(1).bvolume);
    
    scoreMatrix_3D3D = zeros(length(detectionsQ), length(detectionsT));
    scoreMatrix_3D2D = zeros(length(detectionsQ), length(detectionsT));
    
    
    % 3D 3D score    
    for i = 1:length(detectionsQ)                
        for j = 1:length(detectionsT)
            
            % remember all the shapes are in F2, and we are matching shapes
            % i.e. 3D bvolumes and their bboxes in F2 with their
            % corresponding search bounding volumes and bounding volume
            % projections which are the propagated volumes of cars in F1. 
            % Hence here Q is T and vice-versa
            scoreMatrix_3D3D(i,j) = get3D3DMatchScore(detectionsT{j}.bvolume, detectionsQ{i}.bvolume);            
            scoreMatrix_3D2D(i,j) = get3D2DMatchScore(detectionsT{j}.bbox, detectionsQ{i}.bvolume_proj);            
        end
    end
    
end