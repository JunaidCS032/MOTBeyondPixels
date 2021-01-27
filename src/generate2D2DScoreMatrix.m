% Generate score matrix for the 2D-2D cue
% Author: Junaid Ahmed Ansari @ Robotics Research Center, IIIT Hyderabad
% Email : junaid.ansari@research.iiit.ac.in
function [scoreMatrix_2D2D] = generate2D2DScoreMatrix(featureQ, featureT)
    
    scoreMatrix_2D2D = zeros(size(featureQ,1), size(featureT,1));
        
    % 2D 2D score    
    for i = 1:size(featureQ,1)               
        for j = 1:size(featureT,1)
            
            fQ = featureQ(i,2:4097) - mean(featureQ(i,2:4097));
            fT = featureT(j,2:4097) - mean(featureT(j,2:4097));
            fQ = fQ/norm(fQ);
            fT = fT/norm(fT);
                                
            score = sum(fQ .* fT);
            scoreMatrix_2D2D(i,j) = score;            
            
        end
    end
    
end
