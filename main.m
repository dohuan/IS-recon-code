close all
clear
clc
%%
tic
addpath(genpath('./gpml'));
addpath(genpath('./HausdorffDist'));

M = load('./data/bunny_r_10.mat');
X = M.pts;
y = zeros(size(X,1),1);
clear M;

max_ = max(X);
option.x_max = max_(1);
option.y_max = max_(2);
option.z_max = max_(3);
min_ = min(X);
option.x_min = min_(1);
option.y_min = min_(2);
option.z_min = min_(3);

gridsize = 50;
option.x_mesh = linspace(option.x_min,option.x_max,gridsize);
option.y_mesh = linspace(option.y_min,option.y_max,gridsize);
option.z_mesh = linspace(option.z_min,option.z_max,gridsize);
[S1,S2,S3] = meshgrid(option.x_mesh,option.y_mesh,option.z_mesh);
S = [S1(:),S2(:),S3(:)];

covfunc  = @covSEard; 
likfunc  = @likGauss;
meanfunc = @meanOne;

hyp.cov(1) = log(.006);   % bandwidth of x
hyp.cov(2) = log(.006);   % bandwidth of y
hyp.cov(3) = log(.006);  % bandwidth of z
hyp.cov(4) = log(1);
hyp.lik = log(0.03);

[est, var] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, X, y, S);

sur_thres = 0.007;
S_est = [];
for i=1:size(est,1)
	if (est(i)>=0&&est(i)<=sur_thres)
		S_est = [S_est;S(i,:)];
	end
end
scatter3(S_est(:,1),S_est(:,2),S_est(:,3));
hold on
scatter3(X(:,1),X(:,2),X(:,3),'rx');


%%                              THE END
ellapsedTime = toc;
fprintf('Ellapsed time: %.2f (mins)\n',ellapsedTime/60);
EndSound = load('gong');
sound(EndSound.y,EndSound.Fs);