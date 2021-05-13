%%**************************************
%% *   Copyright     2021 by Qu        *
%% *                                   *

%% Computation of the coordinates of the pm nodes
alphap=alphar/2;
alpha_half=alphap/2;

xR1=Dre*cos(alpha_half)/2;
yR1=Dre*sin(alpha_half)/2;

xR2=(Dre/2+hM)*cos(alpha_half);
yR2=(Dre/2+hM)*sin(alpha_half);

xR3=xR1;
yR3=-yR1;

xR4=xR2;
yR4=-yR2;

xR5=Dre/2;
yR5=0;

xR6=Dre/2+hM;
yR6=0;

%% Draw the pm geometry

% Draw nodes
mi_addnode(xR1, yR1);
mi_addnode(xR2, yR2);
mi_addnode(xR3, yR3);
mi_addnode(xR4, yR4);
mi_addnode(xR5, yR5);
mi_addnode(xR6, yR6);

mi_selectnode(xR1, yR1); mi_setnodeprop('none',rotor_group);
mi_selectnode(xR2, yR2); mi_setnodeprop('none',rotor_group);
mi_selectnode(xR3, yR3); mi_setnodeprop('none',rotor_group);
mi_selectnode(xR4, yR4); mi_setnodeprop('none',rotor_group);
mi_selectnode(xR5, yR5); mi_setnodeprop('none',rotor_group);
mi_selectnode(xR6, yR6); mi_setnodeprop('none',rotor_group);

% Draw segment and arcs
%????
mi_addsegment(xR1, yR1, xR2, yR2);
mi_addsegment(xR3, yR3, xR4, yR4);
mi_addsegment(xR5, yR5, xR6, yR6);
%????
mi_addarc(xR5, yR5, xR1, yR1, alpha_half*180/pi,  1);
mi_addarc(xR6, yR6, xR2, yR2, alpha_half*180/pi,  1);
mi_addarc(xR3, yR3, xR5, yR5, alpha_half*180/pi,  1);
mi_addarc(xR4, yR4, xR6, yR6, alpha_half*180/pi,  1);


mi_selectsegment((xR1+xR2)/2, (yR1+yR2)/2);
mi_selectsegment((xR5+xR6)/2, (yR5+yR6)/2);
mi_selectsegment((xR3+xR4)/2, (yR3+yR4)/2);
mi_setsegmentprop('none', 5, 1, 0, rotor_group);
mi_clearselected();

mi_selectarcsegment(Dre/2+hM, 0.001);
mi_selectarcsegment(Dre/2+hM, -0.001);
mi_selectarcsegment(Dre/2, -0.001);
mi_selectarcsegment(Dre/2, -0.001);
mi_setarcsegmentprop(4, 'none', 0, rotor_group);
mi_clearselected();

% center of gravity of PM [1 2 5 6]
x = (xR1 + xR2 + xR5 + xR6) / 4;
y = (yR1 + yR2 + yR5 + yR6) / 4;
% set the upper region label
mi_addblocklabel(x, y);
mi_selectlabel(x, y);
mi_setblockprop(pm_name, 0, mesh_pm, 'none1', alpha_half*180/pi, rotor_group, 0);
mi_clearselected();


% center of gravity of PM [3 4 5 6]
x = (xR4 + xR3 + xR5 + xR6) / 4;
y = (yR4 + yR3 + yR5 + yR6) / 4;
% set the upper region label
mi_addblocklabel(x, y);
mi_selectlabel(x, y);
mi_setblockprop(pm_name, 0, mesh_pm, 'none', -alpha_half*180/pi, rotor_group, 0);
mi_clearselected();

%% Copy and rotate the rotor part
mi_selectgroup(rotor_group);
mi_copyrotate( 0, 0, alphar*180/pi, Qr-1);
mi_clearselected();

%% Draw the rotor pheripheries
% outer diameter nodes
mi_addnode(Dre/2, 0);
mi_addnode(-Dre/2, 0);
mi_selectnode(Dre/2, 0); mi_setnodeprop('none',rotor_group);
mi_selectnode(-Dre/2, 0); mi_setnodeprop('none',rotor_group);
% inner diameter nodes
%mi_addnode(Dri/2, 0);
%mi_addnode(-Dri/2, 0);
%mi_selectnode(Dri/2, 0); mi_setnodeprop('none',rotor_group);
%mi_selectnode(-Dri/2, 0); mi_setnodeprop('none',rotor_group);

% outer diameter arc
mi_addarc( Dre/2, 0, -Dre/2, 0, 180 , 1);
mi_addarc( -Dre/2, 0, Dre/2, 0, 180 , 1);
mi_selectarcsegment(Dre/2, 0.001);
mi_selectarcsegment(-Dre/2, -0.001);
mi_setarcsegmentprop(1, '', 0, rotor_group)
mi_clearselected();
% outer diameter arc
%mi_addarc( Dri/2, 0, -Dri/2, 0, 180 , 1);
%mi_addarc( -Dri/2, 0, Dri/2, 0, 180 , 1);
%mi_selectarcsegment(Dri/2, 0.001);
%mi_selectarcsegment(-Dri/2, -0.001);
%mi_setarcsegmentprop(1, 'none', 0, rotor_group);
%mi_clearselected();

%% Assign the lamination label
%??????
x = 0;
%y = (Dre+Dri) / 4;
y = Dre/ 4;
mi_addblocklabel(x, y);
mi_selectlabel(x, y);
mi_setblockprop(lamination_name, 0, mesh_fe, 'none', 0, rotor_group, 0);
mi_clearselected()
