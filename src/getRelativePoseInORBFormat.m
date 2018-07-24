% given pose matrix in ORB format, it gives relative pose between any two
% frame numbers given as input ;give scale as 1 if you dont want the
% trajectory to be scaled

function relativePose = getRelativePoseInORBFormat(pose_orb, scale, fromFrame, toFrame)    

    R_curr = pose_orb(fromFrame,2:10);
	R_curr = (reshape(R_curr, 3,3))';
	t_curr = pose_orb(fromFrame,11:13)';

	R_next = pose_orb(toFrame,2:10);
	R_next = (reshape(R_next, 3,3))';
	t_next = pose_orb(toFrame,11:13)';
	
	T_curr = [R_curr t_curr.*scale; 0 0 0 1];
	T_next = [R_next t_next.*scale; 0 0 0 1];

	relativePose = inv(T_curr)*T_next;
end
	