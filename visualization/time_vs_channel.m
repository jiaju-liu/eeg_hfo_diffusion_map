function [breaks] = time_vs_channel(set,legend)
%Plots where the detections occur over time
%Inputs:
%set: start and end time of each event. given in rhfe_load
%legend: legend with channel names. also given in rhfe_load
%Outputs:
%breaks: breakpoints in the set matrix

figure;
%Set is nx2 matrix with start and end times of all detected HFOs
hold on;
colors= jet(size(legend,2));
set=set/60000;
set2=set-[zeros(1,2);set(1:(end-1),:)];
%Find where data swtiches to new channel
breaks = [1; find(set2(:,1)<0)-1; size(set,1)];
for i = 1:size(legend,2)
    scatter(set(breaks(i):breaks(i+1),1),i*ones(breaks(i+1)-breaks(i)+1,1),10,colors(i,:),'filled')
end
yticks(1:size(legend,2))
yticklabels(squeeze(legend))
ylabel('Channel')
xlabel('Time (m)')
end