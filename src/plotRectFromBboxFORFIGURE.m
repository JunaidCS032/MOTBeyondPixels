function plotRectFromBboxFORFIGURE(bbox, fno, col, fc, lw)

    figure(fno);
    hold on;
    
    
    rectangle('position',[bbox(1), bbox(2), bbox(3)-bbox(1)+1, bbox(4)-bbox(2)+1 ],'linewidth',lw,'edgecolor',col,'FaceColor', fc, 'FaceAlpha',0.3);
    hold on;
    
end