%% Load data
% Change the filename here to the name of the file you would like to import
tree =load_mvnx('prova_maria-008#MVM_Maria');

%% Read some basic data from the file
mvnxVersion = tree.metaData.mvnx_version; % version of the MVN Studio used during recording

if (isfield(tree.metaData, 'comment'))
    fileComments = tree.metaData.comment; % comments written when saving the file
end

%% Read some basic properties of the subject;
frameRate = tree.metaData.subject_frameRate;
suitLabel = tree.metaData.subject_label;
originalFilename = tree.metaData.subject_originalFilename;
recDate = tree.metaData.subject_recDate;
segmentCount = tree.metaData.subject_segmentCount;

%% Retrieve sensor labels
%creates a struct with sensor data
if isfield(tree,'sensorData') && isstruct(tree.sensorData)
    sensorData = tree.sensorData;
end

%% Retrieve segment labels
%creates a struct with segment definitions
if isfield(tree,'segmentData') && isstruct(tree.segmentData)
    segmentData = tree.segmentData;
end

%% Read the data from the structure e.g. segment 15 : left hand , see in the segment data 
if isfield(tree.segmentData,'position')
    % Plot position of segment 1
    figure('name','Position of left hand segment')
    plot(tree.segmentData(15).position)
    xlabel('frames')
    ylabel('Position in the global frame')
    grid
    legend('x','y','z')
    title ('Position of left hand segment')
    
    % Plot 3D displacement of segment 15
    figure('name','Position of left hand segment in 3D')
    plot3(tree.segmentData(15).position(:,1),tree.segmentData(15).position(:,2),tree.segmentData(15).position(:,3));
    xlabel('x')
    ylabel('y')
    zlabel('z')
    grid
    title ('Displacement of left hand segment in space')
end

%%%% dal my plot 


% differences between ankle, knee, hip angle
R_hand_angle = tree.jointData(11).jointAngle;
R_forearm_angle = tree.jointData(10).jointAngle;
R_upperarm_angle = tree.jointData(9).jointAngle;


for i=1:size(tree.frame,2)
   time(i)=str2num(tree.frame(i).time)./1000;
   
end
% i put ./1000 so , it will show seconds  






%% plottare il frame 
figure
subplot(3,1,1)
plot(R_hand_angle)
title('Right_Hand')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ dorsiflex plantaflex ' )
hold on 

subplot(3,1,2)
plot(R_forearm_angle)
title('Right_Forearm')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ dorsiflex plantaflex ' )
hold on 

subplot(3,1,3)
plot(R_upperarm_angle)
title('Right_Upperarm')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ dorsiflex plantaflex ' )
hold on 

%% plottare il tempo 
figure
subplot(3,1,1)
plot(time, R_hand_angle)
xlabel('time (sec)')
title(' Right Hand')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ dorsiflex plantaflex ' )
hold on 

subplot(3,1,2)
plot(time,R_forearm_angle)
xlabel('time (sec)')
title('Right_Forearm')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ dorsiflex plantaflex ' )
hold on 

subplot(3,1,3)
plot(time, R_upperarm_angle)
xlabel('time (sec)')
title('Right_Upperarm')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ dorsiflex plantaflex ' )
hold on 

%% comparison from left to right 
L_hand_angle = tree.jointData(14).jointAngle;  %14: wrist
L_forearm_angle = tree.jointData(13).jointAngle;  % 13:elbow
L_upperarm_angle = tree.jointData(12).jointAngle; %12= shoulder

figure
subplot(3,1,1)
plot(time, R_hand_angle(:,3))  %per estensione/estensione seleziono solo la 3 
hold on 
plot(time, L_hand_angle(:,3))
hold on 
xlabel('time (sec)')
title('Hand')
legend ('Right' , 'Left ' )
hold on 

subplot(3,1,2)
plot(time,R_forearm_angle(:,3))
hold on 
plot(time,L_forearm_angle(:,3))
hold on 
xlabel('time (sec)')
title('forearm')
legend ('Right' , 'Left ' )
hold on 

subplot(3,1,3)
plot(time, R_upperarm_angle(:,3))
hold on 
plot(time,L_upperarm_angle(:,3))
hold on 
xlabel('time (sec)')
title('upperarm')
legend ('Right' , 'Left ' )
hold on 

