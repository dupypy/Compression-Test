clear all
close all
% User Input start
date = {'Instron_110717';...
    'Instron_110617';...
    'Instron_110617';...
    'Instron_101317';...
    'Instron_101317';...
    'Instron_101317';...
    'Instron_110717';...
    'Instron_110617';...
    'Instron_110717';...
    'Instron_110717'};
folder = {'folder';...
    'folder';...
    'folder';...
    'folder';...
    'folder';...
    'folder';...
    'folder'; ...
    'folder'; ...
    'folder';...
    'folder'};
legendtext = {'0090\_0.2mm';...
    '45135\_0.2mm';...
    '30150\_0.2mm'; ...
    '0090\_0.3mm';...
    '45135\_0.3mm';...
    '30150\_0.3mm';...
    'bulk (55K)';...
    'diffOrient\_0090';...
    'diffOrient\_45135'; ...
    'diffOrient\_30150'};
sample = {'3'; '2'; '3'; '6'; '4'; '2';'4'; '7'; '7'; '6'};
symbol = ['o'; '^'; 's'; 'o';'^';'s';'o'; '^'; 's';'d'];
color = ['r';'r'; 'r'; 'b'; 'b'; 'b'; 'k'; 'k'; 'k'; 'k'];
Figure1 = 'Combine2';
Figure2 = 'CompareModulus2';
% User Input end
set(0, 'DefaultAxesFontSize', 14);
len = size(date, 1);

fg = figure;
hold all;
ax = gca;

for k = 1:len
    filename = sprintf('./%s/%s/%s.csv', date{k}, folder{k}, sample{k});
    fid = fopen(filename, 'rt');
    Headerline = 7;   % remember to check
    for n = 1:Headerline
        fgetl(fid);
    end
    data = textscan(fid,'%f%f%f%f%f%f%f', 'Delimiter', ',');
    fclose(fid);
    stress = data{1,4};
    strain = data{1,5};
    set(fg,'position', [0, 0, 700, 500])
    plot(ax, strain(1:50:end), stress(1:50:end), 'linewidth', 0.5, ...
        'color',color(k), 'marker', symbol(k));
    legend(legendtext, 'fontsize', 8, 'Location', [0.73, 0.13, 0.25, 0.23]);
    legend boxoff
    set(gca, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
    xlabel(gca, 'Compressive strain');
    ylabel(gca,'Compressive stress (MPa)');
end
set(gcf,'PaperPositionMode','auto');   % Directive to use displayed
% figure size when printing or saving
print(gcf, Figure1,'-depsc');


% Compare Modulus
load('AllSamples.mat');
avgs = [];
errs = [];
C = zeros(4, 12);     % zero padding
C(1:length(zeroninety_SS1),1)= zeroninety_SS1;  % Fill first column with A
C(1:length(zeroninety_SSlarge),2)= zeroninety_SSlarge;  % Fill second column with B
C(1:length(zerofortyfive_SS1),3)= zerofortyfive_SS1;
C(1:length(zerofortyfive_SSlarge),4)= zerofortyfive_SSlarge;
C(1:length(fortyfivefortyfive_SS1),5)= fortyfivefortyfive_SS1;
C(1:length(fortyfivefortyfive_SSlarge),6)= fortyfivefortyfive_SSlarge;
C(1:length(zerofortyfivezerofortyfive_SS1),7)= zerofortyfivezerofortyfive_SS1;
C(1:length(zerofortyfivezerofortyfive_SSlarge),8)= zerofortyfivezerofortyfive_SSlarge;
C(1:length(sixtyonetwenty_SS1),9)= sixtyonetwenty_SS1;
C(1:length(sixtyonetwenty_SSlarge),10)= sixtyonetwenty_SSlarge;
C(1:length(sixtyonetwentyzero_SSlarge),11)= sixtyonetwentyzero_SSlarge;
C(1:length(Dual),12)= Dual;

for k = 1: size(C,2)
    avg = mean(nonzeros(C(:, k)));
    avgs = [avgs, avg];
    err = std(nonzeros(C(:, k)));
    errs = [errs, err];
end
figure
e = errorbar(avgs,errs,'s','MarkerSize',4,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
Samples = {'0090\_SS1', '0090\_SS1.5', '0045\_SS1', '0045\_SS1.5', ...
    '45135\_SS1', '45135\_SS1.5', '004500135\_SS1', '004500135\_SS1.5',...
    '60120\_SS1', '60120\_SS1.5','6012000\_SS1.5', 'Dual'};
set(gca, 'XTick', 1:12, 'XTickLabel', Samples, 'fontsize', 12);
rotateXLabels(gca, 60);
set(gcf,'PaperPositionMode','auto');
print(gcf, Figure2,'-depsc');

