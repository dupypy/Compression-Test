clear all
close all

% User Input start
date = {'100617';'111517'};
file = {'3'; '2'};
legendtext = {'description1'; 'description2'};
symbol = ['o'; '^'];
color = ['r';'b'];
ptInterval = 10;  % plot every ptInverval point
FigName = 'MultiPlot';
% User Input end

set(0, 'DefaultAxesFontSize', 14);
len = size(date, 1);

fg = figure;
hold all;
ax = gca;

for k = 1:len
    filename = sprintf('./%s/Specimen_RawData_%s.csv', date{k}, file{k});
    fid = fopen(filename, 'rt');
    Headerline = 7;   % remember to check
    for n = 1:Headerline
        fgetl(fid);
    end
    data = textscan(fid,'%q%q%q%q%q%q%q', 'Delimiter', ',');
    fclose(fid);
    stress = str2double(data{1,4});
    strain = str2double(data{1,5});
    set(fg,'position', [0, 0, 700, 500])
    plot(ax, strain(1:ptInterval:end), stress(1:ptInterval:end), ...
        'color',color(k), 'marker', symbol(k));
    legend(legendtext, 'fontsize', 14, 'Location', [0.13, 0.73, 0.25, 0.23]);
    legend boxoff
    set(gca, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
    xlabel(gca, 'Compressive strain');
    ylabel(gca,'Compressive stress (MPa)');
end
set(gcf,'PaperPositionMode','auto');   % Directive to use displayed
% figure size when printing or saving
print(gcf, FigName,'-depsc');




