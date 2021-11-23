function export_results(par,sim,res,q)
global c
% Plot policy function
figure; 
hold on
plot(res.k,res.pol,'Color',c.maroon)
plot([0,sim.gmx],[0,sim.gmx],'--k')
xlabel('Capital, $k_t$')
ylabel('Policy Function')
xlim([0,sim.gmx])
ylim([0,sim.gmx])
legend('$k_{t+1}=g(k_t)$','$45^\circ$ line','Location','northwest','box','off')
export_fig(strcat('Figures/polFunc',q),'-pdf','-transparent'); 

% Plot value function iteration
figure
plot(res.k,res.trk)
xlabel('Capital, $k_t$')
ylabel('Value Function, $V(k)$')
xlim([0,sim.gmx])
ylim([0,sim.gmx])
export_fig(strcat('Figures/valFunItc',q),'-pdf','-transparent'); 


% Plot final value function
figure; 
hold on
plot(res.k,res.vnk,'Color',c.maroon)
xlabel('Capital, $k_t$')
ylabel('Value Function, $V(k)$')
xlim([0,sim.gmx])
ylim([0,sim.gmx])
export_fig(strcat('Figures/valFunc',q),'-pdf','-transparent');

% Calculate the SS capital
[~,ss] = min(abs(res.pol-res.k));
kss   = res.k(ss);


% Create table for reporting simulation results
input.data                  = [res.it,1e02*res.time,1e03*res.error,kss;...
                               NaN,NaN,NaN,par.kss];
input.tableCaption          = 'Simulation Summary';
input.tableLabel            = strcat('psCp2:tab:sim',q);
input.tablePositioning      = 'htb';
input.tableColumnAlignment  = 'c';
input.tableBorders          = 0;
input.dataFormat            = {'%2.3f'};
input.tableColLabels = {'Iterations','Centiseconds','Error$\times 10^3$','Steady State'};
input.tableRowLabels = {'Simulation','Theory Benchmark'};
latex = latexTable2(input);
dlmcell(strcat('Tables/simulations',q,'.tex'),latex)



end