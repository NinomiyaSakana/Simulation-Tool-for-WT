%%**************************************
%% *   Copyright     2021 by Qu        *
%% *                                   *

close all; clear; clc

%% Reading of the motor data
MACHINE_DATA

openfemm;
% main_minimize;  to hide the femm window
opendocument([filename,'.fem']); % open the model

% Input data for the simulation
freq_sim    = 0;    % frequency (used in FE simulation)
RPM         = 0;    % mech speed in (round/min)
skew        = 0;    % rotor skewing
thetam      = 0;    % rotor position (mechanical degrees)
Ipeak       = 1662;    % current amplitude (A peak)
alphaie     = 0;    % current phase (deg) in d-q reference frame
fileResults = 'ris_single'; % name of the file results

% run 'solving_core.m' procedure
solving_core

%closefemm;

save(['results\',fileResults,'.mat'])
