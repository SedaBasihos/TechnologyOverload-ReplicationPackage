% ================== contour_plots.m ==================
clear; close all; clc;

%% --- Read the file 
T = readtable('alpha_beta.csv');

names = lower(string(T.Properties.VariableNames));
pick = @(keys) T{:, find(any(contains(names, lower(string(keys))),1), 1, 'first')};

alpha  = pick("alpha");
beta   = pick("beta");
growth = pick(["growth_change","growth","d_growth","delta_growth"]);
labor  = pick(["labor_share_change","labor_change","d_labor","delta_labor","dlabor"]);

au = unique(alpha(:)); bu = unique(beta(:));
[~, ia] = ismember(alpha(:), au);
[~, ib] = ismember(beta(:),  bu);

G = accumarray([ib ia], growth(:), [numel(bu) numel(au)], @mean, NaN);   % growth matrix
L = accumarray([ib ia], labor(:),  [numel(bu) numel(au)], @mean, NaN);    % labor matrix

n = 256; stops = [0 0.5 1];
cols = [0.184 0.184 0.184; 0.498 0.498 0.498; 0.898 0.898 0.898];
cmap = interp1(stops, cols, linspace(0,1,n)');

% ======= same alpha/beta on both panels =======
P = struct( ...
  'name',  {'yellow_square','red_circle','orange_triangle'}, ...
  'alpha', {0.532110092,     0.711864407,  0.817204301}, ...
  'beta',  {0.580124894,     0.563110668,  0.623845667}, ...
  'growth_change', {-0.2709375, -0.190131579, -0.131363636}, ...
  'labor_change',  {-6.264692393, -6.195287329, -5.994087358}, ...
  'shape', {'s','o','^'}, ...                    % square, circle, triangle
  'face',  {[0.89 0.47 0.20], ...                % muted orange
            [0.35 0.70 0.90], ...                % sky blue
            [0.46 0.67 0.18]});                  % olive green

% Optional: sanity check that each (alpha,beta) is on the grid
for k = 1:numel(P)
    if ~ismember(P(k).alpha, au) || ~ismember(P(k).beta, bu)
        warning('Point %s (alpha=%.6f, beta=%.6f) is not on the grid.', ...
            P(k).name, P(k).alpha, P(k).beta);
    end
end

markerSize = 80; 

%% ====== figures =============================================
% Growth
figG = figure('Color','w','Units','pixels','Position',[100 100 700 700],'Visible','on');
applyContourToAxes(gca, au, bu, G, 0.1, '$\Delta$ Productivity Growth', cmap, true);
addMarkersFromStruct(gca, P, markerSize);           
savefig(figG, 'growth.fig');

% Labor
figL = figure('Color','w','Units','pixels','Position',[850 100 700 700],'Visible','on');
applyContourToAxes(gca, au, bu, L, 0.5, '$\Delta$ Labor (Income) Share', cmap, true);
addMarkersFromStruct(gca, P, markerSize);           
savefig(figL, 'labor.fig');

figC = figure('Color','w','Units','pixels','Position',[100 100 1300 600],'Visible','on');

subplot(1,2,1);
applyContourToAxes(gca, au, bu, G, 0.1, '$\Delta$ Productivity Growth', cmap, true);
addMarkersFromStruct(gca, P, markerSize);

subplot(1,2,2);
applyContourToAxes(gca, au, bu, L, 0.5, '$\Delta$ Labor (Income) Share', cmap, true);
addMarkersFromStruct(gca, P, markerSize);

% Save combined
savefig(figC, 'combined.fig');

%% =================== Helper ==========================================
function applyContourToAxes(ax, Xvec, Yvec, Zmat, step, titleStr, cmap, showColorbar)
    axes(ax); hold(ax, 'on');

    Z = Zmat(:); Z = Z(~isnan(Z));
    if isempty(Z), error('Z matrix has only NaNs.'); end
    zmin = floor(min(Z)/step)*step;
    zmax = ceil( max(Z)/step)*step;

    levels = zmin:step:zmax;
    if numel(levels) < 3
        levels = linspace(zmin, zmax, 5);
        step = levels(2)-levels(1);
    end
    levels = round(levels*10)/10;

    contourf(Xvec, Yvec, Zmat, levels, 'LineStyle','none');
    [C,h] = contour(Xvec, Yvec, Zmat, levels, 'LineColor','k');
    ht = clabel(C, h, 'FontSize', 14, 'Color', 'k', 'LabelSpacing', 1200);
    for k = 1:numel(ht)
        s = ht(k).String; if iscell(s), s = s{1}; end
        v = str2double(s);
        if ~isnan(v), ht(k).String = sprintf('%.1f', v); end
    end

    colormap(ax, cmap);
    if showColorbar
        c = colorbar(ax);
        nticks = 5;
        c.Ticks = linspace(min(levels), max(levels), nticks);
        c.TickLabels = arrayfun(@(v) sprintf('%.1f', v), c.Ticks, 'UniformOutput', false);
        ylabel(c, '% points', 'Interpreter','latex', 'FontSize', 16);
        c.FontSize = 15;
    else
        colorbar(ax, 'off');
    end
    xlim(ax, [0.2 0.85]);
    ylim(ax, [0.2 0.85]);
    axis(ax, 'square'); pbaspect(ax, [1 1 1]);
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


