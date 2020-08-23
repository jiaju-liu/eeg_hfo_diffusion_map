function make_vid_from_scatter(EEG,dist_func,color_map,name)
%Computes the diffusion map for EEG data and animates the 3d scatter plot
%Inputs:
%EEG: data matrix
%dist_func: diffusion map distance function as a string. see diffusion_map
%color_map: color matrix to group points
%name: output file name

%Initialize video
vid = VideoWriter(name);
open(vid)

%Compute diffusion map
V = diffusion_map(EEG,dist_func);

%Make figure
figure
scatter3(V(:,1),V(:,2),V(:,3),4,color_map,'filled');
title('Shifted L2')
xlabel('Axis 1')
ylabel('Axis 2')
zlabel('Axis 3')
view(225,20)

%60 iterations
loop = 60;

%Make video
F(loop)=struct('cdata',[],'colormap',[]);
for i = 1:loop
view(mod(225+i*(360/loop),360),20)
F = getframe(gcf);
if(size(F.cdata,2)==1120)
writeVideo(vid,F)
end
end
close(vid)
