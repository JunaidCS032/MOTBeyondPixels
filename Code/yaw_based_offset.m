cuboidX_2D_F2 = [-2 -1; 2 -1 ; 2 1; -2 1];
rot = [cosd(-80) -sind(-80); sind(-80) cosd(-80)];
cuboidX_2D_F2 = (rot*cuboidX_2D_F2')';

% compute the bounding box of new projected box	
	[~, idx_max] = max(cuboidX_2D_F2)
	[~, idx_min] = min(cuboidX_2D_F2)
	
    cuboidX_2D_F2 = cuboidX_2D_F2';
	propagated_2D_bbox_F12 = [ cuboidX_2D_F2(1,idx_min(1)) cuboidX_2D_F2(2,idx_max(2));
					  	  cuboidX_2D_F2(1,idx_max(1)) cuboidX_2D_F2(2,idx_max(2));
			 		  	  cuboidX_2D_F2(1,idx_max(1)) cuboidX_2D_F2(2,idx_min(2));			 		 
			 		  	  cuboidX_2D_F2(1,idx_min(1)) cuboidX_2D_F2(2,idx_min(2))]

plot(cuboidX_2D_F2(1,:), cuboidX_2D_F2(2,:), '-b')
hold on;
plot(propagated_2D_bbox_F12(:,1), propagated_2D_bbox_F12(:,2), '-^')
