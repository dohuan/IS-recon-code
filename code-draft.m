% ---- downsample the cloud point from 
%[vertex,face] = read_ply('./data/happy_recon/happy_vrip.ply');
[vertex,face] = read_ply('./data/bunny/reconstruction/bun_zipper.ply');
pts  = downSampling(vertex,10);
save('./data/bunny_r_10.mat','pts');