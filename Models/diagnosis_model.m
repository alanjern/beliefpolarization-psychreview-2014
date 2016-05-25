% "Belief polarization is not always irrational"
% Jern, Chang, & Kemp
%
% Code to generate model predictions for the experiment in the article.

close all;
clear all;

% Bayes net structure
% V-H
%  \
%   D
%
% V: Disease 
% H: Disease class
% D: Test result


false= 1; true= 2;
V = 1; H = 2; D1 = 3; D2 = 4;
dag = zeros(4,4);
dag(V, H)=1;
dag(V, D1)=1;
dag(V, D2)=1;
ns = [4 2 4 4];
bnet = mk_bnet(dag, ns);


% Prior distribution for the diseases
% 
% These lines contain different settings of the prior for V. They
% are based on different transformations of the priors illustrated in
% Figure 8. As discussed in the appendix, all of the transformations
% below produce the same qualitative predictions.

% No probability distortion
bnet.CPD{V} = tabular_CPD(bnet, V, [0.001 0.349 0.25 0.4]); 
% Gonzalez and Wu (1999)
%bnet.CPD{V} = tabular_CPD(bnet, V, [0.1649    0.4549    0.4111    0.4767]);
% Wu and Gonzalez (1996)
%bnet.CPD{V} = tabular_CPD(bnet, V, [0.0073    0.3617    0.2929    0.3954]);
% Tversky and Kahneman (1992)
%bnet.CPD{V} = tabular_CPD(bnet, V, [0.0145    0.3441    0.2907    0.3700]);
% Camerer and Ho (1994)
%bnet.CPD{V} = tabular_CPD(bnet, V, [0.0202    0.3284    0.2836    0.3504]);

% a sets the probability of getting an accurate test result. As discussed in
% the Appendix, as long as acc > 0.25, the model's qualitative predictions hold.
a = 0.5;
h_prior = 0; % Prior probability for H
h_posterior_m = 0; % Posterior probability for H in the moderation condition
h_posterior_p = 0; % Posterior probability for H in the polarization condition

% CPDs for H and D nodes, as shown in Figure 7
bnet.CPD{H} = tabular_CPD(bnet, H, [1 1 0 0, 0 0 1 1]);

b = (1-a)/3;
bnet.CPD{D1} = tabular_CPD(bnet, D1, [a b b b, b a b b, ...
                                      b b a b, b b b a]);
bnet.CPD{D2} = tabular_CPD(bnet, D2, [a b b b, b a b b, ...
                                      b b a b, b b b a]);


engine = jtree_inf_engine(bnet);
ev = cell(1,4);
[engine, ll] = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
h_prior = m.T(true); 

% Evidence for the polarization condition 
ev{D1} = 1;
ev{D2} = 4;
engine = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
m2 = marginal_nodes(engine, V);
h_posterior_p = m.T(true);

% Evidence for the moderation condition 
ev{D1} = 2;
ev{D2} = 3;
engine = enter_evidence(engine, ev);
m = marginal_nodes(engine, H);
m2 = marginal_nodes(engine, V);
h_posterior_m = m.T(true);

% Print out probability assigned to H before and after evidence for each condition
fprintf('P(H) = %.3f\n', h_prior);
fprintf('Moderation: P(H|D1,D2) = %.3f\n', h_posterior_m);
fprintf('Polarization: P(H|D1,D2) = %.3f\n', h_posterior_p);

