% "Belief polarization is not always irrational"
% Jern, Chang, & Kemp
%
% Code to run the divergence frequency analysis reported in the paper

% Bayes net structure
% B--H
%  \/
%   D

close all;
clear all;

numnets = 5000; % Number of iterations to run
thresh = 1e-05; % The threshold for counting as divergence
numdiverge = 0;
numconverge = 0;
%converge = [];
%diverge = [];

false= 1; true= 2;
V = 1; H = 2; D = 3;
dag = zeros(3,3);
dag(V, H)=1;
dag([V H], D)=1;
ns = 2*ones(1,3);
bnet = mk_bnet(dag, ns);

% The parameter for the beta distribution from which the probabilities are sampled
% Biased: 0.1
% Uniform: 1
betaparam = 1;

for n=1:numnets
    % Sample values for the CPDs
    dcpd = betarnd(betaparam,betaparam,[1 4]);
    hcpd = betarnd(betaparam,betaparam,[1 2]);
    vprior = betarnd(betaparam,betaparam,[1 2]);
    bnet.CPD{D} = tabular_CPD(bnet, D, [dcpd 1-dcpd]);
    bnet.CPD{H} = tabular_CPD(bnet, H, [hcpd 1-hcpd]);
    
    % Simulate two people updating their beliefs
    for p=1:2
        bnet.CPD{V} = tabular_CPD(bnet, V, [vprior(p) 1-vprior(p)]);

        engine = jtree_inf_engine(bnet);
        ev = cell(1,3);
        [engine, ll] = enter_evidence(engine, ev);
        m = marginal_nodes(engine, H);
        before(p) = m.T(true);

        % enter the fact that D known to be true
        ev{D} = 2;
        engine = enter_evidence(engine, ev);
        m = marginal_nodes(engine, H);
        after(p) = m.T(true);
    end
    
    if (mod(n,50) == 0)
        disp(n);
    end

    % Check if the two people moved in different directions
    if ( (after(1)-before(1) > 0 && after(2)-before(2) < 0) || ...
                (after(1)-before(1) < 0 && after(2)-before(2) > 0) )
        % Check that the gap change is bigger than a threshold
        % And that each person moved more than a threshold
        if ( (abs((after(1) - after(2)) - (before(1) - before(2))) > thresh) && ...
                abs(after(1) - before(1)) > thresh && abs(after(2) - before(2)) > thresh )
            % find out if gap widened or narrowed
            if ( (before(1) > before(2) && after(1) < before(1)) || ...
                    (before(2) > before(1) && after(2) < before(2)) )
                numconverge = numconverge + 1;
                %converge = [converge; before after];
            else
                numdiverge = numdiverge + 1;
                %diverge = [diverge; before after];
            end
        end
    end
end

fprintf('Proportion converged: %f\n', numconverge/numnets);
fprintf('Proportion diverged: %f\n', numdiverge/numnets);

