%D:\PSU\research2\RESEARCHDATA\GData2\AOO_SingleCorridor_02_Green
% Green(new code from here)
clear,clc
 
%% 1. Only for importing data
%%%%%%%%%%%% import climate data
tic
AOOdata = split(importdata('AOO.txt'),'	');
AOO.station0 = AOOdata(:,1);
AOO.valid0 = AOOdata(:,2);
AOO.airtemperature0 = AOOdata(:,3);
AOO.hourprecipitation0 = AOOdata(:,8);
AOO.visibility0 = AOOdata(:,11);
AOO.skycoverage10 = AOOdata(:,13);
AOO.skycoverage20 = AOOdata(:,14);
AOO.skycoverage30 = AOOdata(:,15);
AOO.skycoverage40 = AOOdata(:,16);
AOO.skylevel10 = AOOdata(:,17);
AOO.skylevel20 = AOOdata(:,18);
AOO.skylevel30 = AOOdata(:,19);
AOO.skylevel40 = AOOdata(:,20);
AOO.weathercode0 = AOOdata(:,21);
AOO.datetime0 = datetime(AOO.valid0,'InputFormat','M/d/yyyy H:mm');
AOO.datevec0 = datevec(AOO.datetime0);
toc
%Elapsed time is 0.971860 seconds.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MODIFIED IN 7/24/2018 ONLY RUN THIS PART ONCE, OTHERWISE PLEASE CLEAR ALL DATA AND RE-RUN FROM START
% Remove one-hour data after preciAOOation ends
tic
removeindex0 = [];
for i = 1:(numel(AOO.hourprecipitation0)-1)
    if (str2double(AOO.hourprecipitation0(i,1)) > 0 & str2double(AOO.hourprecipitation0(i+1,1)) == 0)
        removeindex0 = [removeindex0; i+1];
    end
end
AOO.station0(removeindex0) = [];
AOO.valid0(removeindex0) = [];
AOO.airtemperature0(removeindex0) = [];
AOO.hourprecipitation0(removeindex0) = [];
AOO.visibility0(removeindex0) = [];
AOO.skycoverage10(removeindex0) = [];
AOO.skycoverage20(removeindex0) = [];
AOO.skycoverage30(removeindex0) = [];
AOO.skycoverage40(removeindex0) = [];
AOO.skylevel10(removeindex0) = [];
AOO.skylevel20(removeindex0) = [];
AOO.skylevel30(removeindex0) = [];
AOO.skylevel40(removeindex0) = [];
AOO.weathercode0(removeindex0) = [];
AOO.datetime0(removeindex0) = [];
AOO.datevec0(removeindex0,:) = [];
toc
%Elapsed time is 0.682742 seconds.


%% 2. load data from Excel "traffic.txt" 
%%%%%%%%%%%%%%%%%% import traffic data
tic
trafficdata = importdata('traffic.txt');
trafficdata0 = struct2cell(trafficdata);

numdata0 = cell2mat(trafficdata0(1,1));
TRAFFIC.speed0 = numdata0(:,1);
TRAFFIC.travel_time0 = numdata0(:,4);
TRAFFIC.conf_score0 = numdata0(:,5);
TRAFFIC.measure_tstamp0 = trafficdata.textdata(:,2);
TRAFFIC.tmc_code0 = trafficdata0{2,1}(:,1);
TRAFFIC.datetime0 = datetime(TRAFFIC.measure_tstamp0,'InputFormat','M/d/yyyy H:mm');
TRAFFIC.datevec0 = datevec(TRAFFIC.measure_tstamp0);
toc
%Elapsed time is 90.529821 seconds.

%Next, we are to append AOO to TRAFFIC.
tic
for i = 1:numel(AOO.station0)
    dateindex = find(ismember(TRAFFIC.datevec0(:,1:4),AOO.datevec0(i,1:4),'rows'));
    if(~isempty(dateindex))
        TRAFFIC.station0(dateindex,1) = AOO.station0(i,1);
        TRAFFIC.airtemperature0(dateindex,:) = AOO.airtemperature0(i,:);
        TRAFFIC.hourprecipitation0(dateindex,:) = AOO.hourprecipitation0(i,:);
        TRAFFIC.visibility0(dateindex,:) = AOO.visibility0(i,:);
        TRAFFIC.skycoverage10(dateindex,:) = AOO.skycoverage10(i,:);
        TRAFFIC.skycoverage20(dateindex,:) = AOO.skycoverage20(i,:);
        TRAFFIC.skycoverage30(dateindex,:) = AOO.skycoverage30(i,:);
        TRAFFIC.skycoverage40(dateindex,:) = AOO.skycoverage40(i,:);
        TRAFFIC.skylevel10(dateindex,:) = AOO.skylevel10(i,:);
        TRAFFIC.skylevel20(dateindex,:) = AOO.skylevel20(i,:);
        TRAFFIC.skylevel30(dateindex,:) = AOO.skylevel30(i,:);
        TRAFFIC.skylevel40(dateindex,:) = AOO.skylevel40(i,:);
        TRAFFIC.weathercode0(dateindex,:) = AOO.weathercode0(i,:);
    end
end
toc
%Elapsed time is 380.369432 seconds.

% 07/29/2018 Next, we should remove empty elements from TRAFFIC.speed0,etc
% Run this part ONLY ONCE!!!
tic
precipitationnonemptyindex0 = find(~cellfun(@isempty, TRAFFIC.hourprecipitation0));
TRAFFIC.speed0 = TRAFFIC.speed0(precipitationnonemptyindex0,:);
TRAFFIC.travel_time0 = TRAFFIC.travel_time0(precipitationnonemptyindex0,:);
TRAFFIC.conf_score0 = TRAFFIC.conf_score0(precipitationnonemptyindex0,:);
TRAFFIC.measure_tstamp0 = TRAFFIC.measure_tstamp0(precipitationnonemptyindex0,:);
TRAFFIC.tmc_code0 = TRAFFIC.tmc_code0(precipitationnonemptyindex0,:);
TRAFFIC.datetime0 = TRAFFIC.datetime0(precipitationnonemptyindex0,:);
TRAFFIC.datevec0 = TRAFFIC.datevec0(precipitationnonemptyindex0,:);
TRAFFIC.station0 = TRAFFIC.station0(precipitationnonemptyindex0,:);
TRAFFIC.airtemperature0 = TRAFFIC.airtemperature0(precipitationnonemptyindex0,:);
TRAFFIC.hourprecipitation0 = TRAFFIC.hourprecipitation0(precipitationnonemptyindex0,:);
TRAFFIC.visibility0 = TRAFFIC.visibility0(precipitationnonemptyindex0,:);
TRAFFIC.skycoverage10 = TRAFFIC.skycoverage10(precipitationnonemptyindex0,:);
TRAFFIC.skycoverage20 = TRAFFIC.skycoverage20(precipitationnonemptyindex0,:);
TRAFFIC.skycoverage30 = TRAFFIC.skycoverage30(precipitationnonemptyindex0,:);
TRAFFIC.skycoverage40 = TRAFFIC.skycoverage40(precipitationnonemptyindex0,:);
TRAFFIC.skylevel10 = TRAFFIC.skylevel10(precipitationnonemptyindex0,:);
TRAFFIC.skylevel20 = TRAFFIC.skylevel20(precipitationnonemptyindex0,:);
TRAFFIC.skylevel30 = TRAFFIC.skylevel30(precipitationnonemptyindex0,:);
TRAFFIC.skylevel40 = TRAFFIC.skylevel40(precipitationnonemptyindex0,:);
TRAFFIC.weathercode0 = TRAFFIC.weathercode0(precipitationnonemptyindex0,:);
toc
%Elapsed time is 1.059255 seconds.


%%
tic
tmcdata = split(importdata('tmc.txt'),'	');
TMC.tmc_code0 = tmcdata(:,1);
TMC.road0 = tmcdata(:,2);
TMC.direction0 = tmcdata(:,3);
TMC.miles0 = tmcdata(:,12);
toc
%Elapsed time is 3.293702 seconds.

tic
for i = 1:numel(TMC.tmc_code0)
    tmcindex = find(ismember(TRAFFIC.tmc_code0,TMC.tmc_code0{i,:}(1,:)));
    if(~isempty(tmcindex))
        TRAFFIC.road0(tmcindex,1) = TMC.road0(i,1);
        TRAFFIC.direction0(tmcindex,1) = TMC.direction0(i,1);
        TRAFFIC.miles0(tmcindex,1) = TMC.miles0(i,1);
    end
end
toc
%Elapsed time is 0.645418 seconds.


%% separate two directions and conf_score >= 20:
tic
directionstat0 = sortrows(tabulate(TRAFFIC.direction0));
directionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.direction0,directionstat0{1,1})));
TRAFFIC.speed3 = TRAFFIC.speed0(directionindex3,1);
TRAFFIC.travel_time3 = TRAFFIC.travel_time0(directionindex3,1);
TRAFFIC.conf_score3 = TRAFFIC.conf_score0(directionindex3,1);
TRAFFIC.measure_tstamp3 = TRAFFIC.measure_tstamp0(directionindex3,1);
TRAFFIC.tmc_code3 = TRAFFIC.tmc_code0(directionindex3,1);
TRAFFIC.datetime3 = TRAFFIC.datetime0(directionindex3,1);
TRAFFIC.datevec3 = TRAFFIC.datevec0(directionindex3,:);
TRAFFIC.station3 = TRAFFIC.station0(directionindex3,1);
TRAFFIC.airtemperature3 = TRAFFIC.airtemperature0(directionindex3,1);
TRAFFIC.hourprecipitation3 = TRAFFIC.hourprecipitation0(directionindex3,1);
TRAFFIC.visibility3 = TRAFFIC.visibility0(directionindex3,1);
TRAFFIC.skycoverage13 = TRAFFIC.skycoverage10(directionindex3,1);
TRAFFIC.skycoverage23 = TRAFFIC.skycoverage20(directionindex3,1);
TRAFFIC.skycoverage33 = TRAFFIC.skycoverage30(directionindex3,1);
TRAFFIC.skycoverage43 = TRAFFIC.skycoverage40(directionindex3,1);
TRAFFIC.skylevel13 = TRAFFIC.skylevel10(directionindex3,1);
TRAFFIC.skylevel23 = TRAFFIC.skylevel20(directionindex3,1);
TRAFFIC.skylevel33 = TRAFFIC.skylevel30(directionindex3,1);
TRAFFIC.skylevel43 = TRAFFIC.skylevel40(directionindex3,1);
TRAFFIC.weathercode3 = TRAFFIC.weathercode0(directionindex3,1);
TRAFFIC.road3 = TRAFFIC.road0(directionindex3,1);
TRAFFIC.direction3 = TRAFFIC.direction0(directionindex3,1);
TRAFFIC.miles3 = TRAFFIC.miles0(directionindex3,1);

directionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.direction0,directionstat0{2,1})));
TRAFFIC.speed4 = TRAFFIC.speed0(directionindex4,1);
TRAFFIC.travel_time4 = TRAFFIC.travel_time0(directionindex4,1);
TRAFFIC.conf_score4 = TRAFFIC.conf_score0(directionindex4,1);
TRAFFIC.measure_tstamp4 = TRAFFIC.measure_tstamp0(directionindex4,1);
TRAFFIC.tmc_code4 = TRAFFIC.tmc_code0(directionindex4,1);
TRAFFIC.datetime4 = TRAFFIC.datetime0(directionindex4,1);
TRAFFIC.datevec4 = TRAFFIC.datevec0(directionindex4,:);
TRAFFIC.station4 = TRAFFIC.station0(directionindex4,1);
TRAFFIC.airtemperature4 = TRAFFIC.airtemperature0(directionindex4,1);
TRAFFIC.hourprecipitation4 = TRAFFIC.hourprecipitation0(directionindex4,1);
TRAFFIC.visibility4 = TRAFFIC.visibility0(directionindex4,1);
TRAFFIC.skycoverage14 = TRAFFIC.skycoverage10(directionindex4,1);
TRAFFIC.skycoverage24 = TRAFFIC.skycoverage20(directionindex4,1);
TRAFFIC.skycoverage34 = TRAFFIC.skycoverage30(directionindex4,1);
TRAFFIC.skycoverage44 = TRAFFIC.skycoverage40(directionindex4,1);
TRAFFIC.skylevel14 = TRAFFIC.skylevel10(directionindex4,1);
TRAFFIC.skylevel24 = TRAFFIC.skylevel20(directionindex4,1);
TRAFFIC.skylevel34 = TRAFFIC.skylevel30(directionindex4,1);
TRAFFIC.skylevel44 = TRAFFIC.skylevel40(directionindex4,1);
TRAFFIC.weathercode4 = TRAFFIC.weathercode0(directionindex4,1);
TRAFFIC.road4 = TRAFFIC.road0(directionindex4,1);
TRAFFIC.direction4 = TRAFFIC.direction0(directionindex4,1);
TRAFFIC.miles4 = TRAFFIC.miles0(directionindex4,1);
toc
%Elapsed time is 3.367178 seconds.

% find conf_score:
tic
confscoreindex3 = find(TRAFFIC.conf_score3 ~= 30);
TRAFFIC.speed3(confscoreindex3) = [];
TRAFFIC.travel_time3(confscoreindex3) = [];
TRAFFIC.conf_score3(confscoreindex3) = [];
TRAFFIC.measure_tstamp3(confscoreindex3) = [];
TRAFFIC.tmc_code3(confscoreindex3) = [];
TRAFFIC.datetime3(confscoreindex3) = [];
TRAFFIC.datevec3(confscoreindex3) = [];
TRAFFIC.datevec3 = reshape(TRAFFIC.datevec3,numel(TRAFFIC.datetime3),6);
TRAFFIC.station3(confscoreindex3) = [];
TRAFFIC.airtemperature3(confscoreindex3) = [];
TRAFFIC.hourprecipitation3(confscoreindex3) = [];
TRAFFIC.visibility3(confscoreindex3) = [];
TRAFFIC.skycoverage13(confscoreindex3) = [];
TRAFFIC.skycoverage23(confscoreindex3) = [];
TRAFFIC.skycoverage33(confscoreindex3) = [];
TRAFFIC.skycoverage43(confscoreindex3) = [];
TRAFFIC.skylevel13(confscoreindex3) = [];
TRAFFIC.skylevel23(confscoreindex3) = [];
TRAFFIC.skylevel33(confscoreindex3) = [];
TRAFFIC.skylevel43(confscoreindex3) = [];
TRAFFIC.weathercode3(confscoreindex3) = [];
TRAFFIC.road3(confscoreindex3) = [];
TRAFFIC.direction3(confscoreindex3) = [];
TRAFFIC.miles3(confscoreindex3) = [];

confscoreindex4 = find(TRAFFIC.conf_score4 ~= 30);
TRAFFIC.speed4(confscoreindex4) = [];
TRAFFIC.travel_time4(confscoreindex4) = [];
TRAFFIC.conf_score4(confscoreindex4) = [];
TRAFFIC.measure_tstamp4(confscoreindex4) = [];
TRAFFIC.tmc_code4(confscoreindex4) = [];
TRAFFIC.datetime4(confscoreindex4) = [];
TRAFFIC.datevec4(confscoreindex4) = [];
TRAFFIC.datevec4 = reshape(TRAFFIC.datevec4,numel(TRAFFIC.datetime4),6);
TRAFFIC.station4(confscoreindex4) = [];
TRAFFIC.airtemperature4(confscoreindex4) = [];
TRAFFIC.hourprecipitation4(confscoreindex4) = [];
TRAFFIC.visibility4(confscoreindex4) = [];
TRAFFIC.skycoverage14(confscoreindex4) = [];
TRAFFIC.skycoverage24(confscoreindex4) = [];
TRAFFIC.skycoverage34(confscoreindex4) = [];
TRAFFIC.skycoverage44(confscoreindex4) = [];
TRAFFIC.skylevel14(confscoreindex4) = [];
TRAFFIC.skylevel24(confscoreindex4) = [];
TRAFFIC.skylevel34(confscoreindex4) = [];
TRAFFIC.skylevel44(confscoreindex4) = [];
TRAFFIC.weathercode4(confscoreindex4) = [];
TRAFFIC.road4(confscoreindex4) = [];
TRAFFIC.direction4(confscoreindex4) = [];
TRAFFIC.miles4(confscoreindex4) = [];
toc
%Elapsed time is 0.223961 seconds.


%% 9/2/2018 TEST IF CONGESTION APPEARED.
figure(1)
plot(TRAFFIC.datetime3, TRAFFIC.speed3)
figure(2)
plot(TRAFFIC.datetime4, TRAFFIC.speed4)


%% 7/27/2018 take average for "Speed3" and "Speed4"
tic
statmeasure_tstamp3 = tabulate(TRAFFIC.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(TRAFFIC.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    TRAFFICAVE.speed3(i,:) = sum(TRAFFIC.speed3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE.travel_time3(i,:) = sum(TRAFFIC.travel_time3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE.conf_score3(i,:) = sum(TRAFFIC.conf_score3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE.measure_tstamp3(i,:) = TRAFFIC.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.tmc_code3(i,:) = TRAFFIC.tmc_code3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.datetime3(i,:) = TRAFFIC.datetime3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.datevec3(i,:) = TRAFFIC.datevec3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.station3(i,:) = TRAFFIC.station3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.airtemperature3(i,:) = sum(str2double(TRAFFIC.airtemperature3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE.hourprecipitation3(i,:) = sum(str2double(TRAFFIC.hourprecipitation3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE.visibility3(i,:) = sum(str2double(TRAFFIC.visibility3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE.skycoverage13(i,:) = TRAFFIC.skycoverage13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.skycoverage23(i,:) = TRAFFIC.skycoverage23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.skycoverage33(i,:) = TRAFFIC.skycoverage33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.skycoverage43(i,:) = TRAFFIC.skycoverage43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.skylevel13(i,:) = TRAFFIC.skylevel13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.skylevel23(i,:) = TRAFFIC.skylevel23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.skylevel33(i,:) = TRAFFIC.skylevel33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.skylevel43(i,:) = TRAFFIC.skylevel43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.weathercode3(i,:) = TRAFFIC.weathercode3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.road3(i,:) = TRAFFIC.road3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.direction3(i,:) = TRAFFIC.direction3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE.miles3(i,:) = sum(str2double(TRAFFIC.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 49258.054627 seconds.

tic
statmeasure_tstamp4 = tabulate(TRAFFIC.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(TRAFFIC.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    TRAFFICAVE.speed4(i,:) = sum(TRAFFIC.speed4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE.travel_time4(i,:) = sum(TRAFFIC.travel_time4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE.conf_score4(i,:) = sum(TRAFFIC.conf_score4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE.measure_tstamp4(i,:) = TRAFFIC.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.tmc_code4(i,:) = TRAFFIC.tmc_code4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.datetime4(i,:) = TRAFFIC.datetime4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.datevec4(i,:) = TRAFFIC.datevec4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.station4(i,:) = TRAFFIC.station4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.airtemperature4(i,:) = sum(str2double(TRAFFIC.airtemperature4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE.hourprecipitation4(i,:) = sum(str2double(TRAFFIC.hourprecipitation4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE.visibility4(i,:) = sum(str2double(TRAFFIC.visibility4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE.skycoverage14(i,:) = TRAFFIC.skycoverage14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.skycoverage24(i,:) = TRAFFIC.skycoverage24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.skycoverage34(i,:) = TRAFFIC.skycoverage34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.skycoverage44(i,:) = TRAFFIC.skycoverage44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.skylevel14(i,:) = TRAFFIC.skylevel14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.skylevel24(i,:) = TRAFFIC.skylevel24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.skylevel34(i,:) = TRAFFIC.skylevel34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.skylevel44(i,:) = TRAFFIC.skylevel44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.weathercode4(i,:) = TRAFFIC.weathercode4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.road4(i,:) = TRAFFIC.road4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.direction4(i,:) = TRAFFIC.direction4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE.miles4(i,:) = sum(str2double(TRAFFIC.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 60296.569098 seconds.

%% 9/13/2018 SHORTENED BY YINGHAI
% if speeds lower than 55mph and this time point has no precipitation, we
% remove it. if it has precipitation, we remain it.
% so, we have a new CONSTRUCT "TRAFFICREMOVE"

tic
% speed limit - 5 mph for clear hours, Northbound:
clearfreeflowspeedindex3 = find((TRAFFICAVE.speed3 >= 60 & TRAFFICAVE.hourprecipitation3 == 0) | (TRAFFICAVE.speed3 >= 55 & TRAFFICAVE.hourprecipitation3 > 0));
namesTRAFFICAVE = fieldnames(TRAFFICAVE);
for i = 1:(numel(namesTRAFFICAVE)/2)
    eval(['TRAFFICREMOVE.',char(namesTRAFFICAVE(i)),' = TRAFFICAVE.',char(namesTRAFFICAVE(i)),'(clearfreeflowspeedindex3,:);']);
end
toc
%Elapsed time is 0.351674 seconds.

tic
clearfreeflowspeedindex4 = find((TRAFFICAVE.speed4 >= 50 & TRAFFICAVE.hourprecipitation4 == 0) | (TRAFFICAVE.speed4 >= 50 & TRAFFICAVE.hourprecipitation4 > 0));
namesTRAFFICAVE = fieldnames(TRAFFICAVE);
for i = (numel(namesTRAFFICAVE)/2+1):numel(namesTRAFFICAVE)
    eval(['TRAFFICREMOVE.',char(namesTRAFFICAVE(i)),' = TRAFFICAVE.',char(namesTRAFFICAVE(i)),'(clearfreeflowspeedindex4,:) ;']);
end
toc
% Elapsed time is 0.126545 seconds.


%% descriptive statistics and speed vs time graph// 8/1/2018
% THIS IS SPEED-TIME GRAPH BEFORE REMOVAL!!!
% the descriptive statistics information was stored in "STAT"
% Then draw the HISTOGRAM of hourprecipitation.
STATAVE.max3 = max(TRAFFICAVE.speed3);
STATAVE.mean3 = mean(TRAFFICAVE.speed3);
STATAVE.min3 = min(TRAFFICAVE.speed3);
STATAVE.std3 = std(TRAFFICAVE.speed3);
STATAVE.samplesize3 = numel(TRAFFICAVE.speed3);
STATAVE.countnonprecipitation3 = sum(TRAFFICAVE.hourprecipitation3 == 0);
STATAVE.countprecipitation3 = sum(TRAFFICAVE.hourprecipitation3 > 0)
fractionprecipitation3 = STATAVE.countnonprecipitation3/(STATAVE.countnonprecipitation3 + STATAVE.countprecipitation3)

STATAVE.max4 = max(TRAFFICAVE.speed4);
STATAVE.mean4 = mean(TRAFFICAVE.speed4);
STATAVE.min4 = min(TRAFFICAVE.speed4);
STATAVE.std4 = std(TRAFFICAVE.speed4);
STATAVE.samplesize4 = numel(TRAFFICAVE.speed4);
STATAVE.countnonprecipitation4 = sum(TRAFFICAVE.hourprecipitation4 == 0);
STATAVE.countprecipitation4 = sum(TRAFFICAVE.hourprecipitation4 > 0)
fractionprecipitation4 = STATAVE.countnonprecipitation4/(STATAVE.countnonprecipitation4 + STATAVE.countprecipitation4)

figure(1)
tic
hold on
grid minor

histogram(TRAFFICAVE.hourprecipitation3)
set(gca,'FontSize',9)
xlabel('Precipitation')
ylabel('Count')
title('Histogram of Precipitation (Northbound/Eastbound)')
hold off
saveas(figure(1),'1N_E.jpg');
toc

figure(2)
tic
hold on
grid minor
histogram(TRAFFICAVE.hourprecipitation4)
set(gca,'FontSize',9)
xlabel('Precipitation')
ylabel('Count')
title('Histogram of Precipitation (Southbound/Westbound)')
hold off
saveas(figure(2),'1S_W.jpg');
toc


% the following part is SPEED-TIME graph:
figure(3)
tic
hold on
grid minor
plot(TRAFFICAVE.datetime3,TRAFFICAVE.speed3,'LineWidth',1.5)
set(gca,'FontSize',9)

xlim([min(TRAFFICAVE.datetime3)-calweeks(1),max(TRAFFICAVE.datetime3)+calweeks(1)])
Hlegend3 = legend( 'Average speed (mph) ');
set(Hlegend3,'Position',[.5,.885,.4,.04]);
xlabel('Time')
ylabel('Average Speed (mph)')
title('Speed - Time (Northbound/Eastbound)')
hold off
saveas(figure(3), '2N_E.jpg');
toc
%Elapsed time is 10.874505 seconds.

figure(4)
tic
hold on
grid minor
plot(TRAFFICAVE.datetime4,TRAFFICAVE.speed4,'LineWidth',1.5)
set(gca,'FontSize',9)

xlim([min(TRAFFICAVE.datetime4)-calweeks(1),max(TRAFFICAVE.datetime4)+calweeks(1)])
Hlegend4 = legend( 'Average speed (mph) ');
set(Hlegend4,'Position',[.5,.885,.4,.04]);
xlabel('Time')
ylabel('Average Speed (mph)')
title('Speed - Time (Southbound/Westbound)')
hold off
saveas(figure(4), '2S_W.jpg');
toc
%Elapsed time is 1.487571 seconds.


%% descriptive statistics and speed vs time graph// 07-22-2018
% the descriptive statistics information was stored in "STAT"
% Then draw the HISTOGRAM of hourprecipitation.
STAT.max3 = max(TRAFFICREMOVE.speed3);
STAT.mean3 = mean(TRAFFICREMOVE.speed3);
STAT.min3 = min(TRAFFICREMOVE.speed3);
STAT.std3 = std(TRAFFICREMOVE.speed3);
STAT.samplesize3 = numel(TRAFFICREMOVE.speed3);
STAT.countnonprecipitation3 = sum(TRAFFICREMOVE.hourprecipitation3 == 0);
STAT.countprecipitation3 = sum(TRAFFICREMOVE.hourprecipitation3 > 0)
fractionprecipitation3 = STAT.countnonprecipitation3/(STAT.countnonprecipitation3 + STAT.countprecipitation3)

STAT.max4 = max(TRAFFICREMOVE.speed4);
STAT.mean4 = mean(TRAFFICREMOVE.speed4);
STAT.min4 = min(TRAFFICREMOVE.speed4);
STAT.std4 = std(TRAFFICREMOVE.speed4);
STAT.samplesize4 = numel(TRAFFICREMOVE.speed4);
STAT.countnonprecipitation4 = sum(TRAFFICREMOVE.hourprecipitation4 == 0);
STAT.countprecipitation4 = sum(TRAFFICREMOVE.hourprecipitation4 > 0)
fractionprecipitation4 = STAT.countnonprecipitation4/(STAT.countnonprecipitation4 + STAT.countprecipitation4)

figure(1)
tic
hold on
grid minor
histogram(TRAFFICREMOVE.hourprecipitation3)
set(gca,'FontSize',9)
xlabel('Precipitation')
ylabel('Count')
title('Histogram of Precipitation (Northbound/Eastbound)')
hold off
saveas(figure(1),'3N_E.jpg');
toc

figure(2)
tic
hold on
grid minor
histogram(TRAFFICREMOVE.hourprecipitation4)
set(gca,'FontSize',9)
xlabel('Precipitation')
ylabel('Count')
title('Histogram of Precipitation (Southbound/Westbound)')
hold off
saveas(figure(2),'3S_W.jpg');
toc


% the following part is SPEED-TIME graph:
figure(3)
tic
hold on
grid minor
plot(TRAFFICREMOVE.datetime3,TRAFFICREMOVE.speed3,'LineWidth',1.5)
set(gca,'FontSize',9)

xlim([min(TRAFFICREMOVE.datetime3)-calweeks(1),max(TRAFFICREMOVE.datetime3)+calweeks(1)])
Hlegend3 = legend( 'Average speed (mph) ');
set(Hlegend3,'Position',[.5,.885,.4,.04]);
xlabel('Time')
ylabel('Average Speed (mph)')
title('Speed - Time (Northbound/Eastbound)')
hold off
saveas(figure(3), '4N_E.jpg');
toc
%Elapsed time is 10.874505 seconds.

figure(4)
tic
hold on
grid minor
plot(TRAFFICREMOVE.datetime4,TRAFFICREMOVE.speed4,'LineWidth',1.5)
set(gca,'FontSize',9)

xlim([min(TRAFFICREMOVE.datetime4)-calweeks(1),max(TRAFFICREMOVE.datetime4)+calweeks(1)])
Hlegend4 = legend( 'Average speed (mph) ');
set(Hlegend4,'Position',[.5,.885,.4,.04]);
xlabel('Time')
ylabel('Average Speed (mph)')
title('Speed - Time (Southbound/Westbound)')
hold off
saveas(figure(4), '4S_W.jpg');
toc
%Elapsed time is 1.487571 seconds.

%% NOW WE CAN IGNORE THIS PART! BUT IF OUTLIERS EXIST, WE SHOULD RUN THIS!!!
% calculation the Number of outliers:
outliersindex3 = find(TRAFFICREMOVE.speed3 <= 30)
outliersindex4 = find(TRAFFICREMOVE.speed4 <= 30)
outliers3 = numel(find(TRAFFICREMOVE.speed3 <= 30))
outliers4 = numel(find(TRAFFICREMOVE.speed4 <= 30))

% then remove outliers' record if needed:
% in this corridor, we want to remove Southbound's outliers.
% BE SURE TO RUN EACH DIRECTION SEPARATELY!!!
tic
notoutliersindex3 = find(TRAFFICREMOVE.speed3 > 30);
namesTRAFFICREMOVE3 = fieldnames(TRAFFICREMOVE);
for i = 1:numel(namesTRAFFICREMOVE3)/2
    eval(['TRAFFICREMOVE.',char(namesTRAFFICREMOVE3(i)),'(outliersindex3,:) = [];']);
end
toc
% Elapsed time is 0.351674 seconds.

tic
notoutliersindex4 = find(TRAFFICREMOVE.speed4 > 30);
namesTRAFFICREMOVE4 = fieldnames(TRAFFICREMOVE);
for i = (numel(namesTRAFFICREMOVE4)/2):numel(namesTRAFFICREMOVE4)
    eval(['TRAFFICREMOVE.',char(namesTRAFFICREMOVE4(i)),'(outliersindex4,:) = [];']);
end
toc
%Elapsed time is 0.351674 seconds.

STAT.max3 = max(TRAFFICREMOVE.speed3);
STAT.mean3 = mean(TRAFFICREMOVE.speed3);
STAT.min3 = min(TRAFFICREMOVE.speed3);
STAT.std3 = std(TRAFFICREMOVE.speed3);
STAT.samplesize3 = numel(TRAFFICREMOVE.speed3);
STAT.countnonprecipitation3 = sum(TRAFFICREMOVE.hourprecipitation3 == 0);
STAT.countprecipitation3 = sum(TRAFFICREMOVE.hourprecipitation3 > 0)
fractionprecipitation3 = STAT.countnonprecipitation3/(STAT.countnonprecipitation3 + STAT.countprecipitation3)

STAT.max4 = max(TRAFFICREMOVE.speed4);
STAT.mean4 = mean(TRAFFICREMOVE.speed4);
STAT.min4 = min(TRAFFICREMOVE.speed4);
STAT.std4 = std(TRAFFICREMOVE.speed4);
STAT.samplesize4 = numel(TRAFFICREMOVE.speed4);
STAT.countnonprecipitation4 = sum(TRAFFICREMOVE.hourprecipitation4 == 0);
STAT.countprecipitation4 = sum(TRAFFICREMOVE.hourprecipitation4 > 0)
fractionprecipitation4 = STAT.countnonprecipitation4/(STAT.countnonprecipitation4 + STAT.countprecipitation4)

figure(1)
tic
hold on
grid minor
histogram(TRAFFICREMOVE.hourprecipitation3)
set(gca,'FontSize',9)
xlabel('Precipitation')
ylabel('Count')
title('Histogram of Precipitation after removing outliers (Northbound/Eastbound)')
hold off
saveas(figure(1),'5N_E.jpg');
toc

figure(2)
tic
hold on
grid minor
histogram(TRAFFICREMOVE.hourprecipitation4)
set(gca,'FontSize',9)
xlabel('Precipitation')
ylabel('Count')
title('Histogram of Precipitation after removing outliers (Southbound/Westbound)')
hold off
saveas(figure(2),'6S_W.jpg');
toc


% the following part is SPEED-TIME graph:
figure(3)
tic
hold on
grid minor
plot(TRAFFICREMOVE.datetime3,TRAFFICREMOVE.speed3,'LineWidth',1.5)
set(gca,'FontSize',9)

xlim([min(TRAFFICREMOVE.datetime3)-calweeks(1),max(TRAFFICREMOVE.datetime3)+calweeks(1)])
Hlegend3 = legend( 'Average speed (mph) ');
set(Hlegend3,'Position',[.5,.885,.4,.04]);
xlabel('Time')
ylabel('Average Speed (mph)')
title('Speed - Time after removing outliers (Northbound/Eastbound)')
hold off
saveas(figure(3), '7N_E.jpg');
toc
%Elapsed time is 10.874505 seconds.

figure(4)
tic
hold on
grid minor
plot(TRAFFICREMOVE.datetime4,TRAFFICREMOVE.speed4,'LineWidth',1.5)
set(gca,'FontSize',9)

xlim([min(TRAFFICREMOVE.datetime4)-calweeks(1),max(TRAFFICREMOVE.datetime4)+calweeks(1)])
Hlegend4 = legend( 'Average speed (mph) ');
set(Hlegend4,'Position',[.5,.885,.4,.04]);
xlabel('Time')
ylabel('Average Speed (mph)')
title('Speed - Time after removing outliers (Southbound/Westbound)')
hold off
saveas(figure(4), '8S_W.jpg');
toc
%Elapsed time is 1.487571 seconds.

%% HERE WAS MODIFIED_7/23/2018
% we pick a single day to draw the Line Chart
tic
for i = 5:10
    % see how to pick a random element in a give array: https://blog.csdn.net/hnxyxiaomeng/article/details/53122068
    eval(['month3index',num2str(i),'= TRAFFICREMOVE.datevec3(:,2) == i;']);
    % month3index7 = TRAFFICREMOVE.datevec3(:,2) == 7;
    eval(['day3stat',num2str(i),'= tabulate(TRAFFICREMOVE.datevec3(month3index',num2str(i),',3));']);
    % day3stat7 = tabulate(TRAFFICREMOVE.datevec3(month3index7,3));
    
    for j = 1:31   % This FOR LOOP is to select the 1st row whose second column is not 0.
        if (eval(['day3stat',num2str(i),'(j,2) == 0']))
            continue
        end
        break
    end  % when FOR LOOP finished, j is the row index.

    eval(['start3minute',num2str(i),'=',' datetime(2015, i, j, 10, 0, 0);'])
    % start3minute7 = datetime(2015, 7, j, 10, 0, 0);
    eval(['end3minute',num2str(i),'= start3minute', num2str(i),'+hours(6);'])
    % end3minute7 = start3minute7 + hours(6);
    eval(['xmonth3dayindex',num2str(i), '= find(TRAFFICREMOVE.datetime3 <= end3minute',num2str(i),' & TRAFFICREMOVE.datetime3 >= start3minute',num2str(i),');']);
    % xmonth3dayindex7 = find(TRAFFICREMOVE.datetime3 <= end3minute7 & TRAFFICREMOVE.datetime3 >= start3minute7);
    eval(['xmonth3day', num2str(i),'= TRAFFICREMOVE.datetime3(xmonth3dayindex',num2str(i),');']);
    % xmonth3day7 = TRAFFICREMOVE.datetime3(xmonth3dayindex7);
end


for i = 5:10
    figure(i)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',TRAFFICREMOVE.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex', num2str(i),'))-3, max(TRAFFICREMOVE.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (Northbound/Eastbound)')
    hold off

    eval(['saveas(figure(i),','''N_E',num2str(i),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


%%%%%%%%%%%%%%%%%% SOUTHBOUND/WESTBOUND
tic
for i = 5:10
    % see how to pick a random element in a give array: https://blog.csdn.net/hnxyxiaomeng/article/details/53122068
    eval(['month4index',num2str(i),'= TRAFFICREMOVE.datevec4(:,2) == i;']);
    % month4index7 = TRAFFICREMOVE.datevec4(:,2) == 7;
    eval(['day4stat',num2str(i),'= tabulate(TRAFFICREMOVE.datevec4(month4index',num2str(i),',3));']);
    % day4stat7 = tabulate(TRAFFICREMOVE.datevec4(month4index7,3));
    
    for j = 1:31   % This FOR LOOP is to select the 1st row whose second column is not 0.
        if (eval(['day4stat',num2str(i),'(j,2) == 0']))
            continue
        end
        break
    end  % when FOR LOOP finished, j is the row index.

    eval(['start4minute',num2str(i),'=',' datetime(2015, i, j, 10, 0, 0);'])
    % start4minute7 = datetime(2015, 7, j, 10, 0, 0);
    eval(['end4minute',num2str(i),'= start4minute', num2str(i),'+hours(6);'])
    % end4minute7 = start4minute7 + hours(6);
    eval(['xmonth4dayindex',num2str(i), '= find(TRAFFICREMOVE.datetime4 <= end4minute',num2str(i),' & TRAFFICREMOVE.datetime4 >= start4minute',num2str(i),');']);
    % xmonth4dayindex7 = find(TRAFFICREMOVE.datetime4 <= end4minute7 & TRAFFICREMOVE.datetime4 >= start4minute7);
    eval(['xmonth4day', num2str(i),'= TRAFFICREMOVE.datetime4(xmonth4dayindex',num2str(i),');']);
    % xmonth4day7 = TRAFFICREMOVE.datetime4(xmonth4dayindex7);
end


for i = 5:10
    figure(i+6)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',TRAFFICREMOVE.speed4(xmonth4dayindex',num2str(i),'))'])
    % H4month7 = plot(xmonth4day7,TRAFFICREMOVE.speed4(xmonth4dayindex7))
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    % H4month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth4day7), max(xmonth4day7) + minutes(5)]);
    eval(['ylim([min(TRAFFICREMOVE.speed4(xmonth4dayindex', num2str(i),'))-3, max(TRAFFICREMOVE.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed4(xmonth4dayindex7)) - 3, max(TRAFFICREMOVE.speed4(xmonth4dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (Southbound/Westbound)')
    hold off

    eval(['saveas(figure(i+6),','''S_W',num2str(i),'.jpg'');']);
    % saveas(figure(13), 'S_W7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 13.407092 seconds.


%% 
tic
precipitation0index3 = find(TRAFFICREMOVE.hourprecipitation3 == 0);
precipitation01index3 = find(TRAFFICREMOVE.hourprecipitation3 >= 0.01 & TRAFFICREMOVE.hourprecipitation3 <= 0.02);
precipitation03index3 = find(TRAFFICREMOVE.hourprecipitation3 > 0.02);
figure(17)
hold on
grid minor
[fprecipitation0index3,xprecipitation0index3] = ecdf(TRAFFICREMOVE.speed3(precipitation0index3,1));
[fprecipitation01index3,xprecipitation01index3] = ecdf(TRAFFICREMOVE.speed3(precipitation01index3,1));
[fprecipitation03index3,xprecipitation03index3] = ecdf(TRAFFICREMOVE.speed3(precipitation03index3,1));
plot(xprecipitation0index3,fprecipitation0index3,'LineWidth',1.5)
set(gca,'FontSize',12)
plot(xprecipitation01index3,fprecipitation01index3,'LineWidth',1.5)
set(gca,'FontSize',12)
plot(xprecipitation03index3,fprecipitation03index3,'LineWidth',1.5)
set(gca,'FontSize',12)

xlim([min(TRAFFICREMOVE.speed3)-0.5,max(TRAFFICREMOVE.speed3)+0.5])
legend( 'average speed on clear days',...
   'average speed under precipitation (0.01 <= precipitation <= 0.02 inch/hr)',...
   'average speed when precipitation > 0.02 inch/hr');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plots of average speeds (Altoona (Northbound))')
hold off
saveas(figure(17), 'N_E_17.jpg');
toc
%Elapsed time is 23.035353 seconds.

tic
precipitation0index4 = find(TRAFFICREMOVE.hourprecipitation4 == 0);
precipitation01index4 = find(TRAFFICREMOVE.hourprecipitation4 >= 0.01 & TRAFFICREMOVE.hourprecipitation4 <= 0.02);
precipitation03index4 = find(TRAFFICREMOVE.hourprecipitation4 > 0.02);
figure(18)
hold on
grid minor
[fprecipitation0index4,xprecipitation0index4] = ecdf(TRAFFICREMOVE.speed4(precipitation0index4,1));
[fprecipitation01index4,xprecipitation01index4] = ecdf(TRAFFICREMOVE.speed4(precipitation01index4,1));
[fprecipitation03index4,xprecipitation03index4] = ecdf(TRAFFICREMOVE.speed4(precipitation03index4,1));
plot(xprecipitation0index4,fprecipitation0index4,'LineWidth',1.5)
set(gca,'FontSize',12)
plot(xprecipitation01index4,fprecipitation01index4,'LineWidth',1.5)
set(gca,'FontSize',12)
plot(xprecipitation03index4,fprecipitation03index4,'LineWidth',1.5)
set(gca,'FontSize',12)

xlim([min(TRAFFICREMOVE.speed4)-0.5,max(TRAFFICREMOVE.speed4)+0.5])
legend( 'average speed on clear days',...
   'average speed under precipitation (0.01 <= precipitation <= 0.02 inch/hr)',...
   'average speed when precipitation > 0.02 inch/hr');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plots of average speeds (Altoona (Southbound))')
hold off
saveas(figure(18), 'S_W_18.jpg');
toc
%Elapsed time is 10.702161 seconds.

%%
tic
precipitation0index3 = find(TRAFFICREMOVE.hourprecipitation3 <= 0.02);
precipitation03index3 = find(TRAFFICREMOVE.hourprecipitation3 > 0.02);
figure(23)
hold on
grid minor
[fprecipitation0index3,xprecipitation0index3] = ecdf(TRAFFICREMOVE.speed3(precipitation0index3,1));
[fprecipitation03index3,xprecipitation03index3] = ecdf(TRAFFICREMOVE.speed3(precipitation03index3,1));
plot(xprecipitation0index3,fprecipitation0index3,'LineWidth',3)
set(gca,'FontSize',12)
plot(xprecipitation03index3,fprecipitation03index3,'LineWidth',3)
set(gca,'FontSize',12)

xlim([min(TRAFFICREMOVE.speed3)-0.5,max(TRAFFICREMOVE.speed3)+0.5])
legend( 'average speed when precipitation <= 0.02 inch/hr',...
   'average speed when precipitation > 0.02 inch/hr');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plots of average speeds (Altoona (Northbound))')
hold off
saveas(figure(23), 'N_E_23.jpg');
toc
%Elapsed time is 23.035353 seconds.

tic
precipitation0index4 = find(TRAFFICREMOVE.hourprecipitation4 <= 0.02);
precipitation03index4 = find(TRAFFICREMOVE.hourprecipitation4 > 0.02);
figure(24)
hold on
grid minor
[fprecipitation0index4,xprecipitation0index4] = ecdf(TRAFFICREMOVE.speed4(precipitation0index4,1));
[fprecipitation03index4,xprecipitation03index4] = ecdf(TRAFFICREMOVE.speed4(precipitation03index4,1));
plot(xprecipitation0index4,fprecipitation0index4,'LineWidth',3)
set(gca,'FontSize',12)
plot(xprecipitation03index4,fprecipitation03index4,'LineWidth',3)
set(gca,'FontSize',12)


xlim([min(TRAFFICREMOVE.speed4)-0.5,max(TRAFFICREMOVE.speed4)+0.5])
legend( 'average speed when precipitation <= 0.02 inch/hr',...
   'average speed when precipitation > 0.02 inch/hr');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plots of average speeds (Altoona (Southbound))')
hold off
saveas(figure(24), 'S_W_24.jpg');
toc
%Elapsed time is 10.702161 seconds.


%% 9/21/2018 ADDING VISIBILITY:
% visibility criteria:
% fog: visibility <= 0.62 mile
% mist: 0.62 mile < visibliity <= 1.24 mile
% haze: 1.24 mile < visibility <= 3.1 miles
% clear: visibility > 3.1 miles
tic
visibility01index3 = find(TRAFFICREMOVE.visibility3 <= 0.62);
visibility02index3 = find(TRAFFICREMOVE.visibility3 <= 1.2 & TRAFFICREMOVE.visibility3 > 0.62);
visibility03index3 = find(TRAFFICREMOVE.visibility3 <=  3.1 & TRAFFICREMOVE.visibility3 > 1.2);
visibility04index3 = find(TRAFFICREMOVE.visibility3 > 3.1);
figure(25)
hold on
grid minor
[fvisibility01index3,xvisibility01index3] = ecdf(TRAFFICREMOVE.speed3(visibility01index3,1));
[fvisibility02index3,xvisibility02index3] = ecdf(TRAFFICREMOVE.speed3(visibility02index3,1));
[fvisibility03index3,xvisibility03index3] = ecdf(TRAFFICREMOVE.speed3(visibility03index3,1));
[fvisibility04index3,xvisibility04index3] = ecdf(TRAFFICREMOVE.speed3(visibility04index3,1));
plot(xvisibility01index3,fvisibility01index3,'LineWidth',3)
set(gca,'FontSize',12)
plot(xvisibility02index3,fvisibility02index3,'LineWidth',3)
set(gca,'FontSize',12)
plot(xvisibility03index3,fvisibility03index3,'LineWidth',3)
set(gca,'FontSize',12)
plot(xvisibility04index3,fvisibility04index3,'LineWidth',3)
set(gca,'FontSize',12)
xlim([min(TRAFFICREMOVE.speed3)-0.5,max(TRAFFICREMOVE.speed3)+0.5])
legend('average speed when visibility < 0.62 mile',...
    'average speed when 0.62 < visibility <= 1.2 mile',...
    'average speed when 1.2 < visibility <= 3.1 mile',...
    'average speed when visibility > 3.1 mile')
xlabel('Average Speed (km/h)')
ylabel('Percentile')
title('CDF plots of average speeds (Altoona (Northbound/Eastbound))')
hold off
saveas(figure(25),'N_E_25.jpg');
toc
%Elapsed time is 18.845043 seconds.

tic
visibility01index4 = find(TRAFFICREMOVE.visibility4 <= 0.62);
visibility02index4 = find(TRAFFICREMOVE.visibility4 <= 1.2 & TRAFFICREMOVE.visibility4 > 0.62);
visibility03index4 = find(TRAFFICREMOVE.visibility4 <=  3.1 & TRAFFICREMOVE.visibility4 > 1.2);
visibility04index4 = find(TRAFFICREMOVE.visibility4 > 3.1);
figure(26)
hold on
grid minor
[fvisibility01index4,xvisibility01index4] = ecdf(TRAFFICREMOVE.speed4(visibility01index4,1));
[fvisibility02index4,xvisibility02index4] = ecdf(TRAFFICREMOVE.speed4(visibility02index4,1));
[fvisibility03index4,xvisibility03index4] = ecdf(TRAFFICREMOVE.speed4(visibility03index4,1));
[fvisibility04index4,xvisibility04index4] = ecdf(TRAFFICREMOVE.speed4(visibility04index4,1));
plot(xvisibility01index4,fvisibility01index4,'LineWidth',3)
set(gca,'FontSize',12)
plot(xvisibility02index4,fvisibility02index4,'LineWidth',3)
set(gca,'FontSize',12)
plot(xvisibility03index4,fvisibility03index4,'LineWidth',3)
set(gca,'FontSize',12)
plot(xvisibility04index4,fvisibility04index4,'LineWidth',3)
set(gca,'FontSize',12)
xlim([min(TRAFFICREMOVE.speed4)-0.5,max(TRAFFICREMOVE.speed4)+0.5])
legend('average speed when visibility < 0.62 mile',...
    'average speed when 0.62 < visibility <= 1.2 mile',...
    'average speed when 1.2 < visibility <= 3.1 mile',...
    'average speed when visibility > 3.1 mile')
xlabel('Average Speed (km/h)')
ylabel('Percentile')
title('CDF plots of average speeds (Altoona (Southbound/Westbound))')
hold off
saveas(figure(26),'S_W_26.jpg');
toc
%Elapsed time is 19.115020 seconds.

%%
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4 confscoreindex3 confscoreindex4
clear directionindex3 directionindex4 
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear fprecipitation01index3 fprecipitation01index4 fprecipitation03index3 fprecipitation03index4
clear fprecipitation0index3 fprecipitation0index4 fractionprecipitation3 fractionprecipitation4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear Hlegend3 Hlegend4 i indexmeasure_tstamp3 indexmeasure_tstamp4 j
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear n notoutliersindex3 notoutliersindex4 outliers3 outliers4 outliersindex3 outliersindex4
clear precipitation01index3 precipitation01index4 precipitation03index3 precipitation03index4
clear precipitation0index3 precipitation0index4 removeindex0
clear start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear dateindex statemeasure_tstamp3 statemeasure_tstamp4 tmcindex
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xprecipitation01index3 xprecipitation01index4 xprecipitation03index3 xprecipitation03index4
clear precipitationnonemptyindex0 xprecipitation0index3 xprecipitation0index4
clear directionstat0 fvisibility01index3 fvisibility01index4 fvisibility02index3
clear fvisibility02index4 fvisibility03index3 fvisibility03index4 fvisibility04index3 fvisibility04index4
clear statemeasure_tstamp3 statemeasure_tstamp4 visibility01index3 visibility01index4
clear visibility02index3 visibility02index4 visibility03index3 visibility03index4 visibility04index3 visibility04index4
clear xvisibility01index3 xvisibility01index4 xvisibility02index3 xvisibility02index4
clear xvisibility03index3 xvisibility03index4 xvisibility04index3 xvisibility04index4

%% LINEAR REGRESSION MODEL: (PRECIPITATION)
% table SLM is for simple linear regression analysis:
tic
precipitationzero3 = TRAFFICREMOVE.hourprecipitation3(TRAFFICREMOVE.hourprecipitation3 == 0,:);
precipitationnonzero3 = TRAFFICREMOVE.hourprecipitation3(TRAFFICREMOVE.hourprecipitation3 > 0,:);
speedzero3 = TRAFFICREMOVE.speed3(TRAFFICREMOVE.hourprecipitation3 == 0,:);
speednonzero3 = TRAFFICREMOVE.speed3(TRAFFICREMOVE.hourprecipitation3 > 0,:);

% Simple Linear regression results:
SLM3 = table([speedzero3;speednonzero3],[precipitationzero3;precipitationnonzero3],...
    TRAFFICREMOVE.visibility3,'VariableNames',{'speedtotal3','precipitationtotal3',...
    'visibilitytotal3'});
slrspeed3 = fitlm(SLM3,'speedtotal3 ~ precipitationtotal3')

figure(27)
hold on
grid minor

scatter(SLM3.precipitationtotal3,SLM3.speedtotal3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Altoona (Northbound/Eastbound))')
hold off
saveas(figure(27), 'N_E_27.jpg');
toc
%Elapsed time is 0.874227 seconds.

tic
precipitationzero4 = TRAFFICREMOVE.hourprecipitation4(TRAFFICREMOVE.hourprecipitation4 == 0,:);
precipitationnonzero4 = TRAFFICREMOVE.hourprecipitation4(TRAFFICREMOVE.hourprecipitation4 > 0,:);
speedzero4 = TRAFFICREMOVE.speed4(TRAFFICREMOVE.hourprecipitation4 == 0,:);
speednonzero4 = TRAFFICREMOVE.speed4(TRAFFICREMOVE.hourprecipitation4 > 0,:);

% Simple Linear regression results:
SLM4 = table([speedzero4;speednonzero4],[precipitationzero4;precipitationnonzero4],...
    TRAFFICREMOVE.visibility4,'VariableNames',{'speedtotal4','precipitationtotal4'...
    'visibilitytotal4'});
slr4 = fitlm(SLM4,'speedtotal4 ~ precipitationtotal4')

figure(28)
hold on
grid minor
scatter(SLM4.precipitationtotal4,SLM4.speedtotal4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Altoona (Southbound/Westbound))')
hold off
saveas(figure(28), 'S_W_28.jpg');
toc
%Elapsed time is 1.036130 seconds.


%% 9/21/2018 REGRESSION PLOTS FOR VISIBILITY:
tic
slrvisibility3 = fitlm(SLM3,'speedtotal3 ~ visibilitytotal3')
figure(31)
hold on
grid minor

scatter(SLM3.visibilitytotal3,SLM3.speedtotal3,'.');
lsvisibility3 = lsline
lsvisibility3.Color = 'r';
lsvisibility3.LineWidth = 1;
lsvisibility3.LineStyle = '--';

legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Visibility (miles)')
ylabel('Average Speed (mph)')
title('Linear Regression Plot (Altoona (Northbound/Eastbound))')
hold off
saveas(figure(31), 'N_E_31.jpg');
toc
%Elapsed time is 0.874227 seconds.

tic
slrvisibility4 = fitlm(SLM4,'speedtotal4 ~ visibilitytotal4')
figure(32)
hold on
grid minor

scatter(SLM4.visibilitytotal4,SLM4.speedtotal4,'.');
lsvisibility4 = lsline
lsvisibility4.Color = 'r';
lsvisibility4.LineWidth = 1;
lsvisibility4.LineStyle = '--';

legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Visibility (miles)')
ylabel('Average Speed (mph)')
title('Linear Regression Plot (Altoona (Southbound/Westbound))')
hold off
saveas(figure(32), 'N_E_32.jpg');
toc


%% 8/3/2018 ADD DUMMY VARIABLES FOR VARIABLES
% I'll first combine two directions' data into a variable with suffix of 0.
tic
TRAFFICREMOVE.speed0 = [TRAFFICREMOVE.speed3;TRAFFICREMOVE.speed4];
TRAFFICREMOVE.travel_time0 = [TRAFFICREMOVE.travel_time3;TRAFFICREMOVE.travel_time4];
TRAFFICREMOVE.conf_score0 = [TRAFFICREMOVE.conf_score3;TRAFFICREMOVE.conf_score4];
TRAFFICREMOVE.measure_tstamp0 = [TRAFFICREMOVE.measure_tstamp3;TRAFFICREMOVE.measure_tstamp4];
TRAFFICREMOVE.tmc_code0 = [TRAFFICREMOVE.tmc_code3;TRAFFICREMOVE.tmc_code4];
TRAFFICREMOVE.datetime0 = [TRAFFICREMOVE.datetime3;TRAFFICREMOVE.datetime4];
TRAFFICREMOVE.datevec0 = [TRAFFICREMOVE.datevec3;TRAFFICREMOVE.datevec4];
TRAFFICREMOVE.station0 = [TRAFFICREMOVE.station3;TRAFFICREMOVE.station4];
TRAFFICREMOVE.airtemperature0 = [TRAFFICREMOVE.airtemperature3;TRAFFICREMOVE.airtemperature4];
TRAFFICREMOVE.hourprecipitation0 = [TRAFFICREMOVE.hourprecipitation3;TRAFFICREMOVE.hourprecipitation4];
TRAFFICREMOVE.visibility0 = [TRAFFICREMOVE.visibility3;TRAFFICREMOVE.visibility4];
TRAFFICREMOVE.skycoverage10 = [TRAFFICREMOVE.skycoverage13;TRAFFICREMOVE.skycoverage14];
TRAFFICREMOVE.skycoverage20 = [TRAFFICREMOVE.skycoverage23;TRAFFICREMOVE.skycoverage24];
TRAFFICREMOVE.skycoverage30 = [TRAFFICREMOVE.skycoverage33;TRAFFICREMOVE.skycoverage34];
TRAFFICREMOVE.skycoverage40 = [TRAFFICREMOVE.skycoverage43;TRAFFICREMOVE.skycoverage44];
TRAFFICREMOVE.skylevel10 = [TRAFFICREMOVE.skylevel13;TRAFFICREMOVE.skylevel14];
TRAFFICREMOVE.skylevel20 = [TRAFFICREMOVE.skylevel23;TRAFFICREMOVE.skylevel24];
TRAFFICREMOVE.skylevel30 = [TRAFFICREMOVE.skylevel33;TRAFFICREMOVE.skylevel34];
TRAFFICREMOVE.skylevel40 = [TRAFFICREMOVE.skylevel43;TRAFFICREMOVE.skylevel44];
TRAFFICREMOVE.weathercode0 = [TRAFFICREMOVE.weathercode3;TRAFFICREMOVE.weathercode4];
TRAFFICREMOVE.road0 = [TRAFFICREMOVE.road3;TRAFFICREMOVE.road4];
TRAFFICREMOVE.direction0 = [TRAFFICREMOVE.direction3;TRAFFICREMOVE.direction4];
TRAFFICREMOVE.miles0 = [TRAFFICREMOVE.miles3;TRAFFICREMOVE.miles4];
toc
%Elapsed time is 0.086266 seconds.

% Next,I will add dummy variables into "TRAFFICREMOVE" with respect to each
% variables.
tic
% transform into direction data:
TRAFFICREMOVE.direction3dummy0 = contains(TRAFFICREMOVE.direction0,TRAFFICREMOVE.direction0(1,1));
TRAFFICREMOVE.direction4dummy0 = contains(TRAFFICREMOVE.direction0,TRAFFICREMOVE.direction0(end,1));
% transform into hour of day data:
TRAFFICREMOVE.hourofday10dummy0 = TRAFFICREMOVE.datevec0(:,4) == 10;
TRAFFICREMOVE.hourofday11dummy0 = TRAFFICREMOVE.datevec0(:,4) == 11;
TRAFFICREMOVE.hourofday12dummy0 = TRAFFICREMOVE.datevec0(:,4) == 12;
TRAFFICREMOVE.hourofday13dummy0 = TRAFFICREMOVE.datevec0(:,4) == 13;
TRAFFICREMOVE.hourofday14dummy0 = TRAFFICREMOVE.datevec0(:,4) == 14;
TRAFFICREMOVE.hourofday15dummy0 = (TRAFFICREMOVE.datevec0(:,4) == 15 | TRAFFICREMOVE.datevec0(:,4) == 16);
% transform date data into weekday data:
[TRAFFICREMOVE.weekdaynumber3,TRAFFICREMOVE.weekday3] = weekday(TRAFFICREMOVE.measure_tstamp3);
[TRAFFICREMOVE.weekdaynumber4,TRAFFICREMOVE.weekday4] = weekday(TRAFFICREMOVE.measure_tstamp4);
TRAFFICREMOVE.weekdaynumber0 = [TRAFFICREMOVE.weekdaynumber3;TRAFFICREMOVE.weekdaynumber4];
TRAFFICREMOVE.weekday0 = cellstr([TRAFFICREMOVE.weekday3;TRAFFICREMOVE.weekday4]);
TRAFFICREMOVE.dayofweek1dummy0 = double(contains(TRAFFICREMOVE.weekday0,'Mon'));
TRAFFICREMOVE.dayofweek2dummy0 = double(contains(TRAFFICREMOVE.weekday0,'Tue'));
TRAFFICREMOVE.dayofweek3dummy0 = double(contains(TRAFFICREMOVE.weekday0,'Wed'));
TRAFFICREMOVE.dayofweek4dummy0 = double(contains(TRAFFICREMOVE.weekday0,'Thu'));
TRAFFICREMOVE.dayofweek5dummy0 = double(contains(TRAFFICREMOVE.weekday0,'Fri'));
% transform into month of year data:
TRAFFICREMOVE.monthofyear5dummy0 = TRAFFICREMOVE.datevec0(:,3) == 5;
TRAFFICREMOVE.monthofyear6dummy0 = TRAFFICREMOVE.datevec0(:,3) == 6;
TRAFFICREMOVE.monthofyear7dummy0 = TRAFFICREMOVE.datevec0(:,3) == 7;
TRAFFICREMOVE.monthofyear8dummy0 = TRAFFICREMOVE.datevec0(:,3) == 8;
TRAFFICREMOVE.monthofyear9dummy0 = TRAFFICREMOVE.datevec0(:,3) == 9;
TRAFFICREMOVE.monthofyear10dummy0 = TRAFFICREMOVE.datevec0(:,3) == 10;
toc
%Elapsed time is 34.135495 seconds.

% combine each dummies up:
tic
TRAFFICREMOVE.directiondummy0 = [TRAFFICREMOVE.direction3dummy0, TRAFFICREMOVE.direction4dummy0];
TRAFFICREMOVE.hourofdaydummy0 = [TRAFFICREMOVE.hourofday10dummy0,TRAFFICREMOVE.hourofday11dummy0,...
    TRAFFICREMOVE.hourofday12dummy0,TRAFFICREMOVE.hourofday13dummy0,...
    TRAFFICREMOVE.hourofday14dummy0,TRAFFICREMOVE.hourofday15dummy0];
TRAFFICREMOVE.weekofdaydummy0 = [TRAFFICREMOVE.dayofweek1dummy0,...
    TRAFFICREMOVE.dayofweek2dummy0,TRAFFICREMOVE.dayofweek3dummy0,...
    TRAFFICREMOVE.dayofweek4dummy0,TRAFFICREMOVE.dayofweek5dummy0];
TRAFFICREMOVE.monthofyeardummy0 = [TRAFFICREMOVE.monthofyear5dummy0,...
    TRAFFICREMOVE.monthofyear6dummy0,TRAFFICREMOVE.monthofyear7dummy0,...
    TRAFFICREMOVE.monthofyear8dummy0,TRAFFICREMOVE.monthofyear9dummy0,...
    TRAFFICREMOVE.monthofyear10dummy0];
toc
%Elapsed time is 0.014082 seconds.


%% 8/9/2018 THIS IS TO TEST WHICH CATEGORICAL VARIABLE WILL IMPACT DEPENDENT VARIABLE CALLOPSE HERE

a10 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.hourofday10dummy0 == 1))
a11 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.hourofday11dummy0 == 1))
a12 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.hourofday12dummy0 == 1))
a13 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.hourofday13dummy0 == 1))
a14 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.hourofday14dummy0 == 1))
a15 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.datevec0(:,4) == 15))

a1 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.dayofweek1dummy0 == 1))
a2 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.dayofweek2dummy0 == 1))
a3 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.dayofweek3dummy0 == 1))
a4 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.dayofweek4dummy0 == 1))
a5 = mean(TRAFFICREMOVE.speed0(find(double(contains(TRAFFICREMOVE.weekday0,'Fri')))==1))

a5 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.monthofyear5dummy0 == 1))
a6 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.monthofyear6dummy0 == 1))
a7 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.monthofyear7dummy0 == 1))
a8 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.monthofyear8dummy0 == 1))
a9 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.monthofyear9dummy0 == 1))
a00 = mean(TRAFFICREMOVE.speed0(TRAFFICREMOVE.datevec0(:,3) == 10))

%% 8/9/2018 I prefer to use this part to generate dummy variables instead of 8/3/2018 COLLAPSE FROM HERE!!!
% DON'T RUN THIS PART, ONLY AS A REFERENCE
tic
[B,BINT,R,RINT,STATS] = regress(TRAFFICREMOVE.hourprecipitation0,[TRAFFICREMOVE.directiondummy0,...
    TRAFFICREMOVE.hourofdaydummy0,TRAFFICREMOVE.weekofdaydummy0,TRAFFICREMOVE.monthofyeardummy0,...
    TRAFFICREMOVE.speed0]);
% I have performed the regression analysis, but the result is bad
toc
%    0.0965  544.0397         0    0.0009
%Elapsed time is 0.311903 seconds.
%% 8/13/2018 USELESS, DON'T RUN THIS PART, JUST AS A REFERENCE
% only consider direction:
tic
[Bdirection0,BINTdirection0,Rdirection0,RINTdirection0,STATSdirection0] = ...
    regress(TRAFFICREMOVE.hourprecipitation0,[TRAFFICREMOVE.directiondummy0,...
    TRAFFICREMOVE.speed0]);
toc
%     0.0048  210.3933    0.0000    0.0010
%Elapsed time is 0.184335 seconds.

% only hour of day dummy
tic
[Bhourofday0,BINThourofday0,Rhourofday0,RINThourofday0,STATShourofday0] = ...
    regress(TRAFFICREMOVE.hourprecipitation0,[TRAFFICREMOVE.hourofdaydummy0,...
    TRAFFICREMOVE.speed0]);
toc
%    0.0073  106.4450    0.0000    0.0010
%Elapsed time is 0.157767 seconds.


%% 8/13/2018 THIS COULD BE USED TO PERFORM Linear ANALYSIS
% tutorial website:
% https://www.mathworks.com/help/stats/regression-with-categorical-covariates.html
% https://www.mathworks.com/help/stats/compactlinearmodel.plotinteraction.html
% https://www.mathworks.com/help/stats/compactlinearmodel.plotinteraction.html
% https://www.mathworks.com/help/stats/stepwiselm.html
% https://www.mathworks.com/help/stats/fitlm.html
tic
TTRAFFICREMOVE = table(TRAFFICREMOVE.hourprecipitation0, TRAFFICREMOVE.speed0,...
    TRAFFICREMOVE.measure_tstamp0, TRAFFICREMOVE.tmc_code0, TRAFFICREMOVE.datetime0,...
    TRAFFICREMOVE.datevec0,TRAFFICREMOVE.visibility0, TRAFFICREMOVE.direction0,...
    TRAFFICREMOVE.directiondummy0,nominal(TRAFFICREMOVE.datevec0(:,4)),...
    nominal(TRAFFICREMOVE.weekday0),nominal(TRAFFICREMOVE.datevec0(:,2)),...
    TRAFFICREMOVE.directiondummy0(:,1).*TRAFFICREMOVE.hourprecipitation0,...
    'VariableNames',{'hourprecipitation0','speed0','measure_tstamp0','tmc_code0',...
    'datetime0','datevec0','visibility0','direction0','directiondummy0',...
    'hourofdaydummy0','weekofdaydummy0','monthofyeardummy0','hourprecipitationdirection0'});

% only consider One nominal variable:
% only consider direction's impact
lm1 = fitlm(TTRAFFICREMOVE,'speed0 ~ hourprecipitation0 + direction0')

% only consider the impact of hour of day:
lm2 = fitlm(TTRAFFICREMOVE,'speed0 ~ hourprecipitation0 + hourofdaydummy0')

% only consider the impact of week of day:
lm3 = fitlm(TTRAFFICREMOVE,'speed0 ~ hourprecipitation0 + weekofdaydummy0')

% only consider the impact of month of year:
lm4 = fitlm(TTRAFFICREMOVE,'speed0 ~ hourprecipitation0 + monthofyeardummy0')

% consider Two nominal variables:
% consider direction and hour of day:
lm5 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','hourofdaydummy0'},...
    'CategoricalVar',{'direction0','hourofdaydummy0'})

% consider direction and day of week:
lm6 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','weekofdaydummy0'},...
    'CategoricalVar',{'direction0','weekofdaydummy0'})

% consider direction and month of year:
lm7 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','monthofyeardummy0'},...
    'CategoricalVar',{'direction0','monthofyeardummy0'})

% consider hour of day and day of week:
lm8 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','hourofdaydummy0','weekofdaydummy0'},...
    'CategoricalVar',{'hourofdaydummy0','weekofdaydummy0'})

% consider hour of day and month of year:
lm9 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','hourofdaydummy0','monthofyeardummy0'},...
    'CategoricalVar',{'hourofdaydummy0','monthofyeardummy0'})

% consider day of week and month of year:
lm10 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','weekofdaydummy0','monthofyeardummy0'},...
    'CategoricalVar',{'weekofdaydummy0','monthofyeardummy0'})

% consider Three nominal variables:
% consider direction, hour of day, week of day:
lm11 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','hourofdaydummy0','weekofdaydummy0'},...
    'CategoricalVar',{'direction0','hourofdaydummy0','weekofdaydummy0'})

% consider direction, hour of day, month of year:
lm12 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','hourofdaydummy0','monthofyeardummy0'},...
    'CategoricalVar',{'direction0','hourofdaydummy0','monthofyeardummy0'})

% consider direction, week of day, month of year:
lm13 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','weekofdaydummy0','monthofyeardummy0'},...
    'CategoricalVar',{'direction0','weekofdaydummy0','monthofyeardummy0'})

% consider hour of day, week of day, month of year:
lm14 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','hourofdaydummy0','weekofdaydummy0','monthofyeardummy0'},...
    'CategoricalVar',{'hourofdaydummy0','weekofdaydummy0','monthofyeardummy0'})

% consider Four nominal variables:
% consdier direction, hour of day, week of day, month of year:
lm15 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','hourofdaydummy0','weekofdaydummy0','monthofyeardummy0'},...
    'CategoricalVar',{'direction0','hourofdaydummy0','weekofdaydummy0','monthofyeardummy0'})
toc
%Elapsed time is 29.452533 seconds.


%% 8/16/2018 IN PREVIOUS MODELS, WE ONLY CONSIDER SOME SPECIFIC MODELS
tic
% only consider One nominal variable:
% only consider direction's impact
restlm1 = fitlm(TTRAFFICREMOVE,'speed0 ~ hourprecipitation0 + direction0')

% only consider the impact of hour of day:
restlm2 = fitlm(TTRAFFICREMOVE,'speed0 ~ hourprecipitation0 + hourofdaydummy0')

% only consider the impact of week of day:
restlm3 = fitlm(TTRAFFICREMOVE,'speed0 ~ hourprecipitation0 + weekofdaydummy0')

% only consider the impact of month of year:
restlm4 = fitlm(TTRAFFICREMOVE,'speed0 ~ hourprecipitation0 + monthofyeardummy0')

% consider Two nominal variables:
% consider direction and hour of day:
restlm5 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','hourofdaydummy0'},...
    'CategoricalVar',{'direction0','hourofdaydummy0'})

% consider direction and month of year:
restlm6 = fitlm(TTRAFFICREMOVE,'interactions','ResponseVar','speed0',...
    'PredictorVars',{'hourprecipitation0','direction0','monthofyeardummy0'},...
    'CategoricalVar',{'direction0','monthofyeardummy0'})

%% 8/16/2018 UPDATED BY 8/21 PART. CAN BE REMOVED IF NECESSARY.
% Following Gayah's suggestion, I removed "week of day dummy", and the
% model is:
% speed = 1+hourprecipitation0 + direction0(dummy) +
% hourprecipitation:direction0 + hourofdaydummy0 + monthofyeardummy0
tic
restlm7 = fitlm(TTRAFFICREMOVE,'speed0~1+hourprecipitation0+direction0+hourprecipitationdirection0+hourofdaydummy0+monthofyeardummy0')
toc
%Elapsed time is 1.885171 seconds.

%%
% we will only apply two models:
% 1. direction0_SOUTHBOUND, hourofdaydummy0_11 ... 16, monthofyeardummy0_6
% ...10, hourprecipitation:NORTHBOUND, hourprecipitation:SOUTHBOUND.
TTRAFFICREMOVE = table(TRAFFICREMOVE.hourprecipitation0, TRAFFICREMOVE.speed0,...
    TRAFFICREMOVE.measure_tstamp0, TRAFFICREMOVE.tmc_code0, TRAFFICREMOVE.datetime0,...
    TRAFFICREMOVE.datevec0,TRAFFICREMOVE.visibility0, TRAFFICREMOVE.direction0,...
    TRAFFICREMOVE.directiondummy0,nominal(TRAFFICREMOVE.datevec0(:,4)),...
    nominal(TRAFFICREMOVE.weekday0),nominal(TRAFFICREMOVE.datevec0(:,2)),...
    TRAFFICREMOVE.directiondummy0(:,1).*TRAFFICREMOVE.hourprecipitation0,...
    TRAFFICREMOVE.hourprecipitation0.*TRAFFICREMOVE.directiondummy0(:,2),...
    'VariableNames',{'hourprecipitation0','speed0','measure_tstamp0','tmc_code0',...
    'datetime0','datevec0','visibility0','direction0','directiondummy0',...
    'hourofdaydummy0','weekofdaydummy0','monthofyeardummy0',...
    'hourprecipitation0_direction0_NORTHBOUND','hourprecipitation0_direction0_SOUTHBOUND'});
restlm8 = fitlm(TTRAFFICREMOVE,'speed0~1+direction0+hourprecipitation0_direction0_NORTHBOUND+hourprecipitation0_direction0_SOUTHBOUND+hourofdaydummy0+monthofyeardummy0')

restlm9 = fitlm(TTRAFFICREMOVE,'speed0~1+hourprecipitation0+direction0+hourofdaydummy0+monthofyeardummy0')

%% 9/22/2018 DUMMY REGRESSION WITH VISIBILITY:
TTRAFFICREMOVE = table(TRAFFICREMOVE.hourprecipitation0, TRAFFICREMOVE.speed0,...
    TRAFFICREMOVE.measure_tstamp0, TRAFFICREMOVE.tmc_code0, TRAFFICREMOVE.datetime0,...
    TRAFFICREMOVE.datevec0,TRAFFICREMOVE.visibility0, TRAFFICREMOVE.direction0,...
    TRAFFICREMOVE.directiondummy0,nominal(TRAFFICREMOVE.datevec0(:,4)),...
    nominal(TRAFFICREMOVE.weekday0),nominal(TRAFFICREMOVE.datevec0(:,2)),...
    TRAFFICREMOVE.directiondummy0(:,1).*TRAFFICREMOVE.hourprecipitation0,...
    TRAFFICREMOVE.hourprecipitation0.*TRAFFICREMOVE.directiondummy0(:,2),...
    TRAFFICREMOVE.directiondummy0(:,1).*TRAFFICREMOVE.visibility0,...
    TRAFFICREMOVE.visibility0.*TRAFFICREMOVE.directiondummy0(:,2),...
    'VariableNames',{'hourprecipitation0','speed0','measure_tstamp0','tmc_code0',...
    'datetime0','datevec0','visibility0','direction0','directiondummy0',...
    'hourofdaydummy0','weekofdaydummy0','monthofyeardummy0',...
    'hourprecipitation0_direction0_EASTBOUND','hourprecipitation0_direction0_WESTBOUND',...
    'visibility0_direction0_EASTBOUND','visibility0_direction0_WESTBOUND'});
restlm10 = fitlm(TTRAFFICREMOVE,...
    'speed0~1+direction0+hourprecipitation0_direction0_EASTBOUND+hourprecipitation0_direction0_WESTBOUND+visibility0_direction0_EASTBOUND+visibility0_direction0_WESTBOUND+hourofdaydummy0+monthofyeardummy0')

restlm11 = fitlm(TTRAFFICREMOVE,'speed0~1+hourprecipitation0+visibility0+direction0+hourofdaydummy0+monthofyeardummy0')


%% Add a new column "corridor0" to identify each corridor's name and color
corridor0 = repmat('Altoona Green',numel(TTRAFFICREMOVE.measure_tstamp0),1);
TTRAFFICREMOVE=[table(corridor0,'VariableNames',{'corridor0'}) TTRAFFICREMOVE];


%% 03/04/2019 DESCRIPTIVE STATISTICS
tic
TRAFFICREMOVE.maxspeed3 = max(TRAFFICREMOVE.speed3);
% speedlimit3_ora = 40;
% STAT_ORA.maxspeed3 = max(TRAFFIC_ORA.speed3);
% STAT_ORA.averagespeed3 = mean(TRAFFIC_ORA.speed3);
% STAT_ORA.minspeed3 = min(TRAFFIC_ORA.speed3);
% STAT_ORA.stdspeed3 = std(TRAFFIC_ORA.speed3);
% STAT_ORA.samplesize3 = numel(TRAFFIC_ORA.speed3);
% STAT_ORA.ratio3 = STAT_ORA.averagespeed3/speedlimit3_ora;
% 
% speedlimit4_ora = 40;
% STAT_ORA.maxspeed4 = max(TRAFFIC_ORA.speed4);
% STAT_ORA.averagespeed4 = mean(TRAFFIC_ORA.speed4);
% STAT_ORA.minspeed4 = min(TRAFFIC_ORA.speed4);
% STAT_ORA.stdspeed4 = std(TRAFFIC_ORA.speed4);
% STAT_ORA.samplesize4 = numel(TRAFFIC_ORA.speed4);
% STAT_ORA.ratio4 = STAT_ORA.averagespeed4/speedlimit4_ora
toc

%% 03/19/2019  Determine Levels in Predictors
% https://www.mathworks.com/help/stats/select-predictors-for-random-forests.html
tic
TTRAFFICREMOVE_RF = table(categorical(TTRAFFICREMOVE.datevec0(:,2)),categorical(TTRAFFICREMOVE.weekofdaydummy0),...
    categorical(TTRAFFICREMOVE.datevec0(:,4)),categorical(TTRAFFICREMOVE.direction0),...
    TTRAFFICREMOVE.hourprecipitation0, TTRAFFICREMOVE.visibility0,...
    TTRAFFICREMOVE.speed0, ...
    'VariableNames', {'month','week','hour','direction','precipitation','visibility','speed'});
countLevels = @(x)numel(categories(categorical(x)));
numLevels = varfun(countLevels, TTRAFFICREMOVE_RF(:, 1:end-1), 'OutputFormat', 'uniform');
figure(50);
bar(numLevels);
title('Number of Levels Among Predictors');
xlabel('Predictor variable');
ylabel('Number of levels');
h = gca;
h.XTickLabel = TTRAFFICREMOVE_RF.Properties.VariableNames(1:end-1);
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
saveas(figure(50), '_Categories_50.jpg');

clear Acceleration cyl4 Cylinders Displacement Horsepower Mfg Model Model_Year
clear MPG org Origin Weight when
toc

%% 03/19/2019 Grow Robust Random Forest
tic
t = templateTree('NumVariablesToSample', 'all',...
    'PredictorSelection', 'interaction-curvature', 'Surrogate','on');

rng(1);   % For reproducibility
Mdl = fitrensemble(TTRAFFICREMOVE_RF, 'speed',...
    'Method','bag',...
    'NumLearningCycles', 300,...
    'Learners', t);
toc
% Elapsed time is 262.418665 seconds.

%% 03/19/2019  Calculate y-hat and R-square
tic
yhat = oobPredict(Mdl);
R2 = corr(Mdl.Y, yhat)^2
toc
% R2 = 0.1345
% Elapsed time is 10.677969 seconds.

%% 03/19/2019  Predictor Importance Estimation
tic
impOOB = oobPermutedPredictorImportance(Mdl);
figure(51);
bar(impOOB);
title('Unbiased Predictor Importance Estimates');
xlabel('Predictor variable');
ylabel('Importance');
h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
saveas(figure(51), '_Importance_51.jpg');
toc
% Elapsed time is 311.159576 seconds.

%%
tic
[impGain,predAssociation] = predictorImportance(Mdl);

figure(52);
% plot(1:numel(Mdl.PredictorNames),impOOB', 1:numel(Mdl.PredictorNames), impGain', 'LineWidth', 2);
yyaxis left
b = bar(impOOB');
yyaxis right
plot(1:numel(Mdl.PredictorNames), impGain', 'LineWidth', 2);
title('Predictor Importance Estimation Comparison')
xlabel('Predictor variable');
ylabel('Mean Square Error');
h = gca;
xticks([1:numel(Mdl.PredictorNames)]);
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
legend('OOB permuted','MSE improvement')
grid on
saveas(figure(52), '_FeatureImportance_52.jpg');
toc

%% 03/19/2019  Correlation Map
tic
figure(53);
imagesc(predAssociation);
title('Predictor Association Estimates');
colorbar;
h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
h.YTickLabel = Mdl.PredictorNames;
saveas(figure(53), '_Correlation_53.jpg');
toc

%% 03/19/2019 Find the highest correlation value
% From the above HeatMap, the highest correlation is about 0.3
% , which is between precipitation and visibility.
% This correlation value is still not high enough to indicate a strong
% relationship between the two predictors.
predAssociation(5,6)
% 0.2812

%% 03/19/2019 Gradient Boosting in Regression
tic
t2 = templateTree('Surrogate','On');  % Initialize a tree and use Surrogate to deal with missing value
Mdl2 = fitensemble(TTRAFFICREMOVE_RF, 'speed', 'LSBoost', 100, t2);

formula = 'speed ~ precipitation + visibility + month + hour + direction + week'
mse2 = resubLoss(Mdl2)
% mse2 = 6.7214
toc
% Elapsed time is 7.898268 seconds.

%% 03/25/2019 EXPLORE NON-LINEAR MODEL
tic
modelfun = @(b,x)b(1) + b(2)*x(:,1).^b(3) + ...
    b(4)*x(:,2).^b(5);
beta0 = [-50 500 -1 500 -1];
mdl = fitnlm(tbl,modelfun,beta0)
toc

%%





















