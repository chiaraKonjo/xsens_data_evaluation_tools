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


for i=1:size(tree.frame,2)
   time(i)=str2num(tree.frame(i).time)./1000;
   
end
% i put ./1000 so , it will show seconds  

%%%% dal my plot 
% differences between 
R_elbow_angle = tree.jointData(9).jointAngle;  %9:right elbow
L_elbow_angle = tree.jointData(13).jointAngle; %13:left elbow
R_wrist_angle = tree.jointData(10).jointAngle;  %10:right wrist
L_wrist_angle = tree.jointData(14).jointAngle; %14:left wrist


%% comparison from left to right ,plottare il frame 
figure
subplot(2,1,1)
plot(R_elbow_angle)
hold on

xlabel('frames')
title('Right_elbow')
legend ('x- radial deviation (+) ulnar deviation (-)', 'y_ prono(+)supin(-)' , 'z_ flex(+)ext(-) ' )
hold on 
subplot(2,1,2)
plot(L_elbow_angle)
xlabel('frames')
title('Left_elbow')
legend ('x- radial deviation (+) ulnar deviation (-)', 'y_ prono(+)supin(-)' , 'z_ flex(+)ext(-) ' )
hold on 


%% comparison from left to right ,plottare il tempo

figure
subplot(2,1,1)
plot(time, R_elbow_angle(:,3))
title('right elbow,flex/ext')
legend ('Right')
hold on 
subplot(2,1,2)
plot(time,L_elbow_angle(:,3))
hold on 
xlabel('time (sec)')
title('left elbow,flex/ext')
legend ('Left ' )
hold on 


%le=tree.jointData(13).jointAngle(2461,3)  %frame 2461:flex elbow s a 90 , mi da gl angoli 
...% del joint 13 l frame selezionato 
   
%bar(time,R_elbow_angle)  %per vedere linee invece di plot 
%bar(time,R_elbow_angle,1) 

%movimenti compensatori , joint considerati
jL1T12 = tree.jointData(3).jointAngle;
jT9T8=tree.jointData(4).jointAngle;

figure
subplot(2,1,1)
plot(time,jL1T12(:,1))
title('lombar spine')
%legend ('Right')
hold on 
subplot(2,1,2)
plot(time,jT9T8(:,1))
hold on 
xlabel('time (sec)')
title('thoracic spine')
%legend ('Left ' )
hold on 

% plot del polso
figure
subplot(2,1,1)
plot(R_wrist_angle)
hold on
xlabel('frames')
title('Right_wrist')
legend ('x- radial deviation (+) ulnar deviation (-)', 'y_ prono(+)supin(-)' , 'z_ flex(+)ext(-) ' )
hold on 
subplot(2,1,2)
plot(L_wrist_angle)
xlabel('frames')
title('Left_wrist')
legend ('x- radial deviation (+) ulnar deviation (-)', 'y_ prono(+)supin(-)' , 'z_ flex(+)ext(-) ' )
hold on 

%provo a graficare quello che ho in excel
ren= tree.jointData(9).jointAngle(1920,1) ; %right elbow,neutral pose
ref= tree.jointData(9).jointAngle(187,1) ;   %right elbow,flexion pose
len= tree.jointData(13).jointAngle(2375,1) ;  %left elbow,np
lef= tree.jointData(13).jointAngle(2489,1) ;   %left elbow,flexion pose 
%lw= tree.jointData(14).jointAngle(395,:);  %left wrist

l= [ren;ref;len;lef];



X = categorical({'re np','re flex','le np','le flex'}); %definisco la categoria
X = reordercats(X,{'re np','re flex','le np','le flex'});%ordino i nomi della categoria ...
...visualizzare
Y = [ren ref len lef];
bar(X,Y,'g') %if i write it in the command window is ok 
ylabel('degrees')
title('trial:flexion of the elbow') 

%provo a graficare quello che ho in excel
%posizione neutra per i movimenti compensatori 
en= tree.jointData(3).jointAngle(561,1) ; %right 
ef= tree.jointData(4).jointAngle(561,1) ;   %left 
en2= tree.jointData(3).jointAngle(1987,1) ; %right arm cervicale
ef2= tree.jointData(4).jointAngle(1987,1) ;   %right arm torace
en3= tree.jointData(3).jointAngle(2489,1) ;  %left elbow,cervicale
ef3= tree.jointData(4).jointAngle(2489,1) ;   %left elbow,torace 


