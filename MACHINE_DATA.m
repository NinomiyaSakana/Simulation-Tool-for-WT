%% Name of the file .fem and unit
filename = 'generator'; %
mm = 1e-3; % unit
unit = 'meters'; % unit

%% General data
p =4;              % pole pairs
Lstk = 40*mm;       % stack length 
kpack = 0.96;       % packaging factor
Lfe = Lstk * kpack; % lamination length

%% Winding data
nc = 25;        % number of conductors per slot
npp = 1;        % number of paralle paths
ncs = nc/npp;   % number of series conductors per slot
kfill 	= 0.4;  % slot fill factor

%% Stator
stator_group = 1000; % stator group label
Qs = 24;        % number of slots (total in the stator)
De = 120*mm;    % outer diameter
Ds = 70*mm;     % inner diameter
wt = 4.77*mm;   % width of the stator tooth
wso = 2.5*mm;   % slot opening
hs = 15*mm;     % slot height
hso = 0.8*mm;   % slot opening height
hwed = 1.5*mm;  % wedge height
angleSlot1 = 0; % (deg) angle of the first slot ("Islot1")

%% Rotor geometry
rotor_group = 10; % rotor group label
rotor_alignment = -7.5;  % rotor initial position
Qr = 8; %number of PM on the rotor
%??
Dre =60*mm;    % outer diameter
%??
%Dri = 30*mm;    % inner diameter 
%??
hM= 2*mm;      % magnet thickness
%?????
%hri = 0.2*mm;   % inner rib height
%dbi = 3*mm;     % distance pm - airgap
%hre = 0.5*mm;   % outer rib height
%dbe = 0.2*mm;   % distance pm - out

%% Computation of additional variables
poles = 2 * p; 				% number of poles
t = gcd(Qs,p);              % greatest common divisor of (Q, p)
alphas = 2*pi / Qs;         % slot angle
alphar = 2*pi / Qr;         % ????PM???
hbi = De/2 - Ds/2 - hs;     % height of the stator back iron
gap = (Ds - Dre) / 2;		% air gap
Dslot = Dre + hs;		    % diameter of the middle slot

%% Materials properties
% slot
conductor_name = 'HTS wires';      % slot material name
sigma_cond = 670000000;            % electric conductivity (MS/m) @ 120C mgb2
gamma_cond = 8900;          % mass density of the slot material (kg/m3)

% lamination
lamination_name = 'M530_50A'; % lamination name
sigma_lamination = 3.22;      % electric conductivity (MS/m)
gamma_lamination = 7500;    % mass density of the lamination
freq_rif = 50;          	  % reference frequency (Hz) for iron specific loss
Bfe_rif = 1;                % reference flux density (T) for iron specific loss
khy = 0.7;                  % hysteresis iron losses coefficient
kec = 0.3;              	  % hysteresis iron losses coefficient
Pfe_spec = 1.92;            % specific loss (at freq_rif, and Bfe_rif) (W/kg) 
kmagg_t  = 2;               % tooth manufacturing loss increase factor
kmagg_bi = 1.5;             % back iron manufacturing loss increase factor
weight_t  = gamma_lamination * Qs * hs * wt * Lstk; % (kg) % teeth weight
weight_bi = gamma_lamination * pi * (De-hbi) * hbi * Lstk; % (kg) % back iron weight

% Permanent Magnet (PM) 
pm_name = 'N35SH';          % permanent magnet (PM) name
mur_pm = 1.04;              % PM magnetic permeability
Hc_pm = 895e3;              % PM coercitivity (A/m)
sigma_pm = 0.66;              % PM electric conductivity (MS/m)

%% Regions mesh sizes
mesh_air = 1e-3;            % air mesh
mesh_fe = 5e-3;             % iron mesh
mesh_pm = 0.5e-3;           % magnet mesh
mesh_gap = gap/3;           % air-gap mesh

%% Mechanical losses
calc_Pmech = 1;  % 1--> compute, else --> don't compute

%% Initialize variables
skew    = 0;  % skewing factor
thetam  = 0;  %rotor position angle
Ipeak 	= 0;  % current vector amplitude
alphaie = 0;  % current vector angle

%% Slot matrix
% Slot matrix of phase a: 24 elements.
ka = [0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5];

% Slot matrix of phase b: 24 elements.
kb = [0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5];

% Slot matrix of phase c: 24 elements.
kc = [-0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, 0.5, 0];

warning('off')
mkdir('figures');
mkdir('results');
warning('on')