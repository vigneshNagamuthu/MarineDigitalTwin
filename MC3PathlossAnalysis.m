clear all 
clc
close all 

% Use export2Csv
dir = 'C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\QualipocScannerResults\LazarusCampaignMC3\QualiPoc\Export2csv\m1.csv';
data = readtable(dir);

dataAnalysis = data(:, {'Lat', 'Long', 'PCI__PCell_', 'SS_RSRP__PCell_','NetworkThrptUL'});
cleanQualipocData = dataAnalysis(~isnan(dataAnalysis.Lat) & ~isnan(dataAnalysis.Long) & ~isnan(dataAnalysis.PCI__PCell_), :);

% a) Plot RSRP
gplotColScan(dataAnalysis, 'Lat', 'Long', 'SS_RSRP__PCell_', 'M1 5G RSRP');

% b) Plot Throughput
gplotColScan(dataAnalysis, 'Lat', 'Long', 'NetworkThrptUL', 'M1 5G Throughput');

% c) Distance from BS vs RSRP

% Find how many time instants each pci connects to
[unique_pcis, ~, pci_indices] = unique(cleanQualipocData.PCI__PCell_);

% Count occurrences using accumarray
pci_counts = accumarray(pci_indices, 1);

for i = 1:length(unique_pcis)
    fprintf('PCI: %d, Count: %d\n', unique_pcis(i), pci_counts(i));
end

% max points are pci 678, 729
% plot points with 729
data729 = cleanQualipocData(cleanQualipocData.PCI__PCell_ == 729, :); 
gplotColScan(data729, 'Lat', 'Long', 'SS_RSRP__PCell_', 'M1 5G RSRP PCI 729');

% find lat,long of 729
scanDir = 'C:\Users\A103764\Documents\Sandbox\RadioCoverage\Marine Paper\MC3\m1ScanData3.csv';
scanData = readtable(scanDir);
scan729 = scanData(scanData.PhyCellID == 729, :);
scan729 = scan729(1, :);

% calculate distance from 729 to sample points
wgs84 = wgs84Ellipsoid();

% Calculate distance from 729 to sample points
for i = 1:height(data729)

    rowQ = data729(i, :);
    latQ = rowQ.Lat;
    longQ = rowQ.Long; 

    for j = 1: height(scan729)
        rowS = scan729(j,:); 
        
        latS = rowS.Latitude;
        longS = rowS.Longitude; 
        
        % Calculate the distance between the points using the wgs84 ellipsoid
        distanceArray729(i, j) = distance(latQ, longQ, latS, longS, wgs84);
    end
end

data729.DistFromBS = distanceArray729; 

scatter(data729.DistFromBS, data729.SS_RSRP__PCell_)