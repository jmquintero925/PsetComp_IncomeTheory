function res =  valueFunction(par,sim,varargin)

% Create grid
kg = linspace(sim.gmn,sim.gmx,sim.gp)';
% Calculate all possible utility
Gamma = max(par.z*kg.^par.alpha+(1-par.delta)*kg-kg',0);
uc = log(Gamma);
% Guess for value function 
if(nargin==2)
    Vo      = zeros(size(kg));
    keepIt  = false;
elseif(nargin==3)
    keepIt  = varargin{1};
    Vo      = zeros(size(kg));
else
    keepIt  = varargin{1};
    Vo  = varargin{2}.*ones(size(kg));
end
% Set counter of iterations to 0 and tolerance
it  = 0;
tol = 10;
% If necesary to track value function, initialize the matriz that tracks it
if(keepIt) 
    trk = Vo;
end
% Begin value function iteration
tStart = tic;
while(tol>sim.tol)
    % Calculate the new value function
    [Vn,Id] = max(uc + par.beta*Vo',[],2);
    % Store the iteration if needed
    if(keepIt) 
        trk = [trk,Vn];
    end
    % Update simulation results
    tol = norm(Vn-Vo);
    it  = it+1;
    Vo  = Vn; 
end
tEnd = toc(tStart);
% Policy function 
pol = kg(Id);
% Store results in structure
res.it      = it;
res.time    = tEnd;
res.error   = tol;
res.pol     = pol;
res.k       = kg;
res.vnk     = Vn;
res.id      = Id;
% If tracking the value function results store them. 
if(keepIt)
    res.trk     = trk;
end




end 