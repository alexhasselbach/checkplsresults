%% Check pls results
% Arg 1: either a result variable or a path to a .mat containing the result variable (only required argument)
% Arg 2: set to 1 to make plots of the data
% Arg 3: names of datamat1 variables or excel sheet (from R, i.e. first column header blank); will be the labels on the graph
% Arg 4: names of datamat2 variables or excel sheet (from R, i.e. first column header blank)
% Arg 5: Number of groups for group PLS

% Example line: checkplsresults(result,1,'MCIcogdataStacked_4.19.csv','MCIhealthMale_4.19.csv',2)
%    Results loaded to 'result' variable
%    Graphing turned on
%    Cog data csv
%    One group's health data csv (assumes both groups are in the same order)
%    Number of groups (2)

function checkplsresults(varargin)
if isa(varargin{1},'char'); load(varargin{1},'result'); elseif isa(varargin{1},'struct'); result=varargin{1}; else; error('Put something better as the input.'); end

%---------Variables you can change----------------------------
headerstart=3;    %column where your variable labels start (args 3 and 4)
LVsigvalue=0.05; %p value for a "significant" LV
BSRval = 3;          %z-score for limiting BSR values (absolute)
%-----------------------------------------------------------------

sigLVs=find(result.perm_result.sprob<=LVsigvalue);
cov=result.s.^2/(sum(result.s.^2));

if length(varargin)>2
   lvlabels=varargin{3};
   if isa(varargin{3},'char'); temptable=readtable(varargin{3});lvlabels=string(temptable.Properties.VariableNames(headerstart:end));end
   for i=1:length(lvlabels);lvlabels(i)=sprintf('%i %s',i,lvlabels(i));end
else
   lvlabels=string(1:size(result.lvcorrs,2));
end

if length(varargin)>3
   BSRlabels=varargin{4};
   if isa(varargin{4},'char'); temptable=readtable(varargin{4});BSRlabels=string(temptable.Properties.VariableNames(headerstart:end));end
   for i=1:length(BSRlabels);BSRlabels(i)=sprintf('%i %s',i,BSRlabels(i));end
else
   BSRlabels=string(1:size(result.boot_result.compare_u,1));
end

if length(varargin)>4
    lvlabels=repmat(lvlabels,varargin{5});
    lvlabels=lvlabels(1,:);
    for i=1:length(lvlabels);lvlabels(i)=sprintf('%i %s',i,lvlabels(i));end
end
    
for i=1:length(sigLVs)
   pval=result.perm_result.sprob(sigLVs(i));
   lvcorrs=result.lvcorrs(:,sigLVs(i));
   covar=cov(sigLVs(i));
   sigBSR=find(abs(result.boot_result.compare_u(:,sigLVs(i)))>=BSRval);
   
   BSRs=result.boot_result.compare_u(sigBSR,sigLVs(i));
   
   rangelvs(1,:)=result.boot_result.llcorr(:,sigLVs(i));
   rangelvs(2,:)=result.boot_result.ulcorr(:,sigLVs(i));
   
   rangelog=rangelvs>=0;
   rangemath=abs(abs(rangelog(1,:)-rangelog(2,:))-1);
   sigLVcorrs=find(rangemath);
   
   fprintf('\n--Significant LV: %i--\n',sigLVs(i))
   fprintf('p=%0.4f\n',pval)
   fprintf('Covariance: %0.4f\n',covar)
   fprintf('\nlvcorrs (sig only):\n')
   for j=1:length(sigLVcorrs);fprintf('%s: %0.4f\n',lvlabels(sigLVcorrs(j)),lvcorrs(sigLVcorrs(j)));end
   fprintf('\nBSRs (sig only):\n')
   for j=1:length(sigBSR);fprintf('%s: %0.4f\n',BSRlabels(sigBSR(j)),BSRs(j));end

if length(varargin)>1
   if varargin{2}==1
       figure
       m=result.boot_result.orig_corr(:,sigLVs(i));
       El=result.boot_result.orig_corr(:,sigLVs(i))-result.boot_result.llcorr(:,sigLVs(i));
       Eu=result.boot_result.ulcorr(:,sigLVs(i))-result.boot_result.orig_corr(:,sigLVs(i));
       hb=bar(1:length(m),m);hold on
       set(hb,'FaceColor',[0.72 0.83 0.95]);
       h=errorbar(1:length(m),m,El,Eu,'ok');
       set(h,'Color','k','LineWidth',1);
       grid off;
       title(sprintf('LV %i: p=%0.4f, cov=%2.2f%%',sigLVs(i),pval,covar*100))
       ylabel('Correlation');
       set(gca,'xtick',1:length(lvcorrs))
       xticklabels(lvlabels);
       xtickangle(90);
   end
end
end