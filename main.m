[~,~,training_data] = xlsread('training_data.xlsx');
training_data(1,:) = [];

input_data = cell2mat(training_data(:,4:37));

nans = isnan(input_data);
input_data(nans) = 0; % set NaN values to 0

desired_output = cell2mat(training_data(:,38));
input_data = input_data';

num_input_units = size(input_data,1); %34
num_input_patterns = size(input_data,2); %672

num_hidden_layers = 5;
h1_num_units = 29;
h2_num_units = 24;
h3_num_units = 19;
h4_num_units = 14;
h5_num_units = 9;
num_output_units = 1;
num_epochs = 3000;

% create matrix for the weights between input and hidden layers and hidden
% layer and output
w_fh1 = rand(h1_num_units, num_input_units); % 29x34
w_h1h2 = rand(h2_num_units, h1_num_units); 
w_h2h3 = rand(h3_num_units, h2_num_units);
w_h3h4 = rand(h4_num_units, h3_num_units);
w_h4h5 = rand(h5_num_units, h4_num_units);
w_h5g = rand(num_output_units, h5_num_units);

output_error = zeros(1, num_input_patterns); % vector to store errors of each pattern

for i = 1:num_epochs
   % one pattern at a time
   for curr_pattern = 1:num_input_patterns
       input_to_h1 = w_fh1 * input_data(:,curr_pattern);  % ************* switched dimensions 
       h1_activation = activation_fn(input_to_h1);
       input_to_h2 = w_h1h2 * h1_activation;
       h2_activation = activation_fn(input_to_h2);
       input_to_h3 = w_h2h3 * h2_activation;
       h3_activation = activation_fn(input_to_h3);
       input_to_h4 = w_h3h4 * h3_activation;
       h4_activation = activation_fn(input_to_h4);
       input_to_h5 = w_h4h5 * h4_activation;
       h5_activation = activation_fn(input_to_h5);
       h5_to_output = w_h5g * h5_activation;
       output_activation = activation_fn(h5_to_output);
       
       output_error = desired_output(curr_pattern) - output_activation;
       
       % determine weight changes
       dw_fh1 = diag(h1_activation .* (1-h1_activation)) * w_h1h2' * output_error * (h2_activation .* (1-h2_activation)) * input_data(:,curr_pattern)';
       dw_h1h2 = diag(h2_activation .* (1-h2_activation)) * w_h2h3' * output_error * (h3_activation .* (1-h3_activation)) * input_data(:,curr_pattern)';
       dw_h2h3 = diag(h3_activation .* (1-h3_activation)) * w_h3h4' * output_error * (h4_activation .* (1-h4_activation)) * input_data(:,curr_pattern)';
       dw_h3h4 = diag(h4_activation .* (1-h4_activation)) * w_h4h5' * output_error * (h5_activation .* (1-h5_activation)) * input_data(:,curr_pattern)';
       dw_h4h5 = diag(h5_activation .* (1-h5_activation)) * w_h5g' * output_error * (output_activation .* (1-output_activation)) * input_data(:,curr_pattern)';
       dw_h5g = (output_activation .* (1-output_activation)) * output_error * h5_activation';
       
       % apply weight changes
       w_fh1 = w_fh1 + dw_fh1;
       w_h1h2 = w_h1h2 + dw_h1h2;
       w_h2h3 = w_h2h3 + dw_h2h3;
       w_h3h4 = w_h3h4 + dw_h3h4;
       w_h4h5 = w_h4h5 + dw_h4h5;
       w_h5g = w_h5g + dw_h5g;
   end
end

