% computes intersection of bbox and search region.
% search area is the Train and bbox is the Query because 
% we are looking for the boundign box in F2 in the search
% region of the propagated volume in F2.
function [score] = get3D2DMatchScore(bbox, searchRegion)
    
    convShapeQ = [bbox(1) bbox(2);
                  bbox(3) bbox(2);
                  bbox(3) bbox(4);
                  bbox(1) bbox(4)];
              
    convShapeT = searchRegion;
    
    % find the intersection of bbox and search region
    [x_in, y_in] = polybool('intersection', convShapeQ(:,1), convShapeQ(:,2), convShapeT(:,1), convShapeT(:,2));    
    
    % compute percentage area of bbox i.e. Q present in the search region    
    area_in = polyarea(x_in, y_in);    
    convShapeQ_area  = polyarea(convShapeQ(:,1), convShapeQ(:,2));    
    
    score = area_in / convShapeQ_area;    
    
end