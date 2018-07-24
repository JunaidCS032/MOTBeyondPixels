% draws wire frame of a cuboid
function drawCuboid(cuboid, figNum, col)

	seq = [1, 3, 4, 2, 1, 5, 7, 8, 6, 5, 7, 3, 4, 8, 6, 2 ];
	cuboidWireFrame = cuboid(seq,:);				
	plot3(cuboidWireFrame(:,1), cuboidWireFrame(:, 2), cuboidWireFrame(:,3), col, 'lineWidth',3);
	hold on;
end
