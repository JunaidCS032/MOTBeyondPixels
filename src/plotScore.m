% plots scores as images
function plotScore(detectionsQ, detectionsT, scoreMat, fno, scale,cap_tit, cap_ya, cap_xa)

    figure(fno);
    imshow(imresize(scoreMat,scale,'nearest'));
    hold on;
    
    %rows: T
    for i = 0:length(detectionsT)-1
        text((i*scale + scale/2 + 1), 1, sprintf('%d',detectionsT{i+1}.dno),'color','b','backgroundcolor','y');        
    end

    %cols: Q
    for i = 0:length(detectionsQ)-1
        text(1, (i*scale +scale/2 + 1), sprintf('%d',detectionsQ{i+1}.dno),'color','b','backgroundcolor','y');        
    end
    
    title(cap_tit);
    xlabel(cap_xa);
    ylabel(cap_ya);
    
    colorbar('Ticks', [0,0.5,1], ...
         'TickLabels',{'No Match','Ambiguous','Full Match'});
end