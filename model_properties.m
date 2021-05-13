%%**************************************
%% *   Copyright     2021 by Qu        *
%% *                                   *

% boundary condition
mi_addboundprop('Azero', 0, 0, 0, 0, 0, 0, 0, 0, 0);

% air material
mi_addmaterial('Air', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0);

% slot material
mi_addmaterial(conductor_name, 1, 1, 0, 0, sigma_cond, 0, 0, 1, 0, 0, 0, 0, 0); 

% permanent magnet material
mi_addmaterial(pm_name, mur_pm, mur_pm, Hc_pm, 0, sigma_pm, 0, 0, 1, 0, 0, 0, 0, 0); 

% lamination material
mi_addmaterial(lamination_name, 7000, 7000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0);

BH = [
0.00,  0  	
0.40,  75 	
0.52,  85 	
0.57,  90 	
0.65,  100	
0.70,  110	
0.80,  125	
0.90,  145	
0.95,  160	
1.00,  170	
1.05,  185	
1.10,  200	
1.18,  250	
1.25,  300	
1.30,  360	
1.33,  400	
1.37,  500	
1.40,  600	
1.43,  700	
1.47,  900	
1.48,  1000	
1.54,  1500	
1.58,  2000	
1.605, 2500	
1.63,  3000	
1.67,  4000	
1.70,  5000	
1.74,  6000	
1.78,  8000	
1.81,  10000
1.88,  15000
1.93,  20000
2.00,  30000
2.004, 33000
2.075, 90000
];

for kk = 1:size(BH,1)
    mi_addbhpoint(lamination_name, BH(kk,1), BH(kk,2));
end