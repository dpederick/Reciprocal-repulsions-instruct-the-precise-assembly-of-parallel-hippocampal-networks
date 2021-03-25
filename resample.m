datafolder = 'F:\Cre-L2 CA1\15\sub\raw data\'; % replace
reprocesseddirectory = [datafolder 'resampled\']; mkdir(reprocesseddirectory);
allfilenames = cellstr(ls([datafolder '*.csv']));
% change to xls if needed. This will load all xls files in the directory
nfiles = length(allfilenames);
ndatapoints = 100; % can change if you need
datainds = 1:ndatapoints;
for i = 1:nfiles
    curdatafile = [datafolder allfilenames{i}]; 
    data = xlsread(curdatafile);
    actualinds = linspace(1,ndatapoints,size(data,1));
    resampleddata = interp1(actualinds',data,datainds');
    resampleddata(:,1) = datainds;
    [~,curname,~] = fileparts(allfilenames{i});
    xlswrite([reprocesseddirectory curname '_resamp.xlsx'],resampleddata);
end