clc
clear all
close all 

%--------------------- Compare sim with 2 ray ----------------------------------%
% Define the directory to search
directory = 'C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Insite Simulations\Simulation\PSAPortWaters\WiPSAProject2 - rxtxdist - blockedTx - APWCS\X3D Coverage\5G Throughput';

% Extract Information - WI
dataWI = extractRSumData(directory);


% Add distance from Tx to first Rx position
distArray = str2double(dataWI.Distance) + 120;
totalPowerdBm_WI_array = str2double(dataWI.TotalPower_dBm);

% Calculate received power - 2 ray model
h_t = 10;    
h_r = 10; 
frequency = 35e8;  
power = 45;

totalPowerdBm_2Ray_array = zeros(length(distArray), 1); 

for i = 1:length(distArray)
    d = distArray(i);
    totalPowerdBm_2Ray_array(i) = TwoRayModel(h_t, h_r, d, frequency, power);
end



% Plotting Total Power (dBm) against distance
distArray_km = distArray / 1000;  % Convert distances to kilometers
figure;
hold on
plot(distArray_km, totalPowerdBm_WI_array, 'DisplayName', 'Insite Prediction');
plot(distArray_km, totalPowerdBm_2Ray_array, 'DisplayName', '2 Ray Model');
title('Total Power (dBm) vs Tx Rx Distance');
xlabel('Distance (Km)');
ylabel('Total Power (dBm)');
box on;
set(gca, 'XScale', 'log');  % Set x-axis to logarithmic scale


% Customize x-ticks for better readability
xticks([0.1, 1, 10, 100]);  
xticklabels({'10^{-1}', '10^{0}', '10^{1}', '10^{2}'}); 
grid on;
legend;

hold off


% Find number of paths received by all UEs
%numberPaths = extractNumberPathsFromFiles(directoryPaths); 

% Add to dataWI
%dataWI.numPaths = numberPaths; 


% Scatter plot based on the number of paths
% for i = 1:length(numberPaths)
%     if numberPaths(i) == 1
%         plot(distArray_km(i), totalPowerdBm_WI_array(i), 'x', 'MarkerSize', 5, 'Color', 'blue', 'HandleVisibility', 'off');
%     elseif numberPaths(i) >= 2
%         plot(distArray_km(i), totalPowerdBm_WI_array(i), 'x', 'MarkerSize', 5, 'Color', 'black', 'HandleVisibility', 'off');
%     end
% end