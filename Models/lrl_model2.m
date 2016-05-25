% "Belief polarization is not always irrational"
% Jern, Chang, & Kemp
%
% Code to generate model predictions for the Lord, Ross, and Lepper experiment
% shown in Figure 4.b.ii and the second column of Figure 5b.

close all;
clear all;

% Bayes net structure
% V-H
%  \
%   D
%
% H: Death penalty is effective
% V: Crime-deterring strength of death penalty
% D: Crime-deterring strength of death penalty supported by study

false= 1; true= 2;
V = 1; H = 2; D1 = 3; D2 = 4;
dag = zeros(4,4);
dag(V, H)=1;
dag(V, D1)=1;
dag(V, D2)=1;
ns = [4 2 4 4];
bnet = mk_bnet(dag, ns);


% Prior distributions for strength of death penalty
% The following lines specify prior distributions on
% V -- one for death penalty supportors, one
% for opponents.

%bnet.CPD{V} = tabular_CPD(bnet, V, [0.1 0.1 0.2 0.6]);  % Death penalty supporter
bnet.CPD{V} = tabular_CPD(bnet, V, [0.6 0.2 0.1 0.1]);  % Death penalty opponent

% CPDs for the H and D nodes, as shown in Figure 4.b.ii
bnet.CPD{H} = tabular_CPD(bnet, H, [1 1 0 0, 0 0 1 1]);
a = 0.7;
b = (1-a)/3;
bnet.CPD{D1} = tabular_CPD(bnet, D1, [a b b b, b a b b, ...
                                      b b a b, b b b a]);
bnet.CPD{D2} = tabular_CPD(bnet, D2, [a b b b, b a b b, ...
                                      b b a b, b b b a]);


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

% Evidence piece 1: Negative (very weak) evidence 
ev{D1} = 1;
engine = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
h_posterior(1) = m.T(true); % Posterior probability for H

% Evidence 2: Positive (very strong) evidence
ev{D1} = 1;
ev{D2} = 4;
engine = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
h_posterior(2) = m.T(true);

% Print out probability assigned to H at each time point, for Figure 4.b.i
fprintf('P(H) = %.3f\n', h_prior(1));
fprintf('P(H|D1) = %.3f\n', h_posterior(1));
fprintf('P(H|D1,D2) = %.3f\n', h_posterior(2));

% Apply logit transformation and print out changes, as shown in Figure 5b
fprintf('logit(P(H)) - logit(P(H)) = %.3f\n', adjust_p(h_prior(1)) - adjust_p(h_prior(1)));
fprintf('logit(P(H|D1)) - logit(P(H)) = %.3f\n', adjust_p(h_posterior(1)) - adjust_p(h_prior(1)));
fprintf('logit(P(H|D1,D2)) - logit(P(H)) = %.3f\n', adjust_p(h_posterior(2)) - adjust_p(h_prior(1)));


