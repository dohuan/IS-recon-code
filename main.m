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
n = size(X,1);

sur_thres = 0.007;

max_ = max(X);
option.x_max = max_(1);
option.y_max = max_(2);
option.z_max = max_(3);
min_ = min(X);
option.x_min = min_(1);
option.y_min = min_(2);
option.z_min = min_(3);

gridsize = 100;
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

% --- Create random index of the cloud
index = randperm(n);
%dp = [0.1 0.5 0.7 1]; % data portion
dp = 1;
for i=1:size(dp,2)
    ix = index(1:round(dp(i)*n));
    data(i).X = X(ix,:);
    data(i).y = zeros(size(data(i).X,1),1);
    
    [data(i).est, ~] = gp(hyp, @infExact, meanfunc, covfunc, likfunc,...
        data(i).X, data(i).y, S);
    S_est = [];
    for j=1:size(data(i).est,1)
        if (data(i).est(j)>=0&&data(i).est(j)<=sur_thres)
            S_est = [S_est;S(j,:)];
        end
    end
    data(i).S_est = S_est;
    plySave = ['./results/bunny_PLY_2/bunny_' num2str(size(data(i).X,1)) '.ply'];
    exportMesh(S_est,plySave);
    %figure(i)
    %scatter3(S_est(:,1),S_est(:,2),S_est(:,3));
    
end



%%                              THE END
ellapsedTime = toc;
fprintf('Ellapsed time: %.2f (mins)\n',ellapsedTime/60);
EndSound = load('gong');
sound(EndSound.y,EndSound.Fs);