clear all
close all

% User Input start
date = {'100617';'101317'; '100617'; '100617'; '101317'; '101317'};
file = {'3'; '2'; '1'; '3'; '2'; '1'};
group = {[1 2], [3 4 5 6]};  % order of the date or file
legendtext = {'description1'; 'description2'}; 
% The size of the group and the legendtext should be the same.
% User Input end

modulus = [];
Maverage = [];
Merrbar = [];
YStress = [];
StressAvg = [];
StressErr = [];
YStrain = [];
StrainAvg = [];
StrainErr = [];

% Extract data from .mat files
for k = 1:size(date)
    filename = sprintf('./%s.mat', date{k});
    data = load(filename);
    order = str2double(file{k});
    modulus = [modulus; data.modulus(order)];
    YStress = [YStress; data.YieldStress(order)];
    YStrain = [YStrain; data.YieldStrain(order)];
end

% Calculate average and err
for m = 1:size(group, 2)
    avg = mean(modulus(group{1,m}(:)))
    err = std(modulus(group{1,m}(:)))
    Maverage = [Maverage; avg];
    Merrbar = [Merrbar; err];
    avg = mean(YStress(group{1,m}(:)))
    err = std(YStress(group{1,m}(:)))
    StressAvg = [StressAvg; avg];
    StressErr = [StressErr; err];
    avg = mean(YStrain(group{1,m}(:)))
    err = std(YStrain(group{1,m}(:)))
    StrainAvg = [StrainAvg; avg];
    StrainErr = [StrainErr; err];
end

% Plot Modulus, YieldStress, and YieldStrain
fig1 = figure
errorbar(Maverage,Merrbar,'s','MarkerSize',8,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
set(gca, 'XTick', 1:size(Maverage), 'XTickLabel', legendtext, ...
    'fontsize', 12);
rotateXLabels(gca, 60);
ylabel('Modulus(MPa)');
set(gcf,'PaperPositionMode','auto');
print(gcf, 'Modulus','-depsc');

fig2 = figure
errorbar(StressAvg,StressErr,'s','MarkerSize',8,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
set(gca, 'XTick', 1:size(StressAvg), 'XTickLabel', legendtext, ...
    'fontsize', 12);
rotateXLabels(gca, 60);
ylabel('Yield Stress(MPa)')
set(gcf,'PaperPositionMode','auto');
print(gcf, 'YieldStress','-depsc');

fig3 = figure
errorbar(StrainAvg,StrainErr,'s','MarkerSize',8,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
set(gca, 'XTick', 1:size(StrainAvg), 'XTickLabel', legendtext, ...
    'fontsize', 12);
rotateXLabels(gca, 60);
ylabel('Yield Strain');
set(gcf,'PaperPositionMode','auto');
print(gcf, 'YieldStrain','-depsc');