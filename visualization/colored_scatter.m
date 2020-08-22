function colored_scatter(HFO_Count,V,chanind)
%function [fig1] = coloredScatterRHFE(HFO_Count,V,chanind)
%fig1 =figure;
%Set is nx2 matrix with start and end times of all detected HFOs
hold on;
colors= jet(size(HFO_Count,2));
HFO_Count= [2 HFO_Count]-1;
%Find where data swtiches to new channel
if exist('chanind','var')
    for i = chanind
        ind =sum(HFO_Count(1:i)):sum(HFO_Count(1:(i+1)));
        scatter3(V(ind,1),V(ind,2),V(ind,3),10,colors(i,:),'filled')
    end
else
    for i = 1:(size(HFO_Count,2)-1)
        ind =sum(HFO_Count(1:i)):sum(HFO_Count(1:(i+1)));
        scatter3(V(ind,1),V(ind,2),V(ind,3),10,colors(i,:),'filled')
    end
end
%for i = 1:size(chanlocs,2)
%   figure
%   scatter3(V(breaks(i):breaks(i+1),4),V(breaks(i):breaks(i+1),2),V(breaks(i):breaks(i+1),3),10,colors(i,:),'filled')
%end
end