clc;
clear all;
close all;

path_root = pwd;   %path to working directory 
%path_root = 'C:\Users\chiar\OneDrive\Desktop\paper-xsens\Chiara\prove .mvnx';
path_root = strcat(path_root,'\');
data_tot = {};  %inizialize the data_tot

for ind_subject = 1:2
     path_dir_sub = sprintf('Subject%d',ind_subject);
     path_dir = strcat(path_root , path_dir_sub);
     files = dir(fullfile(path_dir,'*.xlsx')); %load the files with .xlsx extension
     for f=1:length(files)
        path_dir_1 = [];
        path_dir_1 = strcat(path_dir , '\');
        path_dir_1 = strcat(path_dir_1 , files(f).name);
        [NUM,TXT,xsens_data_angles]=xlsread(path_dir_1,'Joint Angles ZXY');
        %ho aggiunto il percorso per i joint angle
        [NUM,TXT,xsens_data_position]=xlsread(path_dir_1,'Segment Position');
        %ho aggiunto il percorso per position
        [NUM,TXT,xsens_data_velocity]=xlsread(path_dir_1,'Segment Velocity');
         [NUM,TXT,xsens_data_acceleration]=xlsread(path_dir_1,'Segment Acceleration');
        %xsens_data =[xsens_data_angles(:,1:43) xsens_data_position(:,1:70) xsens_data_velocity(:,1:46)];
        data_tot(ind_subject).sub(f).xsens.angles = xsens_data_angles(:,1:43);
        data_tot(ind_subject).sub(f).xsens.position = xsens_data_position(:,1:70);
        data_tot(ind_subject).sub(f).xsens.velocity = xsens_data_velocity(:,1:46);
        data_tot(ind_subject).sub(f).xsens.acceleration = xsens_data_acceleration(:,1:70);
     end
         
end
