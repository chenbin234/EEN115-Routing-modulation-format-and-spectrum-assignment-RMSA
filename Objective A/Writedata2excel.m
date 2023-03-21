% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % IMPORTANT:before running this function, you should comment out the
% % following codelines in main_objA.m, main_objB.m, main_benchmarking.m.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  n = "Italian";   % 'German' or 'Italian' topology
%  n_request_integer = 5; % Integer 1 to 5. 1 chooses traffic matrix 1 and so on.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

Topologies = ["German","Italian"];
filename_xls = 'Results_data.xls';


% if the file doesn't exist, create the file
% if ~isfile(filename_xls)
%     writematrix(1,filename_xls,'WriteMode','replacefile')
% end


for i = 1:numel(Topologies)
    n = Topologies(i);
    for n_request_integer = 1:5
        sheetname = sprintf('%s_request_matrix_%d',n,n_request_integer);

        main_objA;
        title_A = ["HighestFSU_objA","TotalFSU_objA","LinkUsage_objA","TotalCost_objA","UE_objA","SE_objA","PathLen_objA"];
        writematrix(title_A,filename_xls,'Sheet',sheetname,'Range','A1:G1')
        writematrix(data_stored_matrix,filename_xls,'Sheet',sheetname,'Range','A2')
        clearvars -except filename_xls Topologies n n_request_integer sheetname

        main_objB;

        title_B = ["HighestFSU_objB","TotalFSU_objB","LinkUsage_objB","TotalCost_objB","UE_objB","SE_objB","PathLen_objB"];
        writematrix(title_B,filename_xls,'Sheet',sheetname,'Range','H1:N1')
        writematrix(data_stored_matrix_B,filename_xls,'Sheet',sheetname,'Range','H2')
        clearvars -except filename_xls Topologies n n_request_integer sheetname

        main_benchmarking;

        title_C = ["HighestFSU_Benchmark","TotalFSU_Benchmark","LinkUsage_Benchmark","TotalCost_Benchmark","UE_Benchmark","SE_Benchmark","PathLen_Benchmark"];
        writematrix(title_C, filename_xls,'Sheet',sheetname,'Range','O1:U1')
        writematrix(data_stored_matrix_C,filename_xls,'Sheet',sheetname,'Range','O2')
        clearvars -except filename_xls Topologies n n_request_integer sheetname
        
        main_objA_Protection;

        title_D = ["HighestFSU_ProtectionA","TotalFSU_ProtectionA","LinkUsage_ProtectionA","TotalCost_ProtectionA","UE_ProtectionA","SE_ProtectionA","PathLen_ProtectionA"];
        writematrix(title_D, filename_xls,'Sheet',sheetname,'Range','V1:AB1')
        writematrix(data_stored_matrix_D,filename_xls,'Sheet',sheetname,'Range','V2')
        clearvars -except filename_xls Topologies n n_request_integer sheetname
        
        main_objB_Protection;

        title_E = ["HighestFSU_ProtectionB","TotalFSU_ProtectionB","LinkUsage_ProtectionB","TotalCost_ProtectionB","UE_ProtectionB","SE_ProtectionB","PathLen_ProtectionB"];
        writematrix(title_E, filename_xls,'Sheet',sheetname,'Range','AC1:AI1')
        writematrix(data_stored_matrix_E,filename_xls,'Sheet',sheetname,'Range','AC2')
        clearvars -except filename_xls Topologies n n_request_integer sheetname
    end
end

