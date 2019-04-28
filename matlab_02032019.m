%%C:\Users\yzy67\Desktop\PSU\research2\RESEARCHDATA\GData3\PHL_C_2_ORA_RED_BLU_GRE_PUR
% PHL_C_2_ORA_RED_BLU_GRE_PUR(new code from here)
clear,clc

%% 1/23/2019  1. Only for importing data
%%%%%%%%%%%% import climate data
tic
PHLdata = split(importdata('PHL.txt'),'	');
PHL.station0 = PHLdata(:,1);  % station PHL 
PHL.valid0 = PHLdata(:,2);  % timestamp 5/1/2015 16:09
PHL.airtemperature0 = PHLdata(:,3);  % temperature 57.02
PHL.hourpreciPHLation0 = PHLdata(:,8);  % preciPHLation 0.03
PHL.visibility0 = PHLdata(:,11);  % visibility 10
PHL.skycoverage10 = PHLdata(:,13);  % skycoverage1  BKN
PHL.skycoverage20 = PHLdata(:,14);  % skycoverage2  OVC
PHL.skycoverage30 = PHLdata(:,15);  % skycoverage3  OVC
PHL.skycoverage40 = PHLdata(:,16);  % skycoverage4  M
PHL.skylevel10 = PHLdata(:,17);  % skylevel1  5500
PHL.skylevel20 = PHLdata(:,18);  % skylevel2  7000
PHL.skylevel30 = PHLdata(:,19);  % skylevel3  11000
PHL.skylevel40 = PHLdata(:,20);  % skylevel4  M
PHL.weathercode0 = PHLdata(:,21);  % weathercode  VCTS RA
PHL.datetime0 = datetime(PHL.valid0,'InputFormat','M/d/yyyy H:mm');
PHL.datevec0 = datevec(PHL.datetime0);

clear PHLdata
toc


%% 12/26/2018
% Remove one-hour data after preciPHLation ends
tic
removeindex0 = [];
for i = 1:(numel(PHL.hourpreciPHLation0)-1)
    if (str2double(PHL.hourpreciPHLation0(i,1)) > 0 & str2double(PHL.hourpreciPHLation0(i+1,1)) == 0)
        removeindex0 = [removeindex0; i+1];
    end
end
PHL.station0(removeindex0) = [];
PHL.valid0(removeindex0) = [];
PHL.airtemperature0(removeindex0) = [];
PHL.hourpreciPHLation0(removeindex0) = [];
PHL.visibility0(removeindex0) = [];
PHL.skycoverage10(removeindex0) = [];
PHL.skycoverage20(removeindex0) = [];
PHL.skycoverage30(removeindex0) = [];
PHL.skycoverage40(removeindex0) = [];
PHL.skylevel10(removeindex0) = [];
PHL.skylevel20(removeindex0) = [];
PHL.skylevel30(removeindex0) = [];
PHL.skylevel40(removeindex0) = [];
PHL.weathercode0(removeindex0) = [];
PHL.datetime0(removeindex0) = [];
PHL.datevec0(removeindex0,:) = [];

clear removeindex0
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
%Elapsed time is 36.529821 seconds.

%Next, we are to append PHL to TRAFFIC.
tic
for i = 1:numel(PHL.station0)
    dateindex = find(ismember(TRAFFIC.datevec0(:,1:4),PHL.datevec0(i,1:4),'rows'));
    if(~isempty(dateindex))
        TRAFFIC.station0(dateindex,1) = PHL.station0(i,1);
        TRAFFIC.airtemperature0(dateindex,:) = PHL.airtemperature0(i,:);
        TRAFFIC.hourpreciPHLation0(dateindex,:) = PHL.hourpreciPHLation0(i,:);
        TRAFFIC.visibility0(dateindex,:) = PHL.visibility0(i,:);
        TRAFFIC.skycoverage10(dateindex,:) = PHL.skycoverage10(i,:);
        TRAFFIC.skycoverage20(dateindex,:) = PHL.skycoverage20(i,:);
        TRAFFIC.skycoverage30(dateindex,:) = PHL.skycoverage30(i,:);
        TRAFFIC.skycoverage40(dateindex,:) = PHL.skycoverage40(i,:);
        TRAFFIC.skylevel10(dateindex,:) = PHL.skylevel10(i,:);
        TRAFFIC.skylevel20(dateindex,:) = PHL.skylevel20(i,:);
        TRAFFIC.skylevel30(dateindex,:) = PHL.skylevel30(i,:);
        TRAFFIC.skylevel40(dateindex,:) = PHL.skylevel40(i,:);
        TRAFFIC.weathercode0(dateindex,:) = PHL.weathercode0(i,:);
    end
end
toc
%Elapsed time is 529.369432 seconds.

% 07/29/2018 Next, we should remove empty elements from TRAFFIC.speed0,etc
% Run this part ONLY ONCE!!!
tic
preciPHLationnonemptyindex0 = find(~cellfun(@isempty, TRAFFIC.hourpreciPHLation0));
TRAFFIC.speed0 = TRAFFIC.speed0(preciPHLationnonemptyindex0,:);
TRAFFIC.travel_time0 = TRAFFIC.travel_time0(preciPHLationnonemptyindex0,:);
TRAFFIC.conf_score0 = TRAFFIC.conf_score0(preciPHLationnonemptyindex0,:);
TRAFFIC.measure_tstamp0 = TRAFFIC.measure_tstamp0(preciPHLationnonemptyindex0,:);
TRAFFIC.tmc_code0 = TRAFFIC.tmc_code0(preciPHLationnonemptyindex0,:);
TRAFFIC.datetime0 = TRAFFIC.datetime0(preciPHLationnonemptyindex0,:);
TRAFFIC.datevec0 = TRAFFIC.datevec0(preciPHLationnonemptyindex0,:);
TRAFFIC.station0 = TRAFFIC.station0(preciPHLationnonemptyindex0,:);
TRAFFIC.airtemperature0 = TRAFFIC.airtemperature0(preciPHLationnonemptyindex0,:);
TRAFFIC.hourpreciPHLation0 = TRAFFIC.hourpreciPHLation0(preciPHLationnonemptyindex0,:);
TRAFFIC.visibility0 = TRAFFIC.visibility0(preciPHLationnonemptyindex0,:);
TRAFFIC.skycoverage10 = TRAFFIC.skycoverage10(preciPHLationnonemptyindex0,:);
TRAFFIC.skycoverage20 = TRAFFIC.skycoverage20(preciPHLationnonemptyindex0,:);
TRAFFIC.skycoverage30 = TRAFFIC.skycoverage30(preciPHLationnonemptyindex0,:);
TRAFFIC.skycoverage40 = TRAFFIC.skycoverage40(preciPHLationnonemptyindex0,:);
TRAFFIC.skylevel10 = TRAFFIC.skylevel10(preciPHLationnonemptyindex0,:);
TRAFFIC.skylevel20 = TRAFFIC.skylevel20(preciPHLationnonemptyindex0,:);
TRAFFIC.skylevel30 = TRAFFIC.skylevel30(preciPHLationnonemptyindex0,:);
TRAFFIC.skylevel40 = TRAFFIC.skylevel40(preciPHLationnonemptyindex0,:);
TRAFFIC.weathercode0 = TRAFFIC.weathercode0(preciPHLationnonemptyindex0,:);
toc
% TRAFFIC.tmc_code0(1,1) = {'103-04124'};
%Elapsed time is 1.059255 seconds.


%% MORNING PEAK
tic
removeindex0 = [];
for i = 1:(numel(PHL.hourpreciPHLation0)-1)
    if (str2double(PHL.hourpreciPHLation0(i,1)) > 0 & str2double(PHL.hourpreciPHLation0(i+1,1)) == 0)
        removeindex0 = [removeindex0; i+1];
    end
end
PHL.station0(removeindex0) = [];
PHL.valid0(removeindex0) = [];
PHL.airtemperature0(removeindex0) = [];
PHL.hourpreciPHLation0(removeindex0) = [];
PHL.visibility0(removeindex0) = [];
PHL.skycoverage10(removeindex0) = [];
PHL.skycoverage20(removeindex0) = [];
PHL.skycoverage30(removeindex0) = [];
PHL.skycoverage40(removeindex0) = [];
PHL.skylevel10(removeindex0) = [];
PHL.skylevel20(removeindex0) = [];
PHL.skylevel30(removeindex0) = [];
PHL.skylevel40(removeindex0) = [];
PHL.weathercode0(removeindex0) = [];
PHL.datetime0(removeindex0) = [];
PHL.datevec0(removeindex0,:) = [];

clear removeindex0
toc
%Elapsed time is 0.682742 seconds.


%% load data from 'morningtraffic.txt'
% MORNING PEAK
tic
trafficdata = importdata('morningtraffic.txt');
trafficdata0 = struct2cell(trafficdata);

numdata0 = cell2mat(trafficdata0(1,1));
AMTRAFFIC.speed0 = numdata0(:,1);
AMTRAFFIC.travel_time0 = numdata0(:,4);
AMTRAFFIC.conf_score0 = numdata0(:,5);
AMTRAFFIC.measure_tstamp0 = trafficdata.textdata(:,2);
AMTRAFFIC.tmc_code0 = trafficdata0{2,1}(:,1);
AMTRAFFIC.datetime0 = datetime(AMTRAFFIC.measure_tstamp0,'InputFormat','M/d/yyyy H:mm');
AMTRAFFIC.datevec0 = datevec(AMTRAFFIC.measure_tstamp0);
toc
%Elapsed time is 38.529821 seconds.

%Next, we are to append PHL to TRAFFIC.
tic
for i = 1:numel(PHL.station0)
    dateindex = find(ismember(AMTRAFFIC.datevec0(:,1:4),PHL.datevec0(i,1:4),'rows'));
    if(~isempty(dateindex))
        AMTRAFFIC.station0(dateindex,1) = PHL.station0(i,1);
        AMTRAFFIC.airtemperature0(dateindex,:) = PHL.airtemperature0(i,:);
        AMTRAFFIC.hourpreciPHLation0(dateindex,:) = PHL.hourpreciPHLation0(i,:);
        AMTRAFFIC.visibility0(dateindex,:) = PHL.visibility0(i,:);
        AMTRAFFIC.skycoverage10(dateindex,:) = PHL.skycoverage10(i,:);
        AMTRAFFIC.skycoverage20(dateindex,:) = PHL.skycoverage20(i,:);
        AMTRAFFIC.skycoverage30(dateindex,:) = PHL.skycoverage30(i,:);
        AMTRAFFIC.skycoverage40(dateindex,:) = PHL.skycoverage40(i,:);
        AMTRAFFIC.skylevel10(dateindex,:) = PHL.skylevel10(i,:);
        AMTRAFFIC.skylevel20(dateindex,:) = PHL.skylevel20(i,:);
        AMTRAFFIC.skylevel30(dateindex,:) = PHL.skylevel30(i,:);
        AMTRAFFIC.skylevel40(dateindex,:) = PHL.skylevel40(i,:);
        AMTRAFFIC.weathercode0(dateindex,:) = PHL.weathercode0(i,:);
    end
end
toc
%Elapsed time is 200.369432 seconds.

% 07/29/2018 Next, we should remove empty elements from TRAFFIC.speed0,etc
% Run this part ONLY ONCE!!!
tic
preciPHLationnonemptyindex0 = find(~cellfun(@isempty, AMTRAFFIC.hourpreciPHLation0));
AMTRAFFIC.speed0 = AMTRAFFIC.speed0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.travel_time0 = AMTRAFFIC.travel_time0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.conf_score0 = AMTRAFFIC.conf_score0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.measure_tstamp0 = AMTRAFFIC.measure_tstamp0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.tmc_code0 = AMTRAFFIC.tmc_code0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.datetime0 = AMTRAFFIC.datetime0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.datevec0 = AMTRAFFIC.datevec0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.station0 = AMTRAFFIC.station0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.airtemperature0 = AMTRAFFIC.airtemperature0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.hourpreciPHLation0 = AMTRAFFIC.hourpreciPHLation0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.visibility0 = AMTRAFFIC.visibility0(preciPHLationnonemptyindex0,:);
AMTRAFFIC.skycoverage10 = AMTRAFFIC.skycoverage10(preciPHLationnonemptyindex0,:);
AMTRAFFIC.skycoverage20 = AMTRAFFIC.skycoverage20(preciPHLationnonemptyindex0,:);
AMTRAFFIC.skycoverage30 = AMTRAFFIC.skycoverage30(preciPHLationnonemptyindex0,:);
AMTRAFFIC.skycoverage40 = AMTRAFFIC.skycoverage40(preciPHLationnonemptyindex0,:);
AMTRAFFIC.skylevel10 = AMTRAFFIC.skylevel10(preciPHLationnonemptyindex0,:);
AMTRAFFIC.skylevel20 = AMTRAFFIC.skylevel20(preciPHLationnonemptyindex0,:);
AMTRAFFIC.skylevel30 = AMTRAFFIC.skylevel30(preciPHLationnonemptyindex0,:);
AMTRAFFIC.skylevel40 = AMTRAFFIC.skylevel40(preciPHLationnonemptyindex0,:);
AMTRAFFIC.weathercode0 = AMTRAFFIC.weathercode0(preciPHLationnonemptyindex0,:);
toc
% AMTRAFFIC.tmc_code0(1,1) = {'103-04124'};
%Elapsed time is 2.059255 seconds.


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

tic
for i = 1:numel(TMC.tmc_code0)
    tmcindex = find(ismember(AMTRAFFIC.tmc_code0, TMC.tmc_code0{i,:}(1,:)));
    if(~isempty(tmcindex))
        AMTRAFFIC.road0(tmcindex,1) = TMC.road0(i,1);
        AMTRAFFIC.direction0(tmcindex,1) = TMC.direction0(i,1);
        AMTRAFFIC.miles0(tmcindex,1) = TMC.miles0(i,1);
    end
end
toc
%Elapsed time is 0.645418 seconds.

%% separate two directions and conf_score >= 20:
tic
% directionstat0 = sortrows(tabulate(TRAFFIC.direction0));
directionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.direction0,'EASTBOUND')) | ~cellfun(@isempty,strfind(TRAFFIC.direction0,'NORTHBOUND')));
TRAFFIC.speed3 = TRAFFIC.speed0(directionindex3,1);
TRAFFIC.travel_time3 = TRAFFIC.travel_time0(directionindex3,1);
TRAFFIC.conf_score3 = TRAFFIC.conf_score0(directionindex3,1);
TRAFFIC.measure_tstamp3 = TRAFFIC.measure_tstamp0(directionindex3,1);
TRAFFIC.tmc_code3 = TRAFFIC.tmc_code0(directionindex3,1);
TRAFFIC.datetime3 = TRAFFIC.datetime0(directionindex3,1);
TRAFFIC.datevec3 = TRAFFIC.datevec0(directionindex3,:);
TRAFFIC.station3 = TRAFFIC.station0(directionindex3,1);
TRAFFIC.airtemperature3 = TRAFFIC.airtemperature0(directionindex3,1);
TRAFFIC.hourpreciPHLation3 = TRAFFIC.hourpreciPHLation0(directionindex3,1);
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

directionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.direction0,'WESTBOUND')) | ~cellfun(@isempty,strfind(TRAFFIC.direction0,'SOUTHBOUND')));
TRAFFIC.speed4 = TRAFFIC.speed0(directionindex4,1);
TRAFFIC.travel_time4 = TRAFFIC.travel_time0(directionindex4,1);
TRAFFIC.conf_score4 = TRAFFIC.conf_score0(directionindex4,1);
TRAFFIC.measure_tstamp4 = TRAFFIC.measure_tstamp0(directionindex4,1);
TRAFFIC.tmc_code4 = TRAFFIC.tmc_code0(directionindex4,1);
TRAFFIC.datetime4 = TRAFFIC.datetime0(directionindex4,1);
TRAFFIC.datevec4 = TRAFFIC.datevec0(directionindex4,:);
TRAFFIC.station4 = TRAFFIC.station0(directionindex4,1);
TRAFFIC.airtemperature4 = TRAFFIC.airtemperature0(directionindex4,1);
TRAFFIC.hourpreciPHLation4 = TRAFFIC.hourpreciPHLation0(directionindex4,1);
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
TRAFFIC.hourpreciPHLation3(confscoreindex3) = [];
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
TRAFFIC.hourpreciPHLation4(confscoreindex4) = [];
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

%% 'morning peak' separate two directions and conf_score >= 20:
tic
% directionstat0 = sortrows(tabulate(AMTRAFFIC.direction0));
directionindex3 = find(~cellfun(@isempty,strfind(AMTRAFFIC.direction0,'EASTBOUND')) | ~cellfun(@isempty,strfind(AMTRAFFIC.direction0,'NORTHBOUND')));
AMTRAFFIC.speed3 = AMTRAFFIC.speed0(directionindex3,1);
AMTRAFFIC.travel_time3 = AMTRAFFIC.travel_time0(directionindex3,1);
AMTRAFFIC.conf_score3 = AMTRAFFIC.conf_score0(directionindex3,1);
AMTRAFFIC.measure_tstamp3 = AMTRAFFIC.measure_tstamp0(directionindex3,1);
AMTRAFFIC.tmc_code3 = AMTRAFFIC.tmc_code0(directionindex3,1);
AMTRAFFIC.datetime3 = AMTRAFFIC.datetime0(directionindex3,1);
AMTRAFFIC.datevec3 = AMTRAFFIC.datevec0(directionindex3,:);
AMTRAFFIC.station3 = AMTRAFFIC.station0(directionindex3,1);
AMTRAFFIC.airtemperature3 = AMTRAFFIC.airtemperature0(directionindex3,1);
AMTRAFFIC.hourpreciPHLation3 = AMTRAFFIC.hourpreciPHLation0(directionindex3,1);
AMTRAFFIC.visibility3 = AMTRAFFIC.visibility0(directionindex3,1);
AMTRAFFIC.skycoverage13 = AMTRAFFIC.skycoverage10(directionindex3,1);
AMTRAFFIC.skycoverage23 = AMTRAFFIC.skycoverage20(directionindex3,1);
AMTRAFFIC.skycoverage33 = AMTRAFFIC.skycoverage30(directionindex3,1);
AMTRAFFIC.skycoverage43 = AMTRAFFIC.skycoverage40(directionindex3,1);
AMTRAFFIC.skylevel13 = AMTRAFFIC.skylevel10(directionindex3,1);
AMTRAFFIC.skylevel23 = AMTRAFFIC.skylevel20(directionindex3,1);
AMTRAFFIC.skylevel33 = AMTRAFFIC.skylevel30(directionindex3,1);
AMTRAFFIC.skylevel43 = AMTRAFFIC.skylevel40(directionindex3,1);
AMTRAFFIC.weathercode3 = AMTRAFFIC.weathercode0(directionindex3,1);
AMTRAFFIC.road3 = AMTRAFFIC.road0(directionindex3,1);
AMTRAFFIC.direction3 = AMTRAFFIC.direction0(directionindex3,1);
AMTRAFFIC.miles3 = AMTRAFFIC.miles0(directionindex3,1);

directionindex4 = find(~cellfun(@isempty,strfind(AMTRAFFIC.direction0,'WESTBOUND')) | ~cellfun(@isempty,strfind(AMTRAFFIC.direction0,'SOUTHBOUND')));
AMTRAFFIC.speed4 = AMTRAFFIC.speed0(directionindex4,1);
AMTRAFFIC.travel_time4 = AMTRAFFIC.travel_time0(directionindex4,1);
AMTRAFFIC.conf_score4 = AMTRAFFIC.conf_score0(directionindex4,1);
AMTRAFFIC.measure_tstamp4 = AMTRAFFIC.measure_tstamp0(directionindex4,1);
AMTRAFFIC.tmc_code4 = AMTRAFFIC.tmc_code0(directionindex4,1);
AMTRAFFIC.datetime4 = AMTRAFFIC.datetime0(directionindex4,1);
AMTRAFFIC.datevec4 = AMTRAFFIC.datevec0(directionindex4,:);
AMTRAFFIC.station4 = AMTRAFFIC.station0(directionindex4,1);
AMTRAFFIC.airtemperature4 = AMTRAFFIC.airtemperature0(directionindex4,1);
AMTRAFFIC.hourpreciPHLation4 = AMTRAFFIC.hourpreciPHLation0(directionindex4,1);
AMTRAFFIC.visibility4 = AMTRAFFIC.visibility0(directionindex4,1);
AMTRAFFIC.skycoverage14 = AMTRAFFIC.skycoverage10(directionindex4,1);
AMTRAFFIC.skycoverage24 = AMTRAFFIC.skycoverage20(directionindex4,1);
AMTRAFFIC.skycoverage34 = AMTRAFFIC.skycoverage30(directionindex4,1);
AMTRAFFIC.skycoverage44 = AMTRAFFIC.skycoverage40(directionindex4,1);
AMTRAFFIC.skylevel14 = AMTRAFFIC.skylevel10(directionindex4,1);
AMTRAFFIC.skylevel24 = AMTRAFFIC.skylevel20(directionindex4,1);
AMTRAFFIC.skylevel34 = AMTRAFFIC.skylevel30(directionindex4,1);
AMTRAFFIC.skylevel44 = AMTRAFFIC.skylevel40(directionindex4,1);
AMTRAFFIC.weathercode4 = AMTRAFFIC.weathercode0(directionindex4,1);
AMTRAFFIC.road4 = AMTRAFFIC.road0(directionindex4,1);
AMTRAFFIC.direction4 = AMTRAFFIC.direction0(directionindex4,1);
AMTRAFFIC.miles4 = AMTRAFFIC.miles0(directionindex4,1);
toc
%Elapsed time is 3.367178 seconds.

% find conf_score:
tic
confscoreindex3 = find(AMTRAFFIC.conf_score3 ~= 30);
AMTRAFFIC.speed3(confscoreindex3) = [];
AMTRAFFIC.travel_time3(confscoreindex3) = [];
AMTRAFFIC.conf_score3(confscoreindex3) = [];
AMTRAFFIC.measure_tstamp3(confscoreindex3) = [];
AMTRAFFIC.tmc_code3(confscoreindex3) = [];
AMTRAFFIC.datetime3(confscoreindex3) = [];
AMTRAFFIC.datevec3(confscoreindex3) = [];
AMTRAFFIC.datevec3 = reshape(AMTRAFFIC.datevec3,numel(AMTRAFFIC.datetime3),6);
AMTRAFFIC.station3(confscoreindex3) = [];
AMTRAFFIC.airtemperature3(confscoreindex3) = [];
AMTRAFFIC.hourpreciPHLation3(confscoreindex3) = [];
AMTRAFFIC.visibility3(confscoreindex3) = [];
AMTRAFFIC.skycoverage13(confscoreindex3) = [];
AMTRAFFIC.skycoverage23(confscoreindex3) = [];
AMTRAFFIC.skycoverage33(confscoreindex3) = [];
AMTRAFFIC.skycoverage43(confscoreindex3) = [];
AMTRAFFIC.skylevel13(confscoreindex3) = [];
AMTRAFFIC.skylevel23(confscoreindex3) = [];
AMTRAFFIC.skylevel33(confscoreindex3) = [];
AMTRAFFIC.skylevel43(confscoreindex3) = [];
AMTRAFFIC.weathercode3(confscoreindex3) = [];
AMTRAFFIC.road3(confscoreindex3) = [];
AMTRAFFIC.direction3(confscoreindex3) = [];
AMTRAFFIC.miles3(confscoreindex3) = [];

confscoreindex4 = find(AMTRAFFIC.conf_score4 ~= 30);
AMTRAFFIC.speed4(confscoreindex4) = [];
AMTRAFFIC.travel_time4(confscoreindex4) = [];
AMTRAFFIC.conf_score4(confscoreindex4) = [];
AMTRAFFIC.measure_tstamp4(confscoreindex4) = [];
AMTRAFFIC.tmc_code4(confscoreindex4) = [];
AMTRAFFIC.datetime4(confscoreindex4) = [];
AMTRAFFIC.datevec4(confscoreindex4) = [];
AMTRAFFIC.datevec4 = reshape(AMTRAFFIC.datevec4,numel(AMTRAFFIC.datetime4),6);
AMTRAFFIC.station4(confscoreindex4) = [];
AMTRAFFIC.airtemperature4(confscoreindex4) = [];
AMTRAFFIC.hourpreciPHLation4(confscoreindex4) = [];
AMTRAFFIC.visibility4(confscoreindex4) = [];
AMTRAFFIC.skycoverage14(confscoreindex4) = [];
AMTRAFFIC.skycoverage24(confscoreindex4) = [];
AMTRAFFIC.skycoverage34(confscoreindex4) = [];
AMTRAFFIC.skycoverage44(confscoreindex4) = [];
AMTRAFFIC.skylevel14(confscoreindex4) = [];
AMTRAFFIC.skylevel24(confscoreindex4) = [];
AMTRAFFIC.skylevel34(confscoreindex4) = [];
AMTRAFFIC.skylevel44(confscoreindex4) = [];
AMTRAFFIC.weathercode4(confscoreindex4) = [];
AMTRAFFIC.road4(confscoreindex4) = [];
AMTRAFFIC.direction4(confscoreindex4) = [];
AMTRAFFIC.miles4(confscoreindex4) = [];
toc
%Elapsed time is 0.223961 seconds.

%% 12/28/2018
% Orange: '103+04117','103-04116','103-04117','103N04117','103P04117','103+04118'
% Red: '103N04381','103-04381','103+04382','103P04381' 
% Blue: '103+04269','103-04268','103N04269','103P04269'
% Green: '103+04267','103-04266','103N04266','103P04266' 
% Purple: '103-04142','103+04143','103N04143','103P04143' 
% Yellow:  
% Black:  
tic
orangedirectionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103+04117')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103P04117')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103+04118'))...
);
orangedirectionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103-04116')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103-04117')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103N04117'))...
);
orangedirectionindex0 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103+04117')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103+04118')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103P04117')) |...
        ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103-04116')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103-04117')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103N04117'))...
);

reddirectionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103P04381')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103+04382'))...
);
reddirectionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103-04381')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103N04381'))...
);
reddirectionindex0 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103P04381')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103+04382')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103-04381')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103N04381'))...
);

bluedirectionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103+04269')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103P04269'))...
);
bluedirectionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103-04268')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103N04269'))...
);
bluedirectionindex0 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103+04269')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103P04269')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103-04268')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103N04269'))...
);

greendirectionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103+04267')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103P04266'))...
);
greendirectionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103-04266')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103N04266'))...
);
greendirectionindex0 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103+04267')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103P04266')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103-04266')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103N04266'))...
);

purpledirectionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103+04143')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'103P04143'))...
);
purpledirectionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103-04142')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'103N04143'))...
);
purpledirectionindex0 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103+04143')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103P04143')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103-04142')) |...
    ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'103N04143'))...
);

% yellowdirectionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'104+04496')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'104P04495'))...
% );
% yellowdirectionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'104-04495')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'104N04495'))...
% );
% yellowdirectionindex0 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'104+04496')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'104P04495')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'104-04495')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'104N04495'))...
% );
% 
% blackdirectionindex3 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'104+04501')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code3,'104P04500'))...
% );
% blackdirectionindex4 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'104-04500')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code4,'104N04500'))...
% );
% blackdirectionindex0 = find(~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'104+04501')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'104P04500')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'104-04500')) |...
%     ~cellfun(@isempty,strfind(TRAFFIC.tmc_code0,'104N04500'))...
% );

toc
%Elapsed time is 52.564354 seconds.

tic
orangeamdirectionindex3 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103+04117')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103P04117')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103+04118'))...
);
orangeamdirectionindex4 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103-04116')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103-04117')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103N04117'))...
);
orangeamdirectionindex0 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103+04117')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103P04117')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103+04118')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103-04116')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103-04117')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103N04117'))...
);

redamdirectionindex3 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103+04382')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103P04381'))...
);
redamdirectionindex4 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103N04381')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103-04381'))...
);
redamdirectionindex0 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103+04382')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103P04381')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103N04381')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103-04381'))...
);

blueamdirectionindex3 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103+04269')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103P04269'))...
);
blueamdirectionindex4 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103-04268')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103N04269'))...
);
blueamdirectionindex0 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103+04269')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103P04269')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103-04268')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103N04269'))...
);

greenamdirectionindex3 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103+04267')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103P04266'))...
);
greenamdirectionindex4 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103-04266')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103N04266'))...
);
greenamdirectionindex0 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103+04267')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103P04266')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103-04266')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103N04266'))...
);

purpleamdirectionindex3 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103+04143')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'103P04143'))...
);
purpleamdirectionindex4 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103-04142')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'103N04143'))...
);
purpleamdirectionindex0 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103+04143')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103P04143')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103-04142')) |...
    ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'103N04143'))...
);

% yellowamdirectionindex3 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'104+04496')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'104P04495'))...
% );
% yellowamdirectionindex4 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'104-04495')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'104N04495'))...
% );
% yellowamdirectionindex0 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'104+04496')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'104P04495')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'104-04495')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'104N04495'))...
% );
% 
% blackamdirectionindex3 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'104+04501')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code3,'104P04500'))...
% );
% blackamdirectionindex4 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'104-04500')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code4,'104N04500'))...
% );
% blackamdirectionindex0 = find(~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'104+04501')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'104P04500')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'104-04500')) |...
%     ~cellfun(@isempty,strfind(AMTRAFFIC.tmc_code0,'104N04500'))...
% );

toc
%Elapsed time is 47.564354 seconds.

%% 12/28/2018 
tic
% since we have 4 corridors and PM/AM, I will define 8 structs to store their data
fieldname = fieldnames(TRAFFIC);
for i = 1:numel(fieldname)
    if (i <= 23)  % THIS IF PART IS TWO DIRECTIONS
    % Afternoon Peak Hour
        eval(['TRAFFIC_ORA.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(orangedirectionindex0,:);']);
        %   TRAFFIC_ORA.(fieldname{1}) = TRAFFIC.(fieldname{1})(orangedirectionindex0);
        eval(['TRAFFIC_RED.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(reddirectionindex0,:);']);
        eval(['TRAFFIC_BLU.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(bluedirectionindex0,:);']);
        eval(['TRAFFIC_GRE.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(greendirectionindex0,:);']);
        eval(['TRAFFIC_PUR.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(purpledirectionindex0,:);']);
%         eval(['TRAFFIC_YEL.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(yellowdirectionindex0,:);']);
%         eval(['TRAFFIC_BLA.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(blackdirectionindex0,:);']);

    % Morning Peak Hour
        eval(['AMTRAFFIC_ORA.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(orangeamdirectionindex0,:);']);
        %     AMTRAFFIC_ORA.fieldname{i} = AMTRAFFIC.fieldname{1}(orangeamdirectionindex0);
        eval(['AMTRAFFIC_RED.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(redamdirectionindex0,:);']);
        eval(['AMTRAFFIC_BLU.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(blueamdirectionindex0,:);']);
        eval(['AMTRAFFIC_GRE.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(greenamdirectionindex0,:);']);
        eval(['AMTRAFFIC_PUR.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(purpleamdirectionindex0,:);']);
%         eval(['AMTRAFFIC_YEL.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(yellowamdirectionindex0,:);']);
%         eval(['AMTRAFFIC_BLA.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(blackamdirectionindex0,:);']);

        
    elseif (i > 23 && i <= 46)  % THIS ELSE IF IS NORTHBOUND/EASTBOUND
    % Afternoon Peak Hour
        eval(['TRAFFIC_ORA.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(orangedirectionindex3,:);']);
        %   TRAFFIC_ORA.(fieldname{1}) = TRAFFIC.(fieldname{1})(orangedirectionindex3);
        eval(['TRAFFIC_RED.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(reddirectionindex3,:);']);
        eval(['TRAFFIC_BLU.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(bluedirectionindex3,:);']);
        eval(['TRAFFIC_GRE.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(greendirectionindex3,:);']);
        eval(['TRAFFIC_PUR.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(purpledirectionindex3,:);']);
%         eval(['TRAFFIC_YEL.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(yellowdirectionindex3,:);']);
%         eval(['TRAFFIC_BLA.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(blackdirectionindex3,:);']);

    % Morning Peak Hour
        eval(['AMTRAFFIC_ORA.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(orangeamdirectionindex3,:);']);
        %     AMTRAFFIC_ORA.fieldname{i} = AMTRAFFIC.fieldname{1}(orangeamdirectionindex3);
        eval(['AMTRAFFIC_RED.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(redamdirectionindex3,:);']);
        eval(['AMTRAFFIC_BLU.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(blueamdirectionindex3,:);']);
        eval(['AMTRAFFIC_GRE.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(greenamdirectionindex3,:);']);
        eval(['AMTRAFFIC_PUR.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(purpleamdirectionindex3,:);']);
%         eval(['AMTRAFFIC_YEL.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(yellowamdirectionindex3,:);']);
%         eval(['AMTRAFFIC_BLA.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(blackamdirectionindex3,:);']);
    
    
    else  % THIS ELSE PART IS SOUTHBOUND/WESTBOUND
    % Afternoon Peak Hour
        eval(['TRAFFIC_ORA.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(orangedirectionindex4,:);']);
        %   TRAFFIC_ORA.(fieldname{1}) = TRAFFIC.(fieldname{1})(orangedirectionindex4);
        eval(['TRAFFIC_RED.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(reddirectionindex4,:);']);
        eval(['TRAFFIC_BLU.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(bluedirectionindex4,:);']);
        eval(['TRAFFIC_GRE.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(greendirectionindex4,:);']);
        eval(['TRAFFIC_PUR.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(purpledirectionindex4,:);']);
%         eval(['TRAFFIC_YEL.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(yellowdirectionindex4,:);']);
%         eval(['TRAFFIC_BLA.(fieldname{',num2str(i),'}) = TRAFFIC.(fieldname{',num2str(i),'})(blackamdirectionindex4,:);']);

    % Morning Peak Hour
        eval(['AMTRAFFIC_ORA.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(orangeamdirectionindex4,:);']);
        %     AMTRAFFIC_ORA.fieldname{i} = AMTRAFFIC.fieldname{1}(orangeamdirectionindex4);
        eval(['AMTRAFFIC_RED.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(redamdirectionindex4,:);']);
        eval(['AMTRAFFIC_BLU.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(blueamdirectionindex4,:);']);
        eval(['AMTRAFFIC_GRE.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(greenamdirectionindex4,:);']);
        eval(['AMTRAFFIC_PUR.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(purpleamdirectionindex4,:);']);
%         eval(['AMTRAFFIC_YEL.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(yellowamdirectionindex4,:);']);
%         eval(['AMTRAFFIC_BLA.(fieldname{',num2str(i),'}) = AMTRAFFIC.(fieldname{',num2str(i),'})(blackamdirectionindex4,:);']);
    end        
end
toc
% Elapsed time is 3.576859 seconds.

%% release some space
clear orangedirectionindex0 orangedirectionindex3 orangedirectionindex4 reddirectionindex0
clear reddirectionindex3 reddirectionindex4 bluedirectionindex0 bluedirectionindex3 bluedirectionindex4
clear greendirectionindex0 greendirectionindex3 greendirectionindex4
clear orangeamdirectionindex0 orangeamdirectionindex3 orangeamdirectionindex4
clear redamdirectionindex0 redamdirectionindex3 redamdirectionindex4
clear blueamdirectionindex0 blueamdirectionindex3 blueamdirectionindex4
clear greenamdirectionindex0 greenamdirectionindex3 greenamdirectionindex4
clear fieldname i statmeasure_tstamp3 directionindex3 directionindex4
clear blackamdirectionindex3 blackamdirectionindex4 blackdirectionindex3 blackdirectionindex4
clear blackamdirectionindex0 blackdirectionindex0
clear confscoreindex3 confscoreindex4 dateindex trafficdata0
clear yellowamdirectionindex3 yellowamdirectionindex4 yellowamdirectionindex0
clear yellowdirectionindex3 yellowdirectionindex4 yellowdirectionindex0
clear purpleamdirectionindex3 purpleamdirectionindex4 purpleamdirectionindex0
clear purpledirectionindex3 purpledirectionindex4 purpledirectionindex0
clear preciPHLationnonemptyindex0 tmcdata tmcindex numdata0

%% 12/30/2018 TEST IF CONGESTION APPEARED.
% Afternoon
figure(1)
plot(TRAFFIC_ORA.datetime3,TRAFFIC_ORA.speed3)  % Congested
figure(2)
plot(TRAFFIC_ORA.datetime4,TRAFFIC_ORA.speed4)  % Congested
figure(3)
plot(TRAFFIC_RED.datetime3,TRAFFIC_RED.speed3)  % Congested
figure(4)
plot(TRAFFIC_RED.datetime4,TRAFFIC_RED.speed4)  % Congested
figure(5)
plot(TRAFFIC_BLU.datetime3,TRAFFIC_BLU.speed3)  % Congested
figure(6)
plot(TRAFFIC_BLU.datetime4,TRAFFIC_BLU.speed4)  % Not Congested
figure(7)
plot(TRAFFIC_GRE.datetime3,TRAFFIC_GRE.speed3)  % Congested
figure(8)
plot(TRAFFIC_GRE.datetime4,TRAFFIC_GRE.speed4)  % Congested
figure(9)
plot(TRAFFIC_PUR.datetime3,TRAFFIC_PUR.speed3)  % Congested
figure(10)
plot(TRAFFIC_PUR.datetime4,TRAFFIC_PUR.speed4)  % Congested
% figure(11)
% plot(TRAFFIC_YEL.datetime3,TRAFFIC_YEL.speed3)  % Missing Data
% figure(12)
% plot(TRAFFIC_YEL.datetime4,TRAFFIC_YEL.speed4)  % Missing Data
% figure(13)
% plot(TRAFFIC_BLA.datetime3,TRAFFIC_BLA.speed3)  % Missing Data
% figure(14)
% plot(TRAFFIC_BLA.datetime4,TRAFFIC_BLA.speed4)  % Missing Data

% Morning
figure(15)
plot(AMTRAFFIC_ORA.datetime3,AMTRAFFIC_ORA.speed3)  % Congested
figure(16)
plot(AMTRAFFIC_ORA.datetime4,AMTRAFFIC_ORA.speed4)  % Congested
figure(17)
plot(AMTRAFFIC_RED.datetime3,AMTRAFFIC_RED.speed3)  % Not Congested
figure(18)
plot(AMTRAFFIC_RED.datetime4,AMTRAFFIC_RED.speed4)  % Not Congested
figure(19)
plot(AMTRAFFIC_BLU.datetime3,AMTRAFFIC_BLU.speed3)  % Not Congested
figure(20)
plot(AMTRAFFIC_BLU.datetime4,AMTRAFFIC_BLU.speed4)  % Congested
figure(21)
plot(AMTRAFFIC_GRE.datetime3,AMTRAFFIC_GRE.speed3)  % Not Congested
figure(22)
plot(AMTRAFFIC_GRE.datetime4,AMTRAFFIC_GRE.speed4)  % Congested
figure(23)
plot(AMTRAFFIC_PUR.datetime3,AMTRAFFIC_PUR.speed3)  % Congested
figure(24)
plot(AMTRAFFIC_PUR.datetime4,AMTRAFFIC_PUR.speed4)  % Not Congested
% figure(25)
% plot(AMTRAFFIC_YEL.datetime3,AMTRAFFIC_YEL.speed3)  % Missing Data
% figure(26)
% plot(AMTRAFFIC_YEL.datetime4,AMTRAFFIC_YEL.speed4)  % Missing Data
% figure(27)
% plot(AMTRAFFIC_BLA.datetime3,AMTRAFFIC_BLA.speed3)  % Missing Data
% figure(28)
% plot(AMTRAFFIC_BLA.datetime4,AMTRAFFIC_BLA.speed4)  % Missing Data

%% 12/30/2018 take average for two directions (ORANGE)
tic
statmeasure_tstamp3 = tabulate(TRAFFIC_ORA.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(TRAFFIC_ORA.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    TRAFFICAVE_ORA.speed3(i,:) = sum(TRAFFIC_ORA.speed3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_ORA.travel_time3(i,:) = sum(TRAFFIC_ORA.travel_time3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_ORA.conf_score3(i,:) = sum(TRAFFIC_ORA.conf_score3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_ORA.measure_tstamp3(i,:) = TRAFFIC_ORA.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.tmc_code3(i,:) = TRAFFIC_ORA.tmc_code3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.datetime3(i,:) = TRAFFIC_ORA.datetime3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.datevec3(i,:) = TRAFFIC_ORA.datevec3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.station3(i,:) = TRAFFIC_ORA.station3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.airtemperature3(i,:) = sum(str2double(TRAFFIC_ORA.airtemperature3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_ORA.hourpreciPHLation3(i,:) = sum(str2double(TRAFFIC_ORA.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_ORA.visibility3(i,:) = sum(str2double(TRAFFIC_ORA.visibility3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_ORA.skycoverage13(i,:) = TRAFFIC_ORA.skycoverage13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.skycoverage23(i,:) = TRAFFIC_ORA.skycoverage23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.skycoverage33(i,:) = TRAFFIC_ORA.skycoverage33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.skycoverage43(i,:) = TRAFFIC_ORA.skycoverage43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.skylevel13(i,:) = TRAFFIC_ORA.skylevel13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.skylevel23(i,:) = TRAFFIC_ORA.skylevel23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.skylevel33(i,:) = TRAFFIC_ORA.skylevel33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.skylevel43(i,:) = TRAFFIC_ORA.skylevel43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.weathercode3(i,:) = TRAFFIC_ORA.weathercode3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.road3(i,:) = TRAFFIC_ORA.road3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.direction3(i,:) = TRAFFIC_ORA.direction3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_ORA.miles3(i,:) = sum(str2double(TRAFFIC_ORA.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 550.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(TRAFFIC_ORA.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(TRAFFIC_ORA.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    TRAFFICAVE_ORA.speed4(i,:) = sum(TRAFFIC_ORA.speed4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_ORA.travel_time4(i,:) = sum(TRAFFIC_ORA.travel_time4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_ORA.conf_score4(i,:) = sum(TRAFFIC_ORA.conf_score4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_ORA.measure_tstamp4(i,:) = TRAFFIC_ORA.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.tmc_code4(i,:) = TRAFFIC_ORA.tmc_code4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.datetime4(i,:) = TRAFFIC_ORA.datetime4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.datevec4(i,:) = TRAFFIC_ORA.datevec4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.station4(i,:) = TRAFFIC_ORA.station4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.airtemperature4(i,:) = sum(str2double(TRAFFIC_ORA.airtemperature4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_ORA.hourpreciPHLation4(i,:) = sum(str2double(TRAFFIC_ORA.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_ORA.visibility4(i,:) = sum(str2double(TRAFFIC_ORA.visibility4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_ORA.skycoverage14(i,:) = TRAFFIC_ORA.skycoverage14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.skycoverage24(i,:) = TRAFFIC_ORA.skycoverage24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.skycoverage34(i,:) = TRAFFIC_ORA.skycoverage34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.skycoverage44(i,:) = TRAFFIC_ORA.skycoverage44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.skylevel14(i,:) = TRAFFIC_ORA.skylevel14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.skylevel24(i,:) = TRAFFIC_ORA.skylevel24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.skylevel34(i,:) = TRAFFIC_ORA.skylevel34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.skylevel44(i,:) = TRAFFIC_ORA.skylevel44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.weathercode4(i,:) = TRAFFIC_ORA.weathercode4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.road4(i,:) = TRAFFIC_ORA.road4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.direction4(i,:) = TRAFFIC_ORA.direction4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_ORA.miles4(i,:) = sum(str2double(TRAFFIC_ORA.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 550.710435 seconds.

tic
statmeasure_tstamp3 = tabulate(AMTRAFFIC_ORA.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(AMTRAFFIC_ORA.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    AMTRAFFICAVE_ORA.speed3(i,:) = sum(AMTRAFFIC_ORA.speed3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_ORA.travel_time3(i,:) = sum(AMTRAFFIC_ORA.travel_time3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_ORA.conf_score3(i,:) = sum(AMTRAFFIC_ORA.conf_score3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_ORA.measure_tstamp3(i,:) = AMTRAFFIC_ORA.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.tmc_code3(i,:) = AMTRAFFIC_ORA.tmc_code3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.datetime3(i,:) = AMTRAFFIC_ORA.datetime3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.datevec3(i,:) = AMTRAFFIC_ORA.datevec3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.station3(i,:) = AMTRAFFIC_ORA.station3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.airtemperature3(i,:) = sum(str2double(AMTRAFFIC_ORA.airtemperature3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_ORA.hourpreciPHLation3(i,:) = sum(str2double(AMTRAFFIC_ORA.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_ORA.visibility3(i,:) = sum(str2double(AMTRAFFIC_ORA.visibility3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_ORA.skycoverage13(i,:) = AMTRAFFIC_ORA.skycoverage13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.skycoverage23(i,:) = AMTRAFFIC_ORA.skycoverage23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.skycoverage33(i,:) = AMTRAFFIC_ORA.skycoverage33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.skycoverage43(i,:) = AMTRAFFIC_ORA.skycoverage43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.skylevel13(i,:) = AMTRAFFIC_ORA.skylevel13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.skylevel23(i,:) = AMTRAFFIC_ORA.skylevel23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.skylevel33(i,:) = AMTRAFFIC_ORA.skylevel33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.skylevel43(i,:) = AMTRAFFIC_ORA.skylevel43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.weathercode3(i,:) = AMTRAFFIC_ORA.weathercode3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.road3(i,:) = AMTRAFFIC_ORA.road3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.direction3(i,:) = AMTRAFFIC_ORA.direction3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_ORA.miles3(i,:) = sum(str2double(AMTRAFFIC_ORA.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 570.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(AMTRAFFIC_ORA.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(AMTRAFFIC_ORA.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    AMTRAFFICAVE_ORA.speed4(i,:) = sum(AMTRAFFIC_ORA.speed4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_ORA.travel_time4(i,:) = sum(AMTRAFFIC_ORA.travel_time4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_ORA.conf_score4(i,:) = sum(AMTRAFFIC_ORA.conf_score4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_ORA.measure_tstamp4(i,:) = AMTRAFFIC_ORA.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.tmc_code4(i,:) = AMTRAFFIC_ORA.tmc_code4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.datetime4(i,:) = AMTRAFFIC_ORA.datetime4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.datevec4(i,:) = AMTRAFFIC_ORA.datevec4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.station4(i,:) = AMTRAFFIC_ORA.station4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.airtemperature4(i,:) = sum(str2double(AMTRAFFIC_ORA.airtemperature4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_ORA.hourpreciPHLation4(i,:) = sum(str2double(AMTRAFFIC_ORA.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_ORA.visibility4(i,:) = sum(str2double(AMTRAFFIC_ORA.visibility4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_ORA.skycoverage14(i,:) = AMTRAFFIC_ORA.skycoverage14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.skycoverage24(i,:) = AMTRAFFIC_ORA.skycoverage24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.skycoverage34(i,:) = AMTRAFFIC_ORA.skycoverage34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.skycoverage44(i,:) = AMTRAFFIC_ORA.skycoverage44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.skylevel14(i,:) = AMTRAFFIC_ORA.skylevel14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.skylevel24(i,:) = AMTRAFFIC_ORA.skylevel24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.skylevel34(i,:) = AMTRAFFIC_ORA.skylevel34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.skylevel44(i,:) = AMTRAFFIC_ORA.skylevel44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.weathercode4(i,:) = AMTRAFFIC_ORA.weathercode4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.road4(i,:) = AMTRAFFIC_ORA.road4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.direction4(i,:) = AMTRAFFIC_ORA.direction4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_ORA.miles4(i,:) = sum(str2double(AMTRAFFIC_ORA.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 570.710435 seconds.

%% 12/30/2018 take average for two directions  (RED)
tic
statmeasure_tstamp3 = tabulate(TRAFFIC_PUR.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(TRAFFIC_PUR.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    TRAFFICAVE_RED.speed3(i,:) = sum(TRAFFIC_PUR.speed3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_RED.travel_time3(i,:) = sum(TRAFFIC_PUR.travel_time3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_RED.conf_score3(i,:) = sum(TRAFFIC_PUR.conf_score3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_RED.measure_tstamp3(i,:) = TRAFFIC_PUR.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.tmc_code3(i,:) = TRAFFIC_PUR.tmc_code3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.datetime3(i,:) = TRAFFIC_PUR.datetime3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.datevec3(i,:) = TRAFFIC_PUR.datevec3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.station3(i,:) = TRAFFIC_PUR.station3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.airtemperature3(i,:) = sum(str2double(TRAFFIC_PUR.airtemperature3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_RED.hourpreciPHLation3(i,:) = sum(str2double(TRAFFIC_PUR.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_RED.visibility3(i,:) = sum(str2double(TRAFFIC_PUR.visibility3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_RED.skycoverage13(i,:) = TRAFFIC_PUR.skycoverage13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.skycoverage23(i,:) = TRAFFIC_PUR.skycoverage23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.skycoverage33(i,:) = TRAFFIC_PUR.skycoverage33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.skycoverage43(i,:) = TRAFFIC_PUR.skycoverage43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.skylevel13(i,:) = TRAFFIC_PUR.skylevel13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.skylevel23(i,:) = TRAFFIC_PUR.skylevel23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.skylevel33(i,:) = TRAFFIC_PUR.skylevel33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.skylevel43(i,:) = TRAFFIC_PUR.skylevel43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.weathercode3(i,:) = TRAFFIC_PUR.weathercode3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.road3(i,:) = TRAFFIC_PUR.road3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.direction3(i,:) = TRAFFIC_PUR.direction3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_RED.miles3(i,:) = sum(str2double(TRAFFIC_PUR.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 270.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(TRAFFIC_PUR.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(TRAFFIC_PUR.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    TRAFFICAVE_RED.speed4(i,:) = sum(TRAFFIC_PUR.speed4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_RED.travel_time4(i,:) = sum(TRAFFIC_PUR.travel_time4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_RED.conf_score4(i,:) = sum(TRAFFIC_PUR.conf_score4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_RED.measure_tstamp4(i,:) = TRAFFIC_PUR.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.tmc_code4(i,:) = TRAFFIC_PUR.tmc_code4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.datetime4(i,:) = TRAFFIC_PUR.datetime4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.datevec4(i,:) = TRAFFIC_PUR.datevec4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.station4(i,:) = TRAFFIC_PUR.station4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.airtemperature4(i,:) = sum(str2double(TRAFFIC_PUR.airtemperature4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_RED.hourpreciPHLation4(i,:) = sum(str2double(TRAFFIC_PUR.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_RED.visibility4(i,:) = sum(str2double(TRAFFIC_PUR.visibility4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_RED.skycoverage14(i,:) = TRAFFIC_PUR.skycoverage14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.skycoverage24(i,:) = TRAFFIC_PUR.skycoverage24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.skycoverage34(i,:) = TRAFFIC_PUR.skycoverage34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.skycoverage44(i,:) = TRAFFIC_PUR.skycoverage44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.skylevel14(i,:) = TRAFFIC_PUR.skylevel14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.skylevel24(i,:) = TRAFFIC_PUR.skylevel24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.skylevel34(i,:) = TRAFFIC_PUR.skylevel34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.skylevel44(i,:) = TRAFFIC_PUR.skylevel44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.weathercode4(i,:) = TRAFFIC_PUR.weathercode4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.road4(i,:) = TRAFFIC_PUR.road4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.direction4(i,:) = TRAFFIC_PUR.direction4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_RED.miles4(i,:) = sum(str2double(TRAFFIC_PUR.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 270.710435 seconds.

tic
statmeasure_tstamp3 = tabulate(AMTRAFFIC_PUR.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(AMTRAFFIC_PUR.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    AMTRAFFICAVE_RED.speed3(i,:) = sum(AMTRAFFIC_PUR.speed3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_RED.travel_time3(i,:) = sum(AMTRAFFIC_PUR.travel_time3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_RED.conf_score3(i,:) = sum(AMTRAFFIC_PUR.conf_score3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_RED.measure_tstamp3(i,:) = AMTRAFFIC_PUR.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.tmc_code3(i,:) = AMTRAFFIC_PUR.tmc_code3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.datetime3(i,:) = AMTRAFFIC_PUR.datetime3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.datevec3(i,:) = AMTRAFFIC_PUR.datevec3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.station3(i,:) = AMTRAFFIC_PUR.station3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.airtemperature3(i,:) = sum(str2double(AMTRAFFIC_PUR.airtemperature3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_RED.hourpreciPHLation3(i,:) = sum(str2double(AMTRAFFIC_PUR.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_RED.visibility3(i,:) = sum(str2double(AMTRAFFIC_PUR.visibility3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_RED.skycoverage13(i,:) = AMTRAFFIC_PUR.skycoverage13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.skycoverage23(i,:) = AMTRAFFIC_PUR.skycoverage23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.skycoverage33(i,:) = AMTRAFFIC_PUR.skycoverage33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.skycoverage43(i,:) = AMTRAFFIC_PUR.skycoverage43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.skylevel13(i,:) = AMTRAFFIC_PUR.skylevel13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.skylevel23(i,:) = AMTRAFFIC_PUR.skylevel23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.skylevel33(i,:) = AMTRAFFIC_PUR.skylevel33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.skylevel43(i,:) = AMTRAFFIC_PUR.skylevel43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.weathercode3(i,:) = AMTRAFFIC_PUR.weathercode3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.road3(i,:) = AMTRAFFIC_PUR.road3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.direction3(i,:) = AMTRAFFIC_PUR.direction3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_RED.miles3(i,:) = sum(str2double(AMTRAFFIC_PUR.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 250.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(AMTRAFFIC_PUR.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(AMTRAFFIC_PUR.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    AMTRAFFICAVE_RED.speed4(i,:) = sum(AMTRAFFIC_PUR.speed4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_RED.travel_time4(i,:) = sum(AMTRAFFIC_PUR.travel_time4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_RED.conf_score4(i,:) = sum(AMTRAFFIC_PUR.conf_score4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_RED.measure_tstamp4(i,:) = AMTRAFFIC_PUR.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.tmc_code4(i,:) = AMTRAFFIC_PUR.tmc_code4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.datetime4(i,:) = AMTRAFFIC_PUR.datetime4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.datevec4(i,:) = AMTRAFFIC_PUR.datevec4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.station4(i,:) = AMTRAFFIC_PUR.station4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.airtemperature4(i,:) = sum(str2double(AMTRAFFIC_PUR.airtemperature4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_RED.hourpreciPHLation4(i,:) = sum(str2double(AMTRAFFIC_PUR.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_RED.visibility4(i,:) = sum(str2double(AMTRAFFIC_PUR.visibility4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_RED.skycoverage14(i,:) = AMTRAFFIC_PUR.skycoverage14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.skycoverage24(i,:) = AMTRAFFIC_PUR.skycoverage24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.skycoverage34(i,:) = AMTRAFFIC_PUR.skycoverage34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.skycoverage44(i,:) = AMTRAFFIC_PUR.skycoverage44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.skylevel14(i,:) = AMTRAFFIC_PUR.skylevel14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.skylevel24(i,:) = AMTRAFFIC_PUR.skylevel24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.skylevel34(i,:) = AMTRAFFIC_PUR.skylevel34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.skylevel44(i,:) = AMTRAFFIC_PUR.skylevel44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.weathercode4(i,:) = AMTRAFFIC_PUR.weathercode4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.road4(i,:) = AMTRAFFIC_PUR.road4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.direction4(i,:) = AMTRAFFIC_PUR.direction4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_RED.miles4(i,:) = sum(str2double(AMTRAFFIC_PUR.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 250.710435 seconds.

%% 12/30/2018 take average for two directions  (BLUE)
tic
statmeasure_tstamp3 = tabulate(TRAFFIC_BLU.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(TRAFFIC_BLU.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    TRAFFICAVE_BLU.speed3(i,:) = sum(TRAFFIC_BLU.speed3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_BLU.travel_time3(i,:) = sum(TRAFFIC_BLU.travel_time3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_BLU.conf_score3(i,:) = sum(TRAFFIC_BLU.conf_score3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_BLU.measure_tstamp3(i,:) = TRAFFIC_BLU.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.tmc_code3(i,:) = TRAFFIC_BLU.tmc_code3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.datetime3(i,:) = TRAFFIC_BLU.datetime3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.datevec3(i,:) = TRAFFIC_BLU.datevec3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.station3(i,:) = TRAFFIC_BLU.station3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.airtemperature3(i,:) = sum(str2double(TRAFFIC_BLU.airtemperature3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_BLU.hourpreciPHLation3(i,:) = sum(str2double(TRAFFIC_BLU.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_BLU.visibility3(i,:) = sum(str2double(TRAFFIC_BLU.visibility3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_BLU.skycoverage13(i,:) = TRAFFIC_BLU.skycoverage13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.skycoverage23(i,:) = TRAFFIC_BLU.skycoverage23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.skycoverage33(i,:) = TRAFFIC_BLU.skycoverage33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.skycoverage43(i,:) = TRAFFIC_BLU.skycoverage43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.skylevel13(i,:) = TRAFFIC_BLU.skylevel13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.skylevel23(i,:) = TRAFFIC_BLU.skylevel23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.skylevel33(i,:) = TRAFFIC_BLU.skylevel33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.skylevel43(i,:) = TRAFFIC_BLU.skylevel43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.weathercode3(i,:) = TRAFFIC_BLU.weathercode3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.road3(i,:) = TRAFFIC_BLU.road3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.direction3(i,:) = TRAFFIC_BLU.direction3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLU.miles3(i,:) = sum(str2double(TRAFFIC_BLU.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 330.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(TRAFFIC_BLU.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(TRAFFIC_BLU.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    TRAFFICAVE_BLU.speed4(i,:) = sum(TRAFFIC_BLU.speed4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_BLU.travel_time4(i,:) = sum(TRAFFIC_BLU.travel_time4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_BLU.conf_score4(i,:) = sum(TRAFFIC_BLU.conf_score4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_BLU.measure_tstamp4(i,:) = TRAFFIC_BLU.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.tmc_code4(i,:) = TRAFFIC_BLU.tmc_code4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.datetime4(i,:) = TRAFFIC_BLU.datetime4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.datevec4(i,:) = TRAFFIC_BLU.datevec4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.station4(i,:) = TRAFFIC_BLU.station4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.airtemperature4(i,:) = sum(str2double(TRAFFIC_BLU.airtemperature4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_BLU.hourpreciPHLation4(i,:) = sum(str2double(TRAFFIC_BLU.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_BLU.visibility4(i,:) = sum(str2double(TRAFFIC_BLU.visibility4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_BLU.skycoverage14(i,:) = TRAFFIC_BLU.skycoverage14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.skycoverage24(i,:) = TRAFFIC_BLU.skycoverage24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.skycoverage34(i,:) = TRAFFIC_BLU.skycoverage34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.skycoverage44(i,:) = TRAFFIC_BLU.skycoverage44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.skylevel14(i,:) = TRAFFIC_BLU.skylevel14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.skylevel24(i,:) = TRAFFIC_BLU.skylevel24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.skylevel34(i,:) = TRAFFIC_BLU.skylevel34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.skylevel44(i,:) = TRAFFIC_BLU.skylevel44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.weathercode4(i,:) = TRAFFIC_BLU.weathercode4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.road4(i,:) = TRAFFIC_BLU.road4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.direction4(i,:) = TRAFFIC_BLU.direction4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLU.miles4(i,:) = sum(str2double(TRAFFIC_BLU.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 330.710435 seconds.

tic
statmeasure_tstamp3 = tabulate(AMTRAFFIC_BLU.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(AMTRAFFIC_BLU.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    AMTRAFFICAVE_BLU.speed3(i,:) = sum(AMTRAFFIC_BLU.speed3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_BLU.travel_time3(i,:) = sum(AMTRAFFIC_BLU.travel_time3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_BLU.conf_score3(i,:) = sum(AMTRAFFIC_BLU.conf_score3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_BLU.measure_tstamp3(i,:) = AMTRAFFIC_BLU.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.tmc_code3(i,:) = AMTRAFFIC_BLU.tmc_code3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.datetime3(i,:) = AMTRAFFIC_BLU.datetime3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.datevec3(i,:) = AMTRAFFIC_BLU.datevec3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.station3(i,:) = AMTRAFFIC_BLU.station3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.airtemperature3(i,:) = sum(str2double(AMTRAFFIC_BLU.airtemperature3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_BLU.hourpreciPHLation3(i,:) = sum(str2double(AMTRAFFIC_BLU.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_BLU.visibility3(i,:) = sum(str2double(AMTRAFFIC_BLU.visibility3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_BLU.skycoverage13(i,:) = AMTRAFFIC_BLU.skycoverage13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.skycoverage23(i,:) = AMTRAFFIC_BLU.skycoverage23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.skycoverage33(i,:) = AMTRAFFIC_BLU.skycoverage33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.skycoverage43(i,:) = AMTRAFFIC_BLU.skycoverage43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.skylevel13(i,:) = AMTRAFFIC_BLU.skylevel13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.skylevel23(i,:) = AMTRAFFIC_BLU.skylevel23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.skylevel33(i,:) = AMTRAFFIC_BLU.skylevel33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.skylevel43(i,:) = AMTRAFFIC_BLU.skylevel43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.weathercode3(i,:) = AMTRAFFIC_BLU.weathercode3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.road3(i,:) = AMTRAFFIC_BLU.road3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.direction3(i,:) = AMTRAFFIC_BLU.direction3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLU.miles3(i,:) = sum(str2double(AMTRAFFIC_BLU.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 330.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(AMTRAFFIC_BLU.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(AMTRAFFIC_BLU.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    AMTRAFFICAVE_BLU.speed4(i,:) = sum(AMTRAFFIC_BLU.speed4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_BLU.travel_time4(i,:) = sum(AMTRAFFIC_BLU.travel_time4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_BLU.conf_score4(i,:) = sum(AMTRAFFIC_BLU.conf_score4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_BLU.measure_tstamp4(i,:) = AMTRAFFIC_BLU.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.tmc_code4(i,:) = AMTRAFFIC_BLU.tmc_code4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.datetime4(i,:) = AMTRAFFIC_BLU.datetime4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.datevec4(i,:) = AMTRAFFIC_BLU.datevec4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.station4(i,:) = AMTRAFFIC_BLU.station4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.airtemperature4(i,:) = sum(str2double(AMTRAFFIC_BLU.airtemperature4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_BLU.hourpreciPHLation4(i,:) = sum(str2double(AMTRAFFIC_BLU.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_BLU.visibility4(i,:) = sum(str2double(AMTRAFFIC_BLU.visibility4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_BLU.skycoverage14(i,:) = AMTRAFFIC_BLU.skycoverage14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.skycoverage24(i,:) = AMTRAFFIC_BLU.skycoverage24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.skycoverage34(i,:) = AMTRAFFIC_BLU.skycoverage34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.skycoverage44(i,:) = AMTRAFFIC_BLU.skycoverage44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.skylevel14(i,:) = AMTRAFFIC_BLU.skylevel14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.skylevel24(i,:) = AMTRAFFIC_BLU.skylevel24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.skylevel34(i,:) = AMTRAFFIC_BLU.skylevel34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.skylevel44(i,:) = AMTRAFFIC_BLU.skylevel44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.weathercode4(i,:) = AMTRAFFIC_BLU.weathercode4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.road4(i,:) = AMTRAFFIC_BLU.road4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.direction4(i,:) = AMTRAFFIC_BLU.direction4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLU.miles4(i,:) = sum(str2double(AMTRAFFIC_BLU.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 330.710435 seconds.

%% 12/30/2018 take average for two directions  (DON'T RUN GREEN)
tic
statmeasure_tstamp3 = tabulate(TRAFFIC_GRE.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(TRAFFIC_GRE.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    TRAFFICAVE_GRE.speed3(i,:) = sum(TRAFFIC_GRE.speed3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_GRE.travel_time3(i,:) = sum(TRAFFIC_GRE.travel_time3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_GRE.conf_score3(i,:) = sum(TRAFFIC_GRE.conf_score3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_GRE.measure_tstamp3(i,:) = TRAFFIC_GRE.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.tmc_code3(i,:) = TRAFFIC_GRE.tmc_code3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.datetime3(i,:) = TRAFFIC_GRE.datetime3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.datevec3(i,:) = TRAFFIC_GRE.datevec3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.station3(i,:) = TRAFFIC_GRE.station3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.airtemperature3(i,:) = sum(str2double(TRAFFIC_GRE.airtemperature3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_GRE.hourpreciPHLation3(i,:) = sum(str2double(TRAFFIC_GRE.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_GRE.visibility3(i,:) = sum(str2double(TRAFFIC_GRE.visibility3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_GRE.skycoverage13(i,:) = TRAFFIC_GRE.skycoverage13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.skycoverage23(i,:) = TRAFFIC_GRE.skycoverage23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.skycoverage33(i,:) = TRAFFIC_GRE.skycoverage33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.skycoverage43(i,:) = TRAFFIC_GRE.skycoverage43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.skylevel13(i,:) = TRAFFIC_GRE.skylevel13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.skylevel23(i,:) = TRAFFIC_GRE.skylevel23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.skylevel33(i,:) = TRAFFIC_GRE.skylevel33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.skylevel43(i,:) = TRAFFIC_GRE.skylevel43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.weathercode3(i,:) = TRAFFIC_GRE.weathercode3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.road3(i,:) = TRAFFIC_GRE.road3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.direction3(i,:) = TRAFFIC_GRE.direction3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_GRE.miles3(i,:) = sum(str2double(TRAFFIC_GRE.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 330.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(TRAFFIC_GRE.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(TRAFFIC_GRE.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    TRAFFICAVE_GRE.speed4(i,:) = sum(TRAFFIC_GRE.speed4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_GRE.travel_time4(i,:) = sum(TRAFFIC_GRE.travel_time4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_GRE.conf_score4(i,:) = sum(TRAFFIC_GRE.conf_score4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_GRE.measure_tstamp4(i,:) = TRAFFIC_GRE.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.tmc_code4(i,:) = TRAFFIC_GRE.tmc_code4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.datetime4(i,:) = TRAFFIC_GRE.datetime4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.datevec4(i,:) = TRAFFIC_GRE.datevec4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.station4(i,:) = TRAFFIC_GRE.station4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.airtemperature4(i,:) = sum(str2double(TRAFFIC_GRE.airtemperature4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_GRE.hourpreciPHLation4(i,:) = sum(str2double(TRAFFIC_GRE.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_GRE.visibility4(i,:) = sum(str2double(TRAFFIC_GRE.visibility4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_GRE.skycoverage14(i,:) = TRAFFIC_GRE.skycoverage14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.skycoverage24(i,:) = TRAFFIC_GRE.skycoverage24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.skycoverage34(i,:) = TRAFFIC_GRE.skycoverage34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.skycoverage44(i,:) = TRAFFIC_GRE.skycoverage44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.skylevel14(i,:) = TRAFFIC_GRE.skylevel14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.skylevel24(i,:) = TRAFFIC_GRE.skylevel24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.skylevel34(i,:) = TRAFFIC_GRE.skylevel34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.skylevel44(i,:) = TRAFFIC_GRE.skylevel44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.weathercode4(i,:) = TRAFFIC_GRE.weathercode4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.road4(i,:) = TRAFFIC_GRE.road4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.direction4(i,:) = TRAFFIC_GRE.direction4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_GRE.miles4(i,:) = sum(str2double(TRAFFIC_GRE.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 330.710435 seconds.

tic
statmeasure_tstamp3 = tabulate(AMTRAFFIC_GRE.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(AMTRAFFIC_GRE.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    AMTRAFFICAVE_GRE.speed3(i,:) = sum(AMTRAFFIC_GRE.speed3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_GRE.travel_time3(i,:) = sum(AMTRAFFIC_GRE.travel_time3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_GRE.conf_score3(i,:) = sum(AMTRAFFIC_GRE.conf_score3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_GRE.measure_tstamp3(i,:) = AMTRAFFIC_GRE.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.tmc_code3(i,:) = AMTRAFFIC_GRE.tmc_code3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.datetime3(i,:) = AMTRAFFIC_GRE.datetime3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.datevec3(i,:) = AMTRAFFIC_GRE.datevec3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.station3(i,:) = AMTRAFFIC_GRE.station3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.airtemperature3(i,:) = sum(str2double(AMTRAFFIC_GRE.airtemperature3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_GRE.hourpreciPHLation3(i,:) = sum(str2double(AMTRAFFIC_GRE.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_GRE.visibility3(i,:) = sum(str2double(AMTRAFFIC_GRE.visibility3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_GRE.skycoverage13(i,:) = AMTRAFFIC_GRE.skycoverage13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.skycoverage23(i,:) = AMTRAFFIC_GRE.skycoverage23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.skycoverage33(i,:) = AMTRAFFIC_GRE.skycoverage33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.skycoverage43(i,:) = AMTRAFFIC_GRE.skycoverage43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.skylevel13(i,:) = AMTRAFFIC_GRE.skylevel13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.skylevel23(i,:) = AMTRAFFIC_GRE.skylevel23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.skylevel33(i,:) = AMTRAFFIC_GRE.skylevel33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.skylevel43(i,:) = AMTRAFFIC_GRE.skylevel43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.weathercode3(i,:) = AMTRAFFIC_GRE.weathercode3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.road3(i,:) = AMTRAFFIC_GRE.road3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.direction3(i,:) = AMTRAFFIC_GRE.direction3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_GRE.miles3(i,:) = sum(str2double(AMTRAFFIC_GRE.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 330.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(AMTRAFFIC_GRE.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(AMTRAFFIC_GRE.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    AMTRAFFICAVE_GRE.speed4(i,:) = sum(AMTRAFFIC_GRE.speed4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_GRE.travel_time4(i,:) = sum(AMTRAFFIC_GRE.travel_time4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_GRE.conf_score4(i,:) = sum(AMTRAFFIC_GRE.conf_score4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_GRE.measure_tstamp4(i,:) = AMTRAFFIC_GRE.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.tmc_code4(i,:) = AMTRAFFIC_GRE.tmc_code4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.datetime4(i,:) = AMTRAFFIC_GRE.datetime4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.datevec4(i,:) = AMTRAFFIC_GRE.datevec4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.station4(i,:) = AMTRAFFIC_GRE.station4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.airtemperature4(i,:) = sum(str2double(AMTRAFFIC_GRE.airtemperature4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_GRE.hourpreciPHLation4(i,:) = sum(str2double(AMTRAFFIC_GRE.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_GRE.visibility4(i,:) = sum(str2double(AMTRAFFIC_GRE.visibility4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_GRE.skycoverage14(i,:) = AMTRAFFIC_GRE.skycoverage14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.skycoverage24(i,:) = AMTRAFFIC_GRE.skycoverage24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.skycoverage34(i,:) = AMTRAFFIC_GRE.skycoverage34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.skycoverage44(i,:) = AMTRAFFIC_GRE.skycoverage44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.skylevel14(i,:) = AMTRAFFIC_GRE.skylevel14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.skylevel24(i,:) = AMTRAFFIC_GRE.skylevel24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.skylevel34(i,:) = AMTRAFFIC_GRE.skylevel34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.skylevel44(i,:) = AMTRAFFIC_GRE.skylevel44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.weathercode4(i,:) = AMTRAFFIC_GRE.weathercode4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.road4(i,:) = AMTRAFFIC_GRE.road4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.direction4(i,:) = AMTRAFFIC_GRE.direction4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_GRE.miles4(i,:) = sum(str2double(AMTRAFFIC_GRE.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 330.710435 seconds.

%% 12/30/2018 take average for two directions  (PURPLE)
tic
statmeasure_tstamp3 = tabulate(TRAFFIC_PUR.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(TRAFFIC_PUR.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    TRAFFICAVE_PUR.speed3(i,:) = sum(TRAFFIC_PUR.speed3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_PUR.travel_time3(i,:) = sum(TRAFFIC_PUR.travel_time3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_PUR.conf_score3(i,:) = sum(TRAFFIC_PUR.conf_score3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_PUR.measure_tstamp3(i,:) = TRAFFIC_PUR.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.tmc_code3(i,:) = TRAFFIC_PUR.tmc_code3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.datetime3(i,:) = TRAFFIC_PUR.datetime3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.datevec3(i,:) = TRAFFIC_PUR.datevec3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.station3(i,:) = TRAFFIC_PUR.station3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.airtemperature3(i,:) = sum(str2double(TRAFFIC_PUR.airtemperature3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_PUR.hourpreciPHLation3(i,:) = sum(str2double(TRAFFIC_PUR.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_PUR.visibility3(i,:) = sum(str2double(TRAFFIC_PUR.visibility3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_PUR.skycoverage13(i,:) = TRAFFIC_PUR.skycoverage13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.skycoverage23(i,:) = TRAFFIC_PUR.skycoverage23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.skycoverage33(i,:) = TRAFFIC_PUR.skycoverage33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.skycoverage43(i,:) = TRAFFIC_PUR.skycoverage43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.skylevel13(i,:) = TRAFFIC_PUR.skylevel13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.skylevel23(i,:) = TRAFFIC_PUR.skylevel23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.skylevel33(i,:) = TRAFFIC_PUR.skylevel33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.skylevel43(i,:) = TRAFFIC_PUR.skylevel43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.weathercode3(i,:) = TRAFFIC_PUR.weathercode3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.road3(i,:) = TRAFFIC_PUR.road3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.direction3(i,:) = TRAFFIC_PUR.direction3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_PUR.miles3(i,:) = sum(str2double(TRAFFIC_PUR.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 250.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(TRAFFIC_PUR.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(TRAFFIC_PUR.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    TRAFFICAVE_PUR.speed4(i,:) = sum(TRAFFIC_PUR.speed4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_PUR.travel_time4(i,:) = sum(TRAFFIC_PUR.travel_time4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_PUR.conf_score4(i,:) = sum(TRAFFIC_PUR.conf_score4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_PUR.measure_tstamp4(i,:) = TRAFFIC_PUR.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.tmc_code4(i,:) = TRAFFIC_PUR.tmc_code4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.datetime4(i,:) = TRAFFIC_PUR.datetime4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.datevec4(i,:) = TRAFFIC_PUR.datevec4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.station4(i,:) = TRAFFIC_PUR.station4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.airtemperature4(i,:) = sum(str2double(TRAFFIC_PUR.airtemperature4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_PUR.hourpreciPHLation4(i,:) = sum(str2double(TRAFFIC_PUR.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_PUR.visibility4(i,:) = sum(str2double(TRAFFIC_PUR.visibility4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_PUR.skycoverage14(i,:) = TRAFFIC_PUR.skycoverage14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.skycoverage24(i,:) = TRAFFIC_PUR.skycoverage24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.skycoverage34(i,:) = TRAFFIC_PUR.skycoverage34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.skycoverage44(i,:) = TRAFFIC_PUR.skycoverage44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.skylevel14(i,:) = TRAFFIC_PUR.skylevel14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.skylevel24(i,:) = TRAFFIC_PUR.skylevel24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.skylevel34(i,:) = TRAFFIC_PUR.skylevel34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.skylevel44(i,:) = TRAFFIC_PUR.skylevel44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.weathercode4(i,:) = TRAFFIC_PUR.weathercode4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.road4(i,:) = TRAFFIC_PUR.road4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.direction4(i,:) = TRAFFIC_PUR.direction4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_PUR.miles4(i,:) = sum(str2double(TRAFFIC_PUR.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 250.710435 seconds.

tic
statmeasure_tstamp3 = tabulate(AMTRAFFIC_PUR.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(AMTRAFFIC_PUR.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    AMTRAFFICAVE_PUR.speed3(i,:) = sum(AMTRAFFIC_PUR.speed3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_PUR.travel_time3(i,:) = sum(AMTRAFFIC_PUR.travel_time3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_PUR.conf_score3(i,:) = sum(AMTRAFFIC_PUR.conf_score3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_PUR.measure_tstamp3(i,:) = AMTRAFFIC_PUR.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.tmc_code3(i,:) = AMTRAFFIC_PUR.tmc_code3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.datetime3(i,:) = AMTRAFFIC_PUR.datetime3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.datevec3(i,:) = AMTRAFFIC_PUR.datevec3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.station3(i,:) = AMTRAFFIC_PUR.station3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.airtemperature3(i,:) = sum(str2double(AMTRAFFIC_PUR.airtemperature3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_PUR.hourpreciPHLation3(i,:) = sum(str2double(AMTRAFFIC_PUR.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_PUR.visibility3(i,:) = sum(str2double(AMTRAFFIC_PUR.visibility3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_PUR.skycoverage13(i,:) = AMTRAFFIC_PUR.skycoverage13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.skycoverage23(i,:) = AMTRAFFIC_PUR.skycoverage23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.skycoverage33(i,:) = AMTRAFFIC_PUR.skycoverage33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.skycoverage43(i,:) = AMTRAFFIC_PUR.skycoverage43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.skylevel13(i,:) = AMTRAFFIC_PUR.skylevel13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.skylevel23(i,:) = AMTRAFFIC_PUR.skylevel23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.skylevel33(i,:) = AMTRAFFIC_PUR.skylevel33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.skylevel43(i,:) = AMTRAFFIC_PUR.skylevel43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.weathercode3(i,:) = AMTRAFFIC_PUR.weathercode3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.road3(i,:) = AMTRAFFIC_PUR.road3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.direction3(i,:) = AMTRAFFIC_PUR.direction3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_PUR.miles3(i,:) = sum(str2double(AMTRAFFIC_PUR.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 250.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(AMTRAFFIC_PUR.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(AMTRAFFIC_PUR.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    AMTRAFFICAVE_PUR.speed4(i,:) = sum(AMTRAFFIC_PUR.speed4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_PUR.travel_time4(i,:) = sum(AMTRAFFIC_PUR.travel_time4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_PUR.conf_score4(i,:) = sum(AMTRAFFIC_PUR.conf_score4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_PUR.measure_tstamp4(i,:) = AMTRAFFIC_PUR.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.tmc_code4(i,:) = AMTRAFFIC_PUR.tmc_code4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.datetime4(i,:) = AMTRAFFIC_PUR.datetime4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.datevec4(i,:) = AMTRAFFIC_PUR.datevec4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.station4(i,:) = AMTRAFFIC_PUR.station4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.airtemperature4(i,:) = sum(str2double(AMTRAFFIC_PUR.airtemperature4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_PUR.hourpreciPHLation4(i,:) = sum(str2double(AMTRAFFIC_PUR.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_PUR.visibility4(i,:) = sum(str2double(AMTRAFFIC_PUR.visibility4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_PUR.skycoverage14(i,:) = AMTRAFFIC_PUR.skycoverage14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.skycoverage24(i,:) = AMTRAFFIC_PUR.skycoverage24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.skycoverage34(i,:) = AMTRAFFIC_PUR.skycoverage34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.skycoverage44(i,:) = AMTRAFFIC_PUR.skycoverage44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.skylevel14(i,:) = AMTRAFFIC_PUR.skylevel14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.skylevel24(i,:) = AMTRAFFIC_PUR.skylevel24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.skylevel34(i,:) = AMTRAFFIC_PUR.skylevel34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.skylevel44(i,:) = AMTRAFFIC_PUR.skylevel44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.weathercode4(i,:) = AMTRAFFIC_PUR.weathercode4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.road4(i,:) = AMTRAFFIC_PUR.road4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.direction4(i,:) = AMTRAFFIC_PUR.direction4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_PUR.miles4(i,:) = sum(str2double(AMTRAFFIC_PUR.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 250.710435 seconds.

%% 12/30/2018 take average for two directions  (DONT RUN YELLOW)
tic
statmeasure_tstamp3 = tabulate(TRAFFIC_YEL.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(TRAFFIC_YEL.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    TRAFFICAVE_YEL.speed3(i,:) = sum(TRAFFIC_YEL.speed3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_YEL.travel_time3(i,:) = sum(TRAFFIC_YEL.travel_time3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_YEL.conf_score3(i,:) = sum(TRAFFIC_YEL.conf_score3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_YEL.measure_tstamp3(i,:) = TRAFFIC_YEL.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.tmc_code3(i,:) = TRAFFIC_YEL.tmc_code3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.datetime3(i,:) = TRAFFIC_YEL.datetime3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.datevec3(i,:) = TRAFFIC_YEL.datevec3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.station3(i,:) = TRAFFIC_YEL.station3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.airtemperature3(i,:) = sum(str2double(TRAFFIC_YEL.airtemperature3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_YEL.hourpreciPHLation3(i,:) = sum(str2double(TRAFFIC_YEL.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_YEL.visibility3(i,:) = sum(str2double(TRAFFIC_YEL.visibility3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_YEL.skycoverage13(i,:) = TRAFFIC_YEL.skycoverage13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.skycoverage23(i,:) = TRAFFIC_YEL.skycoverage23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.skycoverage33(i,:) = TRAFFIC_YEL.skycoverage33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.skycoverage43(i,:) = TRAFFIC_YEL.skycoverage43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.skylevel13(i,:) = TRAFFIC_YEL.skylevel13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.skylevel23(i,:) = TRAFFIC_YEL.skylevel23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.skylevel33(i,:) = TRAFFIC_YEL.skylevel33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.skylevel43(i,:) = TRAFFIC_YEL.skylevel43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.weathercode3(i,:) = TRAFFIC_YEL.weathercode3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.road3(i,:) = TRAFFIC_YEL.road3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.direction3(i,:) = TRAFFIC_YEL.direction3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_YEL.miles3(i,:) = sum(str2double(TRAFFIC_YEL.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 2500.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(TRAFFIC_YEL.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(TRAFFIC_YEL.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    TRAFFICAVE_YEL.speed4(i,:) = sum(TRAFFIC_YEL.speed4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_YEL.travel_time4(i,:) = sum(TRAFFIC_YEL.travel_time4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_YEL.conf_score4(i,:) = sum(TRAFFIC_YEL.conf_score4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_YEL.measure_tstamp4(i,:) = TRAFFIC_YEL.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.tmc_code4(i,:) = TRAFFIC_YEL.tmc_code4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.datetime4(i,:) = TRAFFIC_YEL.datetime4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.datevec4(i,:) = TRAFFIC_YEL.datevec4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.station4(i,:) = TRAFFIC_YEL.station4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.airtemperature4(i,:) = sum(str2double(TRAFFIC_YEL.airtemperature4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_YEL.hourpreciPHLation4(i,:) = sum(str2double(TRAFFIC_YEL.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_YEL.visibility4(i,:) = sum(str2double(TRAFFIC_YEL.visibility4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_YEL.skycoverage14(i,:) = TRAFFIC_YEL.skycoverage14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.skycoverage24(i,:) = TRAFFIC_YEL.skycoverage24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.skycoverage34(i,:) = TRAFFIC_YEL.skycoverage34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.skycoverage44(i,:) = TRAFFIC_YEL.skycoverage44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.skylevel14(i,:) = TRAFFIC_YEL.skylevel14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.skylevel24(i,:) = TRAFFIC_YEL.skylevel24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.skylevel34(i,:) = TRAFFIC_YEL.skylevel34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.skylevel44(i,:) = TRAFFIC_YEL.skylevel44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.weathercode4(i,:) = TRAFFIC_YEL.weathercode4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.road4(i,:) = TRAFFIC_YEL.road4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.direction4(i,:) = TRAFFIC_YEL.direction4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_YEL.miles4(i,:) = sum(str2double(TRAFFIC_YEL.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 2000.710435 seconds.

tic
statmeasure_tstamp3 = tabulate(AMTRAFFIC_YEL.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(AMTRAFFIC_YEL.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    AMTRAFFICAVE_YEL.speed3(i,:) = sum(AMTRAFFIC_YEL.speed3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_YEL.travel_time3(i,:) = sum(AMTRAFFIC_YEL.travel_time3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_YEL.conf_score3(i,:) = sum(AMTRAFFIC_YEL.conf_score3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_YEL.measure_tstamp3(i,:) = AMTRAFFIC_YEL.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.tmc_code3(i,:) = AMTRAFFIC_YEL.tmc_code3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.datetime3(i,:) = AMTRAFFIC_YEL.datetime3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.datevec3(i,:) = AMTRAFFIC_YEL.datevec3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.station3(i,:) = AMTRAFFIC_YEL.station3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.airtemperature3(i,:) = sum(str2double(AMTRAFFIC_YEL.airtemperature3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_YEL.hourpreciPHLation3(i,:) = sum(str2double(AMTRAFFIC_YEL.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_YEL.visibility3(i,:) = sum(str2double(AMTRAFFIC_YEL.visibility3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_YEL.skycoverage13(i,:) = AMTRAFFIC_YEL.skycoverage13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.skycoverage23(i,:) = AMTRAFFIC_YEL.skycoverage23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.skycoverage33(i,:) = AMTRAFFIC_YEL.skycoverage33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.skycoverage43(i,:) = AMTRAFFIC_YEL.skycoverage43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.skylevel13(i,:) = AMTRAFFIC_YEL.skylevel13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.skylevel23(i,:) = AMTRAFFIC_YEL.skylevel23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.skylevel33(i,:) = AMTRAFFIC_YEL.skylevel33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.skylevel43(i,:) = AMTRAFFIC_YEL.skylevel43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.weathercode3(i,:) = AMTRAFFIC_YEL.weathercode3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.road3(i,:) = AMTRAFFIC_YEL.road3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.direction3(i,:) = AMTRAFFIC_YEL.direction3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_YEL.miles3(i,:) = sum(str2double(AMTRAFFIC_YEL.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 2000.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(AMTRAFFIC_YEL.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(AMTRAFFIC_YEL.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    AMTRAFFICAVE_YEL.speed4(i,:) = sum(AMTRAFFIC_YEL.speed4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_YEL.travel_time4(i,:) = sum(AMTRAFFIC_YEL.travel_time4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_YEL.conf_score4(i,:) = sum(AMTRAFFIC_YEL.conf_score4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_YEL.measure_tstamp4(i,:) = AMTRAFFIC_YEL.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.tmc_code4(i,:) = AMTRAFFIC_YEL.tmc_code4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.datetime4(i,:) = AMTRAFFIC_YEL.datetime4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.datevec4(i,:) = AMTRAFFIC_YEL.datevec4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.station4(i,:) = AMTRAFFIC_YEL.station4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.airtemperature4(i,:) = sum(str2double(AMTRAFFIC_YEL.airtemperature4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_YEL.hourpreciPHLation4(i,:) = sum(str2double(AMTRAFFIC_YEL.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_YEL.visibility4(i,:) = sum(str2double(AMTRAFFIC_YEL.visibility4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_YEL.skycoverage14(i,:) = AMTRAFFIC_YEL.skycoverage14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.skycoverage24(i,:) = AMTRAFFIC_YEL.skycoverage24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.skycoverage34(i,:) = AMTRAFFIC_YEL.skycoverage34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.skycoverage44(i,:) = AMTRAFFIC_YEL.skycoverage44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.skylevel14(i,:) = AMTRAFFIC_YEL.skylevel14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.skylevel24(i,:) = AMTRAFFIC_YEL.skylevel24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.skylevel34(i,:) = AMTRAFFIC_YEL.skylevel34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.skylevel44(i,:) = AMTRAFFIC_YEL.skylevel44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.weathercode4(i,:) = AMTRAFFIC_YEL.weathercode4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.road4(i,:) = AMTRAFFIC_YEL.road4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.direction4(i,:) = AMTRAFFIC_YEL.direction4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_YEL.miles4(i,:) = sum(str2double(AMTRAFFIC_YEL.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 2000.710435 seconds.

%% 12/30/2018 take average for two directions  (DONT RUN BLACK)
tic
statmeasure_tstamp3 = tabulate(TRAFFIC_YEL.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(TRAFFIC_BLA.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    TRAFFICAVE_BLA.speed3(i,:) = sum(TRAFFIC_BLA.speed3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_BLC.travel_time3(i,:) = sum(TRAFFIC_BLA.travel_time3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_BLA.conf_score3(i,:) = sum(TRAFFIC_BLA.conf_score3(indexmeasure_tstamp3,:))/n;
    TRAFFICAVE_BLA.measure_tstamp3(i,:) = TRAFFIC_BLA.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.tmc_code3(i,:) = TRAFFIC_BLA.tmc_code3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.datetime3(i,:) = TRAFFIC_BLA.datetime3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.datevec3(i,:) = TRAFFIC_BLA.datevec3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.station3(i,:) = TRAFFIC_BLA.station3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.airtemperature3(i,:) = sum(str2double(TRAFFIC_BLA.airtemperature3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_BLA.hourpreciPHLation3(i,:) = sum(str2double(TRAFFIC_BLA.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_BLA.visibility3(i,:) = sum(str2double(TRAFFIC_BLA.visibility3(indexmeasure_tstamp3,:)))/n;
    TRAFFICAVE_BLA.skycoverage13(i,:) = TRAFFIC_BLA.skycoverage13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.skycoverage23(i,:) = TRAFFIC_BLA.skycoverage23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.skycoverage33(i,:) = TRAFFIC_BLA.skycoverage33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.skycoverage43(i,:) = TRAFFIC_BLA.skycoverage43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.skylevel13(i,:) = TRAFFIC_BLA.skylevel13(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.skylevel23(i,:) = TRAFFIC_BLA.skylevel23(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.skylevel33(i,:) = TRAFFIC_BLA.skylevel33(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.skylevel43(i,:) = TRAFFIC_BLA.skylevel43(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.weathercode3(i,:) = TRAFFIC_BLA.weathercode3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.road3(i,:) = TRAFFIC_BLA.road3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.direction3(i,:) = TRAFFIC_BLA.direction3(indexmeasure_tstamp3(1,:),:);
    TRAFFICAVE_BLA.miles3(i,:) = sum(str2double(TRAFFIC_BLA.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 2500.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(TRAFFIC_BLA.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(TRAFFIC_BLA.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    TRAFFICAVE_BLA.speed4(i,:) = sum(TRAFFIC_BLA.speed4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_BLA.travel_time4(i,:) = sum(TRAFFIC_BLA.travel_time4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_BLA.conf_score4(i,:) = sum(TRAFFIC_BLA.conf_score4(indexmeasure_tstamp4,:))/n;
    TRAFFICAVE_BLA.measure_tstamp4(i,:) = TRAFFIC_BLA.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.tmc_code4(i,:) = TRAFFIC_BLA.tmc_code4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.datetime4(i,:) = TRAFFIC_BLA.datetime4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.datevec4(i,:) = TRAFFIC_BLA.datevec4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.station4(i,:) = TRAFFIC_BLA.station4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.airtemperature4(i,:) = sum(str2double(TRAFFIC_BLA.airtemperature4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_BLA.hourpreciPHLation4(i,:) = sum(str2double(TRAFFIC_BLA.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_BLA.visibility4(i,:) = sum(str2double(TRAFFIC_BLA.visibility4(indexmeasure_tstamp4,:)))/n;
    TRAFFICAVE_BLA.skycoverage14(i,:) = TRAFFIC_BLA.skycoverage14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.skycoverage24(i,:) = TRAFFIC_BLA.skycoverage24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.skycoverage34(i,:) = TRAFFIC_BLA.skycoverage34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.skycoverage44(i,:) = TRAFFIC_BLA.skycoverage44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.skylevel14(i,:) = TRAFFIC_BLA.skylevel14(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.skylevel24(i,:) = TRAFFIC_BLA.skylevel24(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.skylevel34(i,:) = TRAFFIC_BLA.skylevel34(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.skylevel44(i,:) = TRAFFIC_BLA.skylevel44(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.weathercode4(i,:) = TRAFFIC_BLA.weathercode4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.road4(i,:) = TRAFFIC_BLA.road4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.direction4(i,:) = TRAFFIC_BLA.direction4(indexmeasure_tstamp4(1,:),:);
    TRAFFICAVE_BLA.miles4(i,:) = sum(str2double(TRAFFIC_BLA.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 2000.710435 seconds.

tic
statmeasure_tstamp3 = tabulate(AMTRAFFIC_BLA.measure_tstamp3);
for i = 1:numel(statmeasure_tstamp3(:,2))
    indexmeasure_tstamp3 = find(~cellfun(@isempty,strfind(AMTRAFFIC_BLA.measure_tstamp3,statmeasure_tstamp3{i,1})));
    n = numel(indexmeasure_tstamp3);
    AMTRAFFICAVE_BLA.speed3(i,:) = sum(AMTRAFFIC_BLA.speed3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_BLA.travel_time3(i,:) = sum(AMTRAFFIC_BLA.travel_time3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_BLA.conf_score3(i,:) = sum(AMTRAFFIC_BLA.conf_score3(indexmeasure_tstamp3,:))/n;
    AMTRAFFICAVE_BLA.measure_tstamp3(i,:) = AMTRAFFIC_BLA.measure_tstamp3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.tmc_code3(i,:) = AMTRAFFIC_BLA.tmc_code3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.datetime3(i,:) = AMTRAFFIC_BLA.datetime3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.datevec3(i,:) = AMTRAFFIC_BLA.datevec3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.station3(i,:) = AMTRAFFIC_BLA.station3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.airtemperature3(i,:) = sum(str2double(AMTRAFFIC_BLA.airtemperature3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_BLA.hourpreciPHLation3(i,:) = sum(str2double(AMTRAFFIC_BLA.hourpreciPHLation3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_BLA.visibility3(i,:) = sum(str2double(AMTRAFFIC_BLA.visibility3(indexmeasure_tstamp3,:)))/n;
    AMTRAFFICAVE_BLA.skycoverage13(i,:) = AMTRAFFIC_BLA.skycoverage13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.skycoverage23(i,:) = AMTRAFFIC_BLA.skycoverage23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.skycoverage33(i,:) = AMTRAFFIC_BLA.skycoverage33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.skycoverage43(i,:) = AMTRAFFIC_BLA.skycoverage43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.skylevel13(i,:) = AMTRAFFIC_BLA.skylevel13(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.skylevel23(i,:) = AMTRAFFIC_BLA.skylevel23(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.skylevel33(i,:) = AMTRAFFIC_BLA.skylevel33(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.skylevel43(i,:) = AMTRAFFIC_BLA.skylevel43(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.weathercode3(i,:) = AMTRAFFIC_BLA.weathercode3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.road3(i,:) = AMTRAFFIC_BLA.road3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.direction3(i,:) = AMTRAFFIC_BLA.direction3(indexmeasure_tstamp3(1,:),:);
    AMTRAFFICAVE_BLA.miles3(i,:) = sum(str2double(AMTRAFFIC_BLA.miles3(indexmeasure_tstamp3,:)))/n;
end
toc
%Elapsed time is 2000.302037 seconds.

tic
statmeasure_tstamp4 = tabulate(AMTRAFFIC_BLA.measure_tstamp4);
for i = 1:numel(statmeasure_tstamp4(:,2))
    indexmeasure_tstamp4 = find(~cellfun(@isempty,strfind(AMTRAFFIC_BLA.measure_tstamp4,statmeasure_tstamp4{i,1})));
    n = numel(indexmeasure_tstamp4);
    AMTRAFFICAVE_BLA.speed4(i,:) = sum(AMTRAFFIC_BLA.speed4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_BLA.travel_time4(i,:) = sum(AMTRAFFIC_BLA.travel_time4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_BLA.conf_score4(i,:) = sum(AMTRAFFIC_BLA.conf_score4(indexmeasure_tstamp4,:))/n;
    AMTRAFFICAVE_BLA.measure_tstamp4(i,:) = AMTRAFFIC_BLA.measure_tstamp4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.tmc_code4(i,:) = AMTRAFFIC_BLA.tmc_code4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.datetime4(i,:) = AMTRAFFIC_BLA.datetime4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.datevec4(i,:) = AMTRAFFIC_BLA.datevec4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.station4(i,:) = AMTRAFFIC_BLA.station4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.airtemperature4(i,:) = sum(str2double(AMTRAFFIC_BLA.airtemperature4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_BLA.hourpreciPHLation4(i,:) = sum(str2double(AMTRAFFIC_BLA.hourpreciPHLation4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_BLA.visibility4(i,:) = sum(str2double(AMTRAFFIC_BLA.visibility4(indexmeasure_tstamp4,:)))/n;
    AMTRAFFICAVE_BLA.skycoverage14(i,:) = AMTRAFFIC_BLA.skycoverage14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.skycoverage24(i,:) = AMTRAFFIC_BLA.skycoverage24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.skycoverage34(i,:) = AMTRAFFIC_BLA.skycoverage34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.skycoverage44(i,:) = AMTRAFFIC_BLA.skycoverage44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.skylevel14(i,:) = AMTRAFFIC_BLA.skylevel14(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.skylevel24(i,:) = AMTRAFFIC_BLA.skylevel24(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.skylevel34(i,:) = AMTRAFFIC_BLA.skylevel34(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.skylevel44(i,:) = AMTRAFFIC_BLA.skylevel44(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.weathercode4(i,:) = AMTRAFFIC_BLA.weathercode4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.road4(i,:) = AMTRAFFIC_BLA.road4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.direction4(i,:) = AMTRAFFIC_BLA.direction4(indexmeasure_tstamp4(1,:),:);
    AMTRAFFICAVE_BLA.miles4(i,:) = sum(str2double(AMTRAFFIC_BLA.miles4(indexmeasure_tstamp4,:)))/n;
end
toc
%Elapsed time is 2000.710435 seconds.

%%
clear confscoreindex3 confscoreindex4 dateindex directionindex3 directionindex4
clear directionstat0 i indexmeasure_tstamp3 indexmeasure_tstamp4 n 
clear preciPHLationnonemptyindex0 statmeasure_tstamp3 statmeasure_tstamp4
clear tmcindex

%% 1/3/2019 TO AVOID THE DATA GROWS TO LARGE, SOME fieldnames will not be stored
% Some field names in STRUCT TRAFFICAVE_ORA, AMTRAFFICAVE_ORA, etc will be
% deleted. Specifically:
% skycoverage (all), skylevel (all), weathercode
% So, STRUCT after  TRAFFICAVE_ORA, AMTRAFFICAVE_ORA will only have 
% 14 * 2 = 28 fieldnames (for two directions), respectively.
tic
% ORANGE
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skycoverage13');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skycoverage23');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skycoverage33');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skycoverage43');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skylevel13');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skylevel23');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skylevel33');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skylevel43');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'weathercode3');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skycoverage14');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skycoverage24');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skycoverage34');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skycoverage44');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skylevel14');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skylevel24');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skylevel34');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'skylevel44');
TRAFFICAVE_ORA = rmfield(TRAFFICAVE_ORA,'weathercode4');

AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skycoverage13');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skycoverage23');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skycoverage33');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skycoverage43');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skylevel13');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skylevel23');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skylevel33');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skylevel43');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'weathercode3');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skycoverage14');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skycoverage24');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skycoverage34');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skycoverage44');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skylevel14');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skylevel24');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skylevel34');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'skylevel44');
AMTRAFFICAVE_ORA = rmfield(AMTRAFFICAVE_ORA,'weathercode4');

% RED
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skycoverage13');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skycoverage23');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skycoverage33');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skycoverage43');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skylevel13');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skylevel23');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skylevel33');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skylevel43');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'weathercode3');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skycoverage14');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skycoverage24');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skycoverage34');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skycoverage44');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skylevel14');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skylevel24');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skylevel34');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'skylevel44');
TRAFFICAVE_RED = rmfield(TRAFFICAVE_RED,'weathercode4');

AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skycoverage13');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skycoverage23');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skycoverage33');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skycoverage43');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skylevel13');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skylevel23');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skylevel33');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skylevel43');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'weathercode3');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skycoverage14');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skycoverage24');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skycoverage34');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skycoverage44');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skylevel14');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skylevel24');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skylevel34');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'skylevel44');
AMTRAFFICAVE_RED = rmfield(AMTRAFFICAVE_RED,'weathercode4');

% BLUE
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skycoverage13');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skycoverage23');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skycoverage33');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skycoverage43');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skylevel13');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skylevel23');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skylevel33');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skylevel43');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'weathercode3');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skycoverage14');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skycoverage24');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skycoverage34');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skycoverage44');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skylevel14');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skylevel24');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skylevel34');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'skylevel44');
TRAFFICAVE_BLU = rmfield(TRAFFICAVE_BLU,'weathercode4');

AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skycoverage13');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skycoverage23');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skycoverage33');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skycoverage43');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skylevel13');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skylevel23');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skylevel33');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skylevel43');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'weathercode3');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skycoverage14');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skycoverage24');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skycoverage34');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skycoverage44');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skylevel14');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skylevel24');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skylevel34');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'skylevel44');
AMTRAFFICAVE_BLU = rmfield(AMTRAFFICAVE_BLU,'weathercode4');

% GREEN
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skycoverage13');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skycoverage23');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skycoverage33');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skycoverage43');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skylevel13');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skylevel23');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skylevel33');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skylevel43');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'weathercode3');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skycoverage14');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skycoverage24');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skycoverage34');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skycoverage44');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skylevel14');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skylevel24');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skylevel34');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'skylevel44');
% TRAFFICAVE_GRE = rmfield(TRAFFICAVE_GRE,'weathercode4');
% 
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skycoverage13');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skycoverage23');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skycoverage33');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skycoverage43');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skylevel13');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skylevel23');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skylevel33');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skylevel43');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'weathercode3');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skycoverage14');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skycoverage24');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skycoverage34');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skycoverage44');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skylevel14');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skylevel24');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skylevel34');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'skylevel44');
% AMTRAFFICAVE_GRE = rmfield(AMTRAFFICAVE_GRE,'weathercode4');

% PURPLE
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skycoverage13');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skycoverage23');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skycoverage33');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skycoverage43');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skylevel13');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skylevel23');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skylevel33');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skylevel43');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'weathercode3');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skycoverage14');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skycoverage24');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skycoverage34');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skycoverage44');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skylevel14');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skylevel24');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skylevel34');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'skylevel44');
TRAFFICAVE_PUR = rmfield(TRAFFICAVE_PUR,'weathercode4');

AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skycoverage13');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skycoverage23');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skycoverage33');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skycoverage43');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skylevel13');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skylevel23');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skylevel33');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skylevel43');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'weathercode3');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skycoverage14');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skycoverage24');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skycoverage34');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skycoverage44');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skylevel14');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skylevel24');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skylevel34');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'skylevel44');
AMTRAFFICAVE_PUR = rmfield(AMTRAFFICAVE_PUR,'weathercode4');

% YELLOW
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skycoverage13');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skycoverage23');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skycoverage33');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skycoverage43');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skylevel13');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skylevel23');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skylevel33');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skylevel43');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'weathercode3');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skycoverage14');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skycoverage24');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skycoverage34');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skycoverage44');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skylevel14');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skylevel24');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skylevel34');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'skylevel44');
% TRAFFICAVE_YEL = rmfield(TRAFFICAVE_YEL,'weathercode4');
% 
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skycoverage13');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skycoverage23');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skycoverage33');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skycoverage43');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skylevel13');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skylevel23');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skylevel33');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skylevel43');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'weathercode3');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skycoverage14');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skycoverage24');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skycoverage34');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skycoverage44');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skylevel14');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skylevel24');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skylevel34');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'skylevel44');
% AMTRAFFICAVE_YEL = rmfield(AMTRAFFICAVE_YEL,'weathercode4');
% 
% % BLACK
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skycoverage13');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skycoverage23');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skycoverage33');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skycoverage43');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skylevel13');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skylevel23');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skylevel33');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skylevel43');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'weathercode3');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skycoverage14');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skycoverage24');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skycoverage34');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skycoverage44');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skylevel14');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skylevel24');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skylevel34');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'skylevel44');
% TRAFFICAVE_BLA = rmfield(TRAFFICAVE_BLA,'weathercode4');
% 
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skycoverage13');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skycoverage23');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skycoverage33');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skycoverage43');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skylevel13');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skylevel23');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skylevel33');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skylevel43');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'weathercode3');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skycoverage14');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skycoverage24');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skycoverage34');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skycoverage44');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skylevel14');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skylevel24');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skylevel34');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'skylevel44');
% AMTRAFFICAVE_BLA = rmfield(AMTRAFFICAVE_BLA,'weathercode4');
toc
% Elapsed time is 1.142795 seconds.

%% STAT INFO FOR EACH CORRIDOR (ORANGE) 
speedlimit3_ora = 65;
STAT_ORA.maxspeed3 = max(TRAFFIC_ORA.speed3);
STAT_ORA.averagespeed3 = mean(TRAFFIC_ORA.speed3);
STAT_ORA.minspeed3 = min(TRAFFIC_ORA.speed3);
STAT_ORA.stdspeed3 = std(TRAFFIC_ORA.speed3);
STAT_ORA.samplesize3 = numel(TRAFFIC_ORA.speed3);
STAT_ORA.ratio3 = STAT_ORA.averagespeed3/speedlimit3_ora;

speedlimit4_ora = 55;
STAT_ORA.maxspeed4 = max(TRAFFIC_ORA.speed4);
STAT_ORA.averagespeed4 = mean(TRAFFIC_ORA.speed4);
STAT_ORA.minspeed4 = min(TRAFFIC_ORA.speed4);
STAT_ORA.stdspeed4 = std(TRAFFIC_ORA.speed4);
STAT_ORA.samplesize4 = numel(TRAFFIC_ORA.speed4);
STAT_ORA.ratio4 = STAT_ORA.averagespeed4/speedlimit4_ora

%% STAT INFO FOR EACH CORRIDOR (RED) 
speedlimit3_red = 55;
STAT_RED.maxspeed3 = max(TRAFFIC_RED.speed3);
STAT_RED.averagespeed3 = mean(TRAFFIC_RED.speed3);
STAT_RED.minspeed3 = min(TRAFFIC_RED.speed3);
STAT_RED.stdspeed3 = std(TRAFFIC_RED.speed3);
STAT_RED.samplesize3 = numel(TRAFFIC_RED.speed3);
STAT_RED.ratio3 = STAT_RED.averagespeed3/speedlimit3_red;

speedlimit4_red = 50;
STAT_RED.maxspeed4 = max(TRAFFIC_RED.speed4);
STAT_RED.averagespeed4 = mean(TRAFFIC_RED.speed4);
STAT_RED.minspeed4 = min(TRAFFIC_RED.speed4);
STAT_RED.stdspeed4 = std(TRAFFIC_RED.speed4);
STAT_RED.samplesize4 = numel(TRAFFIC_RED.speed4);
STAT_RED.ratio4 = STAT_RED.averagespeed4/speedlimit4_red

%% STAT INFO FOR EACH CORRIDOR (BLUE) 
speedlimit3_blu = 55;
STAT_BLU.maxspeed3 = max(TRAFFIC_BLU.speed3);
STAT_BLU.averagespeed3 = mean(TRAFFIC_BLU.speed3);
STAT_BLU.minspeed3 = min(TRAFFIC_BLU.speed3);
STAT_BLU.stdspeed3 = std(TRAFFIC_BLU.speed3);
STAT_BLU.samplesize3 = numel(TRAFFIC_BLU.speed3);
STAT_BLU.ratio3 = STAT_BLU.averagespeed3/speedlimit3_blu;

speedlimit4_blu = 50;
STAT_BLU.maxspeed4 = max(TRAFFIC_BLU.speed4);
STAT_BLU.averagespeed4 = mean(TRAFFIC_BLU.speed4);
STAT_BLU.minspeed4 = min(TRAFFIC_BLU.speed4);
STAT_BLU.stdspeed4 = std(TRAFFIC_BLU.speed4);
STAT_BLU.samplesize4 = numel(TRAFFIC_BLU.speed4);
STAT_BLU.ratio4 = STAT_BLU.averagespeed4/speedlimit4_blu

%% STAT INFO FOR EACH CORRIDOR (GREEN DONT RUN THIS) 
speedlimit3_gre = 55;
STAT_GRE.maxspeed3 = max(TRAFFIC_GRE.speed3);
STAT_GRE.averagespeed3 = mean(TRAFFIC_GRE.speed3);
STAT_GRE.minspeed3 = min(TRAFFIC_GRE.speed3);
STAT_GRE.stdspeed3 = std(TRAFFIC_GRE.speed3);
STAT_GRE.samplesize3 = numel(TRAFFIC_GRE.speed3);
STAT_GRE.ratio3 = STAT_GRE.averagespeed3/speedlimit3_gre;

speedlimit4_gre = 45;
STAT_GRE.maxspeed4 = max(TRAFFIC_GRE.speed4);
STAT_GRE.averagespeed4 = mean(TRAFFIC_GRE.speed4);
STAT_GRE.minspeed4 = min(TRAFFIC_GRE.speed4);
STAT_GRE.stdspeed4 = std(TRAFFIC_GRE.speed4);
STAT_GRE.samplesize4 = numel(TRAFFIC_GRE.speed4);
STAT_GRE.ratio4 = STAT_GRE.averagespeed4/speedlimit4_gre

%% STAT INFO FOR EACH CORRIDOR (PURPLE) 
speedlimit3_pur = 55;
STAT_PUR.maxspeed3 = max(TRAFFIC_PUR.speed3);
STAT_PUR.averagespeed3 = mean(TRAFFIC_PUR.speed3);
STAT_PUR.minspeed3 = min(TRAFFIC_PUR.speed3);
STAT_PUR.stdspeed3 = std(TRAFFIC_PUR.speed3);
STAT_PUR.samplesize3 = numel(TRAFFIC_PUR.speed3);
STAT_PUR.ratio3 = STAT_PUR.averagespeed3/speedlimit3_pur;

speedlimit4_pur = 65;
STAT_PUR.maxspeed4 = max(TRAFFIC_PUR.speed4);
STAT_PUR.averagespeed4 = mean(TRAFFIC_PUR.speed4);
STAT_PUR.minspeed4 = min(TRAFFIC_PUR.speed4);
STAT_PUR.stdspeed4 = std(TRAFFIC_PUR.speed4);
STAT_PUR.samplesize4 = numel(TRAFFIC_PUR.speed4);
STAT_PUR.ratio4 = STAT_PUR.averagespeed4/speedlimit4_pur

clear ans speedlimit3 speedlimit3_ora speedlimit3_red speedlimit3_blu
clear speedlimit3_gre speedlimit4_ora speedlimit4_red speedlimit4_blu
clear speedlimit4_gre speedlimit3_pur speedlimit4_pur

%% release some space
clear ans i n statmeasure_tstamp3 statmeasure_tstamp4
clear indexmeasure_tstamp3 indexmeasure_tstamp4

%% UPDATED FROM HERE (SAVED BOFORE HERE) 01/24/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 12/31/2018 SUBPLOT ORANGE AFTERNOON N/E (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit3 = 55;
hour3index430 = TRAFFICAVE_ORA.datevec3(:,4) == 16;
min3index430 = TRAFFICAVE_ORA.datevec3(:,5)<30 & TRAFFICAVE_ORA.datevec3(:,5)>=0;
time3index430 = hour3index430==1 & min3index430 ==1;
% the only useful index variable is time3index430, so, I will delete
% hour3index430 and min3index430
clear hour3index430 min3index430
f = figure(1)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_ORA.datetime3(time3index430,:),TRAFFICAVE_ORA.speed3(time3index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_ORA.datetime3(1,:),TRAFFICAVE_ORA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:00 - 16:29')
hold off


hour3index500 = TRAFFICAVE_ORA.datevec3(:,4) == 16;
min3index500 = TRAFFICAVE_ORA.datevec3(:,5) >= 30 & TRAFFICAVE_ORA.datevec3(:,5) < 59;
time3index500 = hour3index500==1 & min3index500 ==1;
clear hour3index500 min3index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_ORA.datetime3(time3index500,:),TRAFFICAVE_ORA.speed3(time3index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_ORA.datetime3(1,:),TRAFFICAVE_ORA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:30 - 16:59')
hold off


hour3index530 = TRAFFICAVE_ORA.datevec3(:,4) == 17;
min3index530 = TRAFFICAVE_ORA.datevec3(:,5) < 30 & TRAFFICAVE_ORA.datevec3(:,5) >= 0;
time3index530 = hour3index530==1 & min3index530 ==1;
clear hour3index530 min3index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_ORA.datetime3(time3index530,:),TRAFFICAVE_ORA.speed3(time3index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_ORA.datetime3(1,:),TRAFFICAVE_ORA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:00 - 17:29')
hold off


hour3index600 = TRAFFICAVE_ORA.datevec3(:,4) == 17;
min3index600 = TRAFFICAVE_ORA.datevec3(:,5) >= 30 & TRAFFICAVE_ORA.datevec3(:,5) < 59;
time3index600 = hour3index600==1 & min3index600 ==1;
clear hour3index600 min3index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_ORA.datetime3(time3index600,:),TRAFFICAVE_ORA.speed3(time3index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_ORA.datetime3(1,:),TRAFFICAVE_ORA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:30 - 17:59')
hold off
% save plot
saveas(figure(1), '01N_E_Subplot.jpg');
% finally, delete all index
clear time3index430 time3index500 time3index530 time3index600 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT ORANGE MORNING N/E (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit3 = 55;
hour3index730 = AMTRAFFICAVE_ORA.datevec3(:,4) == 7;
min3index730 = AMTRAFFICAVE_ORA.datevec3(:,5)<30 & AMTRAFFICAVE_ORA.datevec3(:,5)>=0;
time3index730 = hour3index730==1 & min3index730 ==1;
% the only useful index variable is time3index730, so, I will delete
% hour3index730 and min3index730
clear hour3index730 min3index730
f = figure(2)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_ORA.datetime3(time3index730,:),AMTRAFFICAVE_ORA.speed3(time3index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_ORA.datetime3(1,:),AMTRAFFICAVE_ORA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:00 - 7:29')
hold off


hour3index800 = AMTRAFFICAVE_ORA.datevec3(:,4) == 7;
min3index800 = AMTRAFFICAVE_ORA.datevec3(:,5) >= 30 & AMTRAFFICAVE_ORA.datevec3(:,5) < 59;
time3index800 = hour3index800==1 & min3index800 ==1;
clear hour3index800 min3index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_ORA.datetime3(time3index800,:),AMTRAFFICAVE_ORA.speed3(time3index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_ORA.datetime3(1,:),AMTRAFFICAVE_ORA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:30 - 7:59')
hold off


hour3index830 = AMTRAFFICAVE_ORA.datevec3(:,4) == 8;
min3index830 = AMTRAFFICAVE_ORA.datevec3(:,5) < 30 & AMTRAFFICAVE_ORA.datevec3(:,5) >= 0;
time3index830 = hour3index830==1 & min3index830 ==1;
clear hour3index830 min3index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_ORA.datetime3(time3index830,:),AMTRAFFICAVE_ORA.speed3(time3index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_ORA.datetime3(1,:),AMTRAFFICAVE_ORA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:00 - 8:29')
hold off


hour3index900 = AMTRAFFICAVE_ORA.datevec3(:,4) == 8;
min3index900 = AMTRAFFICAVE_ORA.datevec3(:,5) >= 30 & AMTRAFFICAVE_ORA.datevec3(:,5) < 59;
time3index900 = hour3index900==1 & min3index900 ==1;
clear hour3index900 min3index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_ORA.datetime3(time3index900,:),AMTRAFFICAVE_ORA.speed3(time3index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_ORA.datetime3(1,:),AMTRAFFICAVE_ORA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);    
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:30 - 9:00')
hold off
% save plot
saveas(figure(2), '02N_E_Subplot_AM.jpg');
% finally, delete all index
clear time3index730 time3index800 time3index830 time3index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT RED AFTERNOON N/E (CONGESTED)
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit3 = 55;
hour3index430 = TRAFFICAVE_RED.datevec3(:,4) == 16;
min3index430 = TRAFFICAVE_RED.datevec3(:,5)<30 & TRAFFICAVE_RED.datevec3(:,5)>=0;
time3index430 = hour3index430==1 & min3index430 ==1;
% the only useful index variable is time3index430, so, I will delete
% hour3index430 and min3index430
clear hour3index430 min3index430
f = figure(3)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_RED.datetime3(time3index430,:),TRAFFICAVE_RED.speed3(time3index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_RED.datetime3(1,:),TRAFFICAVE_RED.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:00 - 16:29')
hold off


hour3index500 = TRAFFICAVE_RED.datevec3(:,4) == 16;
min3index500 = TRAFFICAVE_RED.datevec3(:,5) >= 30 & TRAFFICAVE_RED.datevec3(:,5) < 59;
time3index500 = hour3index500==1 & min3index500 ==1;
clear hour3index500 min3index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_RED.datetime3(time3index500,:),TRAFFICAVE_RED.speed3(time3index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_RED.datetime3(1,:),TRAFFICAVE_RED.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:30 - 16:59')
hold off


hour3index530 = TRAFFICAVE_RED.datevec3(:,4) == 17;
min3index530 = TRAFFICAVE_RED.datevec3(:,5) < 30 & TRAFFICAVE_RED.datevec3(:,5) >= 0;
time3index530 = hour3index530==1 & min3index530 ==1;
clear hour3index530 min3index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_RED.datetime3(time3index530,:),TRAFFICAVE_RED.speed3(time3index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_RED.datetime3(1,:),TRAFFICAVE_RED.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:00 - 17:29')
hold off


hour3index600 = TRAFFICAVE_RED.datevec3(:,4) == 17;
min3index600 = TRAFFICAVE_RED.datevec3(:,5) >= 30 & TRAFFICAVE_RED.datevec3(:,5) < 59;
time3index600 = hour3index600==1 & min3index600 ==1;
clear hour3index600 min3index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_RED.datetime3(time3index600,:),TRAFFICAVE_RED.speed3(time3index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_RED.datetime3(1,:),TRAFFICAVE_RED.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:30 - 17:59')
hold off
% save plot
saveas(figure(3), '03N_E_Subplot.jpg');
% finally, delete all index
clear time3index430 time3index500 time3index530 time3index600 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT RED MORNING N/E (CONGESTED)
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit3 = 55;
hour3index730 = AMTRAFFICAVE_RED.datevec3(:,4) == 7;
min3index730 = AMTRAFFICAVE_RED.datevec3(:,5)<30 & AMTRAFFICAVE_RED.datevec3(:,5)>=0;
time3index730 = hour3index730==1 & min3index730 ==1;
% the only useful index variable is time3index730, so, I will delete
% hour3index730 and min3index730
clear hour3index730 min3index730
f = figure(4)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_RED.datetime3(time3index730,:),AMTRAFFICAVE_RED.speed3(time3index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_RED.datetime3(1,:),AMTRAFFICAVE_RED.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:00 - 7:29')
hold off


hour3index800 = AMTRAFFICAVE_RED.datevec3(:,4) == 7;
min3index800 = AMTRAFFICAVE_RED.datevec3(:,5) >= 30 & AMTRAFFICAVE_RED.datevec3(:,5) < 59;
time3index800 = hour3index800==1 & min3index800 ==1;
clear hour3index800 min3index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_RED.datetime3(time3index800,:),AMTRAFFICAVE_RED.speed3(time3index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_RED.datetime3(1,:),AMTRAFFICAVE_RED.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:30 - 7:59')
hold off


hour3index830 = AMTRAFFICAVE_RED.datevec3(:,4) == 8;
min3index830 = AMTRAFFICAVE_RED.datevec3(:,5) < 30 & AMTRAFFICAVE_RED.datevec3(:,5) >= 0;
time3index830 = hour3index830==1 & min3index830 ==1;
clear hour3index830 min3index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_RED.datetime3(time3index830,:),AMTRAFFICAVE_RED.speed3(time3index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_RED.datetime3(1,:),AMTRAFFICAVE_RED.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:00 - 8:29')
hold off


hour3index900 = AMTRAFFICAVE_RED.datevec3(:,4) == 8;
min3index900 = AMTRAFFICAVE_RED.datevec3(:,5) >= 30 & AMTRAFFICAVE_RED.datevec3(:,5) < 59;
time3index900 = hour3index900==1 & min3index900 ==1;
clear hour3index900 min3index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_RED.datetime3(time3index900,:),AMTRAFFICAVE_RED.speed3(time3index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_RED.datetime3(1,:),AMTRAFFICAVE_RED.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);    
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:30 - 9:00')
hold off
% save plot
saveas(figure(4), '04N_E_Subplot_AM.jpg');
% finally, delete all index
clear time3index730 time3index800 time3index830 time3index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT BLUE AFTERNOON N/E (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit3 = 55;
hour3index430 = TRAFFICAVE_BLU.datevec3(:,4) == 16;
min3index430 = TRAFFICAVE_BLU.datevec3(:,5)<30 & TRAFFICAVE_BLU.datevec3(:,5)>=0;
time3index430 = hour3index430==1 & min3index430 ==1;
% the only useful index variable is time3index430, so, I will delete
% hour3index430 and min3index430
clear hour3index430 min3index430
f = figure(5)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_BLU.datetime3(time3index430,:),TRAFFICAVE_BLU.speed3(time3index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLU.datetime3(1,:),TRAFFICAVE_BLU.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end

%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:00 - 16:29')
hold off


hour3index500 = TRAFFICAVE_BLU.datevec3(:,4) == 16;
min3index500 = TRAFFICAVE_BLU.datevec3(:,5) >= 30 & TRAFFICAVE_BLU.datevec3(:,5) < 59;
time3index500 = hour3index500==1 & min3index500 ==1;
clear hour3index500 min3index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_BLU.datetime3(time3index500,:),TRAFFICAVE_BLU.speed3(time3index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLU.datetime3(1,:),TRAFFICAVE_BLU.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:30 - 16:59')
hold off


hour3index530 = TRAFFICAVE_BLU.datevec3(:,4) == 17;
min3index530 = TRAFFICAVE_BLU.datevec3(:,5) < 30 & TRAFFICAVE_BLU.datevec3(:,5) >= 0;
time3index530 = hour3index530==1 & min3index530 ==1;
clear hour3index530 min3index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_BLU.datetime3(time3index530,:),TRAFFICAVE_BLU.speed3(time3index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLU.datetime3(1,:),TRAFFICAVE_BLU.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:00 - 17:29')
hold off


hour3index600 = TRAFFICAVE_BLU.datevec3(:,4) == 17;
min3index600 = TRAFFICAVE_BLU.datevec3(:,5) >= 30 & TRAFFICAVE_BLU.datevec3(:,5) < 59;
time3index600 = hour3index600==1 & min3index600 ==1;
clear hour3index600 min3index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_BLU.datetime3(time3index600,:),TRAFFICAVE_BLU.speed3(time3index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLU.datetime3(1,:),TRAFFICAVE_BLU.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:30 - 17:59')
hold off
% save plot
saveas(figure(5), '05N_E_Subplot.jpg');
% finally, delete all index
clear time3index430 time3index500 time3index530 time3index600 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT BLUE MORNING N/E (NOT CONGESTED)
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit3 = 55;
hour3index730 = AMTRAFFICAVE_BLU.datevec3(:,4) == 7;
min3index730 = AMTRAFFICAVE_BLU.datevec3(:,5)<30 & AMTRAFFICAVE_BLU.datevec3(:,5)>=0;
time3index730 = hour3index730==1 & min3index730 ==1;
% the only useful index variable is time3index730, so, I will delete
% hour3index730 and min3index730
clear hour3index730 min3index730
f = figure(6)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_BLU.datetime3(time3index730,:),AMTRAFFICAVE_BLU.speed3(time3index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLU.datetime3(1,:),AMTRAFFICAVE_BLU.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:00 - 7:29')
hold off


hour3index800 = AMTRAFFICAVE_BLU.datevec3(:,4) == 7;
min3index800 = AMTRAFFICAVE_BLU.datevec3(:,5) >= 30 & AMTRAFFICAVE_BLU.datevec3(:,5) < 59;
time3index800 = hour3index800==1 & min3index800 ==1;
clear hour3index800 min3index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_BLU.datetime3(time3index800,:),AMTRAFFICAVE_BLU.speed3(time3index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLU.datetime3(1,:),AMTRAFFICAVE_BLU.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:30 - 7:59')
hold off


hour3index830 = AMTRAFFICAVE_BLU.datevec3(:,4) == 8;
min3index830 = AMTRAFFICAVE_BLU.datevec3(:,5) < 30 & AMTRAFFICAVE_BLU.datevec3(:,5) >= 0;
time3index830 = hour3index830==1 & min3index830 ==1;
clear hour3index830 min3index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_BLU.datetime3(time3index830,:),AMTRAFFICAVE_BLU.speed3(time3index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLU.datetime3(1,:),AMTRAFFICAVE_BLU.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:00 - 8:29')
hold off


hour3index900 = AMTRAFFICAVE_BLU.datevec3(:,4) == 8;
min3index900 = AMTRAFFICAVE_BLU.datevec3(:,5) >= 30 & AMTRAFFICAVE_BLU.datevec3(:,5) < 59;
time3index900 = hour3index900==1 & min3index900 ==1;
clear hour3index900 min3index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_BLU.datetime3(time3index900,:),AMTRAFFICAVE_BLU.speed3(time3index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLU.datetime3(1,:),AMTRAFFICAVE_BLU.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);    
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:30 - 9:00')
hold off
% save plot
saveas(figure(6), '06N_E_Subplot_AM.jpg');
% finally, delete all index
clear time3index730 time3index800 time3index830 time3index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT GREEN AFTERNOON N/E (DONT RUNCONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit3 = 55;
hour3index430 = TRAFFICAVE_GRE.datevec3(:,4) == 16;
min3index430 = TRAFFICAVE_GRE.datevec3(:,5)<30 & TRAFFICAVE_GRE.datevec3(:,5)>=0;
time3index430 = hour3index430==1 & min3index430 ==1;
% the only useful index variable is time3index430, so, I will delete
% hour3index430 and min3index430
clear hour3index430 min3index430
f = figure(7)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_GRE.datetime3(time3index430,:),TRAFFICAVE_GRE.speed3(time3index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_GRE.datetime3(1,:),TRAFFICAVE_GRE.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:00 - 16:29')
hold off


hour3index500 = TRAFFICAVE_GRE.datevec3(:,4) == 16;
min3index500 = TRAFFICAVE_GRE.datevec3(:,5) >= 30 & TRAFFICAVE_GRE.datevec3(:,5) < 59;
time3index500 = hour3index500==1 & min3index500 ==1;
clear hour3index500 min3index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_GRE.datetime3(time3index500,:),TRAFFICAVE_GRE.speed3(time3index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_GRE.datetime3(1,:),TRAFFICAVE_GRE.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:30 - 16:59')
hold off


hour3index530 = TRAFFICAVE_GRE.datevec3(:,4) == 17;
min3index530 = TRAFFICAVE_GRE.datevec3(:,5) < 30 & TRAFFICAVE_GRE.datevec3(:,5) >= 0;
time3index530 = hour3index530==1 & min3index530 ==1;
clear hour3index530 min3index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_GRE.datetime3(time3index530,:),TRAFFICAVE_GRE.speed3(time3index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_GRE.datetime3(1,:),TRAFFICAVE_GRE.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:00 - 17:29')
hold off


hour3index600 = TRAFFICAVE_GRE.datevec3(:,4) == 17;
min3index600 = TRAFFICAVE_GRE.datevec3(:,5) >= 30 & TRAFFICAVE_GRE.datevec3(:,5) < 59;
time3index600 = hour3index600==1 & min3index600 ==1;
clear hour3index600 min3index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_GRE.datetime3(time3index600,:),TRAFFICAVE_GRE.speed3(time3index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_GRE.datetime3(1,:),TRAFFICAVE_GRE.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:30 - 17:59')
hold off
% save plot
saveas(figure(7), '07N_E_Subplot.jpg');
% finally, delete all index
clear time3index430 time3index500 time3index530 time3index600 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT GREEN MORNING N/E (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit3 = 55;
hour3index730 = AMTRAFFICAVE_GRE.datevec3(:,4) == 7;
min3index730 = AMTRAFFICAVE_GRE.datevec3(:,5)<30 & AMTRAFFICAVE_GRE.datevec3(:,5)>=0;
time3index730 = hour3index730==1 & min3index730 ==1;
% the only useful index variable is time3index730, so, I will delete
% hour3index730 and min3index730
clear hour3index730 min3index730
f = figure(8)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_GRE.datetime3(time3index730,:),AMTRAFFICAVE_GRE.speed3(time3index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_GRE.datetime3(1,:),AMTRAFFICAVE_GRE.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:00 - 7:29')
hold off


hour3index800 = AMTRAFFICAVE_GRE.datevec3(:,4) == 7;
min3index800 = AMTRAFFICAVE_GRE.datevec3(:,5) >= 30 & AMTRAFFICAVE_GRE.datevec3(:,5) < 59;
time3index800 = hour3index800==1 & min3index800 ==1;
clear hour3index800 min3index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_GRE.datetime3(time3index800,:),AMTRAFFICAVE_GRE.speed3(time3index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_GRE.datetime3(1,:),AMTRAFFICAVE_GRE.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:30 - 7:59')
hold off


hour3index830 = AMTRAFFICAVE_GRE.datevec3(:,4) == 8;
min3index830 = AMTRAFFICAVE_GRE.datevec3(:,5) < 30 & AMTRAFFICAVE_GRE.datevec3(:,5) >= 0;
time3index830 = hour3index830==1 & min3index830 ==1;
clear hour3index830 min3index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_GRE.datetime3(time3index830,:),AMTRAFFICAVE_GRE.speed3(time3index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_GRE.datetime3(1,:),AMTRAFFICAVE_GRE.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:00 - 8:29')
hold off


hour3index900 = AMTRAFFICAVE_GRE.datevec3(:,4) == 8;
min3index900 = AMTRAFFICAVE_GRE.datevec3(:,5) >= 30 & AMTRAFFICAVE_GRE.datevec3(:,5) < 59;
time3index900 = hour3index900==1 & min3index900 ==1;
clear hour3index900 min3index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_GRE.datetime3(time3index900,:),AMTRAFFICAVE_GRE.speed3(time3index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_GRE.datetime3(1,:),AMTRAFFICAVE_GRE.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);    
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:30 - 9:00')
hold off
% save plot
saveas(figure(8), '08N_E_Subplot_AM.jpg');
% finally, delete all index
clear time3index730 time3index800 time3index830 time3index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT PURPLE AFTERNOON N/E (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit3 = 55;
hour3index430 = TRAFFICAVE_PUR.datevec3(:,4) == 16;
min3index430 = TRAFFICAVE_PUR.datevec3(:,5)<30 & TRAFFICAVE_PUR.datevec3(:,5)>=0;
time3index430 = hour3index430==1 & min3index430 ==1;
% the only useful index variable is time3index430, so, I will delete
% hour3index430 and min3index430
clear hour3index430 min3index430
f = figure(9)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_PUR.datetime3(time3index430,:),TRAFFICAVE_PUR.speed3(time3index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_PUR.datetime3(1,:),TRAFFICAVE_PUR.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:00 - 16:29')
hold off


hour3index500 = TRAFFICAVE_PUR.datevec3(:,4) == 16;
min3index500 = TRAFFICAVE_PUR.datevec3(:,5) >= 30 & TRAFFICAVE_PUR.datevec3(:,5) < 59;
time3index500 = hour3index500==1 & min3index500 ==1;
clear hour3index500 min3index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_PUR.datetime3(time3index500,:),TRAFFICAVE_PUR.speed3(time3index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_PUR.datetime3(1,:),TRAFFICAVE_PUR.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:30 - 16:59')
hold off


hour3index530 = TRAFFICAVE_PUR.datevec3(:,4) == 17;
min3index530 = TRAFFICAVE_PUR.datevec3(:,5) < 30 & TRAFFICAVE_PUR.datevec3(:,5) >= 0;
time3index530 = hour3index530==1 & min3index530 ==1;
clear hour3index530 min3index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_PUR.datetime3(time3index530,:),TRAFFICAVE_PUR.speed3(time3index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_PUR.datetime3(1,:),TRAFFICAVE_PUR.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:00 - 17:29')
hold off


hour3index600 = TRAFFICAVE_PUR.datevec3(:,4) == 17;
min3index600 = TRAFFICAVE_PUR.datevec3(:,5) >= 30 & TRAFFICAVE_PUR.datevec3(:,5) < 59;
time3index600 = hour3index600==1 & min3index600 ==1;
clear hour3index600 min3index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_PUR.datetime3(time3index600,:),TRAFFICAVE_PUR.speed3(time3index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_PUR.datetime3(1,:),TRAFFICAVE_PUR.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:30 - 17:59')
hold off
% save plot
saveas(figure(9), '09N_E_Subplot.jpg');
% finally, delete all index
clear time3index430 time3index500 time3index530 time3index600 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT PURPLE MORNING N/E (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit3 = 55;
hour3index730 = AMTRAFFICAVE_PUR.datevec3(:,4) == 7;
min3index730 = AMTRAFFICAVE_PUR.datevec3(:,5)<30 & AMTRAFFICAVE_PUR.datevec3(:,5)>=0;
time3index730 = hour3index730==1 & min3index730 ==1;
% the only useful index variable is time3index730, so, I will delete
% hour3index730 and min3index730
clear hour3index730 min3index730
f = figure(10)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_PUR.datetime3(time3index730,:),AMTRAFFICAVE_PUR.speed3(time3index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_PUR.datetime3(1,:),AMTRAFFICAVE_PUR.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:00 - 7:29')
hold off


hour3index800 = AMTRAFFICAVE_PUR.datevec3(:,4) == 7;
min3index800 = AMTRAFFICAVE_PUR.datevec3(:,5) >= 30 & AMTRAFFICAVE_PUR.datevec3(:,5) < 59;
time3index800 = hour3index800==1 & min3index800 ==1;
clear hour3index800 min3index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_PUR.datetime3(time3index800,:),AMTRAFFICAVE_PUR.speed3(time3index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_PUR.datetime3(1,:),AMTRAFFICAVE_PUR.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:30 - 7:59')
hold off


hour3index830 = AMTRAFFICAVE_PUR.datevec3(:,4) == 8;
min3index830 = AMTRAFFICAVE_PUR.datevec3(:,5) < 30 & AMTRAFFICAVE_PUR.datevec3(:,5) >= 0;
time3index830 = hour3index830==1 & min3index830 ==1;
clear hour3index830 min3index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_PUR.datetime3(time3index830,:),AMTRAFFICAVE_PUR.speed3(time3index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_PUR.datetime3(1,:),AMTRAFFICAVE_PUR.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:00 - 8:29')
hold off


hour3index900 = AMTRAFFICAVE_PUR.datevec3(:,4) == 8;
min3index900 = AMTRAFFICAVE_PUR.datevec3(:,5) >= 30 & AMTRAFFICAVE_PUR.datevec3(:,5) < 59;
time3index900 = hour3index900==1 & min3index900 ==1;
clear hour3index900 min3index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_PUR.datetime3(time3index900,:),AMTRAFFICAVE_PUR.speed3(time3index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_PUR.datetime3(1,:),AMTRAFFICAVE_PUR.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);    
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:30 - 9:00')
hold off
% save plot
saveas(figure(10), '10N_E_Subplot_AM.jpg');
% finally, delete all index
clear time3index730 time3index800 time3index830 time3index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT YELLOW AFTERNOON N/E (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit3 = 65;
hour3index430 = TRAFFICAVE_YEL.datevec3(:,4) == 16;
min3index430 = TRAFFICAVE_YEL.datevec3(:,5)<30 & TRAFFICAVE_YEL.datevec3(:,5)>=0;
time3index430 = hour3index430==1 & min3index430 ==1;
% the only useful index variable is time3index430, so, I will delete
% hour3index430 and min3index430
clear hour3index430 min3index430
f = figure(11)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_YEL.datetime3(time3index430,:),TRAFFICAVE_YEL.speed3(time3index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_YEL.datetime3(1,:),TRAFFICAVE_YEL.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:00 - 16:29')
hold off


hour3index500 = TRAFFICAVE_YEL.datevec3(:,4) == 16;
min3index500 = TRAFFICAVE_YEL.datevec3(:,5) >= 30 & TRAFFICAVE_YEL.datevec3(:,5) < 59;
time3index500 = hour3index500==1 & min3index500 ==1;
clear hour3index500 min3index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_YEL.datetime3(time3index500,:),TRAFFICAVE_YEL.speed3(time3index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_YEL.datetime3(1,:),TRAFFICAVE_YEL.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:30 - 16:59')
hold off


hour3index530 = TRAFFICAVE_YEL.datevec3(:,4) == 17;
min3index530 = TRAFFICAVE_YEL.datevec3(:,5) < 30 & TRAFFICAVE_YEL.datevec3(:,5) >= 0;
time3index530 = hour3index530==1 & min3index530 ==1;
clear hour3index530 min3index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_YEL.datetime3(time3index530,:),TRAFFICAVE_YEL.speed3(time3index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_YEL.datetime3(1,:),TRAFFICAVE_YEL.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:00 - 17:29')
hold off


hour3index600 = TRAFFICAVE_YEL.datevec3(:,4) == 17;
min3index600 = TRAFFICAVE_YEL.datevec3(:,5) >= 30 & TRAFFICAVE_YEL.datevec3(:,5) < 59;
time3index600 = hour3index600==1 & min3index600 ==1;
clear hour3index600 min3index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_YEL.datetime3(time3index600,:),TRAFFICAVE_YEL.speed3(time3index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_YEL.datetime3(1,:),TRAFFICAVE_YEL.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:30 - 17:59')
hold off
% save plot
saveas(figure(11), '11N_E_Subplot.jpg');
% finally, delete all index
clear time3index430 time3index500 time3index530 time3index600 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT YELLOW MORNING N/E (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit3 = 65;
hour3index730 = AMTRAFFICAVE_YEL.datevec3(:,4) == 7;
min3index730 = AMTRAFFICAVE_YEL.datevec3(:,5)<30 & AMTRAFFICAVE_YEL.datevec3(:,5)>=0;
time3index730 = hour3index730==1 & min3index730 ==1;
% the only useful index variable is time3index730, so, I will delete
% hour3index730 and min3index730
clear hour3index730 min3index730
f = figure(12)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_YEL.datetime3(time3index730,:),AMTRAFFICAVE_YEL.speed3(time3index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_YEL.datetime3(1,:),AMTRAFFICAVE_YEL.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:00 - 7:29')
hold off


hour3index800 = AMTRAFFICAVE_YEL.datevec3(:,4) == 7;
min3index800 = AMTRAFFICAVE_YEL.datevec3(:,5) >= 30 & AMTRAFFICAVE_YEL.datevec3(:,5) < 59;
time3index800 = hour3index800==1 & min3index800 ==1;
clear hour3index800 min3index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_YEL.datetime3(time3index800,:),AMTRAFFICAVE_YEL.speed3(time3index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_YEL.datetime3(1,:),AMTRAFFICAVE_YEL.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:30 - 7:59')
hold off


hour3index830 = AMTRAFFICAVE_YEL.datevec3(:,4) == 8;
min3index830 = AMTRAFFICAVE_YEL.datevec3(:,5) < 30 & AMTRAFFICAVE_YEL.datevec3(:,5) >= 0;
time3index830 = hour3index830==1 & min3index830 ==1;
clear hour3index830 min3index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_YEL.datetime3(time3index830,:),AMTRAFFICAVE_YEL.speed3(time3index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_YEL.datetime3(1,:),AMTRAFFICAVE_YEL.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:00 - 8:29')
hold off


hour3index900 = AMTRAFFICAVE_YEL.datevec3(:,4) == 8;
min3index900 = AMTRAFFICAVE_YEL.datevec3(:,5) >= 30 & AMTRAFFICAVE_YEL.datevec3(:,5) < 59;
time3index900 = hour3index900==1 & min3index900 ==1;
clear hour3index900 min3index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_YEL.datetime3(time3index900,:),AMTRAFFICAVE_YEL.speed3(time3index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_YEL.datetime3(1,:),AMTRAFFICAVE_YEL.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);    
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:30 - 9:00')
hold off
% save plot
saveas(figure(12), '12N_E_Subplot_AM.jpg');
% finally, delete all index
clear time3index730 time3index800 time3index830 time3index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT BLACK AFTERNOON N/E (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit3 = 65;
hour3index430 = TRAFFICAVE_BLA.datevec3(:,4) == 16;
min3index430 = TRAFFICAVE_BLA.datevec3(:,5)<30 & TRAFFICAVE_BLA.datevec3(:,5)>=0;
time3index430 = hour3index430==1 & min3index430 ==1;
% the only useful index variable is time3index430, so, I will delete
% hour3index430 and min3index430
clear hour3index430 min3index430
f = figure(13)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_BLA.datetime3(time3index430,:),TRAFFICAVE_BLA.speed3(time3index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLA.datetime3(1,:),TRAFFICAVE_BLA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:00 - 16:29')
hold off


hour3index500 = TRAFFICAVE_BLA.datevec3(:,4) == 16;
min3index500 = TRAFFICAVE_BLA.datevec3(:,5) >= 30 & TRAFFICAVE_BLA.datevec3(:,5) < 59;
time3index500 = hour3index500==1 & min3index500 ==1;
clear hour3index500 min3index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_BLA.datetime3(time3index500,:),TRAFFICAVE_BLA.speed3(time3index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLA.datetime3(1,:),TRAFFICAVE_BLA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 16:30 - 16:59')
hold off


hour3index530 = TRAFFICAVE_BLA.datevec3(:,4) == 17;
min3index530 = TRAFFICAVE_BLA.datevec3(:,5) < 30 & TRAFFICAVE_BLA.datevec3(:,5) >= 0;
time3index530 = hour3index530==1 & min3index530 ==1;
clear hour3index530 min3index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_BLA.datetime3(time3index530,:),TRAFFICAVE_BLA.speed3(time3index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLA.datetime3(1,:),TRAFFICAVE_BLA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:00 - 17:29')
hold off


hour3index600 = TRAFFICAVE_BLA.datevec3(:,4) == 17;
min3index600 = TRAFFICAVE_BLA.datevec3(:,5) >= 30 & TRAFFICAVE_BLA.datevec3(:,5) < 59;
time3index600 = hour3index600==1 & min3index600 ==1;
clear hour3index600 min3index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_BLA.datetime3(time3index600,:),TRAFFICAVE_BLA.speed3(time3index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLA.datetime3(1,:),TRAFFICAVE_BLA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 17:30 - 17:59')
hold off
% save plot
saveas(figure(13), '13N_E_Subplot.jpg');
% finally, delete all index
clear time3index430 time3index500 time3index530 time3index600 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/3/2019 SUBPLOT BLACK MORNING N/E (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit3 = 65;
hour3index730 = AMTRAFFICAVE_BLA.datevec3(:,4) == 7;
min3index730 = AMTRAFFICAVE_BLA.datevec3(:,5)<30 & AMTRAFFICAVE_BLA.datevec3(:,5)>=0;
time3index730 = hour3index730==1 & min3index730 ==1;
% the only useful index variable is time3index730, so, I will delete
% hour3index730 and min3index730
clear hour3index730 min3index730
f = figure(14)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_BLA.datetime3(time3index730,:),AMTRAFFICAVE_BLA.speed3(time3index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLA.datetime3(1,:),AMTRAFFICAVE_BLA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:00 - 7:29')
hold off


hour3index800 = AMTRAFFICAVE_BLA.datevec3(:,4) == 7;
min3index800 = AMTRAFFICAVE_BLA.datevec3(:,5) >= 30 & AMTRAFFICAVE_BLA.datevec3(:,5) < 59;
time3index800 = hour3index800==1 & min3index800 ==1;
clear hour3index800 min3index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_BLA.datetime3(time3index800,:),AMTRAFFICAVE_BLA.speed3(time3index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLA.datetime3(1,:),AMTRAFFICAVE_BLA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 7:30 - 7:59')
hold off


hour3index830 = AMTRAFFICAVE_BLA.datevec3(:,4) == 8;
min3index830 = AMTRAFFICAVE_BLA.datevec3(:,5) < 30 & AMTRAFFICAVE_BLA.datevec3(:,5) >= 0;
time3index830 = hour3index830==1 & min3index830 ==1;
clear hour3index830 min3index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_BLA.datetime3(time3index830,:),AMTRAFFICAVE_BLA.speed3(time3index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLA.datetime3(1,:),AMTRAFFICAVE_BLA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:00 - 8:29')
hold off


hour3index900 = AMTRAFFICAVE_BLA.datevec3(:,4) == 8;
min3index900 = AMTRAFFICAVE_BLA.datevec3(:,5) >= 30 & AMTRAFFICAVE_BLA.datevec3(:,5) < 59;
time3index900 = hour3index900==1 & min3index900 ==1;
clear hour3index900 min3index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_BLA.datetime3(time3index900,:),AMTRAFFICAVE_BLA.speed3(time3index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLA.datetime3(1,:),AMTRAFFICAVE_BLA.datetime3(end,:)],[speedlimit3,speedlimit3]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit3;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);    
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia N/E) 8:30 - 9:00')
hold off
% save plot
saveas(figure(14), '14N_E_Subplot_AM.jpg');
% finally, delete all index
clear time3index730 time3index800 time3index830 time3index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% reease some space
clear f lhand speedlimit3 speedlimit4

%% 1/5/2019 SUBPLOT ORANGE AFTERNOON S/W (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit4 = 55;
hour4index430 = TRAFFICAVE_ORA.datevec4(:,4) == 16;
min4index430 = TRAFFICAVE_ORA.datevec4(:,5)<30 & TRAFFICAVE_ORA.datevec4(:,5)>=0;
time4index430 = hour4index430==1 & min4index430 ==1;
% the only useful index variable is time4index430, so, I will delete
% hour4index430 and min4index430
clear hour4index430 min4index430
f = figure(1)
f.Position = [1,50,1500,700];
subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_ORA.datetime4(time4index430,:),TRAFFICAVE_ORA.speed4(time4index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_ORA.datetime4(1,:),TRAFFICAVE_ORA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:00 - 16:29')
hold off


hour4index500 = TRAFFICAVE_ORA.datevec4(:,4) == 16;
min4index500 = TRAFFICAVE_ORA.datevec4(:,5) >= 30 & TRAFFICAVE_ORA.datevec4(:,5) < 59;
time4index500 = hour4index500==1 & min4index500 ==1;
clear hour4index500 min4index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_ORA.datetime4(time4index500,:),TRAFFICAVE_ORA.speed4(time4index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_ORA.datetime4(1,:),TRAFFICAVE_ORA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:30 - 16:59')
hold off


hour4index530 = TRAFFICAVE_ORA.datevec4(:,4) == 17;
min4index530 = TRAFFICAVE_ORA.datevec4(:,5) < 30 & TRAFFICAVE_ORA.datevec4(:,5) >= 0;
time4index530 = hour4index530==1 & min4index530 ==1;
clear hour4index530 min4index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_ORA.datetime4(time4index530,:),TRAFFICAVE_ORA.speed4(time4index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_ORA.datetime4(1,:),TRAFFICAVE_ORA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:00 - 17:29')
hold off


hour4index600 = TRAFFICAVE_ORA.datevec4(:,4) == 17;
min4index600 = TRAFFICAVE_ORA.datevec4(:,5) >= 30 & TRAFFICAVE_ORA.datevec4(:,5) < 59;
time4index600 = hour4index600==1 & min4index600 ==1;
clear hour4index600 min4index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_ORA.datetime4(time4index600,:),TRAFFICAVE_ORA.speed4(time4index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_ORA.datetime4(1,:),TRAFFICAVE_ORA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:30 - 17:59')
hold off
% save plot
saveas(figure(1), '01S_W_Subplot.jpg');
% finally, delete all index
clear time4index430 time4index500 time4index530 time4index600
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler all_ylabels lhand statmeasure_tstamp3
clear statmeasure_tstamp4 tmcindex
toc

%% 1/5/2019 SUBPLOT ORANGE MORNING S/W (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit4 = 55;
hour4index730 = AMTRAFFICAVE_ORA.datevec4(:,4) == 7;
min4index730 = AMTRAFFICAVE_ORA.datevec4(:,5)<30 & AMTRAFFICAVE_ORA.datevec4(:,5)>=0;
time4index730 = hour4index730==1 & min4index730 ==1;
% the only useful index variable is time4index730, so, I will delete
% hour4index730 and min4index730
clear hour4index730 min4index730
f = figure(2)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_ORA.datetime4(time4index730,:),AMTRAFFICAVE_ORA.speed4(time4index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_ORA.datetime4(1,:),AMTRAFFICAVE_ORA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:00 - 7:29')
hold off


hour4index800 = AMTRAFFICAVE_ORA.datevec4(:,4) == 7;
min4index800 = AMTRAFFICAVE_ORA.datevec4(:,5) >= 30 & AMTRAFFICAVE_ORA.datevec4(:,5) < 59;
time4index800 = hour4index800==1 & min4index800 ==1;
clear hour4index800 min4index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_ORA.datetime4(time4index800,:),AMTRAFFICAVE_ORA.speed4(time4index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_ORA.datetime4(1,:),AMTRAFFICAVE_ORA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:30 - 7:59')
hold off


hour4index830 = AMTRAFFICAVE_ORA.datevec4(:,4) == 8;
min4index830 = AMTRAFFICAVE_ORA.datevec4(:,5) < 30 & AMTRAFFICAVE_ORA.datevec4(:,5) >= 0;
time4index830 = hour4index830==1 & min4index830 ==1;
clear hour4index830 min4index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_ORA.datetime4(time4index830,:),AMTRAFFICAVE_ORA.speed4(time4index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_ORA.datetime4(1,:),AMTRAFFICAVE_ORA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:00 - 8:29')
hold off


hour4index900 = AMTRAFFICAVE_ORA.datevec4(:,4) == 8;
min4index900 = AMTRAFFICAVE_ORA.datevec4(:,5) >= 30 & AMTRAFFICAVE_ORA.datevec4(:,5) < 59;
time4index900 = hour4index900==1 & min4index900 ==1;
clear hour4index900 min4index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_ORA.datetime4(time4index900,:),AMTRAFFICAVE_ORA.speed4(time4index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_ORA.datetime4(1,:),AMTRAFFICAVE_ORA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:30 - 9:00')
hold off
% save plot
saveas(figure(2), '02S_W_Subplot_AM.jpg');
% finally, delete all index
clear time4index730 time4index800 time4index830 time4index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/5/2019 SUBPLOT RED AFTERNOON S/W (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit4 = 55;
hour4index430 = TRAFFICAVE_RED.datevec4(:,4) == 16;
min4index430 = TRAFFICAVE_RED.datevec4(:,5)<30 & TRAFFICAVE_RED.datevec4(:,5)>=0;
time4index430 = hour4index430==1 & min4index430 ==1;
% the only useful index variable is time4index430, so, I will delete
% hour4index430 and min4index430
clear hour4index430 min4index430
f = figure(3)
f.Position = [1,50,1500,700];
subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_RED.datetime4(time4index430,:),TRAFFICAVE_RED.speed4(time4index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_RED.datetime4(1,:),TRAFFICAVE_RED.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:00 - 16:29')
hold off


hour4index500 = TRAFFICAVE_RED.datevec4(:,4) == 16;
min4index500 = TRAFFICAVE_RED.datevec4(:,5) >= 30 & TRAFFICAVE_RED.datevec4(:,5) < 59;
time4index500 = hour4index500==1 & min4index500 ==1;
clear hour4index500 min4index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_RED.datetime4(time4index500,:),TRAFFICAVE_RED.speed4(time4index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_RED.datetime4(1,:),TRAFFICAVE_RED.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:30 - 16:59')
hold off


hour4index530 = TRAFFICAVE_RED.datevec4(:,4) == 17;
min4index530 = TRAFFICAVE_RED.datevec4(:,5) < 30 & TRAFFICAVE_RED.datevec4(:,5) >= 0;
time4index530 = hour4index530==1 & min4index530 ==1;
clear hour4index530 min4index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_RED.datetime4(time4index530,:),TRAFFICAVE_RED.speed4(time4index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_RED.datetime4(1,:),TRAFFICAVE_RED.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:00 - 17:29')
hold off


hour4index600 = TRAFFICAVE_RED.datevec4(:,4) == 17;
min4index600 = TRAFFICAVE_RED.datevec4(:,5) >= 30 & TRAFFICAVE_RED.datevec4(:,5) < 59;
time4index600 = hour4index600==1 & min4index600 ==1;
clear hour4index600 min4index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_RED.datetime4(time4index600,:),TRAFFICAVE_RED.speed4(time4index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_RED.datetime4(1,:),TRAFFICAVE_RED.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:30 - 17:59')
hold off
% save plot
saveas(figure(3), '03S_W_Subplot.jpg');
% finally, delete all index
clear time4index430 time4index500 time4index530 time4index600
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler all_ylabels lhand statmeasure_tstamp3
clear statmeasure_tstamp4 tmcindex
toc

%% 1/5/2019 SUBPLOT RED MORNING S/W (NOT CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit4 = 55;
hour4index730 = AMTRAFFICAVE_RED.datevec4(:,4) == 7;
min4index730 = AMTRAFFICAVE_RED.datevec4(:,5)<30 & AMTRAFFICAVE_RED.datevec4(:,5)>=0;
time4index730 = hour4index730==1 & min4index730 ==1;
% the only useful index variable is time4index730, so, I will delete
% hour4index730 and min4index730
clear hour4index730 min4index730
f = figure(4)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_RED.datetime4(time4index730,:),AMTRAFFICAVE_RED.speed4(time4index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_RED.datetime4(1,:),AMTRAFFICAVE_RED.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:00 - 7:29')
hold off


hour4index800 = AMTRAFFICAVE_RED.datevec4(:,4) == 7;
min4index800 = AMTRAFFICAVE_RED.datevec4(:,5) >= 30 & AMTRAFFICAVE_RED.datevec4(:,5) < 59;
time4index800 = hour4index800==1 & min4index800 ==1;
clear hour4index800 min4index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_RED.datetime4(time4index800,:),AMTRAFFICAVE_RED.speed4(time4index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_RED.datetime4(1,:),AMTRAFFICAVE_RED.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:30 - 7:59')
hold off


hour4index830 = AMTRAFFICAVE_RED.datevec4(:,4) == 8;
min4index830 = AMTRAFFICAVE_RED.datevec4(:,5) < 30 & AMTRAFFICAVE_RED.datevec4(:,5) >= 0;
time4index830 = hour4index830==1 & min4index830 ==1;
clear hour4index830 min4index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_RED.datetime4(time4index830,:),AMTRAFFICAVE_RED.speed4(time4index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_RED.datetime4(1,:),AMTRAFFICAVE_RED.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:00 - 8:29')
hold off


hour4index900 = AMTRAFFICAVE_RED.datevec4(:,4) == 8;
min4index900 = AMTRAFFICAVE_RED.datevec4(:,5) >= 30 & AMTRAFFICAVE_RED.datevec4(:,5) < 59;
time4index900 = hour4index900==1 & min4index900 ==1;
clear hour4index900 min4index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_RED.datetime4(time4index900,:),AMTRAFFICAVE_RED.speed4(time4index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_RED.datetime4(1,:),AMTRAFFICAVE_RED.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:30 - 9:00')
hold off
% save plot
saveas(figure(4), '04S_W_Subplot_AM.jpg');
% finally, delete all index
clear time4index730 time4index800 time4index830 time4index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/5/2019 SUBPLOT BLUE AFTERNOON S/W (NOT CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit4 = 55;
hour4index430 = TRAFFICAVE_BLU.datevec4(:,4) == 16;
min4index430 = TRAFFICAVE_BLU.datevec4(:,5)<30 & TRAFFICAVE_BLU.datevec4(:,5)>=0;
time4index430 = hour4index430==1 & min4index430 ==1;
% the only useful index variable is time4index430, so, I will delete
% hour4index430 and min4index430
clear hour4index430 min4index430
f = figure(5)
f.Position = [1,50,1500,700];
subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_BLU.datetime4(time4index430,:),TRAFFICAVE_BLU.speed4(time4index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLU.datetime4(1,:),TRAFFICAVE_BLU.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:00 - 16:29')
hold off


hour4index500 = TRAFFICAVE_BLU.datevec4(:,4) == 16;
min4index500 = TRAFFICAVE_BLU.datevec4(:,5) >= 30 & TRAFFICAVE_BLU.datevec4(:,5) < 59;
time4index500 = hour4index500==1 & min4index500 ==1;
clear hour4index500 min4index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_BLU.datetime4(time4index500,:),TRAFFICAVE_BLU.speed4(time4index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLU.datetime4(1,:),TRAFFICAVE_BLU.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:30 - 16:59')
hold off


hour4index530 = TRAFFICAVE_BLU.datevec4(:,4) == 17;
min4index530 = TRAFFICAVE_BLU.datevec4(:,5) < 30 & TRAFFICAVE_BLU.datevec4(:,5) >= 0;
time4index530 = hour4index530==1 & min4index530 ==1;
clear hour4index530 min4index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_BLU.datetime4(time4index530,:),TRAFFICAVE_BLU.speed4(time4index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLU.datetime4(1,:),TRAFFICAVE_BLU.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:00 - 17:29')
hold off


hour4index600 = TRAFFICAVE_BLU.datevec4(:,4) == 17;
min4index600 = TRAFFICAVE_BLU.datevec4(:,5) >= 30 & TRAFFICAVE_BLU.datevec4(:,5) < 59;
time4index600 = hour4index600==1 & min4index600 ==1;
clear hour4index600 min4index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_BLU.datetime4(time4index600,:),TRAFFICAVE_BLU.speed4(time4index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLU.datetime4(1,:),TRAFFICAVE_BLU.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:30 - 17:59')
hold off
% save plot
saveas(figure(5), '05S_W_Subplot.jpg');
% finally, delete all index
clear time4index430 time4index500 time4index530 time4index600
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler all_ylabels lhand statmeasure_tstamp3
clear statmeasure_tstamp4 tmcindex
toc

%% 1/5/2019 SUBPLOT BLUE MORNING S/W (CONGESTED)
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit4 = 50;
hour4index730 = AMTRAFFICAVE_BLU.datevec4(:,4) == 7;
min4index730 = AMTRAFFICAVE_BLU.datevec4(:,5)<30 & AMTRAFFICAVE_BLU.datevec4(:,5)>=0;
time4index730 = hour4index730==1 & min4index730 ==1;
% the only useful index variable is time4index730, so, I will delete
% hour4index730 and min4index730
clear hour4index730 min4index730
f = figure(6)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_BLU.datetime4(time4index730,:),AMTRAFFICAVE_BLU.speed4(time4index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLU.datetime4(1,:),AMTRAFFICAVE_BLU.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:00 - 7:29')
hold off


hour4index800 = AMTRAFFICAVE_BLU.datevec4(:,4) == 7;
min4index800 = AMTRAFFICAVE_BLU.datevec4(:,5) >= 30 & AMTRAFFICAVE_BLU.datevec4(:,5) < 59;
time4index800 = hour4index800==1 & min4index800 ==1;
clear hour4index800 min4index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_BLU.datetime4(time4index800,:),AMTRAFFICAVE_BLU.speed4(time4index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLU.datetime4(1,:),AMTRAFFICAVE_BLU.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:30 - 7:59')
hold off


hour4index830 = AMTRAFFICAVE_BLU.datevec4(:,4) == 8;
min4index830 = AMTRAFFICAVE_BLU.datevec4(:,5) < 30 & AMTRAFFICAVE_BLU.datevec4(:,5) >= 0;
time4index830 = hour4index830==1 & min4index830 ==1;
clear hour4index830 min4index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_BLU.datetime4(time4index830,:),AMTRAFFICAVE_BLU.speed4(time4index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLU.datetime4(1,:),AMTRAFFICAVE_BLU.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:00 - 8:29')
hold off


hour4index900 = AMTRAFFICAVE_BLU.datevec4(:,4) == 8;
min4index900 = AMTRAFFICAVE_BLU.datevec4(:,5) >= 30 & AMTRAFFICAVE_BLU.datevec4(:,5) < 59;
time4index900 = hour4index900==1 & min4index900 ==1;
clear hour4index900 min4index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_BLU.datetime4(time4index900,:),AMTRAFFICAVE_BLU.speed4(time4index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLU.datetime4(1,:),AMTRAFFICAVE_BLU.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:30 - 9:00')
hold off
% save plot
saveas(figure(6), '06S_W_Subplot_AM.jpg');
% finally, delete all index
clear time4index730 time4index800 time4index830 time4index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/5/2019 SUBPLOT GREEN AFTERNOON S/W (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit4 = 45;
hour4index430 = TRAFFICAVE_GRE.datevec4(:,4) == 16;
min4index430 = TRAFFICAVE_GRE.datevec4(:,5)<30 & TRAFFICAVE_GRE.datevec4(:,5)>=0;
time4index430 = hour4index430==1 & min4index430 ==1;
% the only useful index variable is time4index430, so, I will delete
% hour4index430 and min4index430
clear hour4index430 min4index430
f = figure(7)
f.Position = [1,50,1500,700];
subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_GRE.datetime4(time4index430,:),TRAFFICAVE_GRE.speed4(time4index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_GRE.datetime4(1,:),TRAFFICAVE_GRE.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:00 - 16:29')
hold off


hour4index500 = TRAFFICAVE_GRE.datevec4(:,4) == 16;
min4index500 = TRAFFICAVE_GRE.datevec4(:,5) >= 30 & TRAFFICAVE_GRE.datevec4(:,5) < 59;
time4index500 = hour4index500==1 & min4index500 ==1;
clear hour4index500 min4index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_GRE.datetime4(time4index500,:),TRAFFICAVE_GRE.speed4(time4index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_GRE.datetime4(1,:),TRAFFICAVE_GRE.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:30 - 16:59')
hold off


hour4index530 = TRAFFICAVE_GRE.datevec4(:,4) == 17;
min4index530 = TRAFFICAVE_GRE.datevec4(:,5) < 30 & TRAFFICAVE_GRE.datevec4(:,5) >= 0;
time4index530 = hour4index530==1 & min4index530 ==1;
clear hour4index530 min4index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_GRE.datetime4(time4index530,:),TRAFFICAVE_GRE.speed4(time4index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_GRE.datetime4(1,:),TRAFFICAVE_GRE.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:00 - 17:29')
hold off


hour4index600 = TRAFFICAVE_GRE.datevec4(:,4) == 17;
min4index600 = TRAFFICAVE_GRE.datevec4(:,5) >= 30 & TRAFFICAVE_GRE.datevec4(:,5) < 59;
time4index600 = hour4index600==1 & min4index600 ==1;
clear hour4index600 min4index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_GRE.datetime4(time4index600,:),TRAFFICAVE_GRE.speed4(time4index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_GRE.datetime4(1,:),TRAFFICAVE_GRE.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:30 - 17:59')
hold off
% save plot
saveas(figure(7), '07S_W_Subplot.jpg');
% finally, delete all index
clear time4index430 time4index500 time4index530 time4index600
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler all_ylabels lhand statmeasure_tstamp3
clear statmeasure_tstamp4 tmcindex
toc

%% 1/5/2019 SUBPLOT GREEN MORNING S/W (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit4 = 45;
hour4index730 = AMTRAFFICAVE_GRE.datevec4(:,4) == 7;
min4index730 = AMTRAFFICAVE_GRE.datevec4(:,5)<30 & AMTRAFFICAVE_GRE.datevec4(:,5)>=0;
time4index730 = hour4index730==1 & min4index730 ==1;
% the only useful index variable is time4index730, so, I will delete
% hour4index730 and min4index730
clear hour4index730 min4index730
f = figure(8)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_GRE.datetime4(time4index730,:),AMTRAFFICAVE_GRE.speed4(time4index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_GRE.datetime4(1,:),AMTRAFFICAVE_GRE.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:00 - 7:29')
hold off


hour4index800 = AMTRAFFICAVE_GRE.datevec4(:,4) == 7;
min4index800 = AMTRAFFICAVE_GRE.datevec4(:,5) >= 30 & AMTRAFFICAVE_GRE.datevec4(:,5) < 59;
time4index800 = hour4index800==1 & min4index800 ==1;
clear hour4index800 min4index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_GRE.datetime4(time4index800,:),AMTRAFFICAVE_GRE.speed4(time4index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_GRE.datetime4(1,:),AMTRAFFICAVE_GRE.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:30 - 7:59')
hold off


hour4index830 = AMTRAFFICAVE_GRE.datevec4(:,4) == 8;
min4index830 = AMTRAFFICAVE_GRE.datevec4(:,5) < 30 & AMTRAFFICAVE_GRE.datevec4(:,5) >= 0;
time4index830 = hour4index830==1 & min4index830 ==1;
clear hour4index830 min4index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_GRE.datetime4(time4index830,:),AMTRAFFICAVE_GRE.speed4(time4index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_GRE.datetime4(1,:),AMTRAFFICAVE_GRE.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:00 - 8:29')
hold off


hour4index900 = AMTRAFFICAVE_GRE.datevec4(:,4) == 8;
min4index900 = AMTRAFFICAVE_GRE.datevec4(:,5) >= 30 & AMTRAFFICAVE_GRE.datevec4(:,5) < 59;
time4index900 = hour4index900==1 & min4index900 ==1;
clear hour4index900 min4index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_GRE.datetime4(time4index900,:),AMTRAFFICAVE_GRE.speed4(time4index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_GRE.datetime4(1,:),AMTRAFFICAVE_GRE.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:30 - 9:00')
hold off
% save plot
saveas(figure(8), '08S_W_Subplot_AM.jpg');
% finally, delete all index
clear time4index730 time4index800 time4index830 time4index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/5/2019 SUBPLOT PURPLE AFTERNOON S/W (NOT CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit4 = 55;
hour4index430 = TRAFFICAVE_PUR.datevec4(:,4) == 16;
min4index430 = TRAFFICAVE_PUR.datevec4(:,5)<30 & TRAFFICAVE_PUR.datevec4(:,5)>=0;
time4index430 = hour4index430==1 & min4index430 ==1;
% the only useful index variable is time4index430, so, I will delete
% hour4index430 and min4index430
clear hour4index430 min4index430
f = figure(9)
f.Position = [1,50,1500,700];
subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_PUR.datetime4(time4index430,:),TRAFFICAVE_PUR.speed4(time4index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_PUR.datetime4(1,:),TRAFFICAVE_PUR.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:00 - 16:29')
hold off


hour4index500 = TRAFFICAVE_PUR.datevec4(:,4) == 16;
min4index500 = TRAFFICAVE_PUR.datevec4(:,5) >= 30 & TRAFFICAVE_PUR.datevec4(:,5) < 59;
time4index500 = hour4index500==1 & min4index500 ==1;
clear hour4index500 min4index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_PUR.datetime4(time4index500,:),TRAFFICAVE_PUR.speed4(time4index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_PUR.datetime4(1,:),TRAFFICAVE_PUR.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:30 - 16:59')
hold off


hour4index530 = TRAFFICAVE_PUR.datevec4(:,4) == 17;
min4index530 = TRAFFICAVE_PUR.datevec4(:,5) < 30 & TRAFFICAVE_PUR.datevec4(:,5) >= 0;
time4index530 = hour4index530==1 & min4index530 ==1;
clear hour4index530 min4index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_PUR.datetime4(time4index530,:),TRAFFICAVE_PUR.speed4(time4index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_PUR.datetime4(1,:),TRAFFICAVE_PUR.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:00 - 17:29')
hold off


hour4index600 = TRAFFICAVE_PUR.datevec4(:,4) == 17;
min4index600 = TRAFFICAVE_PUR.datevec4(:,5) >= 30 & TRAFFICAVE_PUR.datevec4(:,5) < 59;
time4index600 = hour4index600==1 & min4index600 ==1;
clear hour4index600 min4index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_PUR.datetime4(time4index600,:),TRAFFICAVE_PUR.speed4(time4index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_PUR.datetime4(1,:),TRAFFICAVE_PUR.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:30 - 17:59')
hold off
% save plot
saveas(figure(9), '09S_W_Subplot.jpg');
% finally, delete all index
clear time4index430 time4index500 time4index530 time4index600
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler all_ylabels lhand statmeasure_tstamp3
clear statmeasure_tstamp4 tmcindex
toc

%% 1/5/2019 SUBPLOT PURPLE MORNING S/W (CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit4 = 55;
hour4index730 = AMTRAFFICAVE_PUR.datevec4(:,4) == 7;
min4index730 = AMTRAFFICAVE_PUR.datevec4(:,5)<30 & AMTRAFFICAVE_PUR.datevec4(:,5)>=0;
time4index730 = hour4index730==1 & min4index730 ==1;
% the only useful index variable is time4index730, so, I will delete
% hour4index730 and min4index730
clear hour4index730 min4index730
f = figure(10)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_PUR.datetime4(time4index730,:),AMTRAFFICAVE_PUR.speed4(time4index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_PUR.datetime4(1,:),AMTRAFFICAVE_PUR.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:00 - 7:29')
hold off


hour4index800 = AMTRAFFICAVE_PUR.datevec4(:,4) == 7;
min4index800 = AMTRAFFICAVE_PUR.datevec4(:,5) >= 30 & AMTRAFFICAVE_PUR.datevec4(:,5) < 59;
time4index800 = hour4index800==1 & min4index800 ==1;
clear hour4index800 min4index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_PUR.datetime4(time4index800,:),AMTRAFFICAVE_PUR.speed4(time4index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_PUR.datetime4(1,:),AMTRAFFICAVE_PUR.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:30 - 7:59')
hold off


hour4index830 = AMTRAFFICAVE_PUR.datevec4(:,4) == 8;
min4index830 = AMTRAFFICAVE_PUR.datevec4(:,5) < 30 & AMTRAFFICAVE_PUR.datevec4(:,5) >= 0;
time4index830 = hour4index830==1 & min4index830 ==1;
clear hour4index830 min4index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_PUR.datetime4(time4index830,:),AMTRAFFICAVE_PUR.speed4(time4index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_PUR.datetime4(1,:),AMTRAFFICAVE_PUR.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:00 - 8:29')
hold off


hour4index900 = AMTRAFFICAVE_PUR.datevec4(:,4) == 8;
min4index900 = AMTRAFFICAVE_PUR.datevec4(:,5) >= 30 & AMTRAFFICAVE_PUR.datevec4(:,5) < 59;
time4index900 = hour4index900==1 & min4index900 ==1;
clear hour4index900 min4index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_PUR.datetime4(time4index900,:),AMTRAFFICAVE_PUR.speed4(time4index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_PUR.datetime4(1,:),AMTRAFFICAVE_PUR.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:30 - 9:00')
hold off
% save plot
saveas(figure(10), '10S_W_Subplot_AM.jpg');
% finally, delete all index
clear time4index730 time4index800 time4index830 time4index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/5/2019 SUBPLOT YELLOW AFTERNOON S/W (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit4 = 45;
hour4index430 = TRAFFICAVE_YEL.datevec4(:,4) == 16;
min4index430 = TRAFFICAVE_YEL.datevec4(:,5)<30 & TRAFFICAVE_YEL.datevec4(:,5)>=0;
time4index430 = hour4index430==1 & min4index430 ==1;
% the only useful index variable is time4index430, so, I will delete
% hour4index430 and min4index430
clear hour4index430 min4index430
f = figure(11)
f.Position = [1,50,1500,700];
subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_YEL.datetime4(time4index430,:),TRAFFICAVE_YEL.speed4(time4index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_YEL.datetime4(1,:),TRAFFICAVE_YEL.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:00 - 16:29')
hold off


hour4index500 = TRAFFICAVE_YEL.datevec4(:,4) == 16;
min4index500 = TRAFFICAVE_YEL.datevec4(:,5) >= 30 & TRAFFICAVE_YEL.datevec4(:,5) < 59;
time4index500 = hour4index500==1 & min4index500 ==1;
clear hour4index500 min4index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_YEL.datetime4(time4index500,:),TRAFFICAVE_YEL.speed4(time4index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_YEL.datetime4(1,:),TRAFFICAVE_YEL.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:30 - 16:59')
hold off


hour4index530 = TRAFFICAVE_YEL.datevec4(:,4) == 17;
min4index530 = TRAFFICAVE_YEL.datevec4(:,5) < 30 & TRAFFICAVE_YEL.datevec4(:,5) >= 0;
time4index530 = hour4index530==1 & min4index530 ==1;
clear hour4index530 min4index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_YEL.datetime4(time4index530,:),TRAFFICAVE_YEL.speed4(time4index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_YEL.datetime4(1,:),TRAFFICAVE_YEL.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:00 - 17:29')
hold off


hour4index600 = TRAFFICAVE_YEL.datevec4(:,4) == 17;
min4index600 = TRAFFICAVE_YEL.datevec4(:,5) >= 30 & TRAFFICAVE_YEL.datevec4(:,5) < 59;
time4index600 = hour4index600==1 & min4index600 ==1;
clear hour4index600 min4index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_YEL.datetime4(time4index600,:),TRAFFICAVE_YEL.speed4(time4index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_YEL.datetime4(1,:),TRAFFICAVE_YEL.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:30 - 17:59')
hold off
% save plot
saveas(figure(11), '11S_W_Subplot.jpg');
% finally, delete all index
clear time4index430 time4index500 time4index530 time4index600
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler all_ylabels lhand statmeasure_tstamp3
clear statmeasure_tstamp4 tmcindex
toc

%% 1/5/2019 SUBPLOT YELLOW MORNING S/W (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit4 = 45;
hour4index730 = AMTRAFFICAVE_YEL.datevec4(:,4) == 7;
min4index730 = AMTRAFFICAVE_YEL.datevec4(:,5)<30 & AMTRAFFICAVE_YEL.datevec4(:,5)>=0;
time4index730 = hour4index730==1 & min4index730 ==1;
% the only useful index variable is time4index730, so, I will delete
% hour4index730 and min4index730
clear hour4index730 min4index730
f = figure(12)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_YEL.datetime4(time4index730,:),AMTRAFFICAVE_YEL.speed4(time4index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_YEL.datetime4(1,:),AMTRAFFICAVE_YEL.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:00 - 7:29')
hold off


hour4index800 = AMTRAFFICAVE_YEL.datevec4(:,4) == 7;
min4index800 = AMTRAFFICAVE_YEL.datevec4(:,5) >= 30 & AMTRAFFICAVE_YEL.datevec4(:,5) < 59;
time4index800 = hour4index800==1 & min4index800 ==1;
clear hour4index800 min4index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_YEL.datetime4(time4index800,:),AMTRAFFICAVE_YEL.speed4(time4index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_YEL.datetime4(1,:),AMTRAFFICAVE_YEL.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:30 - 7:59')
hold off


hour4index830 = AMTRAFFICAVE_YEL.datevec4(:,4) == 8;
min4index830 = AMTRAFFICAVE_YEL.datevec4(:,5) < 30 & AMTRAFFICAVE_YEL.datevec4(:,5) >= 0;
time4index830 = hour4index830==1 & min4index830 ==1;
clear hour4index830 min4index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_YEL.datetime4(time4index830,:),AMTRAFFICAVE_YEL.speed4(time4index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_YEL.datetime4(1,:),AMTRAFFICAVE_YEL.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:00 - 8:29')
hold off


hour4index900 = AMTRAFFICAVE_YEL.datevec4(:,4) == 8;
min4index900 = AMTRAFFICAVE_YEL.datevec4(:,5) >= 30 & AMTRAFFICAVE_YEL.datevec4(:,5) < 59;
time4index900 = hour4index900==1 & min4index900 ==1;
clear hour4index900 min4index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_YEL.datetime4(time4index900,:),AMTRAFFICAVE_YEL.speed4(time4index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_YEL.datetime4(1,:),AMTRAFFICAVE_YEL.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:30 - 9:00')
hold off
% save plot
saveas(figure(12), '12S_W_Subplot_AM.jpg');
% finally, delete all index
clear time4index730 time4index800 time4index830 time4index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%% 1/5/2019 SUBPLOT BLACK AFTERNOON S/W (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 430 is 4:00 - 4:30, etc
speedlimit4 = 45;
hour4index430 = TRAFFICAVE_BLA.datevec4(:,4) == 16;
min4index430 = TRAFFICAVE_BLA.datevec4(:,5)<30 & TRAFFICAVE_BLA.datevec4(:,5)>=0;
time4index430 = hour4index430==1 & min4index430 ==1;
% the only useful index variable is time4index430, so, I will delete
% hour4index430 and min4index430
clear hour4index430 min4index430
f = figure(13)
f.Position = [1,50,1500,700];
subplot(2,2,1)
grid minor
hold on
plot(TRAFFICAVE_BLA.datetime4(time4index430,:),TRAFFICAVE_BLA.speed4(time4index430),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLA.datetime4(1,:),TRAFFICAVE_BLA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:00 - 16:29')
hold off


hour4index500 = TRAFFICAVE_BLA.datevec4(:,4) == 16;
min4index500 = TRAFFICAVE_BLA.datevec4(:,5) >= 30 & TRAFFICAVE_BLA.datevec4(:,5) < 59;
time4index500 = hour4index500==1 & min4index500 ==1;
clear hour4index500 min4index500
subplot(2,2,2)
grid minor
hold on
plot(TRAFFICAVE_BLA.datetime4(time4index500,:),TRAFFICAVE_BLA.speed4(time4index500),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLA.datetime4(1,:),TRAFFICAVE_BLA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 16:30 - 16:59')
hold off


hour4index530 = TRAFFICAVE_BLA.datevec4(:,4) == 17;
min4index530 = TRAFFICAVE_BLA.datevec4(:,5) < 30 & TRAFFICAVE_BLA.datevec4(:,5) >= 0;
time4index530 = hour4index530==1 & min4index530 ==1;
clear hour4index530 min4index530
subplot(2,2,3)
grid minor
hold on
plot(TRAFFICAVE_BLA.datetime4(time4index530,:),TRAFFICAVE_BLA.speed4(time4index530),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLA.datetime4(1,:),TRAFFICAVE_BLA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:00 - 17:29')
hold off


hour4index600 = TRAFFICAVE_BLA.datevec4(:,4) == 17;
min4index600 = TRAFFICAVE_BLA.datevec4(:,5) >= 30 & TRAFFICAVE_BLA.datevec4(:,5) < 59;
time4index600 = hour4index600==1 & min4index600 ==1;
clear hour4index600 min4index600
subplot(2,2,4)
grid minor
hold on
plot(TRAFFICAVE_BLA.datetime4(time4index600,:),TRAFFICAVE_BLA.speed4(time4index600),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([TRAFFICAVE_BLA.datetime4(1,:),TRAFFICAVE_BLA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 17:30 - 17:59')
hold off
% save plot
saveas(figure(13), '13S_W_Subplot.jpg');
% finally, delete all index
clear time4index430 time4index500 time4index530 time4index600
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler all_ylabels lhand statmeasure_tstamp3
clear statmeasure_tstamp4 tmcindex
toc

%% 1/5/2019 SUBPLOT BLACK MORNING S/W (DONT RUN CONGESTED) 
tic
% I will use suffix to represent the ending time point of each time period
% eg. 730 is 7:00 - 7:30, etc
speedlimit4 = 45;
hour4index730 = AMTRAFFICAVE_BLA.datevec4(:,4) == 7;
min4index730 = AMTRAFFICAVE_BLA.datevec4(:,5)<30 & AMTRAFFICAVE_BLA.datevec4(:,5)>=0;
time4index730 = hour4index730==1 & min4index730 ==1;
% the only useful index variable is time4index730, so, I will delete
% hour4index730 and min4index730
clear hour4index730 min4index730
f = figure(14)
f.Position = [1,50,1500,700];
ax1 = subplot(2,2,1)
grid minor
hold on
plot(AMTRAFFICAVE_BLA.datetime4(time4index730,:),AMTRAFFICAVE_BLA.speed4(time4index730),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLA.datetime4(1,:),AMTRAFFICAVE_BLA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:00 - 7:29')
hold off


hour4index800 = AMTRAFFICAVE_BLA.datevec4(:,4) == 7;
min4index800 = AMTRAFFICAVE_BLA.datevec4(:,5) >= 30 & AMTRAFFICAVE_BLA.datevec4(:,5) < 59;
time4index800 = hour4index800==1 & min4index800 ==1;
clear hour4index800 min4index800
subplot(2,2,2)
grid minor
hold on
plot(AMTRAFFICAVE_BLA.datetime4(time4index800,:),AMTRAFFICAVE_BLA.speed4(time4index800),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLA.datetime4(1,:),AMTRAFFICAVE_BLA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 7:30 - 7:59')
hold off


hour4index830 = AMTRAFFICAVE_BLA.datevec4(:,4) == 8;
min4index830 = AMTRAFFICAVE_BLA.datevec4(:,5) < 30 & AMTRAFFICAVE_BLA.datevec4(:,5) >= 0;
time4index830 = hour4index830==1 & min4index830 ==1;
clear hour4index830 min4index830
subplot(2,2,3)
grid minor
hold on
plot(AMTRAFFICAVE_BLA.datetime4(time4index830,:),AMTRAFFICAVE_BLA.speed4(time4index830),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLA.datetime4(1,:),AMTRAFFICAVE_BLA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:00 - 8:29')
hold off


hour4index900 = AMTRAFFICAVE_BLA.datevec4(:,4) == 8;
min4index900 = AMTRAFFICAVE_BLA.datevec4(:,5) >= 30 & AMTRAFFICAVE_BLA.datevec4(:,5) < 59;
time4index900 = hour4index900==1 & min4index900 ==1;
clear hour4index900 min4index900
subplot(2,2,4)
grid minor
hold on
plot(AMTRAFFICAVE_BLA.datetime4(time4index900,:),AMTRAFFICAVE_BLA.speed4(time4index900),...
    'LineWidth',1.2);
set(gca,'FontSize',9)
lhand = line([AMTRAFFICAVE_BLA.datetime4(1,:),AMTRAFFICAVE_BLA.datetime4(end,:)],[speedlimit4,speedlimit4]);
lhand.Color = 'r';
lhand.LineStyle = '--';
lhand.LineWidth = 1;
%
new_tick = speedlimit4;
new_fontsize = 9;
new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
ax = gca;
yruler = ax.YRuler;
old_fmt = yruler.TickLabelFormat;
old_yticks = yruler.TickValues;
old_labels = sprintfc(old_fmt, old_yticks);
new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick);
all_yticks = [old_yticks, new_tick];
all_ylabels = [old_labels, new_label];
[new_yticks, sort_order] = sort(all_yticks);
new_labels = all_ylabels(sort_order);
try
    set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
catch
    warning('skipeped here')
end
%
xlabel('Time')
ylabel('Average Speed')
legend('Average Speed','Speed Limit','Location','Best')
title('Average Speed - Time (Philadelphia S/W) 8:30 - 9:00')
hold off
% save plot
saveas(figure(14), '14S_W_Subplot_AM.jpg');
% finally, delete all index
clear time4index730 time4index800 time4index830 time4index900 all_ylabels
clear all_yticks ax ax1 new_fontsize new_label new_labels new_tick
clear new_tick_rgb new_yticks old_fmt old_labels old_yticks sort_order
clear yruler
toc

%%
clear f lhand speedlimit3_ora speedlimit4 speedlimit4_ora

%% 1/6/2019 SPEED-TIME PLOT ORANGE AFTERNOON 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=TRAFFICAVE_ORA.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(TRAFFICAVE_ORA.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)==0']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(TRAFFICAVE_ORA.datetime3 <= end3minute',num2str(i), '& TRAFFICAVE_ORA.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= TRAFFICAVE_ORA.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',TRAFFICAVE_ORA.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(TRAFFICAVE_ORA.speed3(xmonth3dayindex', num2str(i),'))-3, max(TRAFFICAVE_ORA.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_ORA',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=TRAFFICAVE_ORA.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(TRAFFICAVE_ORA.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)==0']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(TRAFFICAVE_ORA.datetime4 <= end4minute',num2str(i), '& TRAFFICAVE_ORA.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= TRAFFICAVE_ORA.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',TRAFFICAVE_ORA.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(TRAFFICAVE_ORA.speed4(xmonth4dayindex', num2str(i),'))-3, max(TRAFFICAVE_ORA.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_ORA',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT ORANGE MORNING 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=AMTRAFFICAVE_ORA.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(AMTRAFFICAVE_ORA.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)==0']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(AMTRAFFICAVE_ORA.datetime3 <= end3minute',num2str(i), '& AMTRAFFICAVE_ORA.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= AMTRAFFICAVE_ORA.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',AMTRAFFICAVE_ORA.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,AMTRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(AMTRAFFICAVE_ORA.speed3(xmonth3dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_ORA.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(AMTRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(AMTRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_ORA_AM',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=AMTRAFFICAVE_ORA.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(AMTRAFFICAVE_ORA.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)==0']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(AMTRAFFICAVE_ORA.datetime4 <= end4minute',num2str(i), '& AMTRAFFICAVE_ORA.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= AMTRAFFICAVE_ORA.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',AMTRAFFICAVE_ORA.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(AMTRAFFICAVE_ORA.speed4(xmonth4dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_ORA.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_ORA_AM',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT RED AFTERNOON 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=TRAFFICAVE_RED.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(TRAFFICAVE_RED.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)==0']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(TRAFFICAVE_RED.datetime3 <= end3minute',num2str(i), '& TRAFFICAVE_RED.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= TRAFFICAVE_RED.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',TRAFFICAVE_RED.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(TRAFFICAVE_RED.speed3(xmonth3dayindex', num2str(i),'))-3, max(TRAFFICAVE_RED.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_RED',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=TRAFFICAVE_RED.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(TRAFFICAVE_RED.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)==0']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(TRAFFICAVE_RED.datetime4 <= end4minute',num2str(i), '& TRAFFICAVE_RED.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= TRAFFICAVE_RED.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',TRAFFICAVE_RED.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(TRAFFICAVE_RED.speed4(xmonth4dayindex', num2str(i),'))-3, max(TRAFFICAVE_RED.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_RED',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT RED MORNING 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=AMTRAFFICAVE_RED.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(AMTRAFFICAVE_RED.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)<5']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(AMTRAFFICAVE_RED.datetime3 <= end3minute',num2str(i), '& AMTRAFFICAVE_RED.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= AMTRAFFICAVE_RED.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',AMTRAFFICAVE_RED.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(AMTRAFFICAVE_RED.speed3(xmonth3dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_RED.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_RED_AM',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=AMTRAFFICAVE_RED.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(AMTRAFFICAVE_RED.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)<5']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(AMTRAFFICAVE_RED.datetime4 <= end4minute',num2str(i), '& AMTRAFFICAVE_RED.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= AMTRAFFICAVE_RED.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',AMTRAFFICAVE_RED.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(AMTRAFFICAVE_RED.speed4(xmonth4dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_RED.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_RED_AM',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT BLUE AFTERNOON 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=TRAFFICAVE_BLU.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(TRAFFICAVE_BLU.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)<1']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(TRAFFICAVE_BLU.datetime3 <= end3minute',num2str(i), '& TRAFFICAVE_BLU.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= TRAFFICAVE_BLU.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',TRAFFICAVE_BLU.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(TRAFFICAVE_BLU.speed3(xmonth3dayindex', num2str(i),'))-3, max(TRAFFICAVE_BLU.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_BLU',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=TRAFFICAVE_BLU.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(TRAFFICAVE_BLU.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)<1']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(TRAFFICAVE_BLU.datetime4 <= end4minute',num2str(i), '& TRAFFICAVE_BLU.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= TRAFFICAVE_BLU.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',TRAFFICAVE_BLU.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(TRAFFICAVE_BLU.speed4(xmonth4dayindex', num2str(i),'))-3, max(TRAFFICAVE_BLU.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_BLU',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT BLUE MORNING 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=AMTRAFFICAVE_BLU.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(AMTRAFFICAVE_BLU.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(AMTRAFFICAVE_BLU.datetime3 <= end3minute',num2str(i), '& AMTRAFFICAVE_BLU.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= AMTRAFFICAVE_BLU.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',AMTRAFFICAVE_BLU.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,AMTRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(AMTRAFFICAVE_BLU.speed3(xmonth3dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_BLU.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(AMTRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(AMTRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_BLU_AM',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=AMTRAFFICAVE_BLU.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(AMTRAFFICAVE_BLU.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(AMTRAFFICAVE_BLU.datetime4 <= end4minute',num2str(i), '& AMTRAFFICAVE_BLU.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= AMTRAFFICAVE_BLU.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',AMTRAFFICAVE_BLU.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(AMTRAFFICAVE_BLU.speed4(xmonth4dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_BLU.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_BLU_AM',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT GREEN AFTERNOON (DONT RUN) 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=TRAFFICAVE_GRE.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(TRAFFICAVE_GRE.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(TRAFFICAVE_GRE.datetime3 <= end3minute',num2str(i), '& TRAFFICAVE_GRE.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= TRAFFICAVE_GRE.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',TRAFFICAVE_GRE.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(TRAFFICAVE_GRE.speed3(xmonth3dayindex', num2str(i),'))-3, max(TRAFFICAVE_GRE.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_GRE',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=TRAFFICAVE_GRE.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(TRAFFICAVE_GRE.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(TRAFFICAVE_GRE.datetime4 <= end4minute',num2str(i), '& TRAFFICAVE_GRE.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= TRAFFICAVE_GRE.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',TRAFFICAVE_GRE.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(TRAFFICAVE_GRE.speed4(xmonth4dayindex', num2str(i),'))-3, max(TRAFFICAVE_GRE.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_GRE',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT GREEN MORNING (DONT RUN) 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=AMTRAFFICAVE_GRE.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(AMTRAFFICAVE_GRE.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(AMTRAFFICAVE_GRE.datetime3 <= end3minute',num2str(i), '& AMTRAFFICAVE_GRE.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= AMTRAFFICAVE_GRE.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',AMTRAFFICAVE_GRE.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(AMTRAFFICAVE_GRE.speed3(xmonth3dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_GRE.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_GRE_AM',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=AMTRAFFICAVE_GRE.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(AMTRAFFICAVE_GRE.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(AMTRAFFICAVE_GRE.datetime4 <= end4minute',num2str(i), '& AMTRAFFICAVE_GRE.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= AMTRAFFICAVE_GRE.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',AMTRAFFICAVE_GRE.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(AMTRAFFICAVE_GRE.speed4(xmonth4dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_GRE.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_GRE_AM',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT PURPLE AFTERNOON 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=TRAFFICAVE_PUR.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(TRAFFICAVE_PUR.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(TRAFFICAVE_PUR.datetime3 <= end3minute',num2str(i), '& TRAFFICAVE_PUR.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= TRAFFICAVE_PUR.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',TRAFFICAVE_PUR.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(TRAFFICAVE_PUR.speed3(xmonth3dayindex', num2str(i),'))-3, max(TRAFFICAVE_PUR.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_PUR',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=TRAFFICAVE_PUR.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(TRAFFICAVE_PUR.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,16,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(TRAFFICAVE_PUR.datetime4 <= end4minute',num2str(i), '& TRAFFICAVE_PUR.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= TRAFFICAVE_PUR.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',TRAFFICAVE_PUR.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(TRAFFICAVE_PUR.speed4(xmonth4dayindex', num2str(i),'))-3, max(TRAFFICAVE_PUR.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_PUR',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%% 1/6/2019 SPEED-TIME PLOT PURPLE MORNING 
% pick a specific day to take a look at if congestion appeared.
tic
for i=5:10
    eval(['month3index',num2str(i),'=AMTRAFFICAVE_PUR.datevec3(:,2) == i;']);
    eval(['day3stat',num2str(i),'=tabulate(AMTRAFFICAVE_PUR.datevec3(month3index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day3stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start3minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end3minute',num2str(i),'= start3minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth3dayindex',num2str(i),'=find(AMTRAFFICAVE_PUR.datetime3 <= end3minute',num2str(i), '& AMTRAFFICAVE_PUR.datetime3 >= start3minute',num2str(i),');']);
    
    eval(['xmonth3day', num2str(i),'= AMTRAFFICAVE_PUR.datetime3(xmonth3dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i-4)
    hold on
    grid minor
    eval(['H3month',num2str(i), '= plot(xmonth3day',num2str(i),',AMTRAFFICAVE_PUR.speed3(xmonth3dayindex',num2str(i),'))'])
    % H3month7 = plot(xmonth3day7,TRAFFICREMOVE.speed3(xmonth3dayindex7))
    eval(['H3month',num2str(i), '.LineWidth = 1.5'])
    % H3month7.LineWidth = 1.5;
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth3day',num2str(i),'), max(xmonth3day',num2str(i),') + minutes(5)]);']);
    % xlim([min(xmonth3day7), max(xmonth3day7) + minutes(5)]);
    eval(['ylim([min(AMTRAFFICAVE_PUR.speed3(xmonth3dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_PUR.speed3(xmonth3dayindex',num2str(i),'))+3]);']);
    % ylim([min(TRAFFICREMOVE.speed3(xmonth3dayindex7)) - 3, max(TRAFFICREMOVE.speed3(xmonth3dayindex7)) + 3]);
    legend('One-day Speed-Time graph(Northbound/Eastbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (N/E)')
    hold off

    eval(['saveas(figure(i-4),','''_N_E_PUR_AM',num2str(i-4),'.jpg'');']);
    % saveas(figure(7), 'N_E7.jpg'); https://blog.csdn.net/a573233077/article/details/48543333
end
toc
%Elapsed time is 12.642930 seconds.


% DO THE same thing for Southbound/Westbound
tic
for i=5:10
    eval(['month4index',num2str(i),'=AMTRAFFICAVE_PUR.datevec4(:,2) == i;']);
    eval(['day4stat',num2str(i),'=tabulate(AMTRAFFICAVE_PUR.datevec4(month4index',num2str(i),',3));']);
    
    for j = 1:31
        if(eval(['day4stat',num2str(i),'(j,2)<10']))
            continue
        end
        break
    end
    
    eval(['start4minute',num2str(i),'=',' datetime(2015,i,j,7,0,0);'])
    
    eval(['end4minute',num2str(i),'= start4minute',num2str(i),'+hours(6);'])
    
    eval(['xmonth4dayindex',num2str(i),'=find(AMTRAFFICAVE_PUR.datetime4 <= end4minute',num2str(i), '& AMTRAFFICAVE_PUR.datetime4 >= start4minute',num2str(i),');']);
    
    eval(['xmonth4day', num2str(i),'= AMTRAFFICAVE_PUR.datetime4(xmonth4dayindex',num2str(i),');']);
end


for i = 5:10
    figure(i+2)
    hold on
    grid minor
    eval(['H4month',num2str(i), '= plot(xmonth4day',num2str(i),',AMTRAFFICAVE_PUR.speed4(xmonth4dayindex',num2str(i),'))'])
    eval(['H4month',num2str(i), '.LineWidth = 1.5'])
    
    set(gca,'FontSize',9)
    eval(['xlim([min(xmonth4day',num2str(i),'), max(xmonth4day',num2str(i),') + minutes(5)]);']);
    eval(['ylim([min(AMTRAFFICAVE_PUR.speed4(xmonth4dayindex', num2str(i),'))-3, max(AMTRAFFICAVE_PUR.speed4(xmonth4dayindex',num2str(i),'))+3]);']);
    legend('One-day Speed-Time graph(Southbound/Westbound)',[230,285,1,.04]);
    xlabel('Time')
    ylabel('Average Speed (mph)')
    title('Speed-Time (S/W)')
    hold off

    eval(['saveas(figure(i+2),','''_S_W_PUR_AM',num2str(i+2),'.jpg'');']);
end
toc
clear day3stat5 day3stat6 day3stat7 day3stat8 day3stat9 day3stat10
clear day4stat5 day4stat6 day4stat7 day4stat8 day4stat9 day4stat10
clear confscoreindex3 confscoreindex4
clear end3minute5 end3minute6 end3minute7 end3minute8 end3minute9 end3minute10
clear end4minute5 end4minute6 end4minute7 end4minute8 end4minute9 end4minute10
clear dateindex directionindex3 directionindex4
clear H3month5 H3month6 H3month7 H3month8 H3month9 H3month10
clear H4month5 H4month6 H4month7 H4month8 H4month9 H4month10
clear month3index5 month3index6 month3index7 month3index8 month3index9 month3index10
clear month4index5 month4index6 month4index7 month4index8 month4index9 month4index10
clear i j start3minute5 start3minute6 start3minute7 start3minute8 start3minute9 start3minute10
clear start4minute5 start4minute6 start4minute7 start4minute8 start4minute9 start4minute10
clear xmonth3day5 xmonth3day6 xmonth3day7 xmonth3day8 xmonth3day9 xmonth3day10
clear xmonth4day5 xmonth4day6 xmonth4day7 xmonth4day8 xmonth4day9 xmonth4day10
clear xmonth3dayindex5 xmonth3dayindex6 xmonth3dayindex7 xmonth3dayindex8 xmonth3dayindex9 xmonth3dayindex10
clear xmonth4dayindex5 xmonth4dayindex6 xmonth4dayindex7 xmonth4dayindex8 xmonth4dayindex9 xmonth4dayindex10
clear numdata0 preciPHLationnonemptyindex0 namesTRAFFICAVE indexmeasure_tstamp3 indexmeasure_tstamp4
clear clearfreeflowspeedindex3 clearfreeflowspeedindex4
%Elapsed time is 12.642930 seconds.

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (IGNORED) 11/19/2018 TRY EACH DAYS FOR EACH MONTH SPEED-TIME PLOT
tic
congestion3 = 40;
for j = 5:10
    dateinmonth3 = unique(TRAFFICAVE.datevec3(TRAFFICAVE.datevec3(:,2)==j,3));
    if(numel(dateinmonth3(:,1)) > 27)
        n = 4;  % if this month has 27+ days' data, we need 4 figures for this month
    elseif(numel(dateinmonth3(:,1)) <= 27)
        n = 3;  % if this month has 27- days' data, we need 3 figures for this month
    end
    
    for i = 1: numel(dateinmonth3(:,1))
        speedvalue3 = TRAFFICAVE.speed3(TRAFFICAVE.datevec3(:,2)==j & TRAFFICAVE.datevec3(:,3)==dateinmonth3(i,1),:);
        timevalue3 = TRAFFICAVE.datetime3(TRAFFICAVE.datevec3(:,2)==j & TRAFFICAVE.datevec3(:,3)==dateinmonth3(i,1),:);
        if (i<=9)
            f = figure(100+(j-5)*n+1)
            f.Position = [1,50,1500,700];
            subplot(3,3,i)
            hold on
            grid minor
            plot(timevalue3,speedvalue3,'LineWidth',1.2);
            set(gca,'FontSize',9)
            ylim([min(TRAFFICAVE.speed3)-0.5, max(TRAFFICAVE.speed3)+0.5])
            xlim([min(timevalue3), max(timevalue3)])
            %
            lhand = line([TRAFFICAVE.datetime3(1,:),TRAFFICAVE.datetime3(end,:)],[speedlimit3,speedlimit3]);
            lhand.Color = 'r';
            lhand.LineStyle = '--';
            lhand.LineWidth = 1;
            lhandc = line([TRAFFICAVE.datetime3(1,:),TRAFFICAVE.datetime3(end,:)],[congestion3,congestion3]); % Congestion Cutoff Line
            lhandc.Color = 'g';
            lhandc.LineStyle = '--';
            lhandc.LineWidth = 1;
            new_tick = speedlimit3;
            new_fontsize = 9;
            new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
            ax = gca;
            yruler = ax.YRuler;
            old_fmt = yruler.TickLabelFormat;
            old_yticks = yruler.TickValues;
            old_labels = sprintfc(old_fmt, old_yticks);
            new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick(1));
            all_yticks = [old_yticks, new_tick];
            all_ylabels = [old_labels, new_label];
            [new_yticks, sort_order] = sort(all_yticks);
            new_labels = all_ylabels(sort_order);
            set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
            if(i==9)
                legend('Average Speed','Speed Limit','Congestion Cutoff','Location','Best')
            end
            %
            xlabel('Time')
            ylabel('Average Speed')
            title('Average Speed - Time (Philadelphia (Northbound/Eastbound))')
            saveas(figure(100+(j-5)*n+1), strcat(num2str(100+(j-5)*n+1),'_N_E_ST.jpg'));
            hold off
        elseif(i>9 & i<=18)
            f = figure(100+(j-5)*n+2)
            f.Position = [1,50,1500,700];
            subplot(3,3,i-9)
            hold on
            grid minor
            plot(timevalue3, speedvalue3,'LineWidth',1.2);
            set(gca,'FontSize',9)
            ylim([min(TRAFFICAVE.speed3)-0.5, max(TRAFFICAVE.speed3)+0.5])
            xlim([min(timevalue3), max(timevalue3)])
            %
            lhand = line([TRAFFICAVE.datetime3(1,:),TRAFFICAVE.datetime3(end,:)],[speedlimit3,speedlimit3]);
            lhand.Color = 'r';
            lhand.LineStyle = '--';
            lhand.LineWidth = 1;
            lhandc = line([TRAFFICAVE.datetime3(1,:),TRAFFICAVE.datetime3(end,:)],[congestion3,congestion3]); % Congestion Cutoff Line
            lhandc.Color = 'g';
            lhandc.LineStyle = '--';
            lhandc.LineWidth = 1;
            new_tick = speedlimit3;
            new_fontsize = 9;
            new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
            ax = gca;
            yruler = ax.YRuler;
            old_fmt = yruler.TickLabelFormat;
            old_yticks = yruler.TickValues;
            old_labels = sprintfc(old_fmt, old_yticks);
            new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick(1));
            all_yticks = [old_yticks, new_tick];
            all_ylabels = [old_labels, new_label];
            [new_yticks, sort_order] = sort(all_yticks);
            new_labels = all_ylabels(sort_order);
            set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
            if(i==18)
                legend('Average Speed','Speed Limit','Congestion Cutoff','Location','Best')
            end
            %
            xlabel('Time')
            ylabel('Average Speed')
            title('Average Speed - Time (Philadelphia (Northbound/Eastbound))')
            saveas(figure(100+(j-5)*n+2), strcat(num2str(100+(j-5)*n+2),'_N_E_ST.jpg'));
            hold off
        elseif(i>18 & i<=27)
            f = figure(100+(j-5)*n+3)
            f.Position = [1,50,1500,700];
            subplot(3,3,i-18)
            hold on
            grid minor
            plot(timevalue3, speedvalue3,'LineWidth',1.2);
            set(gca,'FontSize',9)
            ylim([min(TRAFFICAVE.speed3)-0.5, max(TRAFFICAVE.speed3)+0.5])
            xlim([min(timevalue3), max(timevalue3)])
            %
            lhand = line([TRAFFICAVE.datetime3(1,:),TRAFFICAVE.datetime3(end,:)],[speedlimit3,speedlimit3]);
            lhand.Color = 'r';
            lhand.LineStyle = '--';
            lhand.LineWidth = 1;
            lhandc = line([TRAFFICAVE.datetime3(1,:),TRAFFICAVE.datetime3(end,:)],[congestion3,congestion3]); % Congestion Cutoff Line
            lhandc.Color = 'g';
            lhandc.LineStyle = '--';
            lhandc.LineWidth = 1;
            new_tick = speedlimit3;
            new_fontsize = 9;
            new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
            ax = gca;
            yruler = ax.YRuler;
            old_fmt = yruler.TickLabelFormat;
            old_yticks = yruler.TickValues;
            old_labels = sprintfc(old_fmt, old_yticks);
            new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick(1));
            all_yticks = [old_yticks, new_tick];
            all_ylabels = [old_labels, new_label];
            [new_yticks, sort_order] = sort(all_yticks);
            new_labels = all_ylabels(sort_order);
            set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
            if(i==27 | i==numel(dateinmonth3(:,1)))
                legend('Average Speed','Speed Limit','Congestion Cutoff','Location','Best')
            end
            %
            xlabel('Time')
            ylabel('Average Speed')
            title('Average Speed - Time (Philadelphia (Northbound/Eastbound))')
            saveas(figure(100+(j-5)*n+3), strcat(num2str(100+(j-5)*n+3),'_N_E_ST.jpg'));
            hold off
        else
            f = figure(100+(j-5)*n+4)
            f.Position = [1,50,1500,700];
            subplot(3,3,i-27)
            hold on
            grid minor
            plot(timevalue3, speedvalue3,'LineWidth',1.2);
            set(gca,'FontSize',9)
            ylim([min(TRAFFICAVE.speed3)-0.5, max(TRAFFICAVE.speed3)+0.5])
            xlim([min(timevalue3), max(timevalue3)])
            %
            lhand = line([TRAFFICAVE.datetime3(1,:),TRAFFICAVE.datetime3(end,:)],[speedlimit3,speedlimit3]);
            lhand.Color = 'r';
            lhand.LineStyle = '--';
            lhand.LineWidth = 1;
            lhandc = line([TRAFFICAVE.datetime3(1,:),TRAFFICAVE.datetime3(end,:)],[congestion3,congestion3]); % Congestion Cutoff Line
            lhandc.Color = 'g';
            lhandc.LineStyle = '--';
            lhandc.LineWidth = 1;
            new_tick = speedlimit3;
            new_fontsize = 9;
            new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
            ax = gca;
            yruler = ax.YRuler;
            old_fmt = yruler.TickLabelFormat;
            old_yticks = yruler.TickValues;
            old_labels = sprintfc(old_fmt, old_yticks);
            new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick(1));
            all_yticks = [old_yticks, new_tick];
            all_ylabels = [old_labels, new_label];
            [new_yticks, sort_order] = sort(all_yticks);
            new_labels = all_ylabels(sort_order);
            set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
            if(i == numel(dateinmonth3(:,1)))
                legend('Average Speed','Speed Limit','Congestion Cutoff','Location','Best')
            end
            %
            xlabel('Time')
            ylabel('Average Speed')
            title('Average Speed - Time (Philadelphia (Northbound/Eastbound))')
            saveas(figure(100+(j-5)*n+4), strcat(num2str(100+(j-5)*n+4),'_N_E_ST.jpg'));
            hold off
        end
    end
end
toc
% Elapsed time is 400.436002 seconds.

%% (IGNORED) 11/19/2018 TRY EACH DAYS FOR EACH MONTH SPEED-TIME PLOT
congestion4 = 40;
for j = 5:10
    dateinmonth4 = unique(TRAFFICAVE.datevec4(TRAFFICAVE.datevec4(:,2)==j,3));
    if(numel(dateinmonth4(:,1)) > 27)
        n = 4;  % if this month has 27+ days' data, we need 4 figures for this month
    elseif(numel(dateinmonth4(:,1)) <= 27)
        n = 3;  % if this month has 27- days' data, we need 3 figures for this month
    end
    
    for i = 1: numel(dateinmonth4(:,1))
        speedvalue4 = TRAFFICAVE.speed4(TRAFFICAVE.datevec4(:,2)==j & TRAFFICAVE.datevec4(:,3)==dateinmonth4(i,1),:);
        timevalue4 = TRAFFICAVE.datetime4(TRAFFICAVE.datevec4(:,2)==j & TRAFFICAVE.datevec4(:,3)==dateinmonth4(i,1),:);
        if (i<=9)
            f = figure(100+(j-5)*n+1)
            f.Position = [1,50,1500,700];
            subplot(3,3,i)
            hold on
            grid minor
            plot(timevalue4,speedvalue4,'LineWidth',1.2);
            set(gca,'FontSize',9)
            ylim([min(TRAFFICAVE.speed4)-0.5, max(TRAFFICAVE.speed4)+0.5])
            xlim([min(timevalue4), max(timevalue4)])
            %
            lhand = line([TRAFFICAVE.datetime4(1,:),TRAFFICAVE.datetime4(end,:)],[speedlimit4,speedlimit4]);
            lhand.Color = 'r';
            lhand.LineStyle = '--';
            lhand.LineWidth = 1;
            lhandc = line([TRAFFICAVE.datetime4(1,:),TRAFFICAVE.datetime4(end,:)],[congestion4,congestion4]); % Congestion Cutoff Line
            lhandc.Color = 'g';
            lhandc.LineStyle = '--';
            lhandc.LineWidth = 1;
            new_tick = speedlimit4;
            new_fontsize = 9;
            new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
            ax = gca;
            yruler = ax.YRuler;
            old_fmt = yruler.TickLabelFormat;
            old_yticks = yruler.TickValues;
            old_labels = sprintfc(old_fmt, old_yticks);
            new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick(1));
            all_yticks = [old_yticks, new_tick];
            all_ylabels = [old_labels, new_label];
            [new_yticks, sort_order] = sort(all_yticks);
            new_labels = all_ylabels(sort_order);
            set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
            if(i==9)
                legend('Average Speed','Speed Limit','Congestion Cutoff','Location','Best')
            end
            %
            xlabel('Time')
            ylabel('Average Speed')
            title('Average Speed - Time (Philadelphia (Southbound/Westbound))')
            saveas(figure(100+(j-5)*n+1), strcat(num2str(100+(j-5)*n+1),'_S_W_ST.jpg'));
            hold off
        elseif(i>9 & i<=18)
            f = figure(100+(j-5)*n+2)
            f.Position = [1,50,1500,700];
            subplot(3,3,i-9)
            hold on
            grid minor
            plot(timevalue4, speedvalue4,'LineWidth',1.2);
            set(gca,'FontSize',9)
            ylim([min(TRAFFICAVE.speed4)-0.5, max(TRAFFICAVE.speed4)+0.5])
            xlim([min(timevalue4), max(timevalue4)])
            %
            lhand = line([TRAFFICAVE.datetime4(1,:),TRAFFICAVE.datetime4(end,:)],[speedlimit4,speedlimit4]);
            lhand.Color = 'r';
            lhand.LineStyle = '--';
            lhand.LineWidth = 1;
            lhandc = line([TRAFFICAVE.datetime4(1,:),TRAFFICAVE.datetime4(end,:)],[congestion4,congestion4]); % Congestion Cutoff Line
            lhandc.Color = 'g';
            lhandc.LineStyle = '--';
            lhandc.LineWidth = 1;
            new_tick = speedlimit4;
            new_fontsize = 9;
            new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
            ax = gca;
            yruler = ax.YRuler;
            old_fmt = yruler.TickLabelFormat;
            old_yticks = yruler.TickValues;
            old_labels = sprintfc(old_fmt, old_yticks);
            new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick(1));
            all_yticks = [old_yticks, new_tick];
            all_ylabels = [old_labels, new_label];
            [new_yticks, sort_order] = sort(all_yticks);
            new_labels = all_ylabels(sort_order);
            set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
            if(i==18)
                legend('Average Speed','Speed Limit','Congestion Cutoff','Location','Best')
            end
            %
            xlabel('Time')
            ylabel('Average Speed')
            title('Average Speed - Time (Philadelphia (Southbound/Westbound))')
            saveas(figure(100+(j-5)*n+2), strcat(num2str(100+(j-5)*n+2),'_S_W_ST.jpg'));
            hold off
        elseif(i>18 & i<=27)
            f = figure(100+(j-5)*n+3)
            f.Position = [1,50,1500,700];
            subplot(3,3,i-18)
            hold on
            grid minor
            plot(timevalue4, speedvalue4,'LineWidth',1.2);
            set(gca,'FontSize',9)
            ylim([min(TRAFFICAVE.speed4)-0.5, max(TRAFFICAVE.speed4)+0.5])
            xlim([min(timevalue4), max(timevalue4)])
            %
            lhand = line([TRAFFICAVE.datetime4(1,:),TRAFFICAVE.datetime4(end,:)],[speedlimit4,speedlimit4]);
            lhand.Color = 'r';
            lhand.LineStyle = '--';
            lhand.LineWidth = 1;
            lhandc = line([TRAFFICAVE.datetime4(1,:),TRAFFICAVE.datetime4(end,:)],[congestion4,congestion4]); % Congestion Cutoff Line
            lhandc.Color = 'g';
            lhandc.LineStyle = '--';
            lhandc.LineWidth = 1;
            new_tick = speedlimit4;
            new_fontsize = 9;
            new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
            ax = gca;
            yruler = ax.YRuler;
            old_fmt = yruler.TickLabelFormat;
            old_yticks = yruler.TickValues;
            old_labels = sprintfc(old_fmt, old_yticks);
            new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick(1));
            all_yticks = [old_yticks, new_tick];
            all_ylabels = [old_labels, new_label];
            [new_yticks, sort_order] = sort(all_yticks);
            new_labels = all_ylabels(sort_order);
            set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
            if(i==27 | i==numel(dateinmonth4(:,1)))
                legend('Average Speed','Speed Limit','Congestion Cutoff','Location','Best')
            end
            %
            xlabel('Time')
            ylabel('Average Speed')
            title('Average Speed - Time (Philadelphia (Southbound/Westbound))')
            saveas(figure(100+(j-5)*n+3), strcat(num2str(100+(j-5)*n+3),'_S_W_ST.jpg'));
            hold off
        else
            f = figure(100+(j-5)*n+4)
            f.Position = [1,50,1500,700];
            subplot(3,3,i-27)
            hold on
            grid minor
            plot(timevalue4, speedvalue4,'LineWidth',1.2);
            set(gca,'FontSize',9)
            ylim([min(TRAFFICAVE.speed4)-0.5, max(TRAFFICAVE.speed4)+0.5])
            xlim([min(timevalue4), max(timevalue4)])
            %
            lhand = line([TRAFFICAVE.datetime4(1,:),TRAFFICAVE.datetime4(end,:)],[speedlimit4,speedlimit4]);
            lhand.Color = 'r';
            lhand.LineStyle = '--';
            lhand.LineWidth = 1;
            lhandc = line([TRAFFICAVE.datetime4(1,:),TRAFFICAVE.datetime4(end,:)],[congestion4,congestion4]); % Congestion Cutoff Line
            lhandc.Color = 'g';
            lhandc.LineStyle = '--';
            lhandc.LineWidth = 1;
            new_tick = speedlimit4;
            new_fontsize = 9;
            new_tick_rgb = [0.28, 0.02, 0.03];   %Bulgarian Rose(Color)
            ax = gca;
            yruler = ax.YRuler;
            old_fmt = yruler.TickLabelFormat;
            old_yticks = yruler.TickValues;
            old_labels = sprintfc(old_fmt, old_yticks);
            new_label = sprintf(['%s%g,%g,%g%s%d%s' old_fmt], '\color[rgb]{', new_tick_rgb, '}\fontsize{', new_fontsize, '}', new_tick(1));
            all_yticks = [old_yticks, new_tick];
            all_ylabels = [old_labels, new_label];
            [new_yticks, sort_order] = sort(all_yticks);
            new_labels = all_ylabels(sort_order);
            set(yruler, 'TickValues', new_yticks, 'TickLabels', new_labels);
            if(i == numel(dateinmonth4(:,1)))
                legend('Average Speed','Speed Limit','Congestion Cutoff','Location','Best')
            end
            %
            xlabel('Time')
            ylabel('Average Speed')
            title('Average Speed - Time (Philadelphia (Southbound/Westbound))')
            saveas(figure(100+(j-5)*n+4), strcat(num2str(100+(j-5)*n+4),'_S_W_ST.jpg'));
            hold off
        end
    end
end
toc
% Elapsed time is 1071.436002 seconds.

%% 1/7/2019 release some space 
clear speedvalue3 speedvalue4 dateinmonth3 dateinmonth4 timevalue3 timevalue4
clear all_ylabels all_yticks ax i j lhand lhandc new_fontsize new_label
clear new_labelc new_labels new_tick new_tick_rgb new_tick_rgbc new_yticks
clear old_fmt old_labels old_yticks sort_order yruler f n lhand ans

%% STAT INFO FOR EACH CORRIDOR (ORANGE) 
speedlimit3_ora = 55;
STAT_ORA.maxspeed3 = max(TRAFFIC_ORA.speed3);
STAT_ORA.averagespeed3 = mean(TRAFFIC_ORA.speed3);
STAT_ORA.minspeed3 = min(TRAFFIC_ORA.speed3);
STAT_ORA.stdspeed3 = std(TRAFFIC_ORA.speed3);
STAT_ORA.samplesize3 = numel(TRAFFIC_ORA.speed3);
STAT_ORA.ratio3 = STAT_ORA.averagespeed3/speedlimit3_ora;

speedlimit4_ora = 55;
STAT_ORA.maxspeed4 = max(TRAFFIC_ORA.speed4);
STAT_ORA.averagespeed4 = mean(TRAFFIC_ORA.speed4);
STAT_ORA.minspeed4 = min(TRAFFIC_ORA.speed4);
STAT_ORA.stdspeed4 = std(TRAFFIC_ORA.speed4);
STAT_ORA.samplesize4 = numel(TRAFFIC_ORA.speed4);
STAT_ORA.ratio4 = STAT_ORA.averagespeed4/speedlimit4_ora

%% STAT INFO FOR EACH CORRIDOR (RED) 
speedlimit3_red = 55;
STAT_RED.maxspeed3 = max(TRAFFIC_RED.speed3);
STAT_RED.averagespeed3 = mean(TRAFFIC_RED.speed3);
STAT_RED.minspeed3 = min(TRAFFIC_RED.speed3);
STAT_RED.stdspeed3 = std(TRAFFIC_RED.speed3);
STAT_RED.samplesize3 = numel(TRAFFIC_RED.speed3);
STAT_RED.ratio3 = STAT_RED.averagespeed3/speedlimit3_red;

speedlimit4_red = 50;
STAT_RED.maxspeed4 = max(TRAFFIC_RED.speed4);
STAT_RED.averagespeed4 = mean(TRAFFIC_RED.speed4);
STAT_RED.minspeed4 = min(TRAFFIC_RED.speed4);
STAT_RED.stdspeed4 = std(TRAFFIC_RED.speed4);
STAT_RED.samplesize4 = numel(TRAFFIC_RED.speed4);
STAT_RED.ratio4 = STAT_RED.averagespeed4/speedlimit4_red

%% STAT INFO FOR EACH CORRIDOR (BLUE) 
speedlimit3_blu = 55;
STAT_BLU.maxspeed3 = max(TRAFFIC_BLU.speed3);
STAT_BLU.averagespeed3 = mean(TRAFFIC_BLU.speed3);
STAT_BLU.minspeed3 = min(TRAFFIC_BLU.speed3);
STAT_BLU.stdspeed3 = std(TRAFFIC_BLU.speed3);
STAT_BLU.samplesize3 = numel(TRAFFIC_BLU.speed3);
STAT_BLU.ratio3 = STAT_BLU.averagespeed3/speedlimit3_blu;

speedlimit4_blu = 50;
STAT_BLU.maxspeed4 = max(TRAFFIC_BLU.speed4);
STAT_BLU.averagespeed4 = mean(TRAFFIC_BLU.speed4);
STAT_BLU.minspeed4 = min(TRAFFIC_BLU.speed4);
STAT_BLU.stdspeed4 = std(TRAFFIC_BLU.speed4);
STAT_BLU.samplesize4 = numel(TRAFFIC_BLU.speed4);
STAT_BLU.ratio4 = STAT_BLU.averagespeed4/speedlimit4_blu

%% STAT INFO FOR EACH CORRIDOR (GREEN) 
speedlimit3_gre = 55;
STAT_GRE.maxspeed3 = max(TRAFFIC_GRE.speed3);
STAT_GRE.averagespeed3 = mean(TRAFFIC_GRE.speed3);
STAT_GRE.minspeed3 = min(TRAFFIC_GRE.speed3);
STAT_GRE.stdspeed3 = std(TRAFFIC_GRE.speed3);
STAT_GRE.samplesize3 = numel(TRAFFIC_GRE.speed3);
STAT_GRE.ratio3 = STAT_GRE.averagespeed3/speedlimit3_gre;

speedlimit4_gre = 45;
STAT_GRE.maxspeed4 = max(TRAFFIC_GRE.speed4);
STAT_GRE.averagespeed4 = mean(TRAFFIC_GRE.speed4);
STAT_GRE.minspeed4 = min(TRAFFIC_GRE.speed4);
STAT_GRE.stdspeed4 = std(TRAFFIC_GRE.speed4);
STAT_GRE.samplesize4 = numel(TRAFFIC_GRE.speed4);
STAT_GRE.ratio4 = STAT_GRE.averagespeed4/speedlimit4_gre

%% STAT INFO FOR EACH CORRIDOR (PURPLE) 
speedlimit3_pur = 55;
STAT_PUR.maxspeed3 = max(TRAFFIC_PUR.speed3);
STAT_PUR.averagespeed3 = mean(TRAFFIC_PUR.speed3);
STAT_PUR.minspeed3 = min(TRAFFIC_PUR.speed3);
STAT_PUR.stdspeed3 = std(TRAFFIC_PUR.speed3);
STAT_PUR.samplesize3 = numel(TRAFFIC_PUR.speed3);
STAT_PUR.ratio3 = STAT_PUR.averagespeed3/speedlimit3_pur;

speedlimit4_pur = 65;
STAT_PUR.maxspeed4 = max(TRAFFIC_PUR.speed4);
STAT_PUR.averagespeed4 = mean(TRAFFIC_PUR.speed4);
STAT_PUR.minspeed4 = min(TRAFFIC_PUR.speed4);
STAT_PUR.stdspeed4 = std(TRAFFIC_PUR.speed4);
STAT_PUR.samplesize4 = numel(TRAFFIC_PUR.speed4);
STAT_PUR.ratio4 = STAT_PUR.averagespeed4/speedlimit4_pur

clear ans speedlimit3 speedlimit3_ora speedlimit3_red speedlimit3_blu
clear speedlimit3_gre speedlimit4_ora speedlimit4_red speedlimit4_blu
clear speedlimit4_gre speedlimit3_pur speedlimit4_pur

%%
clear STAT_ORA STAT_RED STAT_BLU STAT_GRE STAT_PUR STAT_YEL STAT_BLA

%% 1/7/2019 Filter dataset using peak hours cutoff (ORANGE) 
% Northbound/Eastbound: 16:30 - 17:30, 7:30 = 8:30
% Southbound/Westbound: 16:30 - 17:30, 7:30 = 8:30
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_ORA.datevec3(:,4) == 16 & TRAFFICAVE_ORA.datevec3(:,5) >= 0) | (TRAFFICAVE_ORA.datevec3(:,4) == 17 & TRAFFICAVE_ORA.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_ORA.datevec4(:,4) == 16 & TRAFFICAVE_ORA.datevec4(:,5) >= 0) | (TRAFFICAVE_ORA.datevec4(:,4) == 17 & TRAFFICAVE_ORA.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_ORA.datevec3(:,4) == 7 & AMTRAFFICAVE_ORA.datevec3(:,5) >= 0) | (AMTRAFFICAVE_ORA.datevec3(:,4) == 8 & AMTRAFFICAVE_ORA.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_ORA.datevec4(:,4) == 7 & AMTRAFFICAVE_ORA.datevec4(:,5) >= 0) | (AMTRAFFICAVE_ORA.datevec4(:,4) == 8 & AMTRAFFICAVE_ORA.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_ORA.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_ORA.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_ORA.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_ORA.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_ORA.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_ORA.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_ORA.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_ORA.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_ORA.datevec3(:,4) == 16 & TRAFFICAVE_ORA.datevec3(:,5) >= 30) | (TRAFFICAVE_ORA.datevec3(:,4) == 17 & TRAFFICAVE_ORA.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_ORA.datevec4(:,4) == 16 & TRAFFICAVE_ORA.datevec4(:,5) >= 30) | (TRAFFICAVE_ORA.datevec4(:,4) == 17 & TRAFFICAVE_ORA.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_ORA.datevec3(:,4) == 7 & AMTRAFFICAVE_ORA.datevec3(:,5) >= 30) | (AMTRAFFICAVE_ORA.datevec3(:,4) == 8 & AMTRAFFICAVE_ORA.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_ORA.datevec4(:,4) == 7 & AMTRAFFICAVE_ORA.datevec4(:,5) >= 30) | (AMTRAFFICAVE_ORA.datevec4(:,4) == 8 & AMTRAFFICAVE_ORA.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_ORA.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_ORA.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_ORA.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_ORA.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_ORA.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_ORA.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_ORA.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_ORA.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_ORA.datevec3(:,4) == 17 & TRAFFICAVE_ORA.datevec3(:,5) >= 0) | (TRAFFICAVE_ORA.datevec3(:,4) == 18 & TRAFFICAVE_ORA.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_ORA.datevec4(:,4) == 17 & TRAFFICAVE_ORA.datevec4(:,5) >= 0) | (TRAFFICAVE_ORA.datevec4(:,4) == 18 & TRAFFICAVE_ORA.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_ORA.datevec3(:,4) == 8 & AMTRAFFICAVE_ORA.datevec3(:,5) >= 0) | (AMTRAFFICAVE_ORA.datevec3(:,4) == 9 & AMTRAFFICAVE_ORA.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_ORA.datevec4(:,4) == 8 & AMTRAFFICAVE_ORA.datevec4(:,5) >= 0) | (AMTRAFFICAVE_ORA.datevec4(:,4) == 9 & AMTRAFFICAVE_ORA.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_ORA.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_ORA.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_ORA.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_ORA.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_ORA.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_ORA.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_ORA.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_ORA.speed4(ampeakhourindex4))
toc

%%% YOU SHOULD UPDATE peakhourindex3,peakhourindex4, ampeakhourindex3,
%%% ampeakhourindex4 AFTER FINDING PROPER PEAK HOUR!!! (just copy)
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_ORA.datevec3(:,4) == 16 & TRAFFICAVE_ORA.datevec3(:,5) >= 30) | (TRAFFICAVE_ORA.datevec3(:,4) == 17 & TRAFFICAVE_ORA.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_ORA.datevec4(:,4) == 16 & TRAFFICAVE_ORA.datevec4(:,5) >= 30) | (TRAFFICAVE_ORA.datevec4(:,4) == 17 & TRAFFICAVE_ORA.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_ORA.datevec3(:,4) == 7 & AMTRAFFICAVE_ORA.datevec3(:,5) >= 30) | (AMTRAFFICAVE_ORA.datevec3(:,4) == 8 & AMTRAFFICAVE_ORA.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_ORA.datevec4(:,4) == 7 & AMTRAFFICAVE_ORA.datevec4(:,5) >= 30) | (AMTRAFFICAVE_ORA.datevec4(:,4) == 8 & AMTRAFFICAVE_ORA.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_ORA.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_ORA.speed3(peakhourindex3));
congestedratio4 = sum(TRAFFICAVE_ORA.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_ORA.speed4(peakhourindex4));
amcongestedratio3 = sum(AMTRAFFICAVE_ORA.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_ORA.speed3(ampeakhourindex3));
amcongestedratio4 = sum(AMTRAFFICAVE_ORA.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_ORA.speed4(ampeakhourindex4));
toc

% GENERATE "PEAK" HOUR STRUCT
% ORANGE AFTERNOON
tic
fieldname0 = fieldnames(TRAFFICAVE_ORA);
for i=1:numel(fieldnames(TRAFFICAVE_ORA))
    if (i <= numel(fieldnames(TRAFFICAVE_ORA))/2)
        eval(['PEAK_ORA.',fieldname0{i},'=','TRAFFICAVE_ORA.',fieldname0{i},'(peakhourindex3,:);']);
    elseif(i > numel(fieldnames(TRAFFICAVE_ORA))/2)
        eval(['PEAK_ORA.',fieldname0{i},'=','TRAFFICAVE_ORA.',fieldname0{i},'(peakhourindex4,:);']);
    end
end
clear peakhourindex3 peakhourindex4 fieldname0 
toc

% ORANGE MORNING
tic
fieldname0 = fieldnames(AMTRAFFICAVE_ORA);
for i=1:numel(fieldnames(AMTRAFFICAVE_ORA))
    if (i <= numel(fieldnames(AMTRAFFICAVE_ORA))/2)
        eval(['AMPEAK_ORA.',fieldname0{i},'=','AMTRAFFICAVE_ORA.',fieldname0{i},'(ampeakhourindex3,:);']);
    elseif(i > numel(fieldnames(AMTRAFFICAVE_ORA))/2)
        eval(['AMPEAK_ORA.',fieldname0{i},'=','AMTRAFFICAVE_ORA.',fieldname0{i},'(ampeakhourindex4,:);']);
    end
end
clear ampeakhourindex3 ampeakhourindex4 fieldname0 congestedratio3
clear congestedratio4 amcongestedratio3 amcongestedratio4 i speedlimit3
clear speedlimit4 amspeedlimit3 amspeedlimit4
toc

%% 1/7/2019 Filter dataset using peak hours cutoff (RED) 
% Northbound/Eastbound: 16:30 - 17:30, 7:30 = 8:30
% Southbound/Westbound: 16:30 - 17:30, 7:30 = 8:30
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_RED.datevec3(:,4) == 16 & TRAFFICAVE_RED.datevec3(:,5) >= 0) | (TRAFFICAVE_RED.datevec3(:,4) == 17 & TRAFFICAVE_RED.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_RED.datevec4(:,4) == 16 & TRAFFICAVE_RED.datevec4(:,5) >= 0) | (TRAFFICAVE_RED.datevec4(:,4) == 17 & TRAFFICAVE_RED.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_RED.datevec3(:,4) == 7 & AMTRAFFICAVE_RED.datevec3(:,5) >= 0) | (AMTRAFFICAVE_RED.datevec3(:,4) == 8 & AMTRAFFICAVE_RED.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_RED.datevec4(:,4) == 7 & AMTRAFFICAVE_RED.datevec4(:,5) >= 0) | (AMTRAFFICAVE_RED.datevec4(:,4) == 8 & AMTRAFFICAVE_RED.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_RED.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_RED.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_RED.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_RED.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_RED.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_RED.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_RED.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_RED.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_RED.datevec3(:,4) == 16 & TRAFFICAVE_RED.datevec3(:,5) >= 30) | (TRAFFICAVE_RED.datevec3(:,4) == 17 & TRAFFICAVE_RED.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_RED.datevec4(:,4) == 16 & TRAFFICAVE_RED.datevec4(:,5) >= 30) | (TRAFFICAVE_RED.datevec4(:,4) == 17 & TRAFFICAVE_RED.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_RED.datevec3(:,4) == 7 & AMTRAFFICAVE_RED.datevec3(:,5) >= 30) | (AMTRAFFICAVE_RED.datevec3(:,4) == 8 & AMTRAFFICAVE_RED.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_RED.datevec4(:,4) == 7 & AMTRAFFICAVE_RED.datevec4(:,5) >= 30) | (AMTRAFFICAVE_RED.datevec4(:,4) == 8 & AMTRAFFICAVE_RED.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_RED.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_RED.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_RED.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_RED.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_RED.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_RED.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_RED.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_RED.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_RED.datevec3(:,4) == 17 & TRAFFICAVE_RED.datevec3(:,5) >= 0) | (TRAFFICAVE_RED.datevec3(:,4) == 18 & TRAFFICAVE_RED.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_RED.datevec4(:,4) == 17 & TRAFFICAVE_RED.datevec4(:,5) >= 0) | (TRAFFICAVE_RED.datevec4(:,4) == 18 & TRAFFICAVE_RED.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_RED.datevec3(:,4) == 8 & AMTRAFFICAVE_RED.datevec3(:,5) >= 0) | (AMTRAFFICAVE_RED.datevec3(:,4) == 9 & AMTRAFFICAVE_RED.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_RED.datevec4(:,4) == 8 & AMTRAFFICAVE_RED.datevec4(:,5) >= 0) | (AMTRAFFICAVE_RED.datevec4(:,4) == 9 & AMTRAFFICAVE_RED.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_RED.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_RED.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_RED.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_RED.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_RED.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_RED.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_RED.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_RED.speed4(ampeakhourindex4))
toc

%%% YOU SHOULD UPDATE peakhourindex3,peakhourindex4, ampeakhourindex3,
%%% ampeakhourindex4 AFTER FINDING PROPER PEAK HOUR!!! (just copy)
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_RED.datevec3(:,4) == 16 & TRAFFICAVE_RED.datevec3(:,5) >= 30) | (TRAFFICAVE_RED.datevec3(:,4) == 17 & TRAFFICAVE_RED.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_RED.datevec4(:,4) == 16 & TRAFFICAVE_RED.datevec4(:,5) >= 30) | (TRAFFICAVE_RED.datevec4(:,4) == 17 & TRAFFICAVE_RED.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_RED.datevec3(:,4) == 7 & AMTRAFFICAVE_RED.datevec3(:,5) >= 30) | (AMTRAFFICAVE_RED.datevec3(:,4) == 8 & AMTRAFFICAVE_RED.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_RED.datevec4(:,4) == 7 & AMTRAFFICAVE_RED.datevec4(:,5) >= 30) | (AMTRAFFICAVE_RED.datevec4(:,4) == 8 & AMTRAFFICAVE_RED.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_RED.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_RED.speed3(peakhourindex3));
congestedratio4 = sum(TRAFFICAVE_RED.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_RED.speed4(peakhourindex4));
amcongestedratio3 = sum(AMTRAFFICAVE_RED.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_RED.speed3(ampeakhourindex3));
amcongestedratio4 = sum(AMTRAFFICAVE_RED.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_RED.speed4(ampeakhourindex4));
toc

% GENERATE "PEAK" HOUR STRUCT
% ORANGE AFTERNOON
tic
fieldname0 = fieldnames(TRAFFICAVE_RED);
for i=1:numel(fieldnames(TRAFFICAVE_RED))
    if (i <= numel(fieldnames(TRAFFICAVE_RED))/2)
        eval(['PEAK_RED.',fieldname0{i},'=','TRAFFICAVE_RED.',fieldname0{i},'(peakhourindex3,:);']);
    elseif(i > numel(fieldnames(TRAFFICAVE_RED))/2)
        eval(['PEAK_RED.',fieldname0{i},'=','TRAFFICAVE_RED.',fieldname0{i},'(peakhourindex4,:);']);
    end
end
clear peakhourindex3 peakhourindex4 fieldname0 
toc

% ORANGE MORNING
tic
fieldname0 = fieldnames(AMTRAFFICAVE_RED);
for i=1:numel(fieldnames(AMTRAFFICAVE_RED))
    if (i <= numel(fieldnames(AMTRAFFICAVE_RED))/2)
        eval(['AMPEAK_RED.',fieldname0{i},'=','AMTRAFFICAVE_RED.',fieldname0{i},'(ampeakhourindex3,:);']);
    elseif(i > numel(fieldnames(AMTRAFFICAVE_RED))/2)
        eval(['AMPEAK_RED.',fieldname0{i},'=','AMTRAFFICAVE_RED.',fieldname0{i},'(ampeakhourindex4,:);']);
    end
end
clear ampeakhourindex3 ampeakhourindex4 fieldname0 
toc

%% 1/7/2019 Filter dataset using peak hours cutoff (BLUE) 
% Northbound/Eastbound: 16:30 - 17:30, 7:30 = 8:30
% Southbound/Westbound: 16:30 - 17:30
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_BLU.datevec3(:,4) == 16 & TRAFFICAVE_BLU.datevec3(:,5) >= 0) | (TRAFFICAVE_BLU.datevec3(:,4) == 17 & TRAFFICAVE_BLU.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_BLU.datevec4(:,4) == 16 & TRAFFICAVE_BLU.datevec4(:,5) >= 0) | (TRAFFICAVE_BLU.datevec4(:,4) == 17 & TRAFFICAVE_BLU.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_BLU.datevec3(:,4) == 7 & AMTRAFFICAVE_BLU.datevec3(:,5) >= 0) | (AMTRAFFICAVE_BLU.datevec3(:,4) == 8 & AMTRAFFICAVE_BLU.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_BLU.datevec4(:,4) == 7 & AMTRAFFICAVE_BLU.datevec4(:,5) >= 0) | (AMTRAFFICAVE_BLU.datevec4(:,4) == 8 & AMTRAFFICAVE_BLU.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_BLU.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_BLU.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_BLU.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_BLU.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_BLU.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_BLU.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_BLU.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_BLU.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_BLU.datevec3(:,4) == 16 & TRAFFICAVE_BLU.datevec3(:,5) >= 30) | (TRAFFICAVE_BLU.datevec3(:,4) == 17 & TRAFFICAVE_BLU.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_BLU.datevec4(:,4) == 16 & TRAFFICAVE_BLU.datevec4(:,5) >= 30) | (TRAFFICAVE_BLU.datevec4(:,4) == 17 & TRAFFICAVE_BLU.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_BLU.datevec3(:,4) == 7 & AMTRAFFICAVE_BLU.datevec3(:,5) >= 30) | (AMTRAFFICAVE_BLU.datevec3(:,4) == 8 & AMTRAFFICAVE_BLU.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_BLU.datevec4(:,4) == 7 & AMTRAFFICAVE_BLU.datevec4(:,5) >= 30) | (AMTRAFFICAVE_BLU.datevec4(:,4) == 8 & AMTRAFFICAVE_BLU.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_BLU.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_BLU.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_BLU.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_BLU.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_BLU.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_BLU.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_BLU.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_BLU.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_BLU.datevec3(:,4) == 17 & TRAFFICAVE_BLU.datevec3(:,5) >= 0) | (TRAFFICAVE_BLU.datevec3(:,4) == 18 & TRAFFICAVE_BLU.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_BLU.datevec4(:,4) == 17 & TRAFFICAVE_BLU.datevec4(:,5) >= 0) | (TRAFFICAVE_BLU.datevec4(:,4) == 18 & TRAFFICAVE_BLU.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_BLU.datevec3(:,4) == 8 & AMTRAFFICAVE_BLU.datevec3(:,5) >= 0) | (AMTRAFFICAVE_BLU.datevec3(:,4) == 9 & AMTRAFFICAVE_BLU.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_BLU.datevec4(:,4) == 8 & AMTRAFFICAVE_BLU.datevec4(:,5) >= 0) | (AMTRAFFICAVE_BLU.datevec4(:,4) == 9 & AMTRAFFICAVE_BLU.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_BLU.speed3(peakhourindex3)<(speedlimit3-15))/numel(TRAFFICAVE_BLU.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_BLU.speed4(peakhourindex4)<(speedlimit4-15))/numel(TRAFFICAVE_BLU.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_BLU.speed3(ampeakhourindex3)<(amspeedlimit3-15))/numel(AMTRAFFICAVE_BLU.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_BLU.speed4(ampeakhourindex4)<(amspeedlimit4-15))/numel(AMTRAFFICAVE_BLU.speed4(ampeakhourindex4))
toc

%%% YOU SHOULD UPDATE peakhourindex3,peakhourindex4, ampeakhourindex3,
%%% ampeakhourindex4 AFTER FINDING PROPER PEAK HOUR!!! (just copy)
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_BLU.datevec3(:,4) == 16 & TRAFFICAVE_BLU.datevec3(:,5) >= 30) | (TRAFFICAVE_BLU.datevec3(:,4) == 17 & TRAFFICAVE_BLU.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_BLU.datevec4(:,4) == 16 & TRAFFICAVE_BLU.datevec4(:,5) >= 30) | (TRAFFICAVE_BLU.datevec4(:,4) == 17 & TRAFFICAVE_BLU.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_BLU.datevec3(:,4) == 7 & AMTRAFFICAVE_BLU.datevec3(:,5) >= 30) | (AMTRAFFICAVE_BLU.datevec3(:,4) == 8 & AMTRAFFICAVE_BLU.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_BLU.datevec4(:,4) == 7 & AMTRAFFICAVE_BLU.datevec4(:,5) >= 30) | (AMTRAFFICAVE_BLU.datevec4(:,4) == 8 & AMTRAFFICAVE_BLU.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_BLU.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_BLU.speed3(peakhourindex3));
congestedratio4 = sum(TRAFFICAVE_BLU.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_BLU.speed4(peakhourindex4));
amcongestedratio3 = sum(AMTRAFFICAVE_BLU.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_BLU.speed3(ampeakhourindex3));
amcongestedratio4 = sum(AMTRAFFICAVE_BLU.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_BLU.speed4(ampeakhourindex4));
toc

% GENERATE "PEAK" HOUR STRUCT
% ORANGE AFTERNOON
tic
fieldname0 = fieldnames(TRAFFICAVE_BLU);
for i=1:numel(fieldnames(TRAFFICAVE_BLU))
    if (i <= numel(fieldnames(TRAFFICAVE_BLU))/2)
        eval(['PEAK_BLU.',fieldname0{i},'=','TRAFFICAVE_BLU.',fieldname0{i},'(peakhourindex3,:);']);
    elseif(i > numel(fieldnames(TRAFFICAVE_BLU))/2)
        eval(['PEAK_BLU.',fieldname0{i},'=','TRAFFICAVE_BLU.',fieldname0{i},'(peakhourindex4,:);']);
    end
end
clear peakhourindex3 peakhourindex4 fieldname0 
toc

% ORANGE MORNING
tic
fieldname0 = fieldnames(AMTRAFFICAVE_BLU);
for i=1:numel(fieldnames(AMTRAFFICAVE_BLU))
    if (i <= numel(fieldnames(AMTRAFFICAVE_BLU))/2)
        eval(['AMPEAK_BLU.',fieldname0{i},'=','AMTRAFFICAVE_BLU.',fieldname0{i},'(ampeakhourindex3,:);']);
    elseif(i > numel(fieldnames(AMTRAFFICAVE_BLU))/2)
        eval(['AMPEAK_BLU.',fieldname0{i},'=','AMTRAFFICAVE_BLU.',fieldname0{i},'(ampeakhourindex4,:);']);
    end
end
clear ampeakhourindex3 ampeakhourindex4 fieldname0 
toc

%% 1/7/2019 Filter dataset using peak hours cutoff (GREEN DONT RUN) 
% Northbound/Eastbound: 16:30 - 17:30, 7:30 = 8:30
% Southbound/Westbound: 16:30 - 17:30, 7:30 = 8:30
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_GRE.datevec3(:,4) == 16 & TRAFFICAVE_GRE.datevec3(:,5) >= 0) | (TRAFFICAVE_GRE.datevec3(:,4) == 17 & TRAFFICAVE_GRE.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_GRE.datevec4(:,4) == 16 & TRAFFICAVE_GRE.datevec4(:,5) >= 0) | (TRAFFICAVE_GRE.datevec4(:,4) == 17 & TRAFFICAVE_GRE.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_GRE.datevec3(:,4) == 7 & AMTRAFFICAVE_GRE.datevec3(:,5) >= 0) | (AMTRAFFICAVE_GRE.datevec3(:,4) == 8 & AMTRAFFICAVE_GRE.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_GRE.datevec4(:,4) == 7 & AMTRAFFICAVE_GRE.datevec4(:,5) >= 0) | (AMTRAFFICAVE_GRE.datevec4(:,4) == 8 & AMTRAFFICAVE_GRE.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_GRE.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_GRE.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_GRE.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_GRE.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_GRE.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_GRE.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_GRE.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_GRE.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_GRE.datevec3(:,4) == 16 & TRAFFICAVE_GRE.datevec3(:,5) >= 30) | (TRAFFICAVE_GRE.datevec3(:,4) == 17 & TRAFFICAVE_GRE.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_GRE.datevec4(:,4) == 16 & TRAFFICAVE_GRE.datevec4(:,5) >= 30) | (TRAFFICAVE_GRE.datevec4(:,4) == 17 & TRAFFICAVE_GRE.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_GRE.datevec3(:,4) == 7 & AMTRAFFICAVE_GRE.datevec3(:,5) >= 30) | (AMTRAFFICAVE_GRE.datevec3(:,4) == 8 & AMTRAFFICAVE_GRE.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_GRE.datevec4(:,4) == 7 & AMTRAFFICAVE_GRE.datevec4(:,5) >= 30) | (AMTRAFFICAVE_GRE.datevec4(:,4) == 8 & AMTRAFFICAVE_GRE.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_GRE.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_GRE.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_GRE.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_GRE.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_GRE.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_GRE.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_GRE.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_GRE.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_GRE.datevec3(:,4) == 17 & TRAFFICAVE_GRE.datevec3(:,5) >= 0) | (TRAFFICAVE_GRE.datevec3(:,4) == 18 & TRAFFICAVE_GRE.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_GRE.datevec4(:,4) == 17 & TRAFFICAVE_GRE.datevec4(:,5) >= 0) | (TRAFFICAVE_GRE.datevec4(:,4) == 18 & TRAFFICAVE_GRE.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_GRE.datevec3(:,4) == 8 & AMTRAFFICAVE_GRE.datevec3(:,5) >= 0) | (AMTRAFFICAVE_GRE.datevec3(:,4) == 9 & AMTRAFFICAVE_GRE.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_GRE.datevec4(:,4) == 8 & AMTRAFFICAVE_GRE.datevec4(:,5) >= 0) | (AMTRAFFICAVE_GRE.datevec4(:,4) == 9 & AMTRAFFICAVE_GRE.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_GRE.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_GRE.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_GRE.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_GRE.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_GRE.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_GRE.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_GRE.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_GRE.speed4(ampeakhourindex4))
toc

%%% YOU SHOULD UPDATE peakhourindex3,peakhourindex4, ampeakhourindex3,
%%% ampeakhourindex4 AFTER FINDING PROPER PEAK HOUR!!! (just copy)
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_GRE.datevec3(:,4) == 16 & TRAFFICAVE_GRE.datevec3(:,5) >= 30) | (TRAFFICAVE_GRE.datevec3(:,4) == 17 & TRAFFICAVE_GRE.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_GRE.datevec4(:,4) == 16 & TRAFFICAVE_GRE.datevec4(:,5) >= 30) | (TRAFFICAVE_GRE.datevec4(:,4) == 17 & TRAFFICAVE_GRE.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_GRE.datevec3(:,4) == 7 & AMTRAFFICAVE_GRE.datevec3(:,5) >= 30) | (AMTRAFFICAVE_GRE.datevec3(:,4) == 8 & AMTRAFFICAVE_GRE.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_GRE.datevec4(:,4) == 7 & AMTRAFFICAVE_GRE.datevec4(:,5) >= 30) | (AMTRAFFICAVE_GRE.datevec4(:,4) == 8 & AMTRAFFICAVE_GRE.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_GRE.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_GRE.speed3(peakhourindex3));
congestedratio4 = sum(TRAFFICAVE_GRE.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_GRE.speed4(peakhourindex4));
amcongestedratio3 = sum(AMTRAFFICAVE_GRE.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_GRE.speed3(ampeakhourindex3));
amcongestedratio4 = sum(AMTRAFFICAVE_GRE.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_GRE.speed4(ampeakhourindex4));
toc

% GENERATE "PEAK" HOUR STRUCT
% ORANGE AFTERNOON
tic
fieldname0 = fieldnames(TRAFFICAVE_GRE);
for i=1:numel(fieldnames(TRAFFICAVE_GRE))
    if (i <= numel(fieldnames(TRAFFICAVE_GRE))/2)
        eval(['PEAK_GRE.',fieldname0{i},'=','TRAFFICAVE_GRE.',fieldname0{i},'(peakhourindex3,:);']);
    elseif(i > numel(fieldnames(TRAFFICAVE_GRE))/2)
        eval(['PEAK_GRE.',fieldname0{i},'=','TRAFFICAVE_GRE.',fieldname0{i},'(peakhourindex4,:);']);
    end
end
clear peakhourindex3 peakhourindex4 fieldname0 
toc

% ORANGE MORNING
tic
fieldname0 = fieldnames(AMTRAFFICAVE_GRE);
for i=1:numel(fieldnames(AMTRAFFICAVE_GRE))
    if (i <= numel(fieldnames(AMTRAFFICAVE_GRE))/2)
        eval(['AMPEAK_GRE.',fieldname0{i},'=','AMTRAFFICAVE_GRE.',fieldname0{i},'(ampeakhourindex3,:);']);
    elseif(i > numel(fieldnames(AMTRAFFICAVE_GRE))/2)
        eval(['AMPEAK_GRE.',fieldname0{i},'=','AMTRAFFICAVE_GRE.',fieldname0{i},'(ampeakhourindex4,:);']);
    end
end
clear ampeakhourindex3 ampeakhourindex4 fieldname0 i 
toc

%% 1/7/2019 Filter dataset using peak hours cutoff (PURPLE) 
% Northbound/Eastbound: 16:30 - 17:30, 7:30 = 8:30
% Southbound/Westbound: 16:30 - 17:30, 7:30 = 8:30
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_PUR.datevec3(:,4) == 16 & TRAFFICAVE_PUR.datevec3(:,5) >= 0) | (TRAFFICAVE_PUR.datevec3(:,4) == 17 & TRAFFICAVE_PUR.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_PUR.datevec4(:,4) == 16 & TRAFFICAVE_PUR.datevec4(:,5) >= 0) | (TRAFFICAVE_PUR.datevec4(:,4) == 17 & TRAFFICAVE_PUR.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_PUR.datevec3(:,4) == 7 & AMTRAFFICAVE_PUR.datevec3(:,5) >= 0) | (AMTRAFFICAVE_PUR.datevec3(:,4) == 8 & AMTRAFFICAVE_PUR.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_PUR.datevec4(:,4) == 7 & AMTRAFFICAVE_PUR.datevec4(:,5) >= 0) | (AMTRAFFICAVE_PUR.datevec4(:,4) == 8 & AMTRAFFICAVE_PUR.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_PUR.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_PUR.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_PUR.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_PUR.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_PUR.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_PUR.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_PUR.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_PUR.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_PUR.datevec3(:,4) == 16 & TRAFFICAVE_PUR.datevec3(:,5) >= 30) | (TRAFFICAVE_PUR.datevec3(:,4) == 17 & TRAFFICAVE_PUR.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_PUR.datevec4(:,4) == 16 & TRAFFICAVE_PUR.datevec4(:,5) >= 30) | (TRAFFICAVE_PUR.datevec4(:,4) == 17 & TRAFFICAVE_PUR.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_PUR.datevec3(:,4) == 7 & AMTRAFFICAVE_PUR.datevec3(:,5) >= 30) | (AMTRAFFICAVE_PUR.datevec3(:,4) == 8 & AMTRAFFICAVE_PUR.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_PUR.datevec4(:,4) == 7 & AMTRAFFICAVE_PUR.datevec4(:,5) >= 30) | (AMTRAFFICAVE_PUR.datevec4(:,4) == 8 & AMTRAFFICAVE_PUR.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_PUR.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_PUR.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_PUR.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_PUR.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_PUR.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_PUR.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_PUR.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_PUR.speed4(ampeakhourindex4))
toc

tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_PUR.datevec3(:,4) == 17 & TRAFFICAVE_PUR.datevec3(:,5) >= 0) | (TRAFFICAVE_PUR.datevec3(:,4) == 18 & TRAFFICAVE_PUR.datevec3(:,5) <= 0);
peakhourindex4 = (TRAFFICAVE_PUR.datevec4(:,4) == 17 & TRAFFICAVE_PUR.datevec4(:,5) >= 0) | (TRAFFICAVE_PUR.datevec4(:,4) == 18 & TRAFFICAVE_PUR.datevec4(:,5) <= 0);
ampeakhourindex3 = (AMTRAFFICAVE_PUR.datevec3(:,4) == 8 & AMTRAFFICAVE_PUR.datevec3(:,5) >= 0) | (AMTRAFFICAVE_PUR.datevec3(:,4) == 9 & AMTRAFFICAVE_PUR.datevec3(:,5) <= 0);
ampeakhourindex4 = (AMTRAFFICAVE_PUR.datevec4(:,4) == 8 & AMTRAFFICAVE_PUR.datevec4(:,5) >= 0) | (AMTRAFFICAVE_PUR.datevec4(:,4) == 9 & AMTRAFFICAVE_PUR.datevec4(:,5) <= 0);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_PUR.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_PUR.speed3(peakhourindex3))
congestedratio4 = sum(TRAFFICAVE_PUR.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_PUR.speed4(peakhourindex4))
amcongestedratio3 = sum(AMTRAFFICAVE_PUR.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_PUR.speed3(ampeakhourindex3))
amcongestedratio4 = sum(AMTRAFFICAVE_PUR.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_PUR.speed4(ampeakhourindex4))
toc

%%% YOU SHOULD UPDATE peakhourindex3,peakhourindex4, ampeakhourindex3,
%%% ampeakhourindex4 AFTER FINDING PROPER PEAK HOUR!!! (just copy)
tic
% peakhourindex3 = (TRAFFICAVE.datevec3(:,4) == 16) | (TRAFFICAVE.datevec3(:,4) == 17 & TRAFFICAVE.datevec3(:,5) <= 30);
% peakhourindex4 = (TRAFFICAVE.datevec4(:,4) == 16) | (TRAFFICAVE.datevec4(:,4) == 17 & TRAFFICAVE.datevec4(:,5) <= 30);
peakhourindex3 = (TRAFFICAVE_PUR.datevec3(:,4) == 16 & TRAFFICAVE_PUR.datevec3(:,5) >= 30) | (TRAFFICAVE_PUR.datevec3(:,4) == 17 & TRAFFICAVE_PUR.datevec3(:,5) <= 30);
peakhourindex4 = (TRAFFICAVE_PUR.datevec4(:,4) == 16 & TRAFFICAVE_PUR.datevec4(:,5) >= 30) | (TRAFFICAVE_PUR.datevec4(:,4) == 17 & TRAFFICAVE_PUR.datevec4(:,5) <= 30);
ampeakhourindex3 = (AMTRAFFICAVE_PUR.datevec3(:,4) == 7 & AMTRAFFICAVE_PUR.datevec3(:,5) >= 30) | (AMTRAFFICAVE_PUR.datevec3(:,4) == 8 & AMTRAFFICAVE_PUR.datevec3(:,5) <= 30);
ampeakhourindex4 = (AMTRAFFICAVE_PUR.datevec4(:,4) == 7 & AMTRAFFICAVE_PUR.datevec4(:,5) >= 30) | (AMTRAFFICAVE_PUR.datevec4(:,4) == 8 & AMTRAFFICAVE_PUR.datevec4(:,5) <= 30);
% we want to see if the majority of data in peak hour are congested.
speedlimit3 = 55;
speedlimit4 = 55;
amspeedlimit3 = 55;
amspeedlimit4 = 55;
congestedratio3 = sum(TRAFFICAVE_PUR.speed3(peakhourindex3)<(speedlimit3-5))/numel(TRAFFICAVE_PUR.speed3(peakhourindex3));
congestedratio4 = sum(TRAFFICAVE_PUR.speed4(peakhourindex4)<(speedlimit4-5))/numel(TRAFFICAVE_PUR.speed4(peakhourindex4));
amcongestedratio3 = sum(AMTRAFFICAVE_PUR.speed3(ampeakhourindex3)<(amspeedlimit3-5))/numel(AMTRAFFICAVE_PUR.speed3(ampeakhourindex3));
amcongestedratio4 = sum(AMTRAFFICAVE_PUR.speed4(ampeakhourindex4)<(amspeedlimit4-5))/numel(AMTRAFFICAVE_PUR.speed4(ampeakhourindex4));
toc

% GENERATE "PEAK" HOUR STRUCT
% ORANGE AFTERNOON
tic
fieldname0 = fieldnames(TRAFFICAVE_PUR);
for i=1:numel(fieldnames(TRAFFICAVE_PUR))
    if (i <= numel(fieldnames(TRAFFICAVE_PUR))/2)
        eval(['PEAK_PUR.',fieldname0{i},'=','TRAFFICAVE_PUR.',fieldname0{i},'(peakhourindex3,:);']);
    elseif(i > numel(fieldnames(TRAFFICAVE_PUR))/2)
        eval(['PEAK_PUR.',fieldname0{i},'=','TRAFFICAVE_PUR.',fieldname0{i},'(peakhourindex4,:);']);
    end
end
clear peakhourindex3 peakhourindex4 fieldname0 
toc

% ORANGE MORNING
tic
fieldname0 = fieldnames(AMTRAFFICAVE_PUR);
for i=1:numel(fieldnames(AMTRAFFICAVE_PUR))
    if (i <= numel(fieldnames(AMTRAFFICAVE_PUR))/2)
        eval(['AMPEAK_PUR.',fieldname0{i},'=','AMTRAFFICAVE_PUR.',fieldname0{i},'(ampeakhourindex3,:);']);
    elseif(i > numel(fieldnames(AMTRAFFICAVE_PUR))/2)
        eval(['AMPEAK_PUR.',fieldname0{i},'=','AMTRAFFICAVE_PUR.',fieldname0{i},'(ampeakhourindex4,:);']);
    end
end
clear ampeakhourindex3 ampeakhourindex4 fieldname0 i 
toc

%% 1/7/2019 ADD NEW COLUMN TO INDEX WEEK DAY (ORANGE,RED,BLUE,GREEN) 
tic
% NOTE!! MONDAY IS 2, TUESDAY IS 3,... , SUNDAY IS 0.
% PM ORANGE
PEAK_ORA.weekday3 = weekday(PEAK_ORA.datetime3)-1;
PEAK_ORA.weekday4 = weekday(PEAK_ORA.datetime4)-1;
PEAK_ORA.weeknum3 = weeknum(PEAK_ORA.datetime3);
PEAK_ORA.weeknum4 = weeknum(PEAK_ORA.datetime4);

% AM ORANGE
AMPEAK_ORA.weekday3 = weekday(AMPEAK_ORA.datetime3)-1;
AMPEAK_ORA.weekday4 = weekday(AMPEAK_ORA.datetime4)-1;
AMPEAK_ORA.weeknum3 = weeknum(AMPEAK_ORA.datetime3);
AMPEAK_ORA.weeknum4 = weeknum(AMPEAK_ORA.datetime4);
toc

% PM RED
PEAK_RED.weekday3 = weekday(PEAK_RED.datetime3)-1;
PEAK_RED.weekday4 = weekday(PEAK_RED.datetime4)-1;
PEAK_RED.weeknum3 = weeknum(PEAK_RED.datetime3);
PEAK_RED.weeknum4 = weeknum(PEAK_RED.datetime4);

% AM RED
AMPEAK_RED.weekday3 = weekday(AMPEAK_RED.datetime3)-1;
AMPEAK_RED.weekday4 = weekday(AMPEAK_RED.datetime4)-1;
AMPEAK_RED.weeknum3 = weeknum(AMPEAK_RED.datetime3);
AMPEAK_RED.weeknum4 = weeknum(AMPEAK_RED.datetime4);
toc

% PM BLUE
PEAK_BLU.weekday3 = weekday(PEAK_BLU.datetime3)-1;
PEAK_BLU.weekday4 = weekday(PEAK_BLU.datetime4)-1;
PEAK_BLU.weeknum3 = weeknum(PEAK_BLU.datetime3);
PEAK_BLU.weeknum4 = weeknum(PEAK_BLU.datetime4);

% AM BLUE
AMPEAK_BLU.weekday3 = weekday(AMPEAK_BLU.datetime3)-1;
AMPEAK_BLU.weekday4 = weekday(AMPEAK_BLU.datetime4)-1;
AMPEAK_BLU.weeknum3 = weeknum(AMPEAK_BLU.datetime3);
AMPEAK_BLU.weeknum4 = weeknum(AMPEAK_BLU.datetime4);
toc

% % PM GREEN
% PEAK_GRE.weekday3 = weekday(PEAK_GRE.datetime3)-1;
% PEAK_GRE.weekday4 = weekday(PEAK_GRE.datetime4)-1;
% PEAK_GRE.weeknum3 = weeknum(PEAK_GRE.datetime3);
% PEAK_GRE.weeknum4 = weeknum(PEAK_GRE.datetime4);
% 
% % AM GREEN
% AMPEAK_GRE.weekday3 = weekday(AMPEAK_GRE.datetime3)-1;
% AMPEAK_GRE.weekday4 = weekday(AMPEAK_GRE.datetime4)-1;
% AMPEAK_GRE.weeknum3 = weeknum(AMPEAK_GRE.datetime3);
% AMPEAK_GRE.weeknum4 = weeknum(AMPEAK_GRE.datetime4);

% PM PURPLE
PEAK_PUR.weekday3 = weekday(PEAK_PUR.datetime3)-1;
PEAK_PUR.weekday4 = weekday(PEAK_PUR.datetime4)-1;
PEAK_PUR.weeknum3 = weeknum(PEAK_PUR.datetime3);
PEAK_PUR.weeknum4 = weeknum(PEAK_PUR.datetime4);

% AM PURPLE
AMPEAK_PUR.weekday3 = weekday(AMPEAK_PUR.datetime3)-1;
AMPEAK_PUR.weekday4 = weekday(AMPEAK_PUR.datetime4)-1;
AMPEAK_PUR.weeknum3 = weeknum(AMPEAK_PUR.datetime3);
AMPEAK_PUR.weeknum4 = weeknum(AMPEAK_PUR.datetime4);

% % PM YELLOW
% PEAK_YEL.weekday3 = weekday(PEAK_YEL.datetime3)-1;
% PEAK_YEL.weekday4 = weekday(PEAK_YEL.datetime4)-1;
% PEAK_YEL.weeknum3 = weeknum(PEAK_YEL.datetime3);
% PEAK_YEL.weeknum4 = weeknum(PEAK_YEL.datetime4);
% 
% % AM YELLOW
% AMPEAK_YEL.weekday3 = weekday(AMPEAK_YEL.datetime3)-1;
% AMPEAK_YEL.weekday4 = weekday(AMPEAK_YEL.datetime4)-1;
% AMPEAK_YEL.weeknum3 = weeknum(AMPEAK_YEL.datetime3);
% AMPEAK_YEL.weeknum4 = weeknum(AMPEAK_YEL.datetime4);
% 
% % PM BLACK
% PEAK_BLA.weekday3 = weekday(PEAK_BLA.datetime3)-1;
% PEAK_BLA.weekday4 = weekday(PEAK_BLA.datetime4)-1;
% PEAK_BLA.weeknum3 = weeknum(PEAK_BLA.datetime3);
% PEAK_BLA.weeknum4 = weeknum(PEAK_BLA.datetime4);
% 
% % AM BLACK
% AMPEAK_BLA.weekday3 = weekday(AMPEAK_BLA.datetime3)-1;
% AMPEAK_BLA.weekday4 = weekday(AMPEAK_BLA.datetime4)-1;
% AMPEAK_BLA.weeknum3 = weeknum(AMPEAK_BLA.datetime3);
% AMPEAK_BLA.weeknum4 = weeknum(AMPEAK_BLA.datetime4);
toc

%% 1/8/2019 THREE-PART COMPARISON, CDF (ORANGE AFTERNOON) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_ORA.speed3)-1
    if(PEAK_ORA.hourpreciPHLation3(i,:) > 0)
        weekday3 = PEAK_ORA.weekday3(i,:);
        datevec3 = PEAK_ORA.datevec3(i,:);
        weeknum3 = PEAK_ORA.weeknum3(i,:);
        
        % find next week
        nextweekday3index = PEAK_ORA.weekday3 == weekday3;
        nextdatevec3index = PEAK_ORA.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = PEAK_ORA.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = PEAK_ORA.weekday3 == weekday3;
        prevdatevec3index = PEAK_ORA.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = PEAK_ORA.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;PEAK_ORA.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; PEAK_ORA.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; PEAK_ORA.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE3_ORA.clearspeed3 = clearspeed3;
COMPARE3_ORA.nextrainspeed3 = nextrainspeed3; 
COMPARE3_ORA.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(PEAK_ORA);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['COMPARE3_ORA.prev',fieldindex3,'=PEAK_ORA.',fieldindex3,'(previndex,:);']);
    eval(['COMPARE3_ORA.curr',fieldindex3,'=PEAK_ORA.',fieldindex3,'(currindex,:);']);
    eval(['COMPARE3_ORA.next',fieldindex3,'=PEAK_ORA.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE3_ORA.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE3_ORA.nextrainspeed3;COMPARE3_ORA.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE3_ORA.nextrainspeed3;COMPARE3_ORA.prevrainspeed3;COMPARE3_ORA.clearspeed3]) - 1,...
    max([COMPARE3_ORA.nextrainspeed3;COMPARE3_ORA.prevrainspeed3;COMPARE3_ORA.clearspeed3]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Evening Peak Hour (I95 Exit 9B)')
hold off
saveas(figure(11),'11_N_E_CDF_ORA.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_ORA.speed4)-1
    if(PEAK_ORA.hourpreciPHLation4(i,:) > 0)
        weekday4 = PEAK_ORA.weekday4(i,:);
        datevec4 = PEAK_ORA.datevec4(i,:);
        weeknum4 = PEAK_ORA.weeknum4(i,:);
        
        % find next week
        nextweekday4index = PEAK_ORA.weekday4 == weekday4;
        nextdatevec4index = PEAK_ORA.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = PEAK_ORA.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = PEAK_ORA.weekday4 == weekday4;
        prevdatevec4index = PEAK_ORA.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = PEAK_ORA.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;PEAK_ORA.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; PEAK_ORA.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; PEAK_ORA.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE4_ORA.clearspeed4 = clearspeed4;
COMPARE4_ORA.nextrainspeed4 = nextrainspeed4; 
COMPARE4_ORA.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(PEAK_ORA);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['COMPARE4_ORA.prev',fieldindex4,'=PEAK_ORA.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['COMPARE4_ORA.curr',fieldindex4,'=PEAK_ORA.',fieldindex4,'(currindex,:);']);
    eval(['COMPARE4_ORA.next',fieldindex4,'=PEAK_ORA.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE4_ORA.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE4_ORA.nextrainspeed4;COMPARE4_ORA.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE4_ORA.nextrainspeed4;COMPARE4_ORA.prevrainspeed4;COMPARE4_ORA.clearspeed4]) - 1,...
    max([COMPARE4_ORA.nextrainspeed4;COMPARE4_ORA.prevrainspeed4;COMPARE4_ORA.clearspeed4]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Evening Peak Hour (I95 Exit 9B)')
hold off
saveas(figure(12),'12_S_W_CDF_ORA.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n

%% 1/8/2019 THREE-PART COMPARISON, CDF (RED AFTERNOON) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_RED.speed3)-1
    if(PEAK_RED.hourpreciPHLation3(i,:) > 0)
        weekday3 = PEAK_RED.weekday3(i,:);
        datevec3 = PEAK_RED.datevec3(i,:);
        weeknum3 = PEAK_RED.weeknum3(i,:);
        
        % find next week
        nextweekday3index = PEAK_RED.weekday3 == weekday3;
        nextdatevec3index = PEAK_RED.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = PEAK_RED.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = PEAK_RED.weekday3 == weekday3;
        prevdatevec3index = PEAK_RED.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = PEAK_RED.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;PEAK_RED.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; PEAK_RED.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; PEAK_RED.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE3_RED.clearspeed3 = clearspeed3;
COMPARE3_RED.nextrainspeed3 = nextrainspeed3; 
COMPARE3_RED.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(PEAK_RED);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['COMPARE3_RED.prev',fieldindex3,'=PEAK_RED.',fieldindex3,'(previndex,:);']);
    eval(['COMPARE3_RED.curr',fieldindex3,'=PEAK_RED.',fieldindex3,'(currindex,:);']);
    eval(['COMPARE3_RED.next',fieldindex3,'=PEAK_RED.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE3_RED.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE3_RED.nextrainspeed3;COMPARE3_RED.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE3_RED.nextrainspeed3;COMPARE3_RED.prevrainspeed3;COMPARE3_RED.clearspeed3]) - 1,...
    max([COMPARE3_RED.nextrainspeed3;COMPARE3_RED.prevrainspeed3;COMPARE3_RED.clearspeed3]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Evening Peak Hour (I476 Exit5)')
hold off
saveas(figure(11),'11_N_E_CDF_RED.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_RED.speed4)-1
    if(PEAK_RED.hourpreciPHLation4(i,:) > 0)
        weekday4 = PEAK_RED.weekday4(i,:);
        datevec4 = PEAK_RED.datevec4(i,:);
        weeknum4 = PEAK_RED.weeknum4(i,:);
        
        % find next week
        nextweekday4index = PEAK_RED.weekday4 == weekday4;
        nextdatevec4index = PEAK_RED.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = PEAK_RED.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = PEAK_RED.weekday4 == weekday4;
        prevdatevec4index = PEAK_RED.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = PEAK_RED.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;PEAK_RED.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; PEAK_RED.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; PEAK_RED.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE4_RED.clearspeed4 = clearspeed4;
COMPARE4_RED.nextrainspeed4 = nextrainspeed4; 
COMPARE4_RED.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(PEAK_RED);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['COMPARE4_RED.prev',fieldindex4,'=PEAK_RED.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['COMPARE4_RED.curr',fieldindex4,'=PEAK_RED.',fieldindex4,'(currindex,:);']);
    eval(['COMPARE4_RED.next',fieldindex4,'=PEAK_RED.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE4_RED.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE4_RED.nextrainspeed4;COMPARE4_RED.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE4_RED.nextrainspeed4;COMPARE4_RED.prevrainspeed4;COMPARE4_RED.clearspeed4]) - 1,...
    max([COMPARE4_RED.nextrainspeed4;COMPARE4_RED.prevrainspeed4;COMPARE4_RED.clearspeed4]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Evening Peak Hour (I476 Exit5)')
hold off
saveas(figure(12),'12_S_W_CDF_RED.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n

%% 1/8/2019 THREE-PART COMPARISON, CDF (BLUE AFTERNOON) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_BLU.speed3)-1
    if(PEAK_BLU.hourpreciPHLation3(i,:) > 0)
        weekday3 = PEAK_BLU.weekday3(i,:);
        datevec3 = PEAK_BLU.datevec3(i,:);
        weeknum3 = PEAK_BLU.weeknum3(i,:);
        
        % find next week
        nextweekday3index = PEAK_BLU.weekday3 == weekday3;
        nextdatevec3index = PEAK_BLU.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = PEAK_BLU.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = PEAK_BLU.weekday3 == weekday3;
        prevdatevec3index = PEAK_BLU.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = PEAK_BLU.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;PEAK_BLU.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; PEAK_BLU.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; PEAK_BLU.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE3_BLU.clearspeed3 = clearspeed3;
COMPARE3_BLU.nextrainspeed3 = nextrainspeed3; 
COMPARE3_BLU.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(PEAK_BLU);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['COMPARE3_BLU.prev',fieldindex3,'=PEAK_BLU.',fieldindex3,'(previndex,:);']);
    eval(['COMPARE3_BLU.curr',fieldindex3,'=PEAK_BLU.',fieldindex3,'(currindex,:);']);
    eval(['COMPARE3_BLU.next',fieldindex3,'=PEAK_BLU.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE3_BLU.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE3_BLU.nextrainspeed3;COMPARE3_BLU.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE3_BLU.nextrainspeed3;COMPARE3_BLU.prevrainspeed3;COMPARE3_BLU.clearspeed3]) - 1,...
    max([COMPARE3_BLU.nextrainspeed3;COMPARE3_BLU.prevrainspeed3;COMPARE3_BLU.clearspeed3]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Evening Peak Hour (I76 Exit 28B)')
hold off
saveas(figure(11),'11_N_E_CDF_BLU.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_BLU.speed4)-1
    if(PEAK_BLU.hourpreciPHLation4(i,:) > 0)
        weekday4 = PEAK_BLU.weekday4(i,:);
        datevec4 = PEAK_BLU.datevec4(i,:);
        weeknum4 = PEAK_BLU.weeknum4(i,:);
        
        % find next week
        nextweekday4index = PEAK_BLU.weekday4 == weekday4;
        nextdatevec4index = PEAK_BLU.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = PEAK_BLU.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = PEAK_BLU.weekday4 == weekday4;
        prevdatevec4index = PEAK_BLU.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = PEAK_BLU.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;PEAK_BLU.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; PEAK_BLU.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; PEAK_BLU.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE4_BLU.clearspeed4 = clearspeed4;
COMPARE4_BLU.nextrainspeed4 = nextrainspeed4; 
COMPARE4_BLU.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(PEAK_BLU);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['COMPARE4_BLU.prev',fieldindex4,'=PEAK_BLU.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['COMPARE4_BLU.curr',fieldindex4,'=PEAK_BLU.',fieldindex4,'(currindex,:);']);
    eval(['COMPARE4_BLU.next',fieldindex4,'=PEAK_BLU.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE4_BLU.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE4_BLU.nextrainspeed4;COMPARE4_BLU.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE4_BLU.nextrainspeed4;COMPARE4_BLU.prevrainspeed4;COMPARE4_BLU.clearspeed4]) - 1,...
    max([COMPARE4_BLU.nextrainspeed4;COMPARE4_BLU.prevrainspeed4;COMPARE4_BLU.clearspeed4]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Evening Peak Hour (I76 Exit 28B)')
hold off
saveas(figure(12),'12_S_W_CDF_BLU.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n

%% 1/8/2019 THREE-PART COMPARISON, CDF (GREEN AFTERNOON DONT RUN) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_GRE.speed3)-1
    if(PEAK_GRE.hourpreciPHLation3(i,:) > 0)
        weekday3 = PEAK_GRE.weekday3(i,:);
        datevec3 = PEAK_GRE.datevec3(i,:);
        weeknum3 = PEAK_GRE.weeknum3(i,:);
        
        % find next week
        nextweekday3index = PEAK_GRE.weekday3 == weekday3;
        nextdatevec3index = PEAK_GRE.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = PEAK_GRE.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = PEAK_GRE.weekday3 == weekday3;
        prevdatevec3index = PEAK_GRE.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = PEAK_GRE.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;PEAK_GRE.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; PEAK_GRE.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; PEAK_GRE.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE3_GRE.clearspeed3 = clearspeed3;
COMPARE3_GRE.nextrainspeed3 = nextrainspeed3; 
COMPARE3_GRE.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(PEAK_GRE);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['COMPARE3_GRE.prev',fieldindex3,'=PEAK_GRE.',fieldindex3,'(previndex,:);']);
    eval(['COMPARE3_GRE.curr',fieldindex3,'=PEAK_GRE.',fieldindex3,'(currindex,:);']);
    eval(['COMPARE3_GRE.next',fieldindex3,'=PEAK_GRE.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE3_GRE.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE3_GRE.nextrainspeed3;COMPARE3_GRE.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE3_GRE.nextrainspeed3;COMPARE3_GRE.prevrainspeed3;COMPARE3_GRE.clearspeed3]) - 1,...
    max([COMPARE3_GRE.nextrainspeed3;COMPARE3_GRE.prevrainspeed3;COMPARE3_GRE.clearspeed3]) + 1])
legend('Average speed in preciPHLation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Evening Peak Hour (PA28 Exit 10)')
hold off
saveas(figure(11),'11_N_E_CDF_GRE.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_GRE.speed4)-1
    if(PEAK_GRE.hourpreciPHLation4(i,:) > 0)
        weekday4 = PEAK_GRE.weekday4(i,:);
        datevec4 = PEAK_GRE.datevec4(i,:);
        weeknum4 = PEAK_GRE.weeknum4(i,:);
        
        % find next week
        nextweekday4index = PEAK_GRE.weekday4 == weekday4;
        nextdatevec4index = PEAK_GRE.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = PEAK_GRE.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = PEAK_GRE.weekday4 == weekday4;
        prevdatevec4index = PEAK_GRE.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = PEAK_GRE.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;PEAK_GRE.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; PEAK_GRE.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; PEAK_GRE.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE4_GRE.clearspeed4 = clearspeed4;
COMPARE4_GRE.nextrainspeed4 = nextrainspeed4; 
COMPARE4_GRE.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(PEAK_GRE);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['COMPARE4_GRE.prev',fieldindex4,'=PEAK_GRE.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['COMPARE4_GRE.curr',fieldindex4,'=PEAK_GRE.',fieldindex4,'(currindex,:);']);
    eval(['COMPARE4_GRE.next',fieldindex4,'=PEAK_GRE.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE4_GRE.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE4_GRE.nextrainspeed4;COMPARE4_GRE.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE4_GRE.nextrainspeed4;COMPARE4_GRE.prevrainspeed4;COMPARE4_GRE.clearspeed4]) - 1,...
    max([COMPARE4_GRE.nextrainspeed4;COMPARE4_GRE.prevrainspeed4;COMPARE4_GRE.clearspeed4]) + 1])
legend('Average speed in preciPHLation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Evening Peak Hour (PA28 Exit 10)')
hold off
saveas(figure(12),'12_S_W_CDF_GRE.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n F

%% 1/8/2019 THREE-PART COMPARISON, CDF (PURPLE AFTERNOON) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_PUR.speed3)-1
    if(PEAK_PUR.hourpreciPHLation3(i,:) > 0)
        weekday3 = PEAK_PUR.weekday3(i,:);
        datevec3 = PEAK_PUR.datevec3(i,:);
        weeknum3 = PEAK_PUR.weeknum3(i,:);
        
        % find next week
        nextweekday3index = PEAK_PUR.weekday3 == weekday3;
        nextdatevec3index = PEAK_PUR.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = PEAK_PUR.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = PEAK_PUR.weekday3 == weekday3;
        prevdatevec3index = PEAK_PUR.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = PEAK_PUR.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;PEAK_PUR.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; PEAK_PUR.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; PEAK_PUR.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE3_PUR.clearspeed3 = clearspeed3;
COMPARE3_PUR.nextrainspeed3 = nextrainspeed3; 
COMPARE3_PUR.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(PEAK_PUR);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['COMPARE3_PUR.prev',fieldindex3,'=PEAK_PUR.',fieldindex3,'(previndex,:);']);
    eval(['COMPARE3_PUR.curr',fieldindex3,'=PEAK_PUR.',fieldindex3,'(currindex,:);']);
    eval(['COMPARE3_PUR.next',fieldindex3,'=PEAK_PUR.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE3_PUR.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE3_PUR.nextrainspeed3;COMPARE3_PUR.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE3_PUR.nextrainspeed3;COMPARE3_PUR.prevrainspeed3;COMPARE3_PUR.clearspeed3]) - 1,...
    max([COMPARE3_PUR.nextrainspeed3;COMPARE3_PUR.prevrainspeed3;COMPARE3_PUR.clearspeed3]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Evening Peak Hour (I95 Exit 30)')
hold off
saveas(figure(11),'11_N_E_CDF_PUR.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(PEAK_PUR.speed4)-1
    if(PEAK_PUR.hourpreciPHLation4(i,:) > 0)
        weekday4 = PEAK_PUR.weekday4(i,:);
        datevec4 = PEAK_PUR.datevec4(i,:);
        weeknum4 = PEAK_PUR.weeknum4(i,:);
        
        % find next week
        nextweekday4index = PEAK_PUR.weekday4 == weekday4;
        nextdatevec4index = PEAK_PUR.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = PEAK_PUR.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = PEAK_PUR.weekday4 == weekday4;
        prevdatevec4index = PEAK_PUR.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = PEAK_PUR.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;PEAK_PUR.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; PEAK_PUR.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; PEAK_PUR.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
COMPARE4_PUR.clearspeed4 = clearspeed4;
COMPARE4_PUR.nextrainspeed4 = nextrainspeed4; 
COMPARE4_PUR.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(PEAK_PUR);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['COMPARE4_PUR.prev',fieldindex4,'=PEAK_PUR.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['COMPARE4_PUR.curr',fieldindex4,'=PEAK_PUR.',fieldindex4,'(currindex,:);']);
    eval(['COMPARE4_PUR.next',fieldindex4,'=PEAK_PUR.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(COMPARE4_PUR.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([COMPARE4_PUR.nextrainspeed4;COMPARE4_PUR.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([COMPARE4_PUR.nextrainspeed4;COMPARE4_PUR.prevrainspeed4;COMPARE4_PUR.clearspeed4]) - 1,...
    max([COMPARE4_PUR.nextrainspeed4;COMPARE4_PUR.prevrainspeed4;COMPARE4_PUR.clearspeed4]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Evening Peak Hour (I95 Exit 30)')
hold off
saveas(figure(12),'12_S_W_CDF_PUR.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n F

%% 1/8/2019 THREE-PART COMPARISON, CDF (ORANGE MORNING) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_ORA.speed3)-1
    if(AMPEAK_ORA.hourpreciPHLation3(i,:) > 0)
        weekday3 = AMPEAK_ORA.weekday3(i,:);
        datevec3 = AMPEAK_ORA.datevec3(i,:);
        weeknum3 = AMPEAK_ORA.weeknum3(i,:);
        
        % find next week
        nextweekday3index = AMPEAK_ORA.weekday3 == weekday3;
        nextdatevec3index = AMPEAK_ORA.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = AMPEAK_ORA.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = AMPEAK_ORA.weekday3 == weekday3;
        prevdatevec3index = AMPEAK_ORA.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = AMPEAK_ORA.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;AMPEAK_ORA.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; AMPEAK_ORA.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; AMPEAK_ORA.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE3_ORA.clearspeed3 = clearspeed3;
AMCOMPARE3_ORA.nextrainspeed3 = nextrainspeed3; 
AMCOMPARE3_ORA.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(PEAK_ORA);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['AMCOMPARE3_ORA.prev',fieldindex3,'=AMPEAK_ORA.',fieldindex3,'(previndex,:);']);
    eval(['AMCOMPARE3_ORA.curr',fieldindex3,'=AMPEAK_ORA.',fieldindex3,'(currindex,:);']);
    eval(['AMCOMPARE3_ORA.next',fieldindex3,'=AMPEAK_ORA.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE3_ORA.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE3_ORA.nextrainspeed3;AMCOMPARE3_ORA.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE3_ORA.nextrainspeed3;AMCOMPARE3_ORA.prevrainspeed3;AMCOMPARE3_ORA.clearspeed3]) - 1,...
    max([AMCOMPARE3_ORA.nextrainspeed3;AMCOMPARE3_ORA.prevrainspeed3;AMCOMPARE3_ORA.clearspeed3]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Morning Peak Hour (I95 Exit 9B)')
hold off
saveas(figure(11),'11_N_E_CDF_ORA_AM.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_ORA.speed4)-1
    if(AMPEAK_ORA.hourpreciPHLation4(i,:) > 0)
        weekday4 = AMPEAK_ORA.weekday4(i,:);
        datevec4 = AMPEAK_ORA.datevec4(i,:);
        weeknum4 = AMPEAK_ORA.weeknum4(i,:);
        
        % find next week
        nextweekday4index = AMPEAK_ORA.weekday4 == weekday4;
        nextdatevec4index = AMPEAK_ORA.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = AMPEAK_ORA.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = AMPEAK_ORA.weekday4 == weekday4;
        prevdatevec4index = AMPEAK_ORA.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = AMPEAK_ORA.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;AMPEAK_ORA.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; AMPEAK_ORA.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; AMPEAK_ORA.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE4_ORA.clearspeed4 = clearspeed4;
AMCOMPARE4_ORA.nextrainspeed4 = nextrainspeed4; 
AMCOMPARE4_ORA.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(AMPEAK_ORA);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['AMCOMPARE4_ORA.prev',fieldindex4,'=AMPEAK_ORA.',fieldindex4,'(previndex,:);']);
%   AMCOMPARE4.prevhourciPHLation4 = AMPEAK.hourpreciPHLation4(previndex,:);
    eval(['AMCOMPARE4_ORA.curr',fieldindex4,'=AMPEAK_ORA.',fieldindex4,'(currindex,:);']);
    eval(['AMCOMPARE4_ORA.next',fieldindex4,'=AMPEAK_ORA.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE4_ORA.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE4_ORA.nextrainspeed4;AMCOMPARE4_ORA.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE4_ORA.nextrainspeed4;AMCOMPARE4_ORA.prevrainspeed4;AMCOMPARE4_ORA.clearspeed4]) - 1,...
    max([AMCOMPARE4_ORA.nextrainspeed4;AMCOMPARE4_ORA.prevrainspeed4;AMCOMPARE4_ORA.clearspeed4]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Morning Peak Hour (I95 Exit 9B)')
hold off
saveas(figure(12),'12_S_W_CDF_ORA_AM.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n

%% 1/8/2019 THREE-PART COMPARISON, CDF (RED MORNING) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_RED.speed3)-1
    if(AMPEAK_RED.hourpreciPHLation3(i,:) > 0)
        weekday3 = AMPEAK_RED.weekday3(i,:);
        datevec3 = AMPEAK_RED.datevec3(i,:);
        weeknum3 = AMPEAK_RED.weeknum3(i,:);
        
        % find next week
        nextweekday3index = AMPEAK_RED.weekday3 == weekday3;
        nextdatevec3index = AMPEAK_RED.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = AMPEAK_RED.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = AMPEAK_RED.weekday3 == weekday3;
        prevdatevec3index = AMPEAK_RED.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = AMPEAK_RED.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;AMPEAK_RED.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; AMPEAK_RED.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; AMPEAK_RED.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE3_RED.clearspeed3 = clearspeed3;
AMCOMPARE3_RED.nextrainspeed3 = nextrainspeed3; 
AMCOMPARE3_RED.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(AMPEAK_RED);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['AMCOMPARE3_RED.prev',fieldindex3,'=AMPEAK_RED.',fieldindex3,'(previndex,:);']);
    eval(['AMCOMPARE3_RED.curr',fieldindex3,'=AMPEAK_RED.',fieldindex3,'(currindex,:);']);
    eval(['AMCOMPARE3_RED.next',fieldindex3,'=AMPEAK_RED.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE3_RED.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE3_RED.nextrainspeed3;AMCOMPARE3_RED.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE3_RED.nextrainspeed3;AMCOMPARE3_RED.prevrainspeed3;AMCOMPARE3_RED.clearspeed3]) - 1,...
    max([AMCOMPARE3_RED.nextrainspeed3;AMCOMPARE3_RED.prevrainspeed3;AMCOMPARE3_RED.clearspeed3]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Morning Peak Hour (I476 Exit5)')
hold off
saveas(figure(11),'11_N_E_CDF_RED_AM.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_RED.speed4)-1
    if(AMPEAK_RED.hourpreciPHLation4(i,:) > 0)
        weekday4 = AMPEAK_RED.weekday4(i,:);
        datevec4 = AMPEAK_RED.datevec4(i,:);
        weeknum4 = AMPEAK_RED.weeknum4(i,:);
        
        % find next week
        nextweekday4index = AMPEAK_RED.weekday4 == weekday4;
        nextdatevec4index = AMPEAK_RED.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = AMPEAK_RED.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = AMPEAK_RED.weekday4 == weekday4;
        prevdatevec4index = AMPEAK_RED.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = AMPEAK_RED.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;AMPEAK_RED.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; AMPEAK_RED.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; AMPEAK_RED.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE4_RED.clearspeed4 = clearspeed4;
AMCOMPARE4_RED.nextrainspeed4 = nextrainspeed4; 
AMCOMPARE4_RED.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(AMPEAK_RED);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['AMCOMPARE4_RED.prev',fieldindex4,'=AMPEAK_RED.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['AMCOMPARE4_RED.curr',fieldindex4,'=AMPEAK_RED.',fieldindex4,'(currindex,:);']);
    eval(['AMCOMPARE4_RED.next',fieldindex4,'=AMPEAK_RED.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE4_RED.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE4_RED.nextrainspeed4;AMCOMPARE4_RED.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE4_RED.nextrainspeed4;AMCOMPARE4_RED.prevrainspeed4;AMCOMPARE4_RED.clearspeed4]) - 1,...
    max([AMCOMPARE4_RED.nextrainspeed4;AMCOMPARE4_RED.prevrainspeed4;AMCOMPARE4_RED.clearspeed4]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Morning Peak Hour (I476 Exit5)')
hold off
saveas(figure(12),'12_S_W_CDF_RED_AM.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n

%% 1/8/2019 THREE-PART COMPARISON, CDF (BLUE MORNING) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_BLU.speed3)-1
    if(AMPEAK_BLU.hourpreciPHLation3(i,:) > 0)
        weekday3 = AMPEAK_BLU.weekday3(i,:);
        datevec3 = AMPEAK_BLU.datevec3(i,:);
        weeknum3 = AMPEAK_BLU.weeknum3(i,:);
        
        % find next week
        nextweekday3index = AMPEAK_BLU.weekday3 == weekday3;
        nextdatevec3index = AMPEAK_BLU.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = AMPEAK_BLU.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = AMPEAK_BLU.weekday3 == weekday3;
        prevdatevec3index = AMPEAK_BLU.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = AMPEAK_BLU.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;AMPEAK_BLU.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; AMPEAK_BLU.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; AMPEAK_BLU.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE3_BLU.clearspeed3 = clearspeed3;
AMCOMPARE3_BLU.nextrainspeed3 = nextrainspeed3; 
AMCOMPARE3_BLU.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(AMPEAK_BLU);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['AMCOMPARE3_BLU.prev',fieldindex3,'=AMPEAK_BLU.',fieldindex3,'(previndex,:);']);
    eval(['AMCOMPARE3_BLU.curr',fieldindex3,'=AMPEAK_BLU.',fieldindex3,'(currindex,:);']);
    eval(['AMCOMPARE3_BLU.next',fieldindex3,'=AMPEAK_BLU.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE3_BLU.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE3_BLU.nextrainspeed3;AMCOMPARE3_BLU.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE3_BLU.nextrainspeed3;AMCOMPARE3_BLU.prevrainspeed3;AMCOMPARE3_BLU.clearspeed3]) - 1,...
    max([AMCOMPARE3_BLU.nextrainspeed3;AMCOMPARE3_BLU.prevrainspeed3;AMCOMPARE3_BLU.clearspeed3]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Morning Peak Hour (I76 Exit 28B)')
hold off
saveas(figure(11),'11_N_E_CDF_BLU_AM.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_BLU.speed4)-1
    if(AMPEAK_BLU.hourpreciPHLation4(i,:) > 0)
        weekday4 = AMPEAK_BLU.weekday4(i,:);
        datevec4 = AMPEAK_BLU.datevec4(i,:);
        weeknum4 = AMPEAK_BLU.weeknum4(i,:);
        
        % find next week
        nextweekday4index = AMPEAK_BLU.weekday4 == weekday4;
        nextdatevec4index = AMPEAK_BLU.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = AMPEAK_BLU.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = AMPEAK_BLU.weekday4 == weekday4;
        prevdatevec4index = AMPEAK_BLU.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = AMPEAK_BLU.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;AMPEAK_BLU.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; AMPEAK_BLU.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; AMPEAK_BLU.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE4_BLU.clearspeed4 = clearspeed4;
AMCOMPARE4_BLU.nextrainspeed4 = nextrainspeed4; 
AMCOMPARE4_BLU.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(AMPEAK_BLU);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['AMCOMPARE4_BLU.prev',fieldindex4,'=AMPEAK_BLU.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['AMCOMPARE4_BLU.curr',fieldindex4,'=AMPEAK_BLU.',fieldindex4,'(currindex,:);']);
    eval(['AMCOMPARE4_BLU.next',fieldindex4,'=AMPEAK_BLU.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE4_BLU.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE4_BLU.nextrainspeed4;AMCOMPARE4_BLU.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE4_BLU.nextrainspeed4;AMCOMPARE4_BLU.prevrainspeed4;AMCOMPARE4_BLU.clearspeed4]) - 1,...
    max([AMCOMPARE4_BLU.nextrainspeed4;AMCOMPARE4_BLU.prevrainspeed4;AMCOMPARE4_BLU.clearspeed4]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','best');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Morning Peak Hour (I76 Exit 28B)')
hold off
saveas(figure(12),'12_S_W_CDF_BLU_AM.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n

%% 1/8/2019 THREE-PART COMPARISON, CDF (GREEN MORNING DONT RUN) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_GRE.speed3)-1
    if(AMPEAK_GRE.hourpreciPHLation3(i,:) > 0)
        weekday3 = AMPEAK_GRE.weekday3(i,:);
        datevec3 = AMPEAK_GRE.datevec3(i,:);
        weeknum3 = AMPEAK_GRE.weeknum3(i,:);
        
        % find next week
        nextweekday3index = AMPEAK_GRE.weekday3 == weekday3;
        nextdatevec3index = AMPEAK_GRE.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = AMPEAK_GRE.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = AMPEAK_GRE.weekday3 == weekday3;
        prevdatevec3index = AMPEAK_GRE.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = AMPEAK_GRE.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;AMPEAK_GRE.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; AMPEAK_GRE.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; AMPEAK_GRE.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE3_GRE.clearspeed3 = clearspeed3;
AMCOMPARE3_GRE.nextrainspeed3 = nextrainspeed3; 
AMCOMPARE3_GRE.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(AMPEAK_GRE);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['AMCOMPARE3_GRE.prev',fieldindex3,'=AMPEAK_GRE.',fieldindex3,'(previndex,:);']);
    eval(['AMCOMPARE3_GRE.curr',fieldindex3,'=AMPEAK_GRE.',fieldindex3,'(currindex,:);']);
    eval(['AMCOMPARE3_GRE.next',fieldindex3,'=AMPEAK_GRE.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE3_GRE.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE3_GRE.nextrainspeed3;AMCOMPARE3_GRE.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE3_GRE.nextrainspeed3;AMCOMPARE3_GRE.prevrainspeed3;AMCOMPARE3_GRE.clearspeed3]) - 1,...
    max([AMCOMPARE3_GRE.nextrainspeed3;AMCOMPARE3_GRE.prevrainspeed3;AMCOMPARE3_GRE.clearspeed3]) + 1])
legend('Average speed in preciPHLation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Morning Peak Hour (PA28 Exit 10)')
hold off
saveas(figure(11),'11_N_E_CDF_GRE_AM.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_GRE.speed4)-1
    if(AMPEAK_GRE.hourpreciPHLation4(i,:) > 0)
        weekday4 = AMPEAK_GRE.weekday4(i,:);
        datevec4 = AMPEAK_GRE.datevec4(i,:);
        weeknum4 = AMPEAK_GRE.weeknum4(i,:);
        
        % find next week
        nextweekday4index = AMPEAK_GRE.weekday4 == weekday4;
        nextdatevec4index = AMPEAK_GRE.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = AMPEAK_GRE.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = AMPEAK_GRE.weekday4 == weekday4;
        prevdatevec4index = AMPEAK_GRE.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = AMPEAK_GRE.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;AMPEAK_GRE.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; AMPEAK_GRE.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; AMPEAK_GRE.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE4_GRE.clearspeed4 = clearspeed4;
AMCOMPARE4_GRE.nextrainspeed4 = nextrainspeed4; 
AMCOMPARE4_GRE.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(AMPEAK_GRE);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['AMCOMPARE4_GRE.prev',fieldindex4,'=AMPEAK_GRE.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['AMCOMPARE4_GRE.curr',fieldindex4,'=AMPEAK_GRE.',fieldindex4,'(currindex,:);']);
    eval(['AMCOMPARE4_GRE.next',fieldindex4,'=AMPEAK_GRE.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE4_GRE.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE4_GRE.nextrainspeed4;AMCOMPARE4_GRE.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE4_GRE.nextrainspeed4;AMCOMPARE4_GRE.prevrainspeed4;AMCOMPARE4_GRE.clearspeed4]) - 1,...
    max([AMCOMPARE4_GRE.nextrainspeed4;AMCOMPARE4_GRE.prevrainspeed4;AMCOMPARE4_GRE.clearspeed4]) + 1])
legend('Average speed in preciPHLation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Morning Peak Hour (PA28 Exit 10)')
hold off
saveas(figure(12),'12_S_W_CDF_GRE_AM.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n F

%% 1/8/2019 THREE-PART COMPARISON, CDF (PURPLE MORNING) 
% NORTHBOUND/EASTBOUND
tic
weekdatevec3 = [];
nextrainspeed3 = [];
prevrainspeed3 = [];
clearspeed3 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_PUR.speed3)-1
    if(AMPEAK_PUR.hourpreciPHLation3(i,:) > 0)
        weekday3 = AMPEAK_PUR.weekday3(i,:);
        datevec3 = AMPEAK_PUR.datevec3(i,:);
        weeknum3 = AMPEAK_PUR.weeknum3(i,:);
        
        % find next week
        nextweekday3index = AMPEAK_PUR.weekday3 == weekday3;
        nextdatevec3index = AMPEAK_PUR.datevec3(:,4:6) == datevec3(1,4:6);
        nextweeknum3index = AMPEAK_PUR.weeknum3 == (weeknum3+1);
        
        % find previous week
        prevweekday3index = AMPEAK_PUR.weekday3 == weekday3;
        prevdatevec3index = AMPEAK_PUR.datevec3(:,4:6) == datevec3(1,4:6);
        prevweeknum3index = AMPEAK_PUR.weeknum3 == (weeknum3-1);
        
        nexttemp3 = [nextweekday3index, nextdatevec3index, nextweeknum3index];
        prevtemp3 = [prevweekday3index, prevdatevec3index, prevweeknum3index];
        nextindex3 = sum(nexttemp3,2) == 5;
        previndex3 = sum(prevtemp3,2) == 5;

        if(sum(nextindex3) == 1 & sum(previndex3) == 1)
            clearspeed3 = [clearspeed3;AMPEAK_PUR.speed3(i,:)];
            nextrainspeed3 = [nextrainspeed3; AMPEAK_PUR.speed3(nextindex3)];  
            prevrainspeed3 = [prevrainspeed3; AMPEAK_PUR.speed3(previndex3)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp3,2) == 5)];
            previndex = [previndex; find(sum(prevtemp3,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE3_PUR.clearspeed3 = clearspeed3;
AMCOMPARE3_PUR.nextrainspeed3 = nextrainspeed3; 
AMCOMPARE3_PUR.prevrainspeed3 = prevrainspeed3;

%
fieldname0 = fieldnames(AMPEAK_PUR);
fieldname3 = regexp(fieldname0,'[\w]+[3]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname3));
for i=1:numel(fieldnameindex0)
    fieldindex3 = fieldname3{fieldnameindex0(i)};
    fieldindex3 = fieldindex3{1};
    eval(['AMCOMPARE3_PUR.prev',fieldindex3,'=AMPEAK_PUR.',fieldindex3,'(previndex,:);']);
    eval(['AMCOMPARE3_PUR.curr',fieldindex3,'=AMPEAK_PUR.',fieldindex3,'(currindex,:);']);
    eval(['AMCOMPARE3_PUR.next',fieldindex3,'=AMPEAK_PUR.',fieldindex3,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday3 datevec3 weeknum3 nextweekday3index nextdatevec3index i j
clear nextweeknum3index nexttemp3 clearspeed3 nextrainspeed3 weekdatevec3 
clear prevrainspeed3 prevweeknum3index prevweekday3index prevdatevec3index
clear prevtemp3 clearspeed3

tic
f = figure(11)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE3_PUR.clearspeed3);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE3_PUR.nextrainspeed3;AMCOMPARE3_PUR.prevrainspeed3]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE3_PUR.nextrainspeed3;AMCOMPARE3_PUR.prevrainspeed3;AMCOMPARE3_PUR.clearspeed3]) - 1,...
    max([AMCOMPARE3_PUR.nextrainspeed3;AMCOMPARE3_PUR.prevrainspeed3;AMCOMPARE3_PUR.clearspeed3]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Northbound/Eastbound) Morning Peak Hour (I95 Exit 30)')
hold off
saveas(figure(11),'11_N_E_CDF_PUR_AM.jpg');
toc
clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field3 fieldindex3 fieldname0 fieldname3
clear fieldnameindex0 fieldnameindex3 nextindex3 previndex3 statmeasure_tstamp3
clear statmeasure_tstamp4 f i lhand

% SOUTHBOUND/WESTBOUND
tic
weekdatevec4 = [];
nextrainspeed4 = [];
prevrainspeed4 = [];
clearspeed4 = [];
previndex = [];
currindex = [];
nextindex = [];
for i = 2:numel(AMPEAK_PUR.speed4)-1
    if(AMPEAK_PUR.hourpreciPHLation4(i,:) > 0)
        weekday4 = AMPEAK_PUR.weekday4(i,:);
        datevec4 = AMPEAK_PUR.datevec4(i,:);
        weeknum4 = AMPEAK_PUR.weeknum4(i,:);
        
        % find next week
        nextweekday4index = AMPEAK_PUR.weekday4 == weekday4;
        nextdatevec4index = AMPEAK_PUR.datevec4(:,4:6) == datevec4(1,4:6);
        nextweeknum4index = AMPEAK_PUR.weeknum4 == (weeknum4+1);
        
        % find previous week
        prevweekday4index = AMPEAK_PUR.weekday4 == weekday4;
        prevdatevec4index = AMPEAK_PUR.datevec4(:,4:6) == datevec4(1,4:6);
        prevweeknum4index = AMPEAK_PUR.weeknum4 == (weeknum4-1);
        
        nexttemp4 = [nextweekday4index, nextdatevec4index, nextweeknum4index];
        prevtemp4 = [prevweekday4index, prevdatevec4index, prevweeknum4index];
        nextindex4 = sum(nexttemp4,2) == 5;
        previndex4 = sum(prevtemp4,2) == 5;

        if(sum(nextindex4) == 1 & sum(previndex4) == 1)
            clearspeed4 = [clearspeed4;AMPEAK_PUR.speed4(i,:)];
            nextrainspeed4 = [nextrainspeed4; AMPEAK_PUR.speed4(nextindex4)];  
            prevrainspeed4 = [prevrainspeed4; AMPEAK_PUR.speed4(previndex4)];
            
            %
            nextindex = [nextindex; find(sum(nexttemp4,2) == 5)];
            previndex = [previndex; find(sum(prevtemp4,2) == 5)];
            currindex = [currindex; i];
            %
        end
    end
end
AMCOMPARE4_PUR.clearspeed4 = clearspeed4;
AMCOMPARE4_PUR.nextrainspeed4 = nextrainspeed4; 
AMCOMPARE4_PUR.prevrainspeed4 = prevrainspeed4;

%
fieldname0 = fieldnames(AMPEAK_PUR);
fieldname4 = regexp(fieldname0,'[\w]+[4]{1}$','match');
fieldnameindex0 = find(~cellfun(@isempty,fieldname4));
for i=1:numel(fieldnameindex0)
    fieldindex4 = fieldname4{fieldnameindex0(i)};
    fieldindex4 = fieldindex4{1};
    eval(['AMCOMPARE4_PUR.prev',fieldindex4,'=AMPEAK_PUR.',fieldindex4,'(previndex,:);']);
%   COMPARE4.prevhourciPHLation4 = PEAK.hourpreciPHLation4(previndex,:);
    eval(['AMCOMPARE4_PUR.curr',fieldindex4,'=AMPEAK_PUR.',fieldindex4,'(currindex,:);']);
    eval(['AMCOMPARE4_PUR.next',fieldindex4,'=AMPEAK_PUR.',fieldindex4,'(nextindex,:);']);
end
%

toc
% Elapsed time is 0.714578 seconds.

clear weekday4 datevec4 weeknum4 nextweekday4index nextdatevec4index i j
clear nextweeknum4index nexttemp4 clearspeed4 nextrainspeed4 weekdatevec4 
clear prevrainspeed4 prevweeknum4index prevweekday4index prevdatevec4index
clear prevtemp4 clearspeed4

tic
f = figure(12)
f.Position = [1,50,1500,700];
hold on
grid minor
[fprecipitationclear,xprecipitationclear] = ecdf(AMCOMPARE4_PUR.clearspeed4);
[fprecipitationnextrain,xprecipitationnextrain] = ecdf([AMCOMPARE4_PUR.nextrainspeed4;AMCOMPARE4_PUR.prevrainspeed4]);
plot(xprecipitationclear,fprecipitationclear,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
plot(xprecipitationnextrain,fprecipitationnextrain,'LineWidth',3)
set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])

xlim([min([AMCOMPARE4_PUR.nextrainspeed4;AMCOMPARE4_PUR.prevrainspeed4;AMCOMPARE4_PUR.clearspeed4]) - 1,...
    max([AMCOMPARE4_PUR.nextrainspeed4;AMCOMPARE4_PUR.prevrainspeed4;AMCOMPARE4_PUR.clearspeed4]) + 1])
legend('Average speed in precipitation hours', 'Average speed in both previous and next clear hours',...
    'Location','Northwest');
xlabel('Average Speed (mph)')
ylabel('Percentile')
title('CDF plot of average speed (Philadelphia (Southbound/Westbound) Morning Peak Hour (I95 Exit 30)')
hold off
saveas(figure(12),'12_S_W_CDF_PUR_AM.jpg');
toc

clear fprecipitationclear xprecipitationclear fprecipitationnextrain  
clear xprecipitationnextrain field4 fieldindex4 fieldname0 fieldname4
clear fieldnameindex0 fieldnameindex4 nextindex4 previndex4 statmeasure_tstamp4
clear statmeasure_tstamp4 tmcindex currindex previndex nextindex n F

%% 1/8/2019 SLM USING STRUCT "COMPARE" (ORANGE AFTERNOON) 
tic
COMPARET3_ORA = struct2table(COMPARE3_ORA);
slr3 = fitlm(COMPARET3_ORA,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_ORA.currhourpreciPHLation3,COMPARET3_ORA.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I95 Exit 9B)')
hold off
saveas(figure(13), '13_N_E_SLM_ORA.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_ORA = struct2table(COMPARE4_ORA);
slr4 = fitlm(COMPARET4_ORA,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_ORA.currhourpreciPHLation4,COMPARET4_ORA.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I95 Exit 9B))')
hold off
saveas(figure(14), '14_S_W_SLM_ORA.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/8/2019 SLM USING STRUCT "COMPARE" (RED AFTERNOON) 
tic
COMPARET3_RED = struct2table(COMPARE3_RED);
slr3 = fitlm(COMPARET3_RED,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_RED.currhourpreciPHLation3,COMPARET3_RED.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I476 Exit5)')
hold off
saveas(figure(13), '13_N_E_SLM_RED.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_RED = struct2table(COMPARE4_RED);
slr4 = fitlm(COMPARET4_RED,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_RED.currhourpreciPHLation4,COMPARET4_RED.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I476 Exit5))')
hold off
saveas(figure(14), '14_S_W_SLM_RED.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/8/2019 SLM USING STRUCT "COMPARE" (BLUE AFTERNOON) 
tic
COMPARET3_BLU = struct2table(COMPARE3_BLU);
slr3 = fitlm(COMPARET3_BLU,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_BLU.currhourpreciPHLation3,COMPARET3_BLU.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I76 Exit 28B)')
hold off
saveas(figure(13), '13_N_E_SLM_BLU.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_BLU = struct2table(COMPARE4_BLU);
slr4 = fitlm(COMPARET4_BLU,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_BLU.currhourpreciPHLation4,COMPARET4_BLU.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I76 Exit 28B))')
hold off
saveas(figure(14), '14_S_W_SLM_BLU.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/8/2019 SLM USING STRUCT "COMPARE" (GREEN AFTERNOON DONT RUN) 
tic
COMPARET3_GRE = struct2table(COMPARE3_GRE);
slr3 = fitlm(COMPARET3_GRE,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_GRE.currhourpreciPHLation3,COMPARET3_GRE.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (PA28 Exit 10)')
hold off
saveas(figure(13), '13_N_E_SLM_GRE.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_GRE = struct2table(COMPARE4_GRE);
slr4 = fitlm(COMPARET4_GRE,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_GRE.currhourpreciPHLation4,COMPARET4_GRE.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (PA28 Exit 10))')
hold off
saveas(figure(14), '14_S_W_SLM_GRE.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/8/2019 SLM USING STRUCT "COMPARE" (PURPLE AFTERNOON) 
tic
COMPARET3_PUR = struct2table(COMPARE3_PUR);
slr3 = fitlm(COMPARET3_PUR,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_PUR.currhourpreciPHLation3,COMPARET3_PUR.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I95 Exit 30)')
hold off
saveas(figure(13), '13_N_E_SLM_PUR.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_PUR = struct2table(COMPARE4_PUR);
slr4 = fitlm(COMPARET4_PUR,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_PUR.currhourpreciPHLation4,COMPARET4_PUR.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I95 Exit 30))')
hold off
saveas(figure(14), '14_S_W_SLM_PUR.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/8/2019 SLM USING STRUCT "COMPARE" (ORANGE MORNING)
tic
AMCOMPARET3_ORA = struct2table(AMCOMPARE3_ORA);
slr3 = fitlm(AMCOMPARET3_ORA,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_ORA.currhourpreciPHLation3,AMCOMPARET3_ORA.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I95 Exit 9B)')
hold off
saveas(figure(13), '13_N_E_SLM_ORA_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_ORA = struct2table(AMCOMPARE4_ORA);
slr4 = fitlm(AMCOMPARET4_ORA,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_ORA.currhourpreciPHLation4,AMCOMPARET4_ORA.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I95 Exit 9B))')
hold off
saveas(figure(14), '14_S_W_SLM_ORA_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/8/2019 SLM USING STRUCT "COMPARE" (RED MORNING) 
tic
AMCOMPARET3_RED = struct2table(AMCOMPARE3_RED);
slr3 = fitlm(AMCOMPARET3_RED,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_RED.currhourpreciPHLation3,AMCOMPARET3_RED.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I476 Exit5)')
hold off
saveas(figure(13), '13_N_E_SLM_RED_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_RED = struct2table(AMCOMPARE4_RED);
slr4 = fitlm(AMCOMPARET4_RED,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_RED.currhourpreciPHLation4,AMCOMPARET4_RED.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I476 Exit5))')
hold off
saveas(figure(14), '14_S_W_SLM_RED_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/8/2019 SLM USING STRUCT "COMPARE" (BLUE MORNING) 
tic
AMCOMPARET3_BLU = struct2table(AMCOMPARE3_BLU);
slr3 = fitlm(AMCOMPARET3_BLU,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_BLU.currhourpreciPHLation3,AMCOMPARET3_BLU.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I76 Exit 28B)')
hold off
saveas(figure(13), '13_N_E_SLM_BLU_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_BLU = struct2table(AMCOMPARE4_BLU);
slr4 = fitlm(AMCOMPARET4_BLU,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_BLU.currhourpreciPHLation4,AMCOMPARET4_BLU.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I76 Exit 28B))')
hold off
saveas(figure(14), '14_S_W_SLM_BLU_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/8/2019 SLM USING STRUCT "COMPARE" (GREEN MORNING DONT RUN) 
tic
AMCOMPARET3_GRE = struct2table(AMCOMPARE3_GRE);
slr3 = fitlm(AMCOMPARET3_GRE,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_GRE.currhourpreciPHLation3,AMCOMPARET3_GRE.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (PA28 Exit 10)')
hold off
saveas(figure(13), '13_N_E_SLM_GRE_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_GRE = struct2table(AMCOMPARE4_GRE);
slr4 = fitlm(AMCOMPARET4_GRE,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_GRE.currhourpreciPHLation4,AMCOMPARET4_GRE.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (PA28 Exit 10))')
hold off
saveas(figure(14), '14_S_W_SLM_GRE_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0 slr3 slr4 speedlimit4 f

%% 1/8/2019 SLM USING STRUCT "COMPARE" (PURPLE MORNING) 
tic
AMCOMPARET3_PUR = struct2table(AMCOMPARE3_PUR);
slr3 = fitlm(AMCOMPARET3_PUR,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_PUR.currhourpreciPHLation3,AMCOMPARET3_PUR.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I95 Exit 30)')
hold off
saveas(figure(13), '13_N_E_SLM_PUR_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_PUR = struct2table(AMCOMPARE4_PUR);
slr4 = fitlm(AMCOMPARET4_PUR,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_PUR.currhourpreciPHLation4,AMCOMPARET4_PUR.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('Precipitation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I95 Exit 30))')
hold off
saveas(figure(14), '14_S_W_SLM_PUR_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0 slr3 slr4 speedlimit4 f

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (ORANGE AFTERNOON) (N AND S SHOULD BE REMOVED) 
% Notice!!! Only if outliers exist, this part should be run.
% we should check which points are outliers.
tic
COMPARET3_ORA = struct2table(COMPARE3_ORA);
outlierindex3 = find(COMPARET3_ORA.currhourpreciPHLation3==max(COMPARET3_ORA.currhourpreciPHLation3));
COMPARET3_ORA(outlierindex3,:) = [];  % remove outliers' rows
slr3 = fitlm(COMPARET3_ORA,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_ORA.currhourpreciPHLation3,COMPARET3_ORA.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I95 Exit 9B)')
hold off
saveas(figure(13), '13_N_E_SLM_ORA_REMOVED.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_ORA = struct2table(COMPARE4_ORA);
outlierindex4 = find(COMPARET4_ORA.currhourpreciPHLation4==max(COMPARET4_ORA.currhourpreciPHLation4));
COMPARET4_ORA(outlierindex4,:) = [];  % remove outliers' rows
slr4 = fitlm(COMPARET4_ORA,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_ORA.currhourpreciPHLation4,COMPARET4_ORA.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I95 Exit 9B))')
hold off
saveas(figure(14), '14_S_W_SLM_ORA_REMOVED.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0 outlierindex3 outlierindex4

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (RED AFTERNOON) (N SHOULD BE REMOVED) 
tic
COMPARET3_RED = struct2table(COMPARE3_RED);
outlierindex3 = find(COMPARET3_RED.currhourpreciPHLation3==max(COMPARET3_RED.currhourpreciPHLation3));
COMPARET3_RED(outlierindex3,:) = [];  % remove outliers' rows
slr3 = fitlm(COMPARET3_RED,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_RED.currhourpreciPHLation3,COMPARET3_RED.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I476 Exit5)')
hold off
saveas(figure(13), '13_N_E_SLM_RED_REMOVED.jpg');
toc
%Elapsed time is 0.874227 seconds.

% % Southbound/Westbound
% COMPARET4_RED = struct2table(COMPARE4_RED);
% slr4 = fitlm(COMPARET4_RED,'currspeed4~1+currhourpreciPHLation4')
% 
% f = figure(14)
% f.Position = [1,50,1500,700];
% hold on
% grid minor
% scatter(COMPARET4_RED.currhourpreciPHLation4,COMPARET4_RED.currspeed4,'.');
% lsspeed4 = lsline
% lsspeed4.Color = 'r';
% lsspeed4.LineWidth = 1;
% lsspeed4.LineStyle = '--';
% 
% set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
% legend( 'Average speeds in Southbound/Westbound',...
%    'Fitted line');
% xlabel('PreciPHLation (inch/hr)')
% ylabel('Speed (mph)')
% title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I476 Exit5))')
% hold off
% saveas(figure(14), '14_S_W_SLM_RED.jpg');
% toc
% %Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0 outlierindex3

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (BLUE AFTERNOON) (DON'T RUN) 
tic
COMPARET3_BLU = struct2table(COMPARE3_BLU);
slr3 = fitlm(COMPARET3_BLU,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_BLU.currhourpreciPHLation3,COMPARET3_BLU.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I76 Exit 28B)')
hold off
saveas(figure(13), '13_N_E_SLM_BLU.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_BLU = struct2table(COMPARE4_BLU);
slr4 = fitlm(COMPARET4_BLU,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_BLU.currhourpreciPHLation4,COMPARET4_BLU.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I76 Exit 28B))')
hold off
saveas(figure(14), '14_S_W_SLM_BLU.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (GREEN AFTERNOON)  
tic
COMPARET3_GRE = struct2table(COMPARE3_GRE);
outlierindex3 = find(COMPARET3_GRE.currhourpreciPHLation3==max(COMPARET3_GRE.currhourpreciPHLation3));
COMPARET3_GRE(outlierindex3,:) = [];  % remove outliers' rows
slr3 = fitlm(COMPARET3_GRE,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_GRE.currhourpreciPHLation3,COMPARET3_GRE.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (PA28 Exit 10)')
hold off
saveas(figure(13), '13_N_E_SLM_GRE_REMOVED.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_GRE = struct2table(COMPARE4_GRE);
outlierindex4 = find(COMPARET4_GRE.currhourpreciPHLation4==max(COMPARET4_GRE.currhourpreciPHLation4));
COMPARET4_GRE(outlierindex4,:) = [];  % remove outliers' rows
slr4 = fitlm(COMPARET4_GRE,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_GRE.currhourpreciPHLation4,COMPARET4_GRE.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (PA28 Exit 10))')
hold off
saveas(figure(14), '14_S_W_SLM_GRE_REMOVED.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (PURPLE AFTERNOON) 
tic
COMPARET3_PUR = struct2table(COMPARE3_PUR);
outlierindex3 = find(COMPARET3_PUR.currhourpreciPHLation3==max(COMPARET3_PUR.currhourpreciPHLation3));
COMPARET3_PUR(outlierindex3,:) = [];  % remove outliers' rows
slr3 = fitlm(COMPARET3_PUR,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(COMPARET3_PUR.currhourpreciPHLation3,COMPARET3_PUR.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I95 Exit 30)')
hold off
saveas(figure(13), '13_N_E_SLM_PUR_REMOVED.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
COMPARET4_PUR = struct2table(COMPARE4_PUR);
slr4 = fitlm(COMPARET4_PUR,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(COMPARET4_PUR.currhourpreciPHLation4,COMPARET4_PUR.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I95 Exit 30))')
hold off
saveas(figure(14), '14_S_W_SLM_PUR.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (ORANGE MORNING) (DON'T RUN) 
tic
AMCOMPARET3_ORA = struct2table(AMCOMPARE3_ORA);
slr3 = fitlm(AMCOMPARET3_ORA,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_ORA.currhourpreciPHLation3,AMCOMPARET3_ORA.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I95 Exit 9B)')
hold off
saveas(figure(13), '13_N_E_SLM_ORA_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_ORA = struct2table(AMCOMPARE4_ORA);
slr4 = fitlm(AMCOMPARET4_ORA,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_ORA.currhourpreciPHLation4,AMCOMPARET4_ORA.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I95 Exit 9B))')
hold off
saveas(figure(14), '14_S_W_SLM_ORA_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (RED MORNING) (DON'T RUN) 
tic
AMCOMPARET3_RED = struct2table(AMCOMPARE3_RED);
slr3 = fitlm(AMCOMPARET3_RED,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_RED.currhourpreciPHLation3,AMCOMPARET3_RED.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I476 Exit5)')
hold off
saveas(figure(13), '13_N_E_SLM_RED_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_RED = struct2table(AMCOMPARE4_RED);
slr4 = fitlm(AMCOMPARET4_RED,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_RED.currhourpreciPHLation4,AMCOMPARET4_RED.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I476 Exit5))')
hold off
saveas(figure(14), '14_S_W_SLM_RED_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (BLUE MORNING) (DON'T RUN) 
tic
AMCOMPARET3_BLU = struct2table(AMCOMPARE3_BLU);
slr3 = fitlm(AMCOMPARET3_BLU,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_BLU.currhourpreciPHLation3,AMCOMPARET3_BLU.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I76 Exit 28B)')
hold off
saveas(figure(13), '13_N_E_SLM_BLU_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_BLU = struct2table(AMCOMPARE4_BLU);
slr4 = fitlm(AMCOMPARET4_BLU,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_BLU.currhourpreciPHLation4,AMCOMPARET4_BLU.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I76 Exit 28B))')
hold off
saveas(figure(14), '14_S_W_SLM_BLU_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (GREEN MORNING) (DON'T RUN) 
tic
AMCOMPARET3_GRE = struct2table(AMCOMPARE3_GRE);
slr3 = fitlm(AMCOMPARET3_GRE,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_GRE.currhourpreciPHLation3,AMCOMPARET3_GRE.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (PA28 Exit 10)')
hold off
saveas(figure(13), '13_N_E_SLM_GRE_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_GRE = struct2table(AMCOMPARE4_GRE);
slr4 = fitlm(AMCOMPARET4_GRE,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_GRE.currhourpreciPHLation4,AMCOMPARET4_GRE.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (PA28 Exit 10))')
hold off
saveas(figure(14), '14_S_W_SLM_GRE_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0 slr3 slr4 speedlimit4 f

%% 1/28/2019 SLM AFTER REMOVING OUTLIERS (PURPLE MORNING) (DON'T RUN) 
tic
AMCOMPARET3_PUR = struct2table(AMCOMPARE3_PUR);
slr3 = fitlm(AMCOMPARET3_PUR,'currspeed3~1+currhourpreciPHLation3')

f = figure(13)
f.Position = [1,50,1500,700];
hold on
grid minor

scatter(AMCOMPARET3_PUR.currhourpreciPHLation3,AMCOMPARET3_PUR.currspeed3,'.');
lsspeed3 = lsline
lsspeed3.Color = 'r';
lsspeed3.LineWidth = 1;
lsspeed3.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Northbound/Eastbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Northbound/Eastbound) (I95 Exit 30)')
hold off
saveas(figure(13), '13_N_E_SLM_PUR_AM.jpg');
toc
%Elapsed time is 0.874227 seconds.

% Southbound/Westbound
AMCOMPARET4_PUR = struct2table(AMCOMPARE4_PUR);
slr4 = fitlm(AMCOMPARET4_PUR,'currspeed4~1+currhourpreciPHLation4')

f = figure(14)
f.Position = [1,50,1500,700];
hold on
grid minor
scatter(AMCOMPARET4_PUR.currhourpreciPHLation4,AMCOMPARET4_PUR.currspeed4,'.');
lsspeed4 = lsline
lsspeed4.Color = 'r';
lsspeed4.LineWidth = 1;
lsspeed4.LineStyle = '--';

set(gca,'FontSize',12,'position',[0.04,0.08,0.9,0.87])
legend( 'Average speeds in Southbound/Westbound',...
   'Fitted line');
xlabel('PreciPHLation (inch/hr)')
ylabel('Speed (mph)')
title('Linear Regression Plot (Philadelphia (Southbound/Westbound) (I95 Exit 30))')
hold off
saveas(figure(14), '14_S_W_SLM_PUR_AM.jpg');
toc
%Elapsed time is 1.036130 seconds.
clear lsspeed3 lsspeed4 directionstat0 slr3 slr4 speedlimit4 f

%% 1/14/2019 (GREEN WILL NOT BE INCLUDED!!!) NEW .MAT FILE FOR DUMMY REGRESSION GENERATED HERE 
% Combine four corridors' data
% here will generate new .mat file
testtable1 = AMCOMPARET3_ORA;
testtable1.ampm3 = repmat({'AM'},[numel(AMCOMPARET3_ORA.currspeed3),1]);
testtable1.corridorname3 = repmat({'AMCOMPARET3_ORA'},[numel(AMCOMPARET3_ORA.currspeed3),1]);
testtable1.corridorcolor3 = repmat({'ORANGE'},[numel(AMCOMPARET3_ORA.currspeed3),1]);
testtable2 = AMCOMPARET3_RED;
testtable2.ampm3 = repmat({'AM'},[numel(AMCOMPARET3_RED.currspeed3),1]);
testtable2.corridorname3 = repmat({'AMCOMPARET3_RED'},[numel(AMCOMPARET3_RED.currspeed3),1]);
testtable2.corridorcolor3 = repmat({'RED'},[numel(AMCOMPARET3_RED.currspeed3),1]);
testtable3 = AMCOMPARET3_BLU;
testtable3.ampm3 = repmat({'AM'},[numel(AMCOMPARET3_BLU.currspeed3),1]);
testtable3.corridorname3 = repmat({'AMCOMPARET3_BLU'},[numel(AMCOMPARET3_BLU.currspeed3),1]);
testtable3.corridorcolor3 = repmat({'BLUE'},[numel(AMCOMPARET3_BLU.currspeed3),1]);
% testtable4 = AMCOMPARET3_GRE;
% testtable4.ampm3 = repmat({'AM'},[numel(AMCOMPARET3_GRE.currspeed3),1]);
% testtable4.corridorname3 = repmat({'AMCOMPARET3_GRE'},[numel(AMCOMPARET3_GRE.currspeed3),1]);
% testtable4.corridorcolor3 = repmat({'GREEN'},[numel(AMCOMPARET3_GRE.currspeed3),1]);
testtable5 = AMCOMPARET3_PUR;
testtable5.ampm3 = repmat({'AM'},[numel(AMCOMPARET3_PUR.currspeed3),1]);
testtable5.corridorname3 = repmat({'AMCOMPARET3_PUR'},[numel(AMCOMPARET3_PUR.currspeed3),1]);
testtable5.corridorcolor3 = repmat({'PURPLE'},[numel(AMCOMPARET3_PUR.currspeed3),1]);

testtable6 = COMPARET3_ORA;
testtable6.ampm3 = repmat({'PM'},[numel(COMPARET3_ORA.currspeed3),1]);
testtable6.corridorname3 = repmat({'COMPARET3_ORA'},[numel(COMPARET3_ORA.currspeed3),1]);
testtable6.corridorcolor3 = repmat({'ORANGE'},[numel(COMPARET3_ORA.currspeed3),1]);
testtable7 = COMPARET3_RED;
testtable7.ampm3 = repmat({'PM'},[numel(COMPARET3_RED.currspeed3),1]);
testtable7.corridorname3 = repmat({'COMPARET3_RED'},[numel(COMPARET3_RED.currspeed3),1]);
testtable7.corridorcolor3 = repmat({'RED'},[numel(COMPARET3_RED.currspeed3),1]);
testtable8 = COMPARET3_BLU;
testtable8.ampm3 = repmat({'PM'},[numel(COMPARET3_BLU.currspeed3),1]);
testtable8.corridorname3 = repmat({'COMPARET3_BLU'},[numel(COMPARET3_BLU.currspeed3),1]);
testtable8.corridorcolor3 = repmat({'BLUE'},[numel(COMPARET3_BLU.currspeed3),1]);
% testtable9 = COMPARET3_GRE;
% testtable9.ampm3 = repmat({'PM'},[numel(COMPARET3_GRE.currspeed3),1]);
% testtable9.corridorname3 = repmat({'COMPARET3_GRE'},[numel(COMPARET3_GRE.currspeed3),1]);
% testtable9.corridorcolor3 = repmat({'GREEN'},[numel(COMPARET3_GRE.currspeed3),1]);
testtable10 = COMPARET3_PUR;
testtable10.ampm3 = repmat({'PM'},[numel(COMPARET3_PUR.currspeed3),1]);
testtable10.corridorname3 = repmat({'COMPARET3_PUR'},[numel(COMPARET3_PUR.currspeed3),1]);
testtable10.corridorcolor3 = repmat({'PURPLE'},[numel(COMPARET3_PUR.currspeed3),1]);

totaltable1 = outerjoin(testtable1, testtable2,'MergeKeys', true); % join two tables vertically
totaltable2 = outerjoin(testtable3, testtable5,'MergeKeys', true); % join two tables vertically
totaltable3 = outerjoin(testtable6, testtable7,'MergeKeys', true); % join two tables vertically
totaltable4 = outerjoin(testtable8, testtable10,'MergeKeys', true); % join two tables vertically

totaltable6 = outerjoin(totaltable1, totaltable2,'MergeKeys', true); % join two tables vertically
totaltable7 = outerjoin(totaltable3, totaltable4,'MergeKeys', true); % join two tables vertically
totaltable8 = outerjoin(totaltable6, totaltable7,'MergeKeys', true); % join two tables vertically
totaltable = totaltable8;
totaltable.direction3 = repmat({'NORTHorEAST'},numel(totaltable.currspeed3),1);

clear testtable1 testtable2 testtable3 testtable4 testtable5 testtable6 
clear testtable7 testtable8 testtable9 totaltable1 totaltable2 totaltable3 
clear totaltable4 totaltable5 totaltable6 totaltable7 totaltable8 
% totaltable = sortrows(table3.currdatetime3);
% slr1 = fitlm(totaltable,'currspeed3~1+currhourpreciPHLation3')
% lm15 = fitlm(totaltable,'ResponseVar','currspeed3',...
%     'PredictorVars',{'currhourpreciPHLation3','ampm3','corridorcolor3'},...
%     'CategoricalVar',{'ampm3','corridorcolor3'})

% SOUTHBOUND/WESTBOUND
testtable1 = AMCOMPARET4_ORA;
testtable1.ampm4 = repmat({'AM'},[numel(AMCOMPARET4_ORA.currspeed4),1]);
testtable1.corridorname4 = repmat({'AMCOMPARET4_ORA'},[numel(AMCOMPARET4_ORA.currspeed4),1]);
testtable1.corridorcolor4 = repmat({'ORANGE'},[numel(AMCOMPARET4_ORA.currspeed4),1]);
testtable2 = AMCOMPARET4_RED;
testtable2.ampm4 = repmat({'AM'},[numel(AMCOMPARET4_RED.currspeed4),1]);
testtable2.corridorname4 = repmat({'AMCOMPARET4_RED'},[numel(AMCOMPARET4_RED.currspeed4),1]);
testtable2.corridorcolor4 = repmat({'RED'},[numel(AMCOMPARET4_RED.currspeed4),1]);
testtable3 = AMCOMPARET4_BLU;
testtable3.ampm4 = repmat({'AM'},[numel(AMCOMPARET4_BLU.currspeed4),1]);
testtable3.corridorname4 = repmat({'AMCOMPARET4_BLU'},[numel(AMCOMPARET4_BLU.currspeed4),1]);
testtable3.corridorcolor4 = repmat({'BLUE'},[numel(AMCOMPARET4_BLU.currspeed4),1]);
% testtable4 = AMCOMPARET4_GRE;
% testtable4.ampm4 = repmat({'AM'},[numel(AMCOMPARET4_GRE.currspeed4),1]);
% testtable4.corridorname4 = repmat({'AMCOMPARET4_GRE'},[numel(AMCOMPARET4_GRE.currspeed4),1]);
% testtable4.corridorcolor4 = repmat({'GREEN'},[numel(AMCOMPARET4_GRE.currspeed4),1]);
testtable5 = AMCOMPARET4_PUR;
testtable5.ampm4 = repmat({'AM'},[numel(AMCOMPARET4_PUR.currspeed4),1]);
testtable5.corridorname4 = repmat({'AMCOMPARET4_PUR'},[numel(AMCOMPARET4_PUR.currspeed4),1]);
testtable5.corridorcolor4 = repmat({'PURPLE'},[numel(AMCOMPARET4_PUR.currspeed4),1]);

testtable6 = COMPARET4_ORA;
testtable6.ampm4 = repmat({'PM'},[numel(COMPARET4_ORA.currspeed4),1]);
testtable6.corridorname4 = repmat({'COMPARET4_ORA'},[numel(COMPARET4_ORA.currspeed4),1]);
testtable6.corridorcolor4 = repmat({'ORANGE'},[numel(COMPARET4_ORA.currspeed4),1]);
testtable7 = COMPARET4_RED;
testtable7.ampm4 = repmat({'PM'},[numel(COMPARET4_RED.currspeed4),1]);
testtable7.corridorname4 = repmat({'COMPARET4_RED'},[numel(COMPARET4_RED.currspeed4),1]);
testtable7.corridorcolor4 = repmat({'RED'},[numel(COMPARET4_RED.currspeed4),1]);
testtable8 = COMPARET4_BLU;
testtable8.ampm4 = repmat({'PM'},[numel(COMPARET4_BLU.currspeed4),1]);
testtable8.corridorname4 = repmat({'COMPARET4_BLU'},[numel(COMPARET4_BLU.currspeed4),1]);
testtable8.corridorcolor4 = repmat({'BLUE'},[numel(COMPARET4_BLU.currspeed4),1]);
% testtable9 = COMPARET4_GRE;
% testtable9.ampm4 = repmat({'PM'},[numel(COMPARET4_GRE.currspeed4),1]);
% testtable9.corridorname4 = repmat({'COMPARET4_GRE'},[numel(COMPARET4_GRE.currspeed4),1]);
% testtable9.corridorcolor4 = repmat({'GREEN'},[numel(COMPARET4_GRE.currspeed4),1]);
testtable10 = COMPARET4_PUR;
testtable10.ampm4 = repmat({'PM'},[numel(COMPARET4_PUR.currspeed4),1]);
testtable10.corridorname4 = repmat({'COMPARET4_PUR'},[numel(COMPARET4_PUR.currspeed4),1]);
testtable10.corridorcolor4 = repmat({'PURPLE'},[numel(COMPARET4_PUR.currspeed4),1]);

totaltable1 = outerjoin(testtable1, testtable2,'MergeKeys', true); % join two tables vertically
totaltable2 = outerjoin(testtable3, testtable5,'MergeKeys', true); % join two tables vertically
totaltable3 = outerjoin(testtable6, testtable7,'MergeKeys', true); % join two tables vertically
totaltable4 = outerjoin(testtable8, testtable10,'MergeKeys', true); % join two tables vertically

totaltable6 = outerjoin(totaltable1, totaltable2,'MergeKeys', true); % join two tables vertically
totaltable7 = outerjoin(totaltable3, totaltable4,'MergeKeys', true); % join two tables vertically
totaltable8 = outerjoin(totaltable6, totaltable7,'MergeKeys', true); % join two tables vertically
totaltables = totaltable8;
totaltables.direction4 = repmat({'SOUTHorWEST'},numel(totaltables.currspeed4),1);

clear testtable1 testtable2 testtable3 testtable4 testtable5 testtable6 
clear testtable7 testtable8 testtable9 totaltable1 totaltable2 totaltable3 
clear totaltable4 totaltable5 totaltable6 totaltable7 totaltable8 

% slr2 = fitlm(totaltables,'currspeed4~1+currhourpreciPHLation4')
% lm16 = fitlm(totaltables,'ResponseVar','currspeed4',...
%     'PredictorVars',{'currhourpreciPHLation4','ampm4','corridorcolor4'},...
%     'CategoricalVar',{'ampm4','corridorcolor4'})

%% release a lot space
clear PHL TMC TRAFFIC TRAFFIC_BLU TRAFFIC_YEL TRAFFIC_ORA TRAFFIC_PUR
clear TRAFFICAVE TRAFFICAVE_BLU TRAFFICAVE_GRE TRAFFICAVE_ORA TRAFFICAVE_RED
clear AMTRAFFIC AMTRAFFIC_BLU AMTRAFFIC_YEL AMTRAFFIC_ORA AMTRAFFIC_PUR
clear AMTRAFFICAVE AMTRAFFICAVE_BLU AMTRAFFICAVE_GRE AMTRAFFICAVE_ORA AMTRAFFICAVE_RED
clear PEAK_BLU PEAK_GRE PEAK_ORA PEAK_RED AMPEAK_BLU AMPEAK_GRE AMPEAK_ORA AMPEAK_RED
clear slr1 slr2 lm15 lm16

%% 1/18/2019 CREATE TOTAL TABLE CONTAINING TWO DIRECTIONS. AND CREATE SOME DUMMIES
tic
totaltable0.clearspeed0 = [totaltable.clearspeed3;totaltables.clearspeed4];
totaltable0.nextrainspeed0 = [totaltable.nextrainspeed3;totaltables.nextrainspeed4];
totaltable0.prevrainspeed0 = [totaltable.prevrainspeed3;totaltables.prevrainspeed4];
totaltable0.prevspeed0 = [totaltable.prevspeed3;totaltables.prevspeed4];
totaltable0.currspeed0 = [totaltable.currspeed3;totaltables.currspeed4];
totaltable0.nextspeed0 = [totaltable.nextspeed3;totaltables.nextspeed4];
totaltable0.prevtravel_time0 = [totaltable.prevtravel_time3;totaltables.prevtravel_time4];
totaltable0.currtravel_time0 = [totaltable.currtravel_time3;totaltables.currtravel_time4];
totaltable0.nexttravel_time0 = [totaltable.nexttravel_time3;totaltables.nexttravel_time4];
totaltable0.prevconf_score0 = [totaltable.prevconf_score3;totaltables.prevconf_score4];
totaltable0.currconf_score0 = [totaltable.currconf_score3;totaltables.currconf_score4];
totaltable0.nextconf_score0 = [totaltable.nextconf_score3;totaltables.nextconf_score4];
totaltable0.prevmeasure_tstamp0 = [totaltable.prevmeasure_tstamp3;totaltables.prevmeasure_tstamp4];
totaltable0.currmeasure_tstamp0 = [totaltable.currmeasure_tstamp3;totaltables.currmeasure_tstamp4];
totaltable0.nextmeasure_tstamp0 = [totaltable.nextmeasure_tstamp3;totaltables.nextmeasure_tstamp4];
totaltable0.prevtmc_code0 = [totaltable.prevtmc_code3;totaltables.prevtmc_code4];
totaltable0.currtmc_code0 = [totaltable.currtmc_code3;totaltables.currtmc_code4];
totaltable0.nexttmc_code0 = [totaltable.nexttmc_code3;totaltables.nexttmc_code4];
totaltable0.prevdatetime0 = [totaltable.prevdatetime3;totaltables.prevdatetime4];
totaltable0.currdatetime0 = [totaltable.currdatetime3;totaltables.currdatetime4];
totaltable0.nextdatetime0 = [totaltable.nextdatetime3;totaltables.nextdatetime4];
totaltable0.prevdatevec0 = [totaltable.prevdatevec3;totaltables.prevdatevec4];
totaltable0.currdatevec0 = [totaltable.currdatevec3;totaltables.currdatevec4];
totaltable0.nextdatevec0 = [totaltable.nextdatevec3;totaltables.nextdatevec4];
totaltable0.prevstation0 = [totaltable.prevstation3;totaltables.prevstation4];
totaltable0.currstation0 = [totaltable.currstation3;totaltables.currstation4];
totaltable0.nextstation0 = [totaltable.nextstation3;totaltables.nextstation4];
totaltable0.prevairtemperature0 = [totaltable.prevairtemperature3;totaltables.prevairtemperature4];
totaltable0.currairtemperature0 = [totaltable.currairtemperature3;totaltables.currairtemperature4];
totaltable0.nextairtemperature0 = [totaltable.nextairtemperature3;totaltables.nextairtemperature4];
totaltable0.prevhourpreciPHLation0 = [totaltable.prevhourpreciPHLation3;totaltables.prevhourpreciPHLation4];
totaltable0.currhourpreciPHLation0 = [totaltable.currhourpreciPHLation3;totaltables.currhourpreciPHLation4];
totaltable0.nexthourpreciPHLation0 = [totaltable.nexthourpreciPHLation3;totaltables.nexthourpreciPHLation4];
totaltable0.prevvisibility0 = [totaltable.prevvisibility3;totaltables.prevvisibility4];
totaltable0.currvisibility0 = [totaltable.currvisibility3;totaltables.currvisibility4];
totaltable0.nextvisibility0 = [totaltable.nextvisibility3;totaltables.nextvisibility4];
totaltable0.prevroad0 = [totaltable.prevroad3;totaltables.prevroad4];
totaltable0.currroad0 = [totaltable.currroad3;totaltables.currroad4];
totaltable0.nextroad0 = [totaltable.nextroad3;totaltables.nextroad4];
totaltable0.prevdirection0 = [totaltable.prevdirection3;totaltables.prevdirection4];
totaltable0.currdirection0 = [totaltable.currdirection3;totaltables.currdirection4];
totaltable0.nextdirection0 = [totaltable.nextdirection3;totaltables.nextdirection4];
totaltable0.prevmiles0 = [totaltable.prevmiles3;totaltables.prevmiles4];
totaltable0.currmiles0 = [totaltable.currmiles3;totaltables.currmiles4];
totaltable0.nextmiles0 = [totaltable.nextmiles3;totaltables.nextmiles4];
totaltable0.prevweekday0 = [totaltable.prevweekday3;totaltables.prevweekday4];
totaltable0.currweekday0 = [totaltable.currweekday3;totaltables.currweekday4];
totaltable0.nextweekday0 = [totaltable.nextweekday3;totaltables.nextweekday4];
totaltable0.prevweeknum0 = [totaltable.prevweeknum3;totaltables.prevweeknum4];
totaltable0.currweeknum0 = [totaltable.currweeknum3;totaltables.currweeknum4];
totaltable0.nextweeknum0 = [totaltable.nextweeknum3;totaltables.nextweeknum4];
totaltable0.ampm0 = [totaltable.ampm3;totaltables.ampm4];
totaltable0.corridorname0 = [totaltable.corridorname3;totaltables.corridorname4];
totaltable0.corridorcolor0 = [totaltable.corridorcolor3;totaltables.corridorcolor4];
totaltable0.direction0 = [totaltable.direction3;totaltables.direction4];
totaltable0 = struct2table(totaltable0);
toc

% mdl = fitlm(totaltable0,...
%     'currspeed0~1+currhourpreciPHLation0+direction0+ampm0+corridorcolor0+corridorcolor0:direction0')

%%
% corridor color dummy
orangedummy0 = contains(totaltable0.corridorcolor0,'ORANGE');
reddummy0 = contains(totaltable0.corridorcolor0,'RED');
bluedummy0 = contains(totaltable0.corridorcolor0,'BLUE');
% greendummy0 = contains(totaltable0.corridorcolor0,'GREEN');
purpledummy0 = contains(totaltable0.corridorcolor0,'PURPLE');
totaltable0.corridorcolordummy0 = [orangedummy0, reddummy0, bluedummy0, purpledummy0];

% AM PM dummy
amdummy0 = contains(totaltable0.ampm0,'AM');
pmdummy0 = contains(totaltable0.ampm0,'PM');
totaltable0.ampmdummy0 = [amdummy0,pmdummy0];

% Direction dummy
nedummy0 = contains(totaltable0.direction0,'NORTHorEAST');
swdummy0 = contains(totaltable0.direction0,'SOUTHorWEST');
totaltable0.directiondummy0 = [nedummy0, swdummy0];

% add new fields to the table:
totaltable0.ORANGE_AM_NE = totaltable0.corridorcolordummy0(:,1).*totaltable0.ampmdummy0(:,1).*totaltable0.directiondummy0(:,1);
totaltable0.ORANGE_AM_SW = totaltable0.corridorcolordummy0(:,1).*totaltable0.ampmdummy0(:,1).*totaltable0.directiondummy0(:,2);
totaltable0.ORANGE_PM_NE = totaltable0.corridorcolordummy0(:,1).*totaltable0.ampmdummy0(:,2).*totaltable0.directiondummy0(:,1);
totaltable0.ORANGE_PM_SW = totaltable0.corridorcolordummy0(:,1).*totaltable0.ampmdummy0(:,2).*totaltable0.directiondummy0(:,2);

totaltable0.RED_AM_NE = totaltable0.corridorcolordummy0(:,2).*totaltable0.ampmdummy0(:,1).*totaltable0.directiondummy0(:,1);
totaltable0.RED_AM_SW = totaltable0.corridorcolordummy0(:,2).*totaltable0.ampmdummy0(:,1).*totaltable0.directiondummy0(:,2);
totaltable0.RED_PM_NE = totaltable0.corridorcolordummy0(:,2).*totaltable0.ampmdummy0(:,2).*totaltable0.directiondummy0(:,1);
totaltable0.RED_PM_SW = totaltable0.corridorcolordummy0(:,2).*totaltable0.ampmdummy0(:,2).*totaltable0.directiondummy0(:,2);

totaltable0.BLUE_AM_NE = totaltable0.corridorcolordummy0(:,3).*totaltable0.ampmdummy0(:,1).*totaltable0.directiondummy0(:,1);
totaltable0.BLUE_AM_SW = totaltable0.corridorcolordummy0(:,3).*totaltable0.ampmdummy0(:,1).*totaltable0.directiondummy0(:,2);
totaltable0.BLUE_PM_NE = totaltable0.corridorcolordummy0(:,3).*totaltable0.ampmdummy0(:,2).*totaltable0.directiondummy0(:,1);
totaltable0.BLUE_PM_SW = totaltable0.corridorcolordummy0(:,3).*totaltable0.ampmdummy0(:,2).*totaltable0.directiondummy0(:,2);

totaltable0.PURPLE_AM_NE = totaltable0.corridorcolordummy0(:,4).*totaltable0.ampmdummy0(:,1).*totaltable0.directiondummy0(:,1);
totaltable0.PURPLE_AM_SW = totaltable0.corridorcolordummy0(:,4).*totaltable0.ampmdummy0(:,1).*totaltable0.directiondummy0(:,2);
totaltable0.PURPLE_PM_NE = totaltable0.corridorcolordummy0(:,4).*totaltable0.ampmdummy0(:,2).*totaltable0.directiondummy0(:,1);
totaltable0.PURPLE_PM_SW = totaltable0.corridorcolordummy0(:,4).*totaltable0.ampmdummy0(:,2).*totaltable0.directiondummy0(:,2);

clear orangedummy0 reddummy0 bluedummy0 greendummy0 purpledummy0
clear amdummy0 pmdummy0 nedummy0 swdummy0

mdl1 = fitlm(totaltable0,...
    'currspeed0~1+currhourpreciPHLation0+ORANGE_AM_NE+ORANGE_AM_SW+ORANGE_PM_NE+ORANGE_PM_SW+RED_AM_NE+RED_AM_SW+RED_PM_NE+RED_PM_SW+BLUE_AM_NE+BLUE_AM_SW+BLUE_PM_NE+BLUE_PM_SW+PURPLE_AM_NE+PURPLE_AM_SW+PURPLE_PM_NE+PURPLE_PM_SW')

%%
% Interact direction0 with currhourpreciPHLation0
totaltable0.currhourpreciPHLation0_NE = totaltable0.directiondummy0(:,1).*totaltable0.currhourpreciPHLation0;
totaltable0.currhourpreciPHLation0_SW = totaltable0.directiondummy0(:,2).*totaltable0.currhourpreciPHLation0;

% Add hour of day AND month of year dummy.
totaltable0.hourofdaydummy0 = nominal(totaltable0.currdatevec0(:,4));
totaltable0.monthofyeardummy0 = nominal(totaltable0.currdatevec0(:,2));

%%
mdl3 = fitlm(totaltable0,...
    'currspeed0~1+currhourpreciPHLation0+monthofyeardummy0+ORANGE_AM_NE+ORANGE_AM_SW+ORANGE_PM_NE+ORANGE_PM_SW+RED_AM_NE+RED_AM_SW+RED_PM_NE+RED_PM_SW+BLUE_AM_NE+BLUE_AM_SW+BLUE_PM_NE+BLUE_PM_SW+PURPLE_AM_NE+PURPLE_AM_SW+PURPLE_PM_NE+PURPLE_PM_SW')

%%
%% EDITION ENDED HERE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




























