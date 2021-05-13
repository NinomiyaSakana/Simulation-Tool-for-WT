%%**************************************
%% *   Copyright     2021 by Qu        *
%% *                                   *

close all; clear; clc;

MACHINE_DATA

openfemm;
newdocument(0);


%??????????????????
%?????????????????none
model_properties


draw_stator

draw_rotor

mi_zoomnatural();

mi_saveas([filename,'.fem']);

% closefemm;