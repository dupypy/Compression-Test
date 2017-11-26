clear all
close all
% User Input start
date = '100617';
LoadExtension = 'no';
StressStrain = 'no';
% User Input end
set(0, 'DefaultAxesFontSize', 14);
d = dir(sprintf('./%s/*.csv', date));
len = length(d);
ColorOdrCustom = [1 0 0; 0 0 1; 0 0.5 0; 0 0 0; 1 0 1; 1 0.69 0.39;...
    0.6 0.2 0; 0 0.75 0.75; 0.22 0.44 0.34; 0.32 0.19 0.19];

legendtext = [];
modulus = [];

if strcmp(LoadExtension, 'yes');
    fg1 = figure;
    hold all;
    ax1 = gca;
end

if strcmp(StressStrain, 'yes');
    fg2 = figure;
    hold all;
    ax2 = gca;
end

for k = 1:len
    filename = sprintf('./%s/Specimen_RawData_%d.csv', date, k);
    fid = fopen(filename, 'rt');
    Headerline = 7;  % Lines to skip
    for n = 1:Headerline
        fgetl(fid);  % read single line
    end
    data = textscan(fid,'%q%q%q%q%q%q%q', 'Delimiter', ',') % %q to read...
    %the text enclosed by double quotation marks
    fclose(fid);
    time = str2double(data{1,1});
    stress = str2double(data{1,4});
    strain = str2double(data{1,5});
    extension = str2double(data{1,6});
    load = str2double(data{1,7});
    
    fig = figure;
    plot(strain, stress, 'o', 'linewidth', 0.5, 'color','b');
    hold on
    cursor = datacursormode(fig);
    set(cursor,'DisplayStyle','window',...
    'SnapToDataVertex','off','Enable','off')
    pause
    p1 = getCursorInfo(cursor);
    plot(p1.Position(1), p1.Position(2),'rx', 'markersize', 12, ...
        'linewidth', 3)
    pause
    p2 = getCursorInfo(cursor);
    plot(p2.Position(1), p2.Position(2),'rx', 'markersize', 12, ...
        'linewidth', 3)
    pause
    p3 = getCursorInfo(cursor);
    line([p3.Position(1) p3.Position(1)],[0 4], 'linestyle', '--', ...
        'color', 'k')
    pause
    p4 = getCursorInfo(cursor);
    line([p4.Position(1) p4.Position(1)],[0 4], 'linestyle', '--', ...
        'color', 'k')
    
    [fit] = fitting(p1.Position(1), p2.Position(1), strain, stress);
    ind_low = find(strain == p3.Position(1));
    ind_up = find(strain == p4.Position(1));
    [val] = max(stress(ind_low:ind_up));
    ind = find(stress == val)
    YieldStress = val;
    YieldStrain = strain(ind);
    legend(sprintf('run%d', k), sprintf('linear fit: y = %f*x %f', ...
        fit(1), fit(2)), sprintf('yeildStress = %f', YieldStress), ...
        sprintf('yeildStrain = %f', YieldStrain), 'Location', 'southeast');
    set(gca, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
    xlabel(gca, 'Compressive strain');
    ylabel(gca,'Compressive stress (MPa)');
    print(sprintf('./%s/run%d', date, k),'-depsc')
    modulus = [modulus; fit(1)];
    hold off
    legendtext = [legendtext; sprintf('run%d', k)];
    
    if strcmp(LoadExtension, 'yes');
        FE = plot(ax1, extension, load, 'o', 'linewidth', 0.5, 'color', ...
            ColorOdrCustom(k, :));
        set(ax1, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
        xlabel(ax1, 'Compressive extension (mm)');
        ylabel(ax1,'Compressive load (N)');
        h2 = legend(ax1, legendtext, 'Location', 'northwest');
        print(fg1, sprintf('./%s/ForceExtension', date),'-depsc');

    end
    
    if strcmp(StressStrain, 'yes');
        SS = plot(ax2, strain, stress, 'o', 'linewidth', 0.5, 'color',...
            ColorOdrCustom(k, :));
        set(ax2, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
        xlabel(ax2,'Compressive strain ');
        ylabel(ax2,'Compressive stress (MPa)');
        h1 = legend(ax2, legendtext, 'Location', 'northwest');
        print(fg2, sprintf('./%s/StressStrain', date),'-depsc');
    end
    
    
end


%str = [SampleName, '= modulus;'];
%eval(str)  % change variable name
%save('AllSamples',SampleName, '-append')