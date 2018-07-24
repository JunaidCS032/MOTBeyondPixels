function score = get3D3DMatchScore(bvolumeQ, bvolumeT)

    % for now get the bottom plane of the volumes; later we will do the
    % full 3D 3D intersection test
   
    kbvolumeQ_xz = convhull(bvolumeQ(:,1),  bvolumeQ(:,3));
    bvolumeQ_xz  = [bvolumeQ(kbvolumeQ_xz,1) bvolumeQ(kbvolumeQ_xz,3)];
        
    kbvolumeT_xz = convhull(bvolumeT(:,1),  bvolumeT(:,3));
    bvolumeT_xz = [bvolumeT(kbvolumeT_xz,1) bvolumeT(kbvolumeT_xz,3)];
    
    % find the intersection of bbox and search region
    [x_in, y_in] = polybool('intersection', bvolumeQ_xz(:,1), bvolumeQ_xz(:,2), bvolumeT_xz(:,1), bvolumeT_xz(:,2));    
    
    % compute percentage area of bbox i.e. Q present in the search region    
    area_in = polyarea(x_in, y_in);    
    bvolumeQ_xz_area  = polyarea(bvolumeQ_xz(:,1), bvolumeQ_xz(:,2));    
    
    score = area_in / bvolumeQ_xz_area;    
end