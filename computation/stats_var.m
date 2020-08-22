function stats_var(file_path)
%Compute various cluster metrics for different unsupervised learning
%results on the data set
%Inputs:
%file_path: the path of the .rhfe file to analyze

%Load data
[~,~,~,data]=rhfe_load(file_path);
data = normalize(data')';
totSize = size(data,1);
idx= zeros(size(data,1),3);

%Compute metrics
%1)Kmeans
[kmeanR,kmeanV,optind(1),idx(:,1)]=val(data,data);

%2)Diffusion map euclidean distance 
V=diffusion_map(data,'euclidean');
[diffR,diffV,optind(2),idx(:,2)]=val(V(:,1:3),data);

%3)t-SNE with shifted distance
dist_func = @(x1,X)shift_dist(x1,X);
X=tsne(data,'Distance',dist_func);
[tSNER,tSNEV,optind(3),idx(:,3)]=val(X,data);

%2)Diffusion map shifted distance 
V1=diffusion_map(data,'shift');
[mapR,mapV,optind(4),idx(:,4)]=val(V1(:,1:3),data);

%Normal (no unsupervised learning)
indicies = randperm(totSize);
if totSize>1000
    for i = 1:floor(totSize/1000)
        [normR(i), normP(i)]=findxCorr(data(indicies((1:1000)+1000*(i-1)),:),ones(1000,1),1,0);
    end
else
    [normR(1), normP(1)]=findxCorr(data,ones(totSize,1),1,0);
end

save(['outputdata' file_path(9:(end-5))])

function [dataR,dataV,optind,idx] = val(data,long)
idx = zeros(size(data,1),50);
for k=1:50
    idx(:,k) = kmeans(data,k);
end
eva = evalclusters(data,idx,'silhouette');
[~,optind]=max(eva.CriterionValues);
dataR=zeros(1,optind);
dataV=zeros(1,optind);
idx = idx(:,optind);
for i=1:optind
    [dataR(i), dataV(i)]=findxCorr(long,idx,i,0);
end