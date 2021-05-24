% This Matlab Script uses the same construction as main.m, but solves the
% maze using a homebrew back propagation neural network.

% Writen by Hunter Whaples for Prof. R. Wang at HMC on 5/16/2021

rng(10)          % Set a random seed for repeatable results

%% Create the 4-Connected Grid Environment
m       = 10;     % rows
n       = 10;     % columns
exit    = m*n;    % exit bottom right corner
reward  = 10;     % reward for reaching exit
wall    = -100;   % const. representing impassable wall
penalty = -1;     % cost of moving
eps     = 0.7;    % how often to choose optimal connected path

maze = generate_maze(m,n,exit,reward,wall,penalty,eps);

% Visualize the maze
figure(1)
imagesc(maze);
title('Maze Environment');
axis off


%% Testing


%% BPN Training and Application Functions

function [Wh,Wo,g] = BPN_train(X,Y,Wh,Wo,g)
    % Trains a shallow backpropagation neural network.
    % Parameters:
    %   X                -- Input state
    %   Y                -- Labeled output
    %   Wh               -- Hidden layer weights
    %   Wo               -- Output layer weights
    %   g                -- symbolic activation function
    % Returns:
    %   Wh               -- Updated hidden layer weights
    %   Wo               -- Updated output layer weights
    
    %%% Environment Specific Hyper Parameters %%%
    L = 50;      % Number of Hidden Nodes
    M = 4;       % Number of Output Nodes
    eta = 0.01;  % Learning Rate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isempty(g)
        syms x
        g  = 1/(1+exp(-x));             % Sigmoid activation function
    end
    if isempty(Wh) || isempty(Wo)
        Wh = 1 - 2 * rand(L,d+1);      % Inialize hidden layer weights
        Wo = 1 - 2 * rand(M,L+1);       % Initalize output layer weights
    end
    
    dg = diff(g);                       % Activation derivative function
    g  = matlabFunction(g);
    dg = matlabFunction(dg);
    
    %%% Post Intialization %%%
    ah = Wh * X;                  % activation of hidden layer from sample
    z  = [1; g(ah)];              % augment z by adding a 1
    ao = Wo * z;                  % activation of output layer
    yhat = g(ao);                 % output of output layer
    delta = Y - yhat;             % delta error
    do = delta .* dg(ao);         % d of output layer
    
    Wo = Wo + eta * do * z';      % update weights of output layer
    dh = (Wo(:,2:L+1)'*do).*dg(ah);    % delta of hidden layer
    Wh = Wh + eta * dh * x';      % update weights for hidden layer
end

function output = BPN_predict(X,Wh,Wo,g)
    % Calculates the BPN output of a given input
    [~,K] = size(X);
    X  = [ones(1,K);X];
    output = g(Wo*[ones(1,K); g(Wh*X)]);
end




function [Wh, Wo, g]=backPropagate(X,Y)
    syms x; 
    g=1/(1+exp(-x));              % Sigmoid activation function
    dg=diff(g);                   % its derivative function
    g=matlabFunction(g);
    dg=matlabFunction(dg);
    [d,N]=size(X);                % number of inputs and number of samples
    X=[ones(1,N); X];             % augment X by adding a row of x0=1  
    Wh=1-2*rand(L,d+1);           % Initialize hidden layer weights 
    Wo=1-2*rand(M,L+1);           % Initialize output layer weights 
    er=inf;
    while er > tol
        I=randperm(N);            % random permutation of samples
        er=0;
        for n=1:N                 % for all N samples for an epoch
            x=X(:,I(n));          % pick a training sample      
            ah=Wh*x;              % activation of hidden layer  
            z=[1; g(ah)];         % augment z by adding z0=1
            ao=Wo*z;              % activation to output layer
            yhat=g(ao);           % output of output layer 
            delta=Y(:,I(n))-yhat  % delta error
            er=er+norm(delta)/N   % test error
            do=delta.*dg(ao);     % Find d of output layer 
            Wo=Wo+eta*do*z';      % update weights for output layer 
            dh=(Wo(:,2:L+1)'*do).*dg(ah);   % delta of hidden layer 
            Wh=Wh+eta*dh*x';      % update weights for hidden layer 
        end         
    end
end