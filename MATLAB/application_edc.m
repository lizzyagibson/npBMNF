%%
%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 17);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["mecpp", "mehhp", "meohp", "mcpp", "mibp", "mbp", "mbzp", "mep", "mehp", "dcp_24", "dcp_25", "b_pb", "bp_3", "m_pb", "p_pb", "tcs", "bpa"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
edc = readtable("/Users/lizzy/BN2MF/Data/isee_2020_dat.csv", opts);

%% Clear temporary variables
clear opts

%% Convert to output type
edc = table2array(edc);

% Calculate std for each column
sd = std(edc); 

% Subtract mean and divide by std
dataNorm = (edc) ./ sd; 

tic()
[EWA, EH, varH, alphaH, betaH, alphaW, betaW, ...
    alphaA, betaA, varWA, finalscore, final_iter, init_seed_struct] = BN2MF(dataNorm, 50);
toc()

labels = ["mecpp", "mehhp", "meohp", "mcpp", "mibp", "mbp", "mbzp", "mep", "mehp", ...
    "dcp_24", "dcp_25", "b_pb", "bp_3", "m_pb", "p_pb", "tcs", "bpa"];
 
denom = sum(EH, 2);
EHp = EH ./ denom;

%PLOT
figure(3);
subplot(3,1,1);
stem(EHp(1,:));
set(gca,'XTick',1:size(EHp,2));
set(gca,'XTickLabels',labels);
subplot(3,1,2);
stem(EHp(2,:));
set(gca,'XTick',1:size(EHp,2));
set(gca,'XTickLabels',labels);
subplot(3,1,3);
stem(EHp(3,:));
set(gca,'XTick',1:size(EHp,2));
set(gca,'XTickLabels',labels);
% 2: Final Iter: 352. Final Iter Number: 2533.9419


% save("/Users/lizzy/nmf/MATLAB/Output/isee_2020_ewa1.mat", 'ewa_cc');
% save("/Users/lizzy/nmf/MATLAB/Output/isee_2020_eh1.mat", 'eh_cc');