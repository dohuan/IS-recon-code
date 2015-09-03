function Y = downSampling(X,ratio)
[m,~]=size(X);

span = (m-mod(m,ratio))/ratio;

for i=1:span
    Y(i,:) = X(i*ratio,:);
end
% if mod(m,ratio)==0
%     Y=zeros(m/ratio,n);
%     for i=1:size(Y,1)
%         Y(i,:)=X(i*ratio,:);
%     end
% else
%     error('myApp:argChk', 'ratio does not match')
% end
end