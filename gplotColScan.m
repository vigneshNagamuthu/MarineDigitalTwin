function gplotColScan(data, latId, lonId, pId, tstr)
    figure;
    geoscatter(data{:,latId},data{:,lonId},50*ones(size(data{:,latId}))',data{:,pId},"filled");
    colorbarHandle = colorbar; % Get the handle to the colorbar
    colorbarHandle.Label.String = data.Properties.VariableNames{pId};
    colorbarHandle.Label.Interpreter = 'none';
    title(strcat(tstr," : ", data.Properties.VariableNames{pId}),'Interpreter','none');
end