%%**************************************
%% *   Copyright     2021 by Qu        *
%% *                                   *

% setting the problem
mi_probdef(freq_sim, unit, 'planar', 1e-008, Lfe);

% rotation of the rotor
mi_selectgroup(rotor_group);
mi_moverotate(0, 0, thetam + skew + rotor_alignment);
mi_clearselected();

% dq currents computation
Id = Ipeak * cos(alphaie*pi/180);
Iq = Ipeak * sin(alphaie*pi/180);
% phase current computation (ia, ib, ic)
thetame = (thetam * p) * pi/180;	
ia      = Id * cos(thetame)        - Iq * sin(thetame);
ib      = Id * cos(thetame-2/3*pi) - Iq * sin(thetame-2/3*pi);
ic      = Id * cos(thetame+2/3*pi) - Iq * sin(thetame+2/3*pi);

for q = 1 : Qs
	Islot = ncs*(ia * ka(q) + ib *  kb(q) + ic * kc(q));
	mi_modifycircprop(['Islot', num2str(q)], 1, Islot);
end

if ~exist('temp','dir')
  mkdir('temp');
end
mi_saveas(['temp\temp.fem']); % save the model as temp
mi_analyze(1); % solve the model

mi_loadsolution;

%post_processing
