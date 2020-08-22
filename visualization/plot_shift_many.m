function [X1]=plot_shift_many(X)
%Display the effects of shifting before computing the euclidean distance
%Inputs:
%X: data matrix
%Outputs
%X1: shift-aligned data matrix
a=zeros(size(X,1));
dists=[0];
for i = 1:size(X,1)
    for j = (i+1):size(X,1)
        %Find max similarity then dist
        [vals,shift] = xcorr(X(i,:),X(j,:),20);
        [~,ind]=max(vals);
        a(i,j)=shift(ind);
        dists(end+1)=(sum((circshift(X(j,:),shift(ind))-X(i,:)).^2))^(0.5);
    end
end
distsV=std(dists);
dists=sum(dists)/(size(X,1)*(size(X,1)+1)/2);
eucdist = pdist2(X,X);
eucAvg=[0];
for i = 1:size(X,1)
    for j = (i+1):size(X,1)
    eucAvg(end+1)=eucdist(i,j);
    end
end
eucV = std(eucAvg);
eucAvg = mean(eucAvg);
a=a-a';
[~,b]=min(sum(abs(a)));
shifts=a(:,b);
figure
plot(X(b,:))
subplot(1,2,2)
hold on
X1=zeros(size(X));
for i = 1:size(X,1)
    X1(i,:)=circshift(X(i,:),-shifts(i));
end
plot(X1')
title(['Shifted plot n=' num2str(size(X,1)) '. Avg ||2: ' num2str(dists) ' +-' num2str(distsV)])
sort([0 50 100 150 -min(shifts) (200-max(shifts))]);
xlabel('Time (ms)')
ylabel('Normalized Amplitude')
min(shifts)
subplot(1,2,1)
plot(X')
title(['Unshifted plot n=' num2str(size(X,1)) '. Avg ||2: ' num2str(eucAvg) ' +-' num2str(eucV)])
xlabel('Time (ms)')
ylabel('Normalized Amplitude')