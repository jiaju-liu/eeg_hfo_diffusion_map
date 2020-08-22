function [V,D,HFO_Count,data,raw_data,set,legend] = rhfe_load(file_path)
%Loads data in matrix form from a .rhfe (RippleLab analysis) file
%Inputs:
%file_path: file path of .rhfe file
%Outputs:
%V: diffusion map eigenvectors
%D: diffusion map eigenvalues
%HFO_Count: N x 1 matrix where N is the number of channels. i'th entry is
%the number of HFOs detected in channel i
%data: filtered data
%raw_data: unfiltered data
%set: start and end time of each event
%legend: file with channel names

newData1 = importdata(file_path);
load('LocationsEEG.mat')

%Initialize variables
vars = fieldnames(newData1);
data = [];
set= [];
raw_data= [];
HFO_Count=[];
legend=cell(0,0);

%Design filter
s_Filter = f_DesignIIRfilter(newData1.(char(vars{2})).st_HFOInfo.s_Sampling,...
    [80 500],[80-0.5 500+0.5]);

%Load data
for i = 1:length(vars)
    for j = 1:358
        if(vars{i}==posLoc(j).VarName2)
            temp = newData1.(char(vars{i}));
            legend{end+1}=char(vars{i});
            set = [set; temp.st_HFOInfo.m_EvtLims];
            try
                mid = floor(size(temp.v_Intervals{1},2)/2);
                tempSize = size(temp.v_Intervals,1);
            catch
                tempSize = 0;
            end
            HFO_Count=[HFO_Count tempSize];
            for k = 1:size(temp.v_Intervals,1)
                %Apply filter
                v_SignalFilt = f_FilterIIR(temp.v_Intervals{k},s_Filter);
                data(end+1,:)=v_SignalFilt((-149:150)+mid);
                raw_data(end+1,:)=temp.v_Intervals{k}((-149:150)+mid);
            end
        end
    end
    if(strcmp(vars{i},'BurstsNO'))
        temp = newData1.(char(vars{i}));
        legend{end+1}=char(vars{i});
        try
            mid = floor(size(temp.v_Intervals{1},2)/2);
            tempSize = size(temp.v_Intervals,1);
        catch
            tempSize = 0;
        end
        HFO_Count=[HFO_Count 50];
        
        tempData=zeros(100,100);
        for k = 1:100
            v_SignalFilt = f_FilterIIR(temp.v_Intervals{k},s_Filter);
            tempData(k,:)=v_SignalFilt((-49:50)+mid);
        end
        data = [data;tempData];
    end
end

%Compute diffusion map
[V,D] = diffusion_map(data,'mahalanobis');