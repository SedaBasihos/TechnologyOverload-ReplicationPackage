% ================== contour_plots.m ==================
clear; close all; clc;

%% --- Read the CSV ---
T = readtable('L_z_L_h_values.csv');

names = lower(string(T.Properties.VariableNames));
pick  = @(keys) T{:, find(any(contains(names, lower(string(keys))),1), 1, 'first')};

alpha = pick("alpha");
beta  = pick("beta");

L_z_base = pick(["L_z_base","lz_base","base_lz"]);
L_h_base = pick(["L_h_base","lh_base","base_lh"]);

au = unique(alpha(:)); bu = unique(beta(:));
xa = linspace(0.2, 0.85, max(numel(au), 20));
yb = linspace(0.2, 0.85, max(numel(bu), 20));
[XA, YB] = meshgrid(xa, yb);

% Interpolate (natural neighbor), extrapolate with nearest
Fz = scatteredInterpolant(alpha(:), beta(:), L_z_base(:), 'natural', 'nearest');
Fh = scatteredInterpolant(alpha(:), beta(:), L_h_base(:), 'natural', 'nearest');
L_z_grid = Fz(XA, YB);
L_h_grid = Fh(XA, YB);

n = 256;
cols = [0.30 0.30 0.30; 0.95 0.95 0.95];
cmap = flipud(interp1([0 1], cols, linspace(0,1,n)'));

xrange = [0.2 0.85];
yrange = [0.2 0.85];

P = struct( ...
  'name',  {'square','circle','triangle'}, ...
  'alpha', {0.532110092,     0.711864407,  0.817204301}, ...
  'beta',  {0.580124894,     0.563110668,  0.623845667}, ...
  'shape', {'s','o','^'}, ...                                
  'face',  {[0.89 0.47 0.20], [0.35 0.70 0.90], [0.46 0.67 0.18]});  
markerSize = 80;   

%% ====== figures =============================================
% L_z base 
figLz = figure('Color','w','Units','pixels','Position',[100 100 700 700],'Visible','on');
applyContourToAxes(gca, XA, YB, L_z_grid, '$L_z$ Base', cmap, true, xrange, yrange, 5);
addMarkersFromStruct(gca, P, markerSize);   
savefig(figLz, 'L_z_base.fig');

% L_h base 
figLh = figure('Color','w','Units','pixels','Position',[850 100 700 700],'Visible','on');
applyContourToAxes(gca, XA, YB, L_h_grid, '$L_h$ Base', cmap, true, xrange, yrange, 5);
addMarkersFromStruct(gca, P, markerSize);  
savefig(figLh, 'L_h_base.fig');

figC = figure('Color','w','Units','pixels','Position',[100 100 1300 600],'Visible','on');

subplot(1,2,1);
applyContourToAxes(gca, XA, YB, L_z_grid, '$L_z$ Base', cmap, true, xrange, yrange, 5);
addMarkersFromStruct(gca, P, markerSize);  

subplot(1,2,2);
applyContourToAxes(gca, XA, YB, L_h_grid, '$L_h$ Base', cmap, true, xrange, yrange, 5);
addMarkersFromStruct(gca, P, markerSize);   

savefig(figC, 'L_combined.fig');

%% =================== Helper ==========================================
function applyContourToAxes(ax, X, Y, Z, titleStr, cmap, showColorbar, xlims, ylims, numTicks)
    if nargin < 10 || isempty(numTicks), numTicks = 5; end

    axes(ax); hold(ax, 'on');
    set(ax,'Color',[0.98 0.98 0.98]);

    ZZ = Z(:); ZZ = ZZ(~isnan(ZZ));
    if isempty(ZZ), error('Z matrix has only NaNs.'); end
    zmin = min(ZZ); zmax = max(ZZ);
    nLevels = 9;
    raw     = linspace(zmin, zmax, nLevels);
    levels  = unique(round(raw, 2), 'stable');
    if numel(levels) < 3
        levels = unique(round(linspace(zmin, zmax, 5), 2), 'stable');
    end

    contourf(X, Y, Z, levels, 'LineStyle','none');
    [C,h] = contour(X, Y, Z, levels, 'LineColor',[0.15 0.15 0.15], 'LineWidth',0.8);
    ht = clabel(C, h, 'FontSize', 14, 'Color', 'k', 'LabelSpacing', 1200); 
    for k = 1:numel(ht)
        v = str2double(ht(k).String);
        if ~isnan(v), ht(k).String = sprintf('%.2f', v); end
    end
    colormap(ax, cmap);
    if showColorbar
        cb = colorbar(ax);
        cb.Ticks = linspace(levels(1), levels(end), numTicks);
        cb.TickLabels = arrayfun(@(v) sprintf('%.2f', v), cb.Ticks, 'UniformOutput', false);
        ylabel(cb, 'Value', 'Interpreter','latex', 'FontSize', 16); 
        cb.FontSize = 15; 
    end
    if nargin >= 8 && ~isempty(xlims), xlim(ax, xlims); else, xlim(ax, [min(X(:)) max(X(:))]); end
    if nargin >= 9 && ~isempty(ylims), ylim(ax, ylims); else, ylim(ax, [min(Y(:)) max(Y(:))]); end
    axis(ax,'square');
    set(ax, 'TickDir','out','Box','off','Layer','top','FontName','Times', ...
        'FontSize', 15, 'TickLabelInterpreter','latex'); 
    xlabel(ax, '$\alpha$', 'Interpreter','latex', 'FontSize', 16); 
    ylabel(ax, '$\beta$',  'Interpreter','latex', 'FontSize', 16); 
    title(ax, titleStr, 'Interpreter','latex', 'FontSize', 18, 'FontWeight','normal'); 
end

function addMarkersFromStruct(ax, P, sz)
    if nargin < 3, sz = 120; end   
    scaling_factor = 1.5;  
    hold(ax,'on');
    for k = 1:numel(P)
        plot(ax, P(k).alpha, P(k).beta, ...
            'LineStyle','none', ...
            'Marker', P(k).shape, ...
            'MarkerSize', scaling_factor * sqrt(sz), ...
            'MarkerFaceColor', P(k).face, ...
            'MarkerEdgeColor', 'none');   
    end
end