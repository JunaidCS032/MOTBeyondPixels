% this function outputs the bounding box in the format [x1 y1 x2 y2] for
% the provided points. pts is an Nx2 matrix.

function bbox = makeBboxFromPoints(pts)

    [~ id_max] = max(pts);
    [~ id_min] = min(pts);
    
    bbox = [pts(id_min, 1); pts(id_min,2); pts(id_max,1); pts(id_max,2)];
    
end