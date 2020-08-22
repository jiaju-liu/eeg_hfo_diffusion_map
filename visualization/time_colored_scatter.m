function [fig1,breaks] = timeColoredScatter(set,V,legend,num_dimensions)
%Scatter plot for diffusion map eigenvectors. Like a normal scatter, but
%points a colored by when in the recording they were detected
%Inputs:
%set: start and end time of each event. given in rhfe_load
%V: diffusion map eigenvectors
%legend: legend with channel names. also given in rhfe_load
%num_dimensions: dimension to display results in
%Outputs:
%fig1: plotted figure
%breaks: breakpoints in the set matrix

clear fig1
fig1 = figure;
%Set is nx2 matrix with start and end times of all detected HFOs
hold on;
set2 = set-[zeros(1,2);set(1:(end-1),:)];

%Find where data swtiches to new channel
breaks = [1; find(set2(:,1)<0)-1; size(set,1)];
colorTemplate = jet(1920);
endTime = max(set);

%Change colors to match how far along it is in recording
colors = colorTemplate(max(floor(1920*set/endTime),1),:);
if num_dimensions == 2
    scatter(V(:,1),V(:,2),5,colors,'filled');
else
    scatter3(V(:,1),V(:,2),V(:,3),5,colors,'filled');
end
yticks(1:size(legend,2))
yticklabels(squeeze(legend))
ylabel('Channel')
xlabel('Time (ms)')
end