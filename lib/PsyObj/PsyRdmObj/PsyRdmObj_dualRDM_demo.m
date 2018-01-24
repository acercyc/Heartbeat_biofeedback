function PsyRdmObj_dual_demo()
% 1.0 - Acer 2015/11/16 20:24


% clc;
% clear all;
% clear classes;
addpath(genpath('lib'));

%% Joint Parameters
para.rdm.duration = 20;

%% Parameters_1
para.rdm_1.n = 100;
para.rdm_1.dotSize = 5;       % 0~10
para.rdm_1.speed = 2;
para.rdm_1.color = [200, 200, 200];
para.rdm_1.pRange = [-250, -100, -50, 100];


%% Parameters_2
para.rdm_2.n = 100;
para.rdm_2.dotSize = 5;       % 0~10
para.rdm_2.speed = 2;
para.rdm_2.color = [200, 200, 200];
para.rdm_2.pRange = [50, -100, 250, 100];            



%% Initialisation
% screen
PI = PsyInitialize;
PI.SkipSyncTests = 1;
w = PsyScreen(0);
w.openTest([5 5 600 600]);

% rdm
rdm_1 = PsyRdmObj(w, para.rdm_1);
rdm_2 = PsyRdmObj(w, para.rdm_2);

%% Run RDM
rdm_1.newDots( 0.6 ); % set the coherent level here
rdm_2.newDots( 0.3 ); 

t0 = GetSecs();
while GetSecs() - t0 < para.rdm.duration
    rdm_1.draw();
    rdm_2.draw();
    w.flip();
    
    rdm_1.xy = rdmObj.nextFrame(rdm_1.xy', rdm_1.dirt, rdm_1.para.speed);
    rdm_2.xy = rdmObj.nextFrame(rdm_2.xy', rdm_2.dirt, rdm_2.para.speed);
    rdm_1.xy = rdmObj.returnToBoundary(rdm_1.xy, rdm_1.b)';
    rdm_2.xy = rdmObj.returnToBoundary(rdm_2.xy, rdm_2.b)';
end