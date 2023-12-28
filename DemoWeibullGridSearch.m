clc; clear; close all;

% % True pdf 
a  = 10;    % scale > 0 
b  = 5;    % shape > 0 
n  = 100;  % sample size 

% z = a*(-log(rand(n,1))).^(1/b); % Weibull random generator 
z = wblrnd(a, b, 1, n); % Matlab's Weibull random generator 

% % Grid Search
grid_res = 0.1; % grid resolution 
grid_a = 0:grid_res:2*a; % arbitary grid for a 
grid_b = 0:grid_res:2*b; % arbitary grid for b 

% Log likelihood 
likelihood = nan(length(grid_a),length(grid_b));
for i = 1:length(grid_a)
    for j = 1:length(grid_b)
        likelihood(i,j) = prod(wblpdf(z,grid_a(i),grid_b(j)));
    end
end
clear i j 


% % Minimum of Negative Log-Likelihood
negLL   = -log(likelihood); 
[~,ind] = min(negLL,[],'all');
[id_a,id_b] = ind2sub(size(negLL),ind); 

a_hat = grid_a(id_a);
b_hat = grid_b(id_b);


figure(Position=[150,450,1200,300])
tiledlayout(1,3)
nexttile
histogram(z, Normalization="pdf", DisplayName='Samples');
hold on 
plot(0:0.1:2*a, wblpdf(0:0.1:2*a,a_hat,b_hat), DisplayName='Fit')
legend(HandleVisibility="on")

title(['Weibull Distribution (a=',num2str(a), ', b=',num2str(b),')'])
xlabel('$z$', Interpreter='latex')
ylabel('pdf', Interpreter='latex')

nexttile
surf(likelihood);
zlabel('Likelihood', Interpreter='latex')
xlabel('$a$-grid index', Interpreter='latex')
ylabel('$b$-grid index', Interpreter='latex')

nexttile
imagesc(grid_a,grid_b, likelihood);
colorbar;
title(['ahat=',num2str(a_hat), ', bhat=',num2str(b_hat)])
xlabel('$a$', Interpreter='latex')
ylabel('$b$', Interpreter='latex')