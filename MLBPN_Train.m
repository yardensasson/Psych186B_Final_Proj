% Multilayer Backpropagation Neural Network
% with any number of input units, hidden layers, output units
% and any number of neurons in hidden layers and output units

% Written by:    Asad Ali
%                asad_82@yahoo.com
%                16-17th Feburary 2006
% the code was written while I was at the GIK Institute of Engineering Sciences and Technology

% Cite the original backpropagation paper (Learning representations by back-propagating errors, Nature) 
% and the following paper if you use this in your work and want to acknowledge. 
% A. Chaudhry, A. Khan, A.M. Mirza, A. Ali, et. al, 
% Neuro Fuzzy and Punctual Kriging Based Filter for Image Restoration
% Applied Soft Computing, vol. 13, issue 2, page 817-832, February 2013

clear all;
close all;

%%%%%%% Set Parameters of Multilayer Backpropagation Neural Network %%%%%%
% Initialize some parameters
alpha = 0.9;      % learning rate (change as required)
I = 34;			  % no. of input units
HN = [29 19 9]; 	  % no. of neurons in each hidden layer i.e 3 layers currently
HL = size(HN,2);  % no. of hidden layers
O = 1; 	 	      % no. of output units
totalLayers = [I HN O];
TOTAL_ITERATIONS = 50; % change the total number of iterations here

%%% Define input/output pattern (use your own pattern here)
% s contains the input pattern and t the desired output for training
[s,t] = DefinePattern();

%%%%%%%%%%%%%%%%%% Initialization of Weights %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize the hidden and output layer weights
% to small random numbers
for i=1:size(totalLayers,2)-1
    L1 = totalLayers(i);
    L2 = totalLayers(i+1);
    for j = 1: L1+1 % 1 is for bias input
        for k= 1:L2
            % ith layer jth neuron in that layer and kth link of that
            % neuron
            Wts(i,k,j) = -0.01+0.02*rand;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Start of forward Propagation%%%%%%%%%%%%%%%%%%%

for k=1:TOTAL_ITERATIONS
    % randomly select an input : target pair from
    % the given pattern
    p=fix(1+rand*7);
    x=s(p,:);
    x(I+1)=1;
    outDesired=t(p,:);
    
    for g=1:HN(1)
        % output of the first hidden layer units
        % 1 shows that its layer 1 and g counters the number of neurons in
        % the layer
        clear tempWts;
        tempWts(1:I+1) = Wts(1,g,1:I+1);
        yInHid(1,g)=x*tempWts'; % summations i.e input to every neuron
        yHid(1,g)=1./(1.+exp(-yInHid(1,g)));
    end
    % output of hidden layer 1 and bias input used in next layer is added
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
    for g=1:O
        tempWts(1:HN(HL)+1)=Wts(lastLayer,g,1:HN(HL)+1);
        % this is the input to the output layer neurons i.e summed input
        yInHid(lastLayer,g)=yHid(lastLayer-1,1 : HN(HL)+1)*tempWts'; %lastLayer-1
        yOut(g)=1./(1. + exp(-yInHid(lastLayer,g)));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%End of forward Propagation%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% Back Propagation of errors %%%%%%%%%%%%%%%%%%%%
    
    %Calculate errors and the deltas for output weights
    for g=1:O
        outErrors(g)=outDesired(g) - yOut(g);
        outDelta(g)= outErrors(g)*(yOut(g)*(1-yOut(g)));
        % multiply the weights of the output layer with delta
        % to compute the terms that will be propagated back as the
        % difference between the input and the desired output
        abc(g,1:HN(HL)+1)= Wts(lastLayer,g,1:HN(HL)+1)*outDelta(g);
        
        % Update weights on the output layer
        clear tempWts;
        tempWts(1:HN(HL)+1) = Wts(lastLayer,g,1:HN(HL)+1);
        Wts(lastLayer,g,1:HN(HL)+1) = tempWts + alpha*yHid(lastLayer-1,1:HN(HL)+1)*outDelta(g); %lastlayer-1
        
    end
    
    % index variable used for obtaining the number of neurons in each hidden
    % layer
    index=0;
    index2=1;
    for q=lastLayer-1:-1:2
        %clear the variables
        clear yhidTemp;
        clear hidDelta;
        clear yHtemp;
        clear tempHidDelta;
        clear intermediateCalc;
        
        % compute the hidden layer delta for each neuron
        yhidTemp=yHid(q,1:HN(HL-index)+1); % bias term included but will be removed later
        hidDelta= abc(g,:)' * (1-yhidTemp)*yhidTemp';
        
        % update weights on the hidden layer neurons
        yHtemp=yHid(q-1,1:HN(HL-index2)+1); % include the bias input for this layer because we'll update it
        
        v = HN(HL-index); % no. of neurons in the layer before
        clear tempWts;
        tempWts(1:v,1:HN(HL-index2)+1) = Wts(q,1:v,1:HN(HL-index2)+1);%index2
        
        % before updating the weights calculate the delta_in_j i.e abc
        tempHidDelta = hidDelta(1:HN(HL-index)); % remove the bias input term from the hiddelta
        clear abc;
        abc= (tempWts'*tempHidDelta)';
        
        % continue with the updation of weights
        intermediateCalc = alpha*yHtemp'*hidDelta';
        tempWts = tempWts' + intermediateCalc(1:size(intermediateCalc,1),1:size(intermediateCalc,2)-1);
        
        for m=1:v
            Wts(q,m,1:HN(HL-index2)+1) = tempWts(1:HN(HL-index2)+1,m);
        end
        
        % increment the index values index1 follows index2
        index = index +1;
        index2 = index2+1;
    end
    
    % now update the weights of input units
    clear yhidTemp;
    
    % compute the hidden delta
    yhidTemp=yHid(1,1:HN(HL-index)+1); % bias term included
    hidDelta= abc(g,:)' * (1-yhidTemp)*yhidTemp';
    
    % update weights on the hidden layer neurons
    yHtemp=x; % include the bias input for this layer because we'll update it
    yHtemp(I+1)=1;
    
    v = HN(1); % no. of neurons in the layer before
    clear tempWts;
    tempWts(1:v,1:I+1) = Wts(1,1:v,1:I+1);
    
    % continue with the updation of weights
    intermediateCalc = alpha*yHtemp'*hidDelta';
    tempWts = tempWts' + intermediateCalc(1:size(intermediateCalc,1),1:size(intermediateCalc,2)-1);
    
    for m=1:v
        Wts(1,m,1:I+1) = tempWts(1:I+1,m);
    end
    
    % end of updation of weights of input units
    
    %%%%%%%%%%%%%%%%%%%% End of Back Propagation of errors %%%%%%%%%%%%%%%%%%%%    
    clear abc;
    
    % compute the squared error
    err(k)= outErrors*outErrors;
end

disp('Training Complete');
figure,plot(err);
xlabel('No. of epochs')
ylabel('Error')

% save the trained network(Wts) for use in testing along with input output
% pattern pairs
save mlbpn_train.mat Wts I HN O totalLayers s t;
