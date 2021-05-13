%%**************************************
%% *   Copyright     2021 by Qu        *
%% *                                   *

%mo_hidecontourplot();

% Computation of the slot cross-section area
Rslot = Dslot / 2;
mo_selectblock(Rslot*cosd(angleSlot1), Rslot*sind(angleSlot1)); % select 1st slot
Sslot = mo_blockintegral(5); % [m^2], slot area
mo_clearblock();

% Get the vector potential of the q-th slot
for q = 1 : Qs
    mo_selectblock(Rslot*cos(angleSlot1*pi/180 + (q-1)*2*pi/Qs), Rslot*sin(angleSlot1*pi/180 + (q-1)*2*pi/Qs));
    Az(q,1) = mo_blockintegral(1)/Sslot;
    mo_clearblock();
end

% Computation of the phase flux linkage
FluxA = ncs*ka*real(Az);
FluxB = ncs*kb*real(Az);
FluxC = ncs*kc*real(Az);

fluxD =  2/3 * ( FluxA*cos(thetame) + ...
    FluxB*cos(thetame - 2*pi/3) + ...
    FluxC*cos(thetame - 4*pi/3) );

fluxQ = -2/3 * ( FluxA*sin(thetame) + ...
    FluxB*sin(thetame - 2*pi/3) + ...
    FluxC*sin(thetame - 4*pi/3) );

%% Computation of the torque and radial force
mo_groupselectblock(rotor_group);
Tmxw = mo_blockintegral(22);
Fx = mo_blockintegral(18);
Fy = mo_blockintegral(19);
mo_clearblock();

% computation of the dq-torque
Tdq = 3/2 * p * (fluxD*Iq - fluxQ*Id);

% computation
mo_groupselectblock();
Energy = mo_blockintegral(2);
Coenergy = mo_blockintegral(17);
AJint = mo_blockintegral(0);
mo_clearblock();

% stator joule losses
Lew    		= 2.5 * Ds / p; % end-winding length
Ltot   		= (Lstk + Lew); % total conductor length
Vol_cond  	= kfill * Sslot * Qs * Ltot; % total conductor volume
Jrms   		= Ipeak / sqrt(2) / (Sslot * kfill) * ncs; % rms current density
Pjs    		= Jrms^2 * Vol_cond / (sigma_cond*1e6); % joule losses

% Computation of the peak flux density in the stator teeth
Bmax_t = 0;
for tt = 0 : 360
    xx = Dslot/2 * cos(tt*pi/180);
    yy = Dslot/2 * sin(tt*pi/180);
    try
        values = mo_getpointvalues(xx,yy);
    catch
        values = zeros(1,14);
    end
    B = hypot(values(2), values(3));
    if B > Bmax_t
        Bmax_t = B;
    end
end

% Computation of the peak flux density in the stator yoke
Bmax_bi = 0;
for tt = 0 : 360
    xx = (De - hbi)/2 * cos(tt*pi/180);
    yy = (De - hbi)/2 * sin(tt*pi/180);
    try
        values = mo_getpointvalues(xx,yy);
    catch
        values = zeros(1,14);
    end
    B = hypot(values(2), values(3));
    if B > Bmax_bi
        Bmax_bi = B;
    end
end

% tooth iron losses
freq_loss = p * RPM /60;
Pspec_t  = Pfe_spec * (Bmax_t/Bfe_rif)^2  * ...
    (khy*(freq_loss/freq_rif) + kec*(freq_loss/freq_rif)^2);
Pfe_t  = kmagg_t  * Pspec_t  * weight_t;

% yoke iron losses
Pspec_bi = Pfe_spec * (Bmax_bi/Bfe_rif)^2 * ...
    (khy*(freq_loss/freq_rif) + kec*(freq_loss/freq_rif)^2);
Pfe_bi = kmagg_bi * Pspec_bi * weight_bi;

% total iron losses
Pfe    = Pfe_t + Pfe_bi;

% powers and power factor
Fpeak  = hypot(fluxD, fluxQ);
alphaf = angle(fluxD + 1i*fluxQ);
phii   = alphaf + pi/2 - alphaie*pi/180;
omega  = 2*pi*freq_loss;
Pout   = 1.5 * omega * Fpeak * Ipeak * cos(phii);
Qvar   = 1.5 * omega * Fpeak * Ipeak * sin(phii);
if calc_Pmech == 1    % mechanical losses to be computed
    Pmech = 0.15 * Pout/1000 * sqrt(RPM);
else
    Pmech = 0;
end
% Alternatively
% Vq     =  omega * fluxD;
% Vd     = -omega * fluxQ;
% active power
% Pm     = 3/2 * omega * (fluxD * Iq - fluxQ * Id);
% P      = Pm + Pj + Pfe + Pmech;
% reactive power
% Q      = 3/2 * omega * (fluxD * Id + fluxQ * Iq);
% Power factor
% tanphi = Q / P;
% phi    = atan(tanphi);
% PF     = cos(phi);

Ploss  	= Pjs + Pfe + Pmech;
Pin    	= Pout + Ploss;
phi    	= atan(Qvar / Pin);
PF     	= cos(phi);
eta	 	= Pout / Pin * 100;

Dgap = (Ds + Dre)/2;
Bg_points = 720;
mo_seteditmode('contour')
mo_addcontour(Dgap/2,0);
mo_addcontour(-Dgap/2, 0);
mo_bendcontour(180,1);
mo_addcontour(Dgap/2, 0);
mo_bendcontour(180,1);
mo_makeplot(2, Bg_points, 'Bg.txt', 1);
temp_Bg = load('Bg.txt');
Bg = [temp_Bg(:,2)];
delete('Bg.txt');
mo_clearcontour();

% Exit from post processing procedure
mo_close()