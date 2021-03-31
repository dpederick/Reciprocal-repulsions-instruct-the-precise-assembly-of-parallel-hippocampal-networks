%% Load data
clear; close all;
parentdir = '\data';
figdir = '\results';
fn1 = 'z gfp'; fn2 = 'z mch';
figformat = 'png'; 
% figformat = 'svg';
j = 1;
masscut = 0.5;
fns = {fn1,fn2};
junk = dir(parentdir); alldirs = junk(cat(1,junk.isdir)); alldirs = string({alldirs.name});
classdirs = fullfile(parentdir,setdiff(alldirs,[".." "."]));
nclasses = length(classdirs);
labls = cell(nclasses,1);
alldat = cell(nclasses,1);
nexpmts = zeros(nclasses,1);
for m = 1:nclasses
curdir = classdirs(m);
junk = strsplit(curdir,'\'); labls{m} = junk{end};
junk = dir(curdir); alldirs = junk(cat(1,junk.isdir)); alldirs = string({alldirs.name});
expmtdirs = fullfile(curdir,setdiff(alldirs,[".." "."]));
nexpmts(m) = length(expmtdirs);
alldat{m} = cell(nexpmts(m),1);
for d = 1:nexpmts(m)
foldername = char(expmtdirs(d));
fullfn1 = fullfile(foldername,[fn1 '.txt']);
alldat{m}{d}{1} = dlmread(fullfn1);
fullfn2 = fullfile(foldername,[fn2 '.txt']);
alldat{m}{d}{2} = dlmread(fullfn2);
alldat{m}{d}{2} = (alldat{m}{d}{2} - min(alldat{m}{d}{2}(:)))./range(alldat{m}{d}{2}(:))*100;
end
end
winsz = size(alldat{1}{1}{1},2);
%% Binned intensity comparison
seg_intensity = cell(nclasses,1);
seg_intensity2 = cell(nclasses,1);
colstouse = round(winsz*0.8):winsz;
j=1;
disp_result = true;
for m  = 1:nclasses
    rowstouse = cell(nexpmts(m),1);
    for k = 1:nexpmts(m)
        % find central row of last 20% of columns (by center of mass)
        nrows = size(alldat{m}{k}{j},1);
        rowmass = sum(alldat{m}{k}{j}(:,colstouse),2);
        scalefacs = rowmass/sum(rowmass)*nrows;
        centmss = round(sum(scalefacs.*(1:nrows)')/nrows);
        totmass = sum(rowmass);
        % find row window around center w/>50% of total intensity
        rngecheck = 1:floor(min(centmss-1,nrows-centmss));
        masscontained = arrayfun(@(x)(sum(rowmass(centmss+(-x:x))/totmass)),rngecheck);
        masscutcol = find(masscontained>masscut,1);
        rowstouse{k} = centmss+(-masscutcol:masscutcol);
%         tmp = [sum(sum(alldat{m}{k}{2}(1:(rowstouse{k}(1)-1),colstouse),2),1) ...
%                sum(sum(alldat{m}{k}{2}(rowstouse{k},colstouse),2),1)...
%                sum(sum(alldat{m}{k}{2}((rowstouse{k}(end)+1):end,colstouse),2),1)];
%         seg_intensity{m}(k,:) = tmp./sum(tmp);
        tmp = [mean(mean(alldat{m}{k}{2}(1:(rowstouse{k}(1)-1),colstouse),2),1) ...
              mean(mean(alldat{m}{k}{2}(rowstouse{k},colstouse),2),1)...
              mean(mean(alldat{m}{k}{2}((rowstouse{k}(end)+1):end,colstouse),2),1)];
        tmp2 = [mean(mean(alldat{m}{k}{2}([(-1:0)+(rowstouse{k}(1)-1) (rowstouse{k}(end)+1)+(0:1)],colstouse),2),1) ...
              mean(mean(alldat{m}{k}{2}(rowstouse{k},colstouse),2),1)];
        seg_intensity{m}(k,:) = tmp;
        seg_intensity2{m}(k,:) = tmp2;
        if disp_result
        subaxis(2,1,1); imagesc(alldat{m}{k}{1}); box off
        cur_rect1 = [colstouse(1) rowstouse{k}(1)-2-0.4 length(colstouse) 2];
        cur_rect2 = [colstouse(1) rowstouse{k}(1)-0.4 length(colstouse) length(rowstouse{k})-0.1];
        cur_rect3 = [colstouse(1) rowstouse{k}(end)+0.6 length(colstouse) 2];
        hold on;
        rectangle('position',cur_rect1,'edgecolor','k','linewidth',2);
        rectangle('position',cur_rect2,'edgecolor','r','linewidth',2);
        rectangle('position',cur_rect3,'edgecolor','k','linewidth',2);
        titlstr = sprintf('group %s, mouse %d',labls{m},k);
        title(titlstr);
        subaxis(2,1,2); imagesc(alldat{m}{k}{2});
        hold on;
        rectangle('position',cur_rect1,'edgecolor','k','linewidth',2);
        rectangle('position',cur_rect2,'edgecolor','r','linewidth',2);
        rectangle('position',cur_rect3,'edgecolor','k','linewidth',2);
%         pause;
        print(fullfile(figdir,[titlstr '.' figformat]),'-painters',['-d' figformat]);
        clf;
        end
    end
end
%%
figure('position',[1140          74         236         806]); 
clear yl;
for m = 1:nclasses
    subaxis(nclasses,1,m,'ML',0.15,'SV',0.1,'MR',0.3); 
    plot(seg_intensity2{m}','.-','markersize',10)
    disp(labls{m})
    disp(seg_intensity2{m})
    xlim([0.8 2.2]); box off;
    xticks(1:2);
    if m==2, ylabel('Intensity'); end
    if m==nclasses,
        xticklabels({'GFP-','GFP+'});
    else
        xticklabels({});
    end
    yticks([0:50:100]);
    title(strrep(labls{m},'_',' '))
    yl(m,:) = ylim;
end
yl2 = [min(yl(:,1)) max(yl(:,2))];
for m = 1:nclasses
    subaxis(nclasses,1,m);
    ylim(yl2);
    box off;
    if m==3,
        pos = get(gca,'Position');
        legend(num2str((1:5)'),'location','southeastoutside'); legend('boxoff');
        set(gca,'Position',pos);
    end
end
print(fullfile(figdir,['intensity quantification2.' figformat]),'-painters',['-d' figformat]);