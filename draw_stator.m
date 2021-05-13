%%**************************************
%% *   Copyright     2021 by Qu        *
%% *                                   *


%% Computation of the coordinates of the slot points
alpha1 = asin(wso / Ds);

x1 = Ds/2 * cos(alpha1);
y1 = Ds/2 * sin(alpha1);

ang0  = atan(y1/x1);
alphat = alphas - 2 * ang0;
x0  = Ds/2 * cos(alphas - ang0);
y0  = Ds/2 * sin(alphas - ang0);

x3 = x1 + hso;
y3 = y1;

x2 =  x1;
y2 = -y1;

x4 =  x3;
y4 = -y3;

xo5 = Ds/2 + hwed + hso * cos(alphas/2);
yo5 = wt/2;
rad5 = sqrt(xo5*xo5 + yo5*yo5);
ang5 = atan(yo5/xo5);
x5  = rad5 * cos(alphas/2 - ang5);
y5  = rad5 * sin(alphas/2 - ang5);

xo7 = Ds/2 + hs;
yo7 = wt/2;
rad7 = sqrt(xo7*xo7 + yo7*yo7);
ang7 = atan(yo7/xo7);
x7  = rad7 * cos(alphas/2 - ang7);
y7  = rad7 * sin(alphas/2 - ang7);

x6 =  x5;
y6 = -y5;

x8 =  x7;
y8 = -y7;

%% Draw the slot geometry

% Draw nodes
mi_addnode(x0, y0);
mi_addnode(x1, y1);
mi_addnode(x2, y2);
mi_addnode(x3, y3);
mi_addnode(x4, y4);
mi_addnode(x5, y5);
mi_addnode(x6, y6);
mi_addnode(x7, y7);
mi_addnode(x8, y8);

mi_selectnode(x0, y0);
mi_selectnode(x1, y1);
mi_selectnode(x2, y2);
mi_selectnode(x3, y3);
mi_selectnode(x4, y4);
mi_selectnode(x5, y5);
mi_selectnode(x6, y6);
mi_selectnode(x7, y7);
mi_selectnode(x8, y8);
mi_setnodeprop('none',stator_group);

% Draw segments and arcs
mi_addsegment(x1, y1, x3, y3);
mi_addsegment(x3, y3, x5, y5);
mi_addsegment(x5, y5, x7, y7);
mi_addsegment(x2, y2, x4, y4);
mi_addsegment(x4, y4, x6, y6);
mi_addsegment(x6, y6, x8, y8);
mi_addsegment(x1, y1, x2, y2);
mi_addsegment(x3, y3, x4, y4);

mi_addarc(x8, y8, x7,   y7,   (alphas-2*ang7)*180/pi, 1);
mi_addarc(x1, y1, x0, y0, alphat*180/pi,  1);

mi_selectsegment((x1+x2)/2, (y1+y2)/2);
mi_selectsegment((x1+x3)/2, (y1+y3)/2);
mi_selectsegment((x3+x4)/2, (y3+y4)/2);
mi_selectsegment((x3+x5)/2, (y3+y5)/2);
mi_selectsegment((x5+x7)/2, (y5+y7)/2);
mi_selectsegment((x2+x4)/2, (y2+y4)/2);
mi_selectsegment((x4+x6)/2, (y4+y6)/2);
mi_selectsegment((x6+x8)/2, (y6+y8)/2);
mi_setsegmentprop('none', 5, 1, 0, stator_group);
mi_clearselected();

mi_selectarcsegment(rad7, 0);
mi_setarcsegmentprop(4, 'none', 0, stator_group);
mi_clearselected();

mi_selectarcsegment(x1, y1);
mi_setarcsegmentprop(1, 'none', 0, stator_group);
mi_clearselected();

%% Copy and rotate the slot
mi_selectgroup(stator_group);
mi_copyrotate( 0, 0, alphas*180/pi, Qs-1);
mi_clearselected();

%% Draw the external stator periphery
mi_addnode( De/2, 0);
mi_addnode(-De/2, 0);

mi_selectnode( De/2, 0);
mi_selectnode(-De/2, 0);
mi_setnodeprop('none', stator_group);

mi_addarc(  De/2, 0, -De/2, 0, 180, 5);
mi_addarc( -De/2, 0,  De/2, 0, 180, 5);

mi_selectarcsegment(0, De/2);
mi_selectarcsegment(0,-De/2);
mi_setarcsegmentprop(5,'Azero', 0, stator_group);
mi_clearselected();

%mi_addblocklabel(0, 0);
%mi_selectlabel(0, 0);
%mi_setblockprop('Air', 1, 0, '', 0, stator_group, 0)
%mi_clearselected();

%% Assign the label materials to the slots
rads  = (Ds + hs)/2; % middle slot radius
radso = (Ds + hso)/2; % slot-opening radius

for i = 1 : Qs
    
    mi_addcircprop(sprintf('Islot%d',i), 0, 0);
    mi_addblocklabel(rads*cos(alphas * (i-1) + angleSlot1), rads*sin(alphas * (i-1) + angleSlot1));
    mi_selectlabel(  rads*cos(alphas * (i-1) + angleSlot1), rads*sin(alphas * (i-1) + angleSlot1));
    mi_setblockprop('Cu', 1, 1, sprintf('Islot%d',i), 0, stator_group + i, 0);
    mi_clearselected();
    
    mi_addblocklabel(radso*cos(alphas * (i-1) + angleSlot1), radso*sin(alphas * (i-1) + angleSlot1));
    mi_selectlabel(  radso*cos(alphas * (i-1) + angleSlot1), radso*sin(alphas * (i-1) + angleSlot1));
    mi_setblockprop('Air', 0, mesh_air, 'none', 0, stator_group, 0);
    mi_clearselected();
    
end

%% Assign the label to the stator lamination
radbi = De/2 - hbi/2;

mi_addblocklabel(radbi, 0);
mi_selectlabel(  radbi, 0);
mi_setblockprop(lamination_name, 0, mesh_fe, '', 0, stator_group, 0)
mi_clearselected();

%% Assign the label to the air-gap
radgap   = Ds/2 - gap/2;

mi_addblocklabel(radgap, 0);
mi_selectlabel( radgap, 0);
mi_setblockprop('Air', 0, mesh_gap, '', 0, stator_group, 0)
mi_clearselected();