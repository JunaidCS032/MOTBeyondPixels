function plotRectFromBbox(bbox, fno, col, lw)

    figure(fno);
    hold on;
    rectangle('position',[bbox(1), bbox(2), bbox(3)-bbox(1)+1, bbox(4)-bbox(2)+1 ],'linewidth',lw,'edgecolor',col);
    hold on;
    
end