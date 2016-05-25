% "Belief polarization is not always irrational"
% Jern, Chang, & Kemp
%
% Code to generate model predictions for the Batson experiment
% shown in Figure 4.c.ii

close all;
clear all;

% Bayes net structure
% V-H
%  \|
%   D
%
% H: Jesus is the son of God
% V: Christian world view
% D: Christians are persecuted


no_persecution = 1; persecution = 2;
V = 1; H = 2; D = 3;
dag = zeros(3,3);
dag(V, H)=1;
dag(V, D)=1;
dag(H, D)=1;
ns = [2 2 2];
bnet = mk_bnet(dag, ns);


% Prior distribution for belief in Christian world view
% The following lines specify prior distributions on
% V -- one for believers and one for skeptics.

bnet.CPD{V} = tabular_CPD(bnet, V, [0.9 0.1]);  % Prior belief in Christian worldview
%bnet.CPD{V} = tabular_CPD(bnet, V, [0.1 0.9]);  % Prior belief in secular worldview

% CPDs for H and D nodes, as shown in Figure 4.c.i
bnet.CPD{H} = tabular_CPD(bnet, H, [0.9 0.1, 0.1 0.9]);
bnet.CPD{D} = tabular_CPD(bnet, D, [0.6 0.6 0.99 0.4, 0.4 0.4 0.01 0.6]);

engine = jtree_inf_engine(bnet);
ev = cell(1,4);
[engine, ll] = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
h_prior = m.T(1); % Prior probability for H 

% Evidence: persecution 
ev{D} = persecution;
engine = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
h_posterior = m.T(1); % Posterior probability for H

% Print out probability assigned to H at each time point, for Figure 4.a.ii
fprintf('P(H) = %.3f\n', h_prior);
fprintf('P(H|D) = %.3f\n', h_posterior);





