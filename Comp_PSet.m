%% Housekeeping
clear all;
%close all;
clc;

% Formatting figures
set(0,'DefaultTextFontname', 'CMU Serif')
set(0,'DefaultAxesFontName', 'CMU Serif')
set(0,'defaultAxesFontSize', 15)
set(0,'defaultlinelinewidth', 2)
set(0,'defaulttextInterpreter','latex')
set(0, 'defaultLegendInterpreter','latex')
myColors();

%% Initialize

% Set structure for parameters
par.beta    = 0.99;
par.alpha   = 0.3;
par.z       = 1;
par.delta   = 0.1;
par.kss     = (par.z*par.beta*par.alpha/(1-par.beta*(1-par.delta)))^(1/(1-par.alpha));
par.css     = par.z*par.kss.^par.alpha - par.delta*par.kss;

% Set simulation parameters
sim.tol     = exp(-5);
sim.gp      = 500;
sim.gmn     = 0.1;
sim.gmx     = (par.z/par.delta)^(1/(1-par.alpha));
sim.save    = false;


%% Problem 2.a

% Solve value function
res =  valueFunction(par,sim,true);
% Export results
export_results(par,sim,res,'2a')

%% Problem 2.b

% Update parameters
par.beta    = 0.1;
par.kss     = (par.z*par.beta*par.alpha/(1-par.beta*(1-par.delta)))^(1/(1-par.alpha));
par.css     = par.z*par.kss.^par.alpha - par.delta*par.kss;

% Solve value function
res         =  valueFunction(par,sim,true);
% Export results
export_results(par,sim,res,'2b')

%% Problem 2.c
par.beta    = 0.99;
par.kss     = (par.z*par.beta*par.alpha/(1-par.beta*(1-par.delta)))^(1/(1-par.alpha));
par.css     = par.z*par.kss.^par.alpha - par.delta*par.kss;

% Initial guess
vo          = log(max(par.z*res.k.^par.alpha - par.delta*res.k,0))/(1-par.beta);
% Solve value function
res         =  valueFunction(par,sim,true,vo);
% Export results
export_results(par,sim,res,'2c')

%% Problem 3.a

% New set of  parameters
par2        = par;
par2.z      = 2;
par2.kss    = (par2.z*par.beta*par.alpha/(1-par.beta*(1-par.delta)))^(1/(1-par.alpha));

% Solve new equilibrium
res2        =  valueFunction(par2,sim,false,vo);
% Get steady states
[~,ss] = min(abs(res.pol-res.k));
[~,ss2] = min(abs(res2.pol-res2.k));
kss1   = res.k(ss);
kss2   = res2.k(ss2);

global c
% Plot policy functions
figure;
hold on
plot(res.k,res.pol,'Color',c.maroon)
plot(res2.k,res2.pol,'Color',c.nvyBlue)
plot(xlim(),[kss1,kss1],':k')
plot(xlim(),[kss2,kss2],':k')
scatter([kss1,kss2],[kss1,kss2],'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
xlabel('Capital, $k_t$')
ylabel('Policy Function, $k_{t+1}=g(k_t)$')
xlim([0,sim.gmx])
ylim([0,sim.gmx])
legend('$z=1$','$z=2$','Location','northwest','box','off')
if(sim.save)
    export_fig('Figures/polFunc3a','-pdf','-transparent');
end

%% Problem 3.b

% Create vector of transition
ktrans      = NaN(36,1);
ktrans(1)   = res.k(ss);

for t = 1:35
    ss = res2.id(ss);
    ktrans(t+1) = res2.k(ss);
end

figure;
hold on
plot(0:35,ktrans,'Color',c.maroon)
plot(xlim(),[kss1,kss1],':k')
plot(xlim(),[kss2,kss2],':k')
xlim([0,30])
ylim([3,12])
ylabel('Capital, $k_t$')
xlabel('Period, $t$')
if(sim.save)
    export_fig('Figures/transition','-pdf','-transparent');
end

