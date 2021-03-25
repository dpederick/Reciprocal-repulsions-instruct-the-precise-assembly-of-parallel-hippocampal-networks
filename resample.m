datafolder = '';
reprocesseddirectory = [datafolder 'resampled\']; mkdir(reprocesseddirectory);
allfilenames = cellstr(ls([datafolder '*.csv']));

nfiles = length(allfilenames);
ndatapoints = 100;
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
