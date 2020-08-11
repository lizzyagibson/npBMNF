%% Make this whole thing loop

for i = 1:100

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 50);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["pcb28", "pcb66", "pcb74", "pcb99", "pcb105", "pcb118", "pcb138_158", "pcb146", "pcb153", "pcb156", "pcb167", "pcb170", "pcb178", "pcb183", "pcb187", "pcb180", "pcb189", "pcb194", "pcb196_203", "pcb199", "pcb206", "pcb209", "BDE17", "BDE28", "BDE47", "BDE66", "BDE85", "BDE99", "BDE100", "BDE153", "BDE154", "BDE183", "BDE209", "MECPP", "MEHHP", "MEOHP", "MCPP", "MIBP", "MBP", "MBZP", "MEP", "MEHP", "dcp_24", "dcp_25", "b_pb", "bp_3", "m_pb", "p_pb", "tcs", "bpa"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
simdata1 = readtable(strcat("/Users/lizzy/nmf/R/Sims/Iterate/sim_dist_", num2str(i), "_stand.csv"), opts);
%simdata1 = readtable("/Users/lizzy/nmf/R/Sims/Iterate/sim_dist_1.csv", opts);

%% Convert to output type
simdata1 = table2array(simdata1);

%% Clear temporary variables
clear opts

[ewa1,eh1] = NPBayesNMF(simdata1, 50);

labels = ["pcb28", "pcb66", "pcb74", "pcb99", "pcb105", "pcb118", "pcb138_158" "pcb146", "pcb153", "pcb156", "pcb167", ...
    "pcb170", "pcb178", "pcb183", "pcb187", "pcb180", "pcb189", "pcb194", "pcb196_203" "pcb199", "pcb206", "pcb209", "BDE17", ...
    "BDE28", "BDE47", "BDE66", "BDE85", "BDE99", "BDE100", "BDE153", "BDE154", "BDE183", "BDE209", "MECPP", "MEHHP", "MEOHP", ...
    "MCPP", "MIBP", "MBP", "MBZP", "MEP", "MEHP", "dcp_24", "dcp_25", "b_pb", "bp_3", "m_pb", "p_pb", "tcs", "bpa"];

save(strcat("/Users/lizzy/nmf/R/Sims/Iterate_Out/ewa_dist_", num2str(i), "_stand.mat"), 'ewa1');
save(strcat("/Users/lizzy/nmf/R/Sims/Iterate_Out/eh_dist_", num2str(i), "_stand.mat"), 'eh1');

end

