% "Belief polarization is not always irrational"
% Jern, Chang, & Kemp
%
% Code to generate model predictions for the Lord, Ross, and Lepper experiment
% shown in Figure 4.a.ii and the first column of Figure 5b.

close all;
clear all;

% Bayes net structure
% H-->D<--V
%
% H: Death penalty is effective
% V: Consensus supports effectiveness of death penalty
% D: Study supports effectiveness of death penalty

false = 1; true = 2;
H = 1; V = 2; D1 = 3; D2 = 4;
dag = zeros(4,4);
dag(V, D1)=1;
dag(V, D2)=1;
dag(H, D1)=1;
dag(H, D2)=1;
ns = [2 2 2 2];
bnet = mk_bnet(dag, ns);


% Prior distribution for belief in death penalty
% The following lines specify prior distributions on
% H and V -- one for death penalty supportors, one
% for opponents.

% Death penalty supporter
%bnet.CPD{H} = tabular_CPD(bnet, H, [0.2 0.8]);
%bnet.CPD{V} = tabular_CPD(bnet, V, [0.8 0.2]);

% Death penalty opponent
bnet.CPD{H} = tabular_CPD(bnet, H, [0.8 0.2]);
bnet.CPD{V} = tabular_CPD(bnet, V, [0.2 0.8]);

% CPDs for the D node, as shown in Figure 4.a.i
bnet.CPD{D1} = tabular_CPD(bnet, D1, [0.9 0.5 0.5 0.1, 0.1 0.5 0.5 0.9]);
bnet.CPD{D2} = tabular_CPD(bnet, D2, [0.9 0.5 0.5 0.1, 0.1 0.5 0.5 0.9]);

engine = jtree_inf_engine(bnet);
ev = cell(1,4);
[engine, ll] = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
h_prior = m.T(true); % Initial (prior) probability for H

% Provide one piece of evidence, compute posterior on H, then
% provide the second piece of evidence, and compute posterior again.
%
% The code below generates predictions for the first row of Figure
% 5b, in which the negative evidence is observed first.
%
% To generate predictions for the second row, simply invert D1 and D2.

% Evidence piece 1: negative evidence
ev{D1} = false;
engine = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
h_posterior(1) = m.T(true); % Posterior probability for H

% Evidence piece 2: positive evidence
ev{D1} = false; ev{D2} = true;
engine = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
h_posterior(2) = m.T(true);

% Print out probability assigned to H at each time point, for Figure 4.a.ii
fprintf('P(H) = %.3f\n', h_prior(1));
fprintf('P(H|D1) = %.3f\n', h_posterior(1));
fprintf('P(H|D1,D2) = %.3f\n', h_posterior(2));

% Apply logit transformation and print out changes, as shown in Figure 5b
fprintf('logit(P(H)) - logit(P(H)) = %.3f\n', adjust_p(h_prior(1)) - adjust_p(h_prior(1)));
fprintf('logit(P(H|D1)) - logit(P(H)) = %.3f\n', adjust_p(h_posterior(1)) - adjust_p(h_prior(1)));
fprintf('logit(P(H|D1,D2)) - logit(P(H)) = %.3f\n', adjust_p(h_posterior(2)) - adjust_p(h_prior(1)));

