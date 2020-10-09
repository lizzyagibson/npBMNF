%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: /Users/lizzy/nmf/Data/isee_2020_dat.csv
%
% Auto-generated by MATLAB on 10-Aug-2020 14:01:46

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
isee2020dat = readtable("/Users/lizzy/nmf/Data/isee_2020_dat.csv", opts);

%% Clear temporary variables
clear opts

%% Convert to output type
isee2020dat = table2array(isee2020dat);
%flip = isee2020dat'

% Calculate std for each column
sd = std(isee2020dat, [], 1); 

% Subtract mean and divide by std
dataNorm = (isee2020dat) ./ sd; 

%% Clear temporary variables
clear opts

tic()
[EWA, EH, varWA, varH, alphaH, betaH] = NPBayesNMF(dataNorm);
toc()
% Elapsed time is 47.751565 seconds.
% 10 RUNS Elapsed time is 4.764525 seconds.
% MATLAB Run Time: <1 second.

% tic()
% [EWA, EH, varWA, varH, alphaH, betaH] = NPBayesNMF(isee2020dat);
% %[ewa_cc,eh_cc] = NPBayesNMF(isee2020dat);
% toc()
% Elapsed time is 8859.970457 seconds.
labels = ["mecpp", "mehhp", "meohp", "mcpp", "mibp", "mbp", "mbzp", "mep", "mehp", ...
    "dcp_24", "dcp_25", "b_pb", "bp_3", "m_pb", "p_pb", "tcs", "bpa"];
       
%PLOT
figure;
subplot(3,1,1);
stem(EH(1,:));
set(gca,'XTick',1:size(EH,2));
set(gca,'XTickLabels',labels);
subplot(3,1,2);
stem(EH(2,:));
set(gca,'XTick',1:size(EH,2));
set(gca,'XTickLabels',labels);
subplot(3,1,3);
stem(EH(3,:));
set(gca,'XTick',1:size(EH,2));
set(gca,'XTickLabels',labels);

figure;
subplot(4,1,1);
stem(EH_low(1,:));
set(gca,'XTick',1:size(EH_low,2));
set(gca,'XTickLabels',labels);
subplot(4,1,2);
stem(EH_low(2,:));
set(gca,'XTick',1:size(EH_low,2));
set(gca,'XTickLabels',labels);
subplot(4,1,3);
stem(EH_low(3,:));
set(gca,'XTick',1:size(EH_low,2));
set(gca,'XTickLabels',labels);
subplot(4,1,4);
stem(EH_low(4,:));
set(gca,'XTick',1:size(EH_low,2));
set(gca,'XTickLabels',labels);

% save("/Users/lizzy/nmf/MATLAB/Output/isee_2020_ewa1.mat", 'ewa_cc');
% save("/Users/lizzy/nmf/MATLAB/Output/isee_2020_eh1.mat", 'eh_cc');
