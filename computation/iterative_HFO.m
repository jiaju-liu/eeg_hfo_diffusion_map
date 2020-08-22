function aux = iterative_HFO(path1,path2,detect)
%Entire HFO detection pipeline. No interface or human supervision needed.
%Output is saved in the .rhfe RippleLab format
%path1 = location of file (must end with /)
%path2 = name of file
%detect: detection method ('STE' or 'MNI')
%% Get file info
path.path = char(path1);
path.name = char(path2);
[~,~,~,~] = eeglab;
st_FileData = f_GetHeader(path);
st_FileData.v_Labels
chanNames = cell(0,0);
numel(st_FileData.v_Labels)
for i = 1:numel(st_FileData.v_Labels)
    chanNames{end+1} = st_FileData.v_Labels{i};
end
chanNames = unique(chanNames);
save([path.name(1:(end-4)) '.rhfe'], 'st_FileData')

%% Record filtered data from those intervals
for j = 1:numel(st_FileData.v_Labels)
    %j's index the channels
    strcat(path.path,path.name);
    m_EvtLims=[];
    v_Intervals=[];
    %Since there is too much data, we add a loop to split the data into
    %1 hour segments. s_Time is in minutes but 'blockrange' is in reconds
    for k = 1:ceil(st_FileData.s_Time/60)
        %EEGLAB bug requires you to load channel 1 + another channel then
        %remove channel 1
        EEG = pop_biosig(strcat(path.path,path.name),'channels',[1 j],...
            'blockrange',[3600*(k-1) min(3600*k,60*st_FileData.s_Time)],...
            'importevent','off','importannot','off');
        EEG = pop_select( EEG,'channel',{EEG.chanlocs(end).labels});
        %EEG.data will be filtered while EEG.data1 remains unfiltered
        EEG.data1=EEG.data;
        s_Filter = f_DesignIIRfilter(EEG.srate,[80 500],[80-0.5 500+0.5]);
        
        %Skip channel 'EDF Annotations'
        if strcmp(chanNames{j},'EDF Annotations')
            continue
        end
        
        %'-' cannot be stored in the struct's field
        EEG.chanlocs.labels=regexprep(chanNames{j},'[-]','');
        EEG.chanlocs.labels
        EEG.data = f_FilterIIR(EEG.data,s_Filter);
        
        if(strcmp(detect,'STE'))
            [tempm_EvtLims, ~,info] = findHFOxSTE(EEG,1,'avg');
        elseif strcmp(detect,'MNI')
            [tempm_EvtLims, ~,info] = findHFOxMNI(EEG,1);
        end
        
        %% Build requisite variables to save under aux.(EEG.chanlocs.labels)
        m_IntervLims = zeros(size(tempm_EvtLims));
        m_Rel2IntLims = zeros(size(tempm_EvtLims));
        s_IntWidth      = 2;
        s_IntWidth      = s_IntWidth .* EEG.srate;
        s_IntMean       = round(s_IntWidth / 2);
        for kk = 1:size(tempm_EvtLims,1)
            s_EvtMean   = round(mean(tempm_EvtLims(kk,:)));
            s_PosIni    = s_EvtMean - s_IntMean;
            s_PosEnd    = s_EvtMean + s_IntMean;
            if s_PosIni < 1
                s_PosIni    = 1;
                s_PosEnd    = s_IntWidth;
            elseif s_PosEnd > numel(EEG.times)
                s_PosIni    = numel(EEG.times) - s_IntWidth;
                s_PosEnd    = numel(EEG.times);
            end
            m_IntervLims(kk,:)   = [s_PosIni,s_PosEnd];
            m_Rel2IntLims(kk,:)  = tempm_EvtLims(kk,:)- s_PosIni + 1;
        end
        tempv_Intervals = cell(size(tempm_EvtLims,1),1);
        for i = 1:size(tempm_EvtLims,1)
            tempv_Intervals(i)={EEG.data1(1,m_IntervLims(i,1):m_IntervLims(i,2))'};
        end
        v_Intervals = [v_Intervals; tempv_Intervals];
        m_EvtLims=[m_EvtLims; (tempm_EvtLims+EEG.srate*(k-1)*3600)];
    end
    %Okay
    aux =struct;
    if strcmp(chanNames{j},'EDF Annotations')
        continue
    end
    EEG.chanlocs.labels=regexprep(chanNames{j},'[-]','');
    
    %% Add variables to aux.(EEG.chanlocs.labels) and save the result
    aux.(EEG.chanlocs.labels).st_HFOSetting = info;
    aux.(EEG.chanlocs.labels).st_HFOInfo.str_ChLabel=st_FileData.v_Labels(j);
    aux.(EEG.chanlocs.labels).st_HFOInfo.s_Sampling=EEG.srate;
    if(strcmp(detect,'STE'))
        aux.(EEG.chanlocs.labels).st_HFOInfo.str_DetMethod='Short Time Energy';
    elseif strcmp(detect,'MNI')
        aux.(EEG.chanlocs.labels).st_HFOInfo.str_DetMethod='MNI';
    end
    aux.(EEG.chanlocs.labels).st_HFOInfo.s_ChIdx=j;
    aux.(EEG.chanlocs.labels).st_HFOInfo.m_EvtLims=m_EvtLims;
    aux.(EEG.chanlocs.labels).st_HFOInfo.m_IntervLims = m_IntervLims;
    aux.(EEG.chanlocs.labels).st_HFOInfo.m_Rel2IntLims = m_Rel2IntLims;
    aux.(EEG.chanlocs.labels).st_HFOInfo.v_EvType=ones(size(m_EvtLims,1),1);
    aux.(EEG.chanlocs.labels).v_Intervals=v_Intervals;
    save([path.name(1:(end-4)) '.rhfe'],'-struct','aux', '-append')
    clear EEG
end
'done'