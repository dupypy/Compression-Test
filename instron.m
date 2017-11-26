clear all  
close all
% User Input start
date = 'test';
% User Input end
set(0, 'DefaultAxesFontSize', 14);
d = dir(sprintf('./%s/*.csv', date));
len = length(d);
ColorOdrCustom = [1 0 0; 0 0 1; 0 0.5 0; 0 0 0; 1 0 1; 1 0.69 0.39;...
    0.6 0.2 0; 0 0.75 0.75; 0.22 0.44 0.34; 0.32 0.19 0.19];

text = [];
modulus = [];
fg1 = figure;
hold all;
ax1 = gca;

fg2 = figure;
hold all;
ax2 = gca;

for k = 1:len  
    filename = sprintf('./%s/Specimen_RawData_%d.csv', date, k);
    fid = fopen(filename, 'rt');
    Headerline = 7;   
    for n = 1:Headerline
        fgetl(fid);
    end
    data = textscan(fid,'%q%q%q%q%q%q%q', 'Delimiter', ',') % headerline doesn't work here due to empty cells
    fclose(fid);
    time = str2double(data{1,1});
    stress = str2double(data{1,4});
    strain = str2double(data{1,5});
    extension = str2double(data{1,6});
    load = str2double(data{1,7});
    
    figure
    plot(strain, stress, 'o', 'linewidth', 0.5, 'color','b');
    hold on
    zoom on;
    pause
    [p1] = ginput(1);
    plot(p1(1), p1(2),'rx', 'markersize', 12, 'linewidth', 3)
    pause
    [p2] = ginput(1);
    plot(p2(1), p2(2),'rx', 'markersize', 12, 'linewidth', 3)
    zoom out;
    [fit] = fitting(p1, p2, strain, stress);
    legend(sprintf('run%d', k), sprintf('linear fit: y = %f*x %f', ...
        fit(1), fit(2)), 'Location', 'southeast');
    set(gca, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
    xlabel(gca, 'Compressive strain');
    ylabel(gca,'Compressive stress (MPa)');
    print(sprintf('./%s/run%d', date, k),'-depsc')
    modulus = [modulus; fit(1)];
    hold off
    
    FE = plot(ax1, extension, load, 'o', 'linewidth', 0.5, 'color', ColorOdrCustom(k, :));
    SS = plot(ax2, strain, stress, 'o', 'linewidth', 0.5, 'color',...
        ColorOdrCustom(k, :));
    text = [text; sprintf('run%d', k)];
    
end

set(ax1, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
xlabel(ax1, 'Compressive extension (mm)');
ylabel(ax1,'Compressive load (N)');
h2 = legend(ax1, text, 'Location', 'northwest');
print(fg1, sprintf('./%s/%s/raw', date, folder),'-depsc');

set(ax2, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
xlabel(ax2,'Compressive strain ');
ylabel(ax2,'Compressive stress (MPa)');
h1 = legend(ax2, text, 'Location', 'northwest');
print(fg2, sprintf('./%s/%s/SS', date, folder),'-depsc');

%str = [SampleName, '= modulus;'];
%eval(str)  % change variable name
%save('AllSamples',SampleName, '-append') 