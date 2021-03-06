%% Initializations 
%data_analysis all: per calcolare le mediane 

ROM_shoulder_a_hand = []; %i want to change something 
ROM_shoulder_rot_hand = [];
ROM_shoulder_f_hand = [];
ROM_elbow_a_hand = [];
ROM_elbow_f_hand = [];
ROM_elbow_rot_hand = [];
ROM_head_a_hand = [];
ROM_head_rot_hand = [];
ROM_head_f_hand = [];
ROM_trunk_a_hand = [];
ROM_trunk_rot_hand = [];
ROM_trunk_f_hand = [];
ROM_wrist_a_hand = [];
ROM_wrist_rot_hand = [];
ROM_wrist_f_hand = [];
duration_hand = [];
center_mean_hand = [];
shoulder_position_mean_hand = [];
v_mean_hand = [];
a_mean_hand = [];

subjects_data = {};
path_length_ref = [];

%{
ROM_shoulder_a_DDC = [];
ROM_shoulder_rot_DDC = [];
ROM_shoulder_f_DDC = [];
ROM_elbow_a_DDC = [];
ROM_elbow_rot_DDC = [];
ROM_elbow_f_DDC = [];
ROM_head_a_DDC = [];
ROM_head_rot_DDC = [];
ROM_head_f_DDC = [];
ROM_trunk_a_DDC = [];
ROM_trunk_rot_DDC = [];
ROM_trunk_f_DDC = [];
ROM_wrist_a_DDC = [];
ROM_wrist_rot_DDC = [];
ROM_wrist_f_DDC = [];
duration_DDC = [];
center_mean_DDC = [];
shoulder_position_mean_DDC = [];
v_mean_DDC = [];
a_mean_DDC = [];
A_DDC = [];
E_DDC = [];
%}

%{
ROM_shoulder_a_PMC = [];
ROM_shoulder_rot_PMC = [];
ROM_shoulder_f_PMC = [];
ROM_elbow_a_PMC = [];
ROM_elbow_rot_PMC = [];
ROM_elbow_f_PMC = [];
ROM_head_a_PMC = [];
ROM_head_rot_PMC = [];
ROM_head_f_PMC = [];
ROM_trunk_a_PMC = [];
ROM_trunk_rot_PMC = [];
ROM_trunk_f_PMC = [];
ROM_wrist_a_PMC = [];
ROM_wrist_rot_PMC = [];
ROM_wrist_f_PMC = [];
duration_PMC = [];
center_mean_PMC = [];
shoulder_position_mean_PMC = [];
v_mean_PMC = [];
a_mean_PMC = [];
A_PMC = [];
E_PMC = [];

 %}

alfa_min = 0.25;
beta = 20;
A_REF = 62.5;
z = 1;
fig = 1;

fs = 2000;  %2000 from the emg system 
T = 1/fs;

subjects = 2; %numero di soggetti che al momento ho 

%% Hand
for z = 1:subjects
    y = 1;
    task_number = 1;
    for w = 1:3   %in 1 soggetto ho 3 cartelle , come se fossero 3 task 
        %EMG_data = [];
        %SHX_data = [];
        %xsens_data = [];
       % EMG_data = data_tot(z).sub(w).EMG;
        %SHX_data = data_tot(z).sub(w).SHX;
        xsens_data = data_tot(z).sub(w).xsens.angles;
        
        % Time  
        %campionare n modo uguale i dati xsens ed emg
        %t = [SHX_data(1,1) EMG_data(1,1) 
        t = cell2mat(xsens_data(2:end,1));
        %SHX_data(:,1) = SHX_data(:,1) - max(t);
        %EMG_data(:,1) = EMG_data(:,1) - max(t);
        %xsens_data_normal_time = cell2mat(xsens_data(2:end,1)) - max(t());
        xsens_data_normal_time = cell2mat(xsens_data(2:end,1));
        clear t  %prch?? lo cancello?
        %ind = find(EMG_data(:,1)<0);
        %EMG_data(ind,:) = [];
        %ind = find(xsens_data_normal_time(:,1)<0);
        %xsens_data_normal_time(ind,:) = [];
        %ind = find(SHX_data(:,1)<0);
        %SHX_data(ind,:) = [];
        clear ind
        %time_SHX = [];
        %time_EMG = [];
        %time_xsens = [];
        %time_SHX = SHX_data(:,1);
        %time_EMG = EMG_data(:,1);
        %time_xsens = xsens_data(:,1);
        
        % Phases
        %qui loro avevano un codice c++,
        %io dovrei farlo manualmente di inserire le fasi di start e end
        %phase1 = find(SHX_data(:,6)==1);  % 6 ?? la colonna della shp,...
        %... nel codice c++ dava 1 quando faceva le ripetizioni 
        %phase2 = find(SHX_data(:,6)==2);
        %phase3 = find(SHX_data(:,6)==3);
        
        %if isempty(phase2)     per tornare comodo scriveva questo perch?? non le funzionava 
        %    phase2 = phase1;
        %end
        %if isempty(phase3)
        %    phase3 = phase1;
        %end
        
        %{
        ind_start_phase_SHX = [phase1(1) phase2(1) phase3(1)];
        ind_end_phase_SHX = [phase1(end) phase2(end) phase3(end)];
        start_phase_SHX = [time_SHX(phase1(1)) time_SHX(phase2(1)) time_SHX(phase3(1))];
        end_phase_SHX = [time_SHX(phase1(end)) time_SHX(phase2(end)) time_SHX(phase3(end))];
        phases_duration = [end_phase_SHX(1)-start_phase_SHX(1) end_phase_SHX(2)-start_phase_SHX(2) end_phase_SHX(3)-start_phase_SHX(3)];
        clear phase1 phase2 phase3
        
        
        for i=1:length(start_phase_SHX)
            ind_lower  = find(time_EMG <= start_phase_SHX(i),1,'last');
            ind_higher = find(time_EMG >= start_phase_SHX(i),1,'first');
            if isempty(ind_higher)
                ind_higher = ind_lower;
            end
            if abs(time_EMG(ind_lower)-start_phase_SHX(i)) <= abs(time_EMG(ind_higher)-start_phase_SHX(i))
                ind_start_phase_EMG(i) = ind_lower;
                start_phase_EMG(i) = time_EMG(ind_lower);
            else
                ind_start_phase_EMG(i) = ind_higher;
                start_phase_EMG(i) = time_EMG(ind_higher);
            end
            ind_lower  = find(time_EMG <= end_phase_SHX(i),1,'last');
            ind_higher = find(time_EMG >= end_phase_SHX(i),1,'first');
            if isempty(ind_higher)
                ind_higher = ind_lower;
            end
            if abs(time_EMG(ind_lower)-end_phase_SHX(i)) <= abs(time_EMG(ind_higher)-end_phase_SHX(i))
                ind_end_phase_EMG(i) = ind_lower;
                end_phase_EMG(i) = time_EMG(ind_lower);
            else
                ind_end_phase_EMG(i) = ind_higher;
                end_phase_EMG(i) = time_EMG(ind_higher);
            end
            %xsens
            ind_lower  = find(time_xsens <= start_phase_SHX(i),1,'last');
            ind_higher = find(time_xsens >= start_phase_SHX(i),1,'first');
            if isempty(ind_higher)
                ind_higher = ind_lower;
            end
            if abs(time_xsens(ind_lower)-start_phase_SHX(i)) <= abs(time_xsens(ind_higher)-start_phase_SHX(i))
                ind_start_phase_xsens(i) = ind_lower;
                start_phase_xsens(i) = time_xsens(ind_lower);
            else
                ind_start_phase_xsens(i) = ind_higher;
                start_phase_xsens(i) = time_xsens(ind_higher);
            end
            ind_lower  = find(time_xsens <= end_phase_SHX(i),1,'last');
            ind_higher = find(time_xsens >= end_phase_SHX(i),1,'first');
            if isempty(ind_higher)
                ind_higher = ind_lower;
            end
            if abs(time_xsens(ind_lower)-end_phase_SHX(i)) <= abs(time_xsens(ind_higher)-end_phase_SHX(i))
                ind_end_phase_xsens(i) = ind_lower;
                end_phase_xsens(i) = time_xsens(ind_lower);
            else
                ind_end_phase_xsens(i) = ind_higher;
                end_phase_xsens(i) = time_xsens(ind_higher);
            end
        end
        clear ind_higher
        clear ind_lower
        %}
    end
        % Calculation of the Range of Motion considering shoulder, elbow, trunk and
        % head angles
        ROM_shoulder_a = [];
        ROM_shoulder_rot = [];
        ROM_shoulder_f = [];
        ROM_elbow_a = [];
        ROM_elbow_rot = [];
        ROM_elbow_f = [];
        ROM_head_a = [];
        ROM_head_rot = [];
        ROM_head_f = [];
        ROM_trunk_a = [];
        ROM_trunk_rot = [];
        ROM_trunk_f = [];
        ROM_wrist_a = [];
        ROM_wrist_rot = [];
        ROM_wrist_f = [];
        s = [];
        v = [];
        a = [];
        ind_start_phase_xsens = 1;
        ind_end_phase_xsens = max(xsens_data_normal_time);
        % Angle extraction and calculation of the ROM of the three trials
        for i = 1:1 %length(xsens_data_normal_time)
            shoulder_a_angle = [];
            shoulder_rot_angle = [];
            shoulder_f_angle = [];
            elbow_a_angle = [];
            elbow_rot_angle = [];
            elbow_f_angle = [];
            head_a_angle = [];
            head_rot_angle = [];
            head_f_angle = [];
            trunk_a_angle = [];
            trunk_rot_angle = [];
            trunk_f_angle = [];
            wrist_a_angle = [];
            wrist_rot_angle = [];
            wrist_f_angle = [];
            shoulder_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),23); %164 %i put 23 foor right shoulder
            shoulder_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),24); %165
            shoulder_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),25); %166
            elbow_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),26); %169
            elbow_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),27); %169
            elbow_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),28); %169
            head_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),17); %170
            head_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),18); %171
            head_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),19); %172
            %{
            trunk_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),173)... %173
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),176)... %176
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),179)... %179
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),182)... %182
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),185); %185
            trunk_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),174)... %174
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),177)... %177
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),180)... %180
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),183)... %183
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),186); %186
            trunk_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),175)... %175,...
                ...per il trunk faccio la somma di tutti gli angoli 
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),178)... %178
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),181)... %181
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),184)... %184
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),187); %187
            %}

            wrist_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),29); %188
            wrist_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),30); %189
            wrist_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),31); %190
            ROM_shoulder_a = [ROM_shoulder_a abs(max(cell2mat(shoulder_a_angle(2:end,1))) - min(cell2mat(shoulder_a_angle(2:end,1))))];
            ROM_shoulder_rot = [ROM_shoulder_rot abs(max(cell2mat(shoulder_rot_angle(2:end,1))) - min(cell2mat(shoulder_rot_angle(2:end,1))))];
            ROM_shoulder_f = [ROM_shoulder_f abs(max(cell2mat(shoulder_f_angle(2:end,1))) - min(cell2mat(shoulder_f_angle(2:end,1))))];
            ROM_elbow_a = [ROM_elbow_a abs(max(cell2mat(elbow_a_angle(2:end,1))) - min(cell2mat(elbow_a_angle(2:end,1))))];
            ROM_elbow_rot = [ROM_elbow_rot abs(max(cell2mat(elbow_rot_angle(2:end,1)))) - min(cell2mat(elbow_rot_angle(2:end,1)))];
            ROM_elbow_f = [ROM_elbow_f abs(max(cell2mat(elbow_f_angle(2:end,1))) - min(cell2mat(elbow_f_angle(2:end,1))))];
            ROM_head_a = [ROM_head_a abs(max(cell2mat(head_a_angle(2:end,1))) - min(cell2mat(head_a_angle(2:end,1))))];
            ROM_head_rot = [ROM_head_rot abs(max(cell2mat((head_rot_angle(2:end,1)))) - min(cell2mat(head_rot_angle(2:end,1))))];
            ROM_head_f = [ROM_head_f abs(max(cell2mat((head_f_angle(2:end,1)))) - min(cell2mat(head_f_angle(2:end,1))))];
            %{
            ROM_trunk_a = [ROM_trunk_a abs(max(trunk_a_angle) - min(trunk_a_angle))];
            ROM_trunk_rot = [ROM_trunk_rot abs(max(trunk_rot_angle) - min(trunk_rot_angle))];
            ROM_trunk_f = [ROM_trunk_f abs(max(trunk_f_angle) - min(trunk_f_angle))];
            %}
            ROM_wrist_a = [ROM_wrist_a abs(max(cell2mat(wrist_a_angle(2:end,1))) - min(cell2mat(wrist_a_angle(2:end,1))))];
            ROM_wrist_rot = [ROM_wrist_rot abs(max(cell2mat(wrist_rot_angle(2:end,1))) - min(cell2mat(wrist_rot_angle(2:end,1))))];
            ROM_wrist_f = [ROM_wrist_f abs(max(cell2mat(wrist_f_angle(2:end,1))) - min(cell2mat(wrist_f_angle(2:end,1))))];
        end
        
        %subjects_data(z).sub(y).elbow_hand = xsens_data(:,169);
        % Center of mass
        center = [];
        %center = xsens_data(:,354:356); %354:356
        
        % Calculation of the hand trajectory, shoulder trajectory, velocity and acceleration as the module of the position, velocity and acceleration vector
        hand_position = [];
        shoulder_position = [];
        hand_velocity = []; %263:265
        hand_acceleration = []; %266:268
        s = [];
        v = [];
        a = [];
        
        hand_position = data_tot(z).sub(w).xsens.position(2:end,44:46); %i found the index releted to the hand 
        shoulder_position = data_tot(z).sub(w).xsens.position(2:end,23:25);
        hand_velocity = data_tot(z).sub(w).xsens.position(2:end,23:25); %263:265
        hand_acceleration = data_tot(z).sub(w).xsens.acceleration(2:end,32:34); %266:268
        for i = 1:size(hand_position,1)
            s(i) = sqrt(cell2mat(hand_position(i,1)).^2 + cell2mat(hand_position(i,2)).^2 + cell2mat(hand_position(i,3)).^2);
            v(i) = sqrt(cell2mat(hand_velocity(i,1)).^2 + cell2mat(hand_velocity(i,2)).^2 + cell2mat(hand_velocity(i,3)).^2);
            a(i) = sqrt(cell2mat(hand_acceleration(i,1)).^2 + cell2mat(hand_acceleration(i,2)).^2 + cell2mat(hand_acceleration(i,3)).^2);
        end
        
        s = s - mean(s(1:3)); %tolgo dalla traiettoria il valore medio,...
        ...intra-subejct comparison 
        
        % Hand
        ROM_shoulder_a_hand(z,y) = mean(ROM_shoulder_a);
        ROM_shoulder_rot_hand(z,y) = mean(ROM_shoulder_rot);
        ROM_shoulder_f_hand(z,y) = mean(ROM_shoulder_f);
        ROM_elbow_a_hand(z,y) = mean(ROM_elbow_a);
        ROM_elbow_rot_hand(z,y) = mean(ROM_elbow_rot);
        ROM_elbow_f_hand(z,y) = mean(ROM_elbow_f);
        ROM_head_a_hand(z,y) = mean(ROM_head_a);
        ROM_head_rot_hand(z,y) = mean(ROM_head_rot);
        ROM_head_f_hand(z,y) = mean(ROM_head_f);
        ROM_trunk_a_hand(z,y) = mean(ROM_trunk_a);
        ROM_trunk_rot_hand(z,y) = mean(ROM_trunk_rot);
        ROM_trunk_f_hand(z,y) = mean(ROM_trunk_f);
        ROM_wrist_a_hand(z,y) = mean(ROM_wrist_a);
        ROM_wrist_rot_hand(z,y) = mean(ROM_wrist_rot);
        ROM_wrist_f_hand(z,y) = mean(ROM_wrist_f);
        
        phases_duration=ind_end_phase_xsens(1)-ind_start_phase_xsens(1);
        duration_hand(z,y) = min(phases_duration);
        clear phases_duration
        
        % Mean of the center of mass, velocity and acceleration
        %center_mean_hand(z,y,:) = [mean(center(:,1)) mean(center(:,2)) mean(center(:,3))];
        shoulder_position_mean_hand(z,y,:) = [mean(cell2mat(shoulder_position(:,1))) mean(cell2mat(shoulder_position(:,2))) mean(cell2mat(shoulder_position(:,3)))];
        %there is the position in x,y,z 
        v_mean_hand(z,y) = mean(v);
        a_mean_hand(z,y) = mean(a);
        
        % Resample of the hand trajectory to obtain vectors of the same length
        phase_1 = s(ind_start_phase_xsens(1):ind_end_phase_xsens(1));
        %phase_2 = s(ind_start_phase_xsens(2):ind_end_phase_xsens(2));
        %phase_3 = s(ind_start_phase_xsens(3):ind_end_phase_xsens(3));
        
        a = linspace(0,100,length(phase_1));
        %b = linspace(0,100,length(phase_2));
        %c = linspace(0,100,length(phase_3));
        t = linspace(0,100,max(length(phase_1)));
        
        phase_1 = interp1(a, phase_1 , t);   %per avere lunghezze uguali 
        %phase_2 = interp1(b, phase_2 , t);
        %phase_3 = interp1(c, phase_3 , t);
        
        subjects_data(z).sub(y).hand_phase1 = phase_1;
        %subjects_data(z).sub(y).hand_phase2 = phase_2;
        %subjects_data(z).sub(y).hand_phase3 = phase_3;
        
        clear a b c t
        
        ts = phase_1;
        mean_trajectory = mean(ts);
        distance = abs(phase_1 - mean_trajectory);
        diff = sum(distance);
        %distance = abs(phase_2 - mean_trajectory);
        %diff = [diff sum(distance)];
        %distance = abs(phase_3 - mean_trajectory);
        diff = [diff sum(distance)];
        
        if length(find(diff == min(diff))) > 1
            diff = 1;
        end
        
        switch find(diff == min(diff))
            case 0
                reference_trajectory = phase_1;
            case 1
                reference_trajectory = phase_1;
            case 2
                reference_trajectory = phase_2;
            case 3
                reference_trajectory = phase_3;
        end
        
        subjects_data(z).sub(y).hand = reference_trajectory;
        
        clear ts mean_trajectory distance
        
        % Reference path length
        n = length(reference_trajectory);
        ref_path = 0;
        for i = 1:(n - 1)
            x = abs(reference_trajectory(i) - reference_trajectory(i+1));
            ref_path = ref_path + x;
        end
        
        path_length_ref(z,y) = ref_path;
        
        
        clear phase_1 phase_2 phase_3
        
    
   
    
    
    %% PMC
    %{
    y = 1;
    task_number = 1;
    for w = 35:51
        
        EMG_data = [];
        SHX_data = [];
        xsens_data = [];
        EMG_data = data_tot(z).sub(w).EMG;
        SHX_data = data_tot(z).sub(w).SHX;
        xsens_data = data_tot(z).sub(w).xsens;
        
        % Time
        t = [SHX_data(1,1) EMG_data(1,1) xsens_data(1,1)];
        SHX_data(:,1) = SHX_data(:,1) - max(t);
        EMG_data(:,1) = EMG_data(:,1) - max(t);
        xsens_data(:,1) = xsens_data(:,1) - max(t);
        clear t
        ind = find(EMG_data(:,1)<0);
        EMG_data(ind,:) = [];
        ind = find(xsens_data(:,1)<0);
        xsens_data(ind,:) = [];
        ind = find(SHX_data(:,1)<0);
        SHX_data(ind,:) = [];
        clear ind
        time_SHX = [];
        time_EMG = [];
        time_xsens = [];
        time_SHX = SHX_data(:,1);
        time_EMG = EMG_data(:,1);
        time_xsens = xsens_data(:,1);
        
        % Phases
        phase1 = find(SHX_data(:,6)==1);
        phase2 = find(SHX_data(:,6)==2);
        phase3 = find(SHX_data(:,6)==3);
        
        if isempty(phase2)
            phase2 = phase1;
        end
        if isempty(phase3)
            phase3 = phase1;
        end
        
        ind_start_phase_SHX = [phase1(1) phase2(1) phase3(1)];
        ind_end_phase_SHX = [phase1(end) phase2(end) phase3(end)];
        start_phase_SHX = [time_SHX(phase1(1)) time_SHX(phase2(1)) time_SHX(phase3(1))];
        end_phase_SHX = [time_SHX(phase1(end)) time_SHX(phase2(end)) time_SHX(phase3(end))];
        phases_duration = [end_phase_SHX(1)-start_phase_SHX(1) end_phase_SHX(2)-start_phase_SHX(2) end_phase_SHX(3)-start_phase_SHX(3)];
        clear phase1 phase2 phase3
        
        for i=1:length(start_phase_SHX)
            ind_lower  = find(time_EMG <= start_phase_SHX(i),1,'last');
            ind_higher = find(time_EMG >= start_phase_SHX(i),1,'first');
            if isempty(ind_higher)
                ind_higher = ind_lower;
            end
            if abs(time_EMG(ind_lower)-start_phase_SHX(i)) <= abs(time_EMG(ind_higher)-start_phase_SHX(i))
                ind_start_phase_EMG(i) = ind_lower;
                start_phase_EMG(i) = time_EMG(ind_lower);
            else
                ind_start_phase_EMG(i) = ind_higher;
                start_phase_EMG(i) = time_EMG(ind_higher);
            end
            ind_lower  = find(time_EMG <= end_phase_SHX(i),1,'last');
            ind_higher = find(time_EMG >= end_phase_SHX(i),1,'first');
            if isempty(ind_higher)
                ind_higher = ind_lower;
            end
            if abs(time_EMG(ind_lower)-end_phase_SHX(i)) <= abs(time_EMG(ind_higher)-end_phase_SHX(i))
                ind_end_phase_EMG(i) = ind_lower;
                end_phase_EMG(i) = time_EMG(ind_lower);
            else
                ind_end_phase_EMG(i) = ind_higher;
                end_phase_EMG(i) = time_EMG(ind_higher);
            end
            %xsens
            ind_lower  = find(time_xsens <= start_phase_SHX(i),1,'last');
            ind_higher = find(time_xsens >= start_phase_SHX(i),1,'first');
            if isempty(ind_higher)
                ind_higher = ind_lower;
            end
            if abs(time_xsens(ind_lower)-start_phase_SHX(i)) <= abs(time_xsens(ind_higher)-start_phase_SHX(i))
                ind_start_phase_xsens(i) = ind_lower;
                start_phase_xsens(i) = time_xsens(ind_lower);
            else
                ind_start_phase_xsens(i) = ind_higher;
                start_phase_xsens(i) = time_xsens(ind_higher);
            end
            ind_lower  = find(time_xsens <= end_phase_SHX(i),1,'last');
            ind_higher = find(time_xsens >= end_phase_SHX(i),1,'first');
            if isempty(ind_higher)
                ind_higher = ind_lower;
            end
            if abs(time_xsens(ind_lower)-end_phase_SHX(i)) <= abs(time_xsens(ind_higher)-end_phase_SHX(i))
                ind_end_phase_xsens(i) = ind_lower;
                end_phase_xsens(i) = time_xsens(ind_lower);
            else
                ind_end_phase_xsens(i) = ind_higher;
                end_phase_xsens(i) = time_xsens(ind_higher);
            end
        end
        clear ind_higher
        clear ind_lower
        
        % Calculation of the Range of Motion considering shoulder, elbow, trunk and
        % head angles
        ROM_shoulder_a = [];
        ROM_shoulder_rot = [];
        ROM_shoulder_f = [];
        ROM_elbow_a = [];
        ROM_elbow_rot = [];
        ROM_elbow_f = [];
        ROM_head_a = [];
        ROM_head_rot = [];
        ROM_head_f = [];
        ROM_trunk_a = [];
        ROM_trunk_rot = [];
        ROM_trunk_f = [];
        ROM_wrist_a = [];
        ROM_wrist_rot = [];
        ROM_wrist_f = [];
        s = [];
        v = [];
        a = [];
        
        % Angle extraction and calculation of the ROM of the three trials
        for i = 1:length(start_phase_xsens)
            shoulder_a_angle = [];
            shoulder_rot_angle = [];
            shoulder_f_angle = [];
            elbow_a_angle = [];
            elbow_rot_angle = [];
            elbow_f_angle = [];
            head_a_angle = [];
            head_rot_angle = [];
            head_f_angle = [];
            trunk_a_angle = [];
            trunk_rot_angle = [];
            trunk_f_angle = [];
            wrist_a_angle = [];
            wrist_rot_angle = [];
            wrist_f_angle = [];
            shoulder_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),164); %164
            shoulder_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),165); %165
            shoulder_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),166); %166
            elbow_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),167); %169
            elbow_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),168); %169
            elbow_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),169); %169
            head_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),170); %170
            head_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),171); %171
            head_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),172); %172
            trunk_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),173)... %173
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),176)... %176
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),179)... %179
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),182)... %182
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),185); %185
            trunk_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),174)... %174
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),177)... %177
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),180)... %180
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),183)... %183
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),186); %186
            trunk_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),175)... %175
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),178)... %178
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),181)... %181
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),184)... %184
                + xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),187); %187
            wrist_a_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),188); %188
            wrist_rot_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),189); %189
            wrist_f_angle = xsens_data(ind_start_phase_xsens(i):ind_end_phase_xsens(i),190); %190
            ROM_shoulder_a = [ROM_shoulder_a abs(max(shoulder_a_angle) - min(shoulder_a_angle))];
            ROM_shoulder_rot = [ROM_shoulder_rot abs(max(shoulder_rot_angle) - min(shoulder_rot_angle))];
            ROM_shoulder_f = [ROM_shoulder_f abs(max(shoulder_f_angle) - min(shoulder_f_angle))];
            ROM_elbow_a = [ROM_elbow_a abs(max(elbow_a_angle) - min(elbow_a_angle))];
            ROM_elbow_rot = [ROM_elbow_rot abs(max(elbow_rot_angle) - min(elbow_rot_angle))];
            ROM_elbow_f = [ROM_elbow_f abs(max(elbow_f_angle) - min(elbow_f_angle))];
            ROM_head_a = [ROM_head_a abs(max(head_a_angle) - min(head_a_angle))];
            ROM_head_rot = [ROM_head_rot abs(max(head_rot_angle) - min(head_rot_angle))];
            ROM_head_f = [ROM_head_f abs(max(head_f_angle) - min(head_f_angle))];
            ROM_trunk_a = [ROM_trunk_a abs(max(trunk_a_angle) - min(trunk_a_angle))];
            ROM_trunk_rot = [ROM_trunk_rot abs(max(trunk_rot_angle) - min(trunk_rot_angle))];
            ROM_trunk_f = [ROM_trunk_f abs(max(trunk_f_angle) - min(trunk_f_angle))];
            ROM_wrist_a = [ROM_wrist_a abs(max(wrist_a_angle) - min(wrist_a_angle))];
            ROM_wrist_rot = [ROM_wrist_rot abs(max(wrist_rot_angle) - min(wrist_rot_angle))];
            ROM_wrist_f = [ROM_wrist_f abs(max(wrist_f_angle) - min(wrist_f_angle))];
        end
        subjects_data(z).sub(y).elbow_PMC = xsens_data(:,169);
        % Center of mass
        center = [];
        center = xsens_data(:,354:356); %354:356
        
        % Calculation of the hand trajectory, shoulder trajectory, velocity and acceleration as the module of the position, velocity and acceleration vector
        hand_position = [];
        shoulder_position = [];
        hand_velocity = []; %263:265
        hand_acceleration = []; %266:268
        s = [];
        v = [];
        a = [];
        
        hand_position = xsens_data(:,73:75);
        shoulder_position = xsens_data(:,52:54);
        hand_velocity = xsens_data(:,263:265); %263:265
        hand_acceleration = xsens_data(:,266:268); %266:268
        for i = 1:size(hand_position,1)
            s(i) = sqrt(hand_position(i,1)^2 + hand_position(i,2)^2 + hand_position(i,3)^2);
            v(i) = sqrt(hand_velocity(i,1)^2 + hand_velocity(i,2)^2 + hand_velocity(i,3)^2);
            a(i) = sqrt(hand_acceleration(i,1)^2 + hand_acceleration(i,2)^2 + hand_acceleration(i,3)^2);
        end
        
        s = s - mean(s(1:3));
        %
        % %                 Plot of the position of the hand and of the opening and closure of the
        % %                 robotic hand
        %                 figure(fig)
        %                 graph_title = strcat('PMC - Task',fig);
        %                 title(graph_title)
        %                 subplot(211)
        %                 plot(time_xsens,s)
        %                 subplot(212)
        %                 plot(time_SHX,SHX_data(:,2))
        %                 fig = fig + 1;
        %                 task_number = task_number + 1;
        
        ROM_shoulder_a_PMC(z,y) = mean(ROM_shoulder_a);
        ROM_shoulder_rot_PMC(z,y) = mean(ROM_shoulder_rot);
        ROM_shoulder_f_PMC(z,y) = mean(ROM_shoulder_f);
        ROM_elbow_a_PMC(z,y) = mean(ROM_elbow_a);
        ROM_elbow_rot_PMC(z,y) = mean(ROM_elbow_rot);
        ROM_elbow_f_PMC(z,y) = mean(ROM_elbow_f);
        ROM_head_a_PMC(z,y) = mean(ROM_head_a);
        ROM_head_rot_PMC(z,y) = mean(ROM_head_rot);
        ROM_head_f_PMC(z,y) = mean(ROM_head_f);
        ROM_trunk_a_PMC(z,y) = mean(ROM_trunk_a);
        ROM_trunk_rot_PMC(z,y) = mean(ROM_trunk_rot);
        ROM_trunk_f_PMC(z,y) = mean(ROM_trunk_f);
        ROM_wrist_a_PMC(z,y) = mean(ROM_wrist_a);
        ROM_wrist_rot_PMC(z,y) = mean(ROM_wrist_rot);
        ROM_wrist_f_PMC(z,y) = mean(ROM_wrist_f);
        
        duration_PMC(z,y) = min(phases_duration);
        clear phases_duration
       %}
    
        % Mean and variance of the center of mass, velocity and acceleration
        %center_mean_PMC(z,y,:) = [mean(center(:,1)) mean(center(:,2)) mean(center(:,3))];
        %shoulder_position_mean_PMC(z,y,:) = [mean(shoulder_position(:,1)) mean(shoulder_position(:,2)) mean(shoulder_position(:,3))];
        %v_mean_PMC(z,y) = mean(v);
        %a_mean_PMC(z,y) = mean(a);
        
        % Resample
        phase_1 = s(ind_start_phase_xsens(1):ind_end_phase_xsens(1));
        %phase_2 = s(ind_start_phase_xsens(2):ind_end_phase_xsens(2));
        %phase_3 = s(ind_start_phase_xsens(3):ind_end_phase_xsens(3));
        
        subjects_data(z).sub(y).PMC_phase1 = phase_1;
        %subjects_data(z).sub(y).PMC_phase2 = phase_2;
        %subjects_data(z).sub(y).PMC_phase3 = phase_3;
   
        
        reference_trajectory = subjects_data(z).sub(y).hand;
        a = linspace(0,100,length(phase_1));
        %b = linspace(0,100,length(phase_2));
        %c = linspace(0,100,length(phase_3));
        d = linspace(0,100,length(reference_trajectory));
        t = linspace(0,100,max([length(phase_1) length(reference_trajectory)]));
        
        phase_1 = interp1(a, phase_1 , t);
        %phase_2 = interp1(b, phase_2 , t);
        %phase_3 = interp1(c, phase_3 , t);
        ref = interp1(d, reference_trajectory , t);
        
        
        clear a b c d t
     
        
        n = length(ref);
        
        % Phase 1
        % Correlation coefficient (Pearson) between the two trajectories
        trajectories = [ref' phase_1'];
        rho = corr(trajectories);
        
        clear trajectories
        
        
        d(:,1) = abs(ref - phase_1);
        %d(:,2) = abs(ref - phase_2);
        %d(:,3) = abs(ref - phase_3);
        
        th = mean(mean(d));
        % Dispersion band used for the calculation of the BN parameter
        disp_band_low = ref - 2*th;
        disp_band_high = ref + 2*th;
        
        alfa = alfa_min + (1 - alfa_min) * (1 ./ (1 + exp(beta*abs((mean(d(:,1))-max(d(:,1))/2)))));
        
        
        
        ind = 0;
        for i = 1:n
            if phase_1(i) >= disp_band_low(i) && phase_1(i) <= disp_band_high(i)
                ind = ind + 1;
            end
        end
        BN = ind*100/n;
        
        A = alfa*rho(2,1)*BN/A_REF*100;
        
        clear ind BN alfa rho
        
        path_length = 0;
        for i = 1:(length(phase_1) - 1)
            x = abs(phase_1(i) - phase_1(i+1));
            path_length = path_length + x;
        end
        if path_length <= path_length_ref(z,y)
            E = (path_length/path_length_ref(z,y))*100;
        else
            E = (path_length_ref(z,y)/path_length)*100;
        end
        
        % Phase 2
        % Correlation coefficient (Pearson) between the two trajectories
        trajectories = [ref' phase_2'];
        rho = corr(trajectories);
        
        clear trajectories
        
        
        
        alfa = alfa_min + (1 - alfa_min) * (1 ./ (1 + exp(beta*abs((mean(d(:,2))-max(d(:,2))/2)))));
        
        
        
        ind = 0;
        for i = 1:n
            if phase_2(i) >= disp_band_low(i) && phase_2(i) <= disp_band_high(i)
                ind = ind + 1;
            end
        end
        BN = ind*100/n;
        
        A = [A alfa*rho(2,1)*BN/A_REF*100];
        
        clear ind BN alfa rho
        
        path_length = 0;
        for i = 1:(length(phase_2) - 1)
            x = abs(phase_2(i) - phase_2(i+1));
            path_length = path_length + x;
        end
        if path_length <= path_length_ref(z,y)
            E = [E (path_length/path_length_ref(z,y))*100];
        else
            E = [E (path_length_ref(z,y)/path_length)*100];
        end
        
        % Phase 3
        % Correlation coefficient (Pearson) between the two trajectories
        trajectories = [ref' phase_3'];
        rho = corr(trajectories);
        
        clear trajectories
        
        
        
        alfa = alfa_min + (1 - alfa_min) * (1 ./ (1 + exp(beta*abs((mean(d(:,3))-max(d(:,3))/2)))));
        
        
        
        ind = 0;
        for i = 1:n
            if phase_3(i) >= disp_band_low(i) && phase_3(i) <= disp_band_high(i)
                ind = ind + 1;
            end
        end
        BN = ind*100/n;
        
        A = [A alfa*rho(2,1)*BN/A_REF*100];
        
        clear ind BN alfa rho
        
        path_length = 0;
        for i = 1:(length(phase_3) - 1)
            x = abs(phase_3(i) - phase_3(i+1));
            path_length = path_length + x;
        end
        if path_length <= path_length_ref(z,y)
            E = [E (path_length/path_length_ref(z,y))*100];
        else
            E = [E (path_length_ref(z,y)/path_length)*100];
        end
        
        % Final values obtained as the mean value of the three indices of the three trials
        A_PMC(z,y) = mean(A);
        E_PMC(z,y) = mean(E);
        
        clear A E ref disp_band_low disp_band_high phase_1 phase_2 phase_3
        
        % EMG
        j = 1;
        for i = 2:7
            emg(:,j) = EMG_data(:,i) - mean(EMG_data(:,i));
            [b,a] = butter(9,500/(fs/2));
            emg(:,j) = filter(b,a,emg(:,j));
            [d,c] = butter(9,10/(fs/2),'high');
            emg(:,j) = filter(d,c,emg(:,j));
            j = j + 1;
        end
        
        %         phase_1 = [];
        %         phase_2 = [];
        %         phase_3 = [];
        %         phase_1 = emg(ind_start_phase_EMG(1):ind_end_phase_EMG(1),:);
        %         phase_2 = emg(ind_start_phase_EMG(2):ind_end_phase_EMG(2),:);
        %         phase_3 = emg(ind_start_phase_EMG(3):ind_end_phase_EMG(3),:);
        
        % Rectification
        for i = 1:6
            emg(:,i) = abs(emg(:,i));
        end
        
        % Normalization and envelope extraction
        [f,e] = butter(5,10/(fs/2),'low');
        for i = 1:6
            emg(:,i) =  emg(:,i)/max_PMC(z,y,i);
            envelope(:,i) = filtfilt(f,e,emg(:,i));
        end
        phase_1 = [];
        phase_2 = [];
        phase_3 = [];
        time1 = [];
        time2 = [];
        time3 = [];
        phase_1 = envelope(ind_start_phase_EMG(1):ind_end_phase_EMG(1),:);
        time1 = time_EMG(ind_start_phase_EMG(1):ind_end_phase_EMG(1));
        phase_2 = envelope(ind_start_phase_EMG(2):ind_end_phase_EMG(2),:);
        time2 = time_EMG(ind_start_phase_EMG(2):ind_end_phase_EMG(2));
        phase_3 = envelope(ind_start_phase_EMG(3):ind_end_phase_EMG(3),:);
        time3 = time_EMG(ind_start_phase_EMG(3):ind_end_phase_EMG(3));
        for muscle = 1:6
            sup_th = find(phase_1(:,muscle)> 2*mean(envelope(1:1000,muscle)));
            if isempty(sup_th) ~= 1
                phase_1_new = phase_1(sup_th(1):sup_th(end),muscle);
                time1_new = time1(sup_th(1):sup_th(end));
                clear sup_th
            else
                phase_1_new = 0;
            end
            
            sup_th = find(phase_2(:,muscle)> 2*mean(envelope(1:1000,muscle)));
            if isempty(sup_th) ~= 1
                phase_2_new = phase_2(sup_th(1):sup_th(end),muscle);
                time2_new = time2(sup_th(1):sup_th(end));
                clear sup_th
            else
                phase_2_new = 0;
            end
            
            sup_th = find(phase_3(:,muscle)> 2*mean(envelope(1:1000,muscle)));
            if isempty(sup_th) ~= 1
                phase_3_new = phase_3(sup_th(1):sup_th(end),muscle);
                time3_new = time3(sup_th(1):sup_th(end));
                clear sup_th
            else
                phase_3_new = 0;
            end
            
            RMS(:,muscle) = [rms(phase_1_new); rms(phase_2_new); rms(phase_3_new)];
            
        end
        
        subjects_data(z).sub(y).rms_PMC = mean(RMS);
        subjects_data(z).sub(y).envelope_PMC = envelope;
        
        
        clear emg envelope emg phase_1 phase_2 phase_3 rms
        y = y + 1;
        
    end
    
    
