% Multilayer Backpropagation Neural Network
% with any number of input units, hidden layers, output units
% and any number of neurons in hidden layers and output units

% Written by:    Asad Ali
%                asad_82@yahoo.com
%                16-17th Feburary 2006
% the code was written while I was at the GIK Institute of Engineering Sciences and Technology

% Cite the original backpropagation paper (Learning representations by back-propagating errors, Nature) 
% and the following paper if you use this in your work and want to acknowledge 
% A. Chaudhry, A. Khan, A.M. Mirza, A. Ali, et. al, 
% Neuro Fuzzy and Punctual Kriging Based Filter for Image Restoration
% Applied Soft Computing, vol. 13, issue 2, page 817-832, February 2013

% Test the trained MLBPN network (output shown in matlab command window)

clear all;
close all;

load mlbpn_train.mat;

% randomly select an input : target pair from
% the given pattern
p=fix(1+rand*7);

disp('Input on which it is trained');
x=s(p,:)
x(I+1)=1;
disp('Desired Output');
outDesired=t(p,:)

HL = size(HN,2);  % no. of hidden layers

for g=1:HN(1)
    % output of the first hidden layer units
    % 1 shows that its layer 1 and g counters the number of neurons in
    % the layer
    clear tempWts;
    tempWts(1:I+1) = Wts(1,g,1:I+1);
    yInHid(1,g)=x*tempWts'; % summations i.e input to every neuron
    yHid(1,g)=1./(1.+exp(-yInHid(1,g)));
end
% output of hidden layer 1 and bias input
yHid(1,HN(1)+1)=1;

% forward propagation of input to hidden layers
for i=2:size(totalLayers,2)-2
    for g=1:HN(i)
        clear tempWts;
        tempWts(1:HN(i-1)+1) = Wts(i,g,1:HN(i-1)+1);
        yInHid(i,g)=yHid(i-1,1:HN(i-1)+1)* tempWts';
        yHid(i,g)=1./(1.+exp(-yInHid(i,g) ));
    end
    yHid(i,HN(i)+1)=1;
end

% Output of the output layer units
clear tempWts;
lastLayer=size(totalLayers,2)-1;
disp('Obtained Output')
for g=1:O
    tempWts(1:HN(HL)+1)=Wts(lastLayer,g,1:HN(HL)+1);
    % this is the input to the output layer neurons i.e summed input
    yInHid(lastLayer,g)=yHid(lastLayer-1,1 : HN(HL)+1)*tempWts'; %lastLayer-1
    yOut(g)= 1./(1. + exp(-yInHid(lastLayer,g)))
end
