%% Load data
% Change the filename here to the name of the file you would like to import
tree =load_mvnx('prova_chiara-005');

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

for i=1:size(tree.frame,2)
   time(i)=str2num(tree.frame(i).time)./1000;
   
end

%% Read the data from the structure e.g. segment 15 : left hand , see in the segment data 
if isfield(tree.segmentData,'position')
    % Plot position of segment 1
    %figure('name','Position of left hand segment')
    %plot(time, tree.segmentData(15).position)
    %xlabel('tempo(s)')
    %ylabel('Position in the global frame')
    %grid
    %legend('x','y','z')
    %title ('Position of left hand segment')
    
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


% differences between tunk,shoulder,elbow,wrist angle
R_hand_angle = tree.jointData(10).jointAngle;
R_forearm_angle = tree.jointData(9).jointAngle;
R_upperarm_angle = tree.jointData(8).jointAngle;
R_trunk_angle=tree.jointData(7).jointAngle;


for i=1:size(tree.frame,2)
   time(i)=str2num(tree.frame(i).time)./1000;
   
end
% i put ./1000 so , it will show seconds  



%% plottare il tempo 
figure
subplot(3,1,1)
plot(time, R_trunk_angle)
xlabel('time (sec)')
ylabel('angle(deg)')
title(' R_trunk_angle')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ flex-ext ' )
hold on 

subplot(3,1,2)
plot(time,R_forearm_angle)
xlabel('time (sec)')
ylabel('angle(deg)')
title('Right_Forearm')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ flex-ext ' )
hold on 

subplot(3,1,3)
plot(time, R_upperarm_angle)
xlabel('time (sec)')
ylabel('angle(deg)')
title('Right_Upperarm')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ flex-ext ' )
hold on 

%% plottare il tempo 

L_hand_angle = tree.jointData(14).jointAngle;  %14: wrist
L_forearm_angle = tree.jointData(13).jointAngle;  % 13:elbow
L_upperarm_angle = tree.jointData(12).jointAngle; %12= shoulder
L_trunk_angle=tree.jointData(11).jointAngle;

figure
subplot(3,1,1)
plot(time, L_trunk_angle)
xlabel('time (sec)')
ylabel('angle(deg)')
title(' L_trunk_angle')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ flex-ext  ' )
hold on 

subplot(3,1,2)
plot(time,L_forearm_angle)
xlabel('time (sec)')
ylabel('angle(deg)')
title('Left_Forearm')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ flex-ext ' )
hold on 

subplot(3,1,3)
plot(time, L_upperarm_angle)
xlabel('time (sec)')
ylabel('angle(deg)')
title('Left_Upperarm')
legend ('x- abduction (+) adduction(-)', 'y_ Internal external rot' , 'z_ flex-ext ' )
hold on 



%% comparison from left to right 


figure
subplot(3,1,1)
plot(time, R_trunk_angle(:,3))  %per estensione/estensione seleziono solo la 3 
hold on 
plot(time, L_trunk_angle(:,3))
hold on 
xlabel('time (sec)')
ylabel('angle(deg)')
title('Hand')
legend ('Right' , 'Left ' )
hold on 

subplot(3,1,2)
plot(time,R_forearm_angle(:,3))
hold on 
plot(time,L_forearm_angle(:,3))
hold on 
xlabel('time (sec)')
ylabel('angle(deg)')
title('forearm')
legend ('Right' , 'Left ' )
hold on 

subplot(3,1,3)
plot(time, R_upperarm_angle(:,3))
hold on 
plot(time,L_upperarm_angle(:,3))
hold on 
xlabel('time (sec)')
ylabel('angle(deg)')
title('upperarm')
legend ('Right' , 'Left ' )
hold on 

a=(R_hand_angle(:,3)) %flessione estensione del polso destro , 
%5 secondi braccio dx e poi va il flessione il sx 
%aa=length(a)

%right shoulder , frame 330 alla massima flessione ,
%da x sens vedo che x=ab-ad y=i-e  z=f-e 
tree.jointData(12).jointAngle(330,3) 
tree.jointData(12).jointAngle(502,3)

%frame 166= p-s braccio dx ,
%il numero del frame lo vedo da xsens in basso a destra durante il playback

rt=tree.jointData(7).jointAngle(166,:) ; %right tronco
rs=tree.jointData(8).jointAngle(166,:) ;   %right shoulder
re= tree.jointData(9).jointAngle(166,:) ;    %right elbow
rw= tree.jointData(10).jointAngle(166,:);        %right wrist
r= [rt;rs;re;rw]

%frame iniziale,posizione neutra,braccio dx 
rt0=tree.jointData(7).jointAngle(1,:) ; %right tronco
rs0=tree.jointData(8).jointAngle(1,:) ;   %right shoulder
re0= tree.jointData(9).jointAngle(1,:) ;    %right elbow
rw0= tree.jointData(10).jointAngle(1,:);        %right wrist
r0= [rt0;rs0;re0;rw0]

abr= tree.jointData(8).jointAngle(884,3)
adr=tree.jointData(8).jointAngle(956,3)

abl= tree.jointData(12).jointAngle(884,3)
adl=tree.jointData(12).jointAngle(956,3)
%xlswrite('C:\documenti\f_prova007.xls') come passare da matlab a excel

%frame iniziale,posizione neutra,braccio sx 
lt0=tree.jointData(11).jointAngle(1,:) ; %left tronco
ls0=tree.jointData(12).jointAngle(1,:) ;   %left shoulder
le0= tree.jointData(13).jointAngle(1,:) ;    %left elbow
lw0= tree.jointData(14).jointAngle(1,:);        %left wrist
l0= [lt0;ls0;le0;lw0]

%frame 395,posizione p-s ,braccio sx 
lt=tree.jointData(11).jointAngle(395,:) ; %left tronco
ls=tree.jointData(12).jointAngle(395,:) ;   %left shoulder
le= tree.jointData(13).jointAngle(395,:) ;    %left elbow
lw= tree.jointData(14).jointAngle(395,:);        %left wrist
l= [lt;ls;le;lw]

