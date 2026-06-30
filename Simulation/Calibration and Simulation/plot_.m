
%%%%%%%%% Plot the Main Results %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%To make pretty
t1=[-25,-24,-23,-22,-21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1];
tt=[t1,t];
%
Zs2=zeros(length(t1),1)';
Zs=[Zs2,Zlog];
Zss=zeros(length(tt),1)';
%
Plog2=zeros(length(t1),1)';
Plogs=[Plog2,Plog];
Plogss=zeros(length(tt),1)';
%
r2=7.7*ones(length(t1),1)';
rs=[r2,r];
rss=7.7*ones(length(tt),1)';
%
k2=zeros(length(t1),1)';
ks=[k2,kappalog];
kss=zeros(length(tt),1)';
%
g2=1.70*ones(length(t1),1)';
gs=[g2,g];
gss=1.70*ones(length(tt),1)';
%
sigma_l=sigma;
sigmal2=62.6*ones(length(t1),1)';
sigmals=[sigmal2,sigma];
sigmalss=62.6*ones(length(tt),1)';
%
log_sigma2=zeros(length(t1),1)';
log_sigmaa=[log_sigma2,log_sigma];
log_sigmass=zeros(length(tt),1)';
%
val_block_log2=zeros(length(t1),1)';
val_block_logg=[val_block_log2,val_block_log];
val_block_logss=zeros(length(tt),1)';
%
w_g2=1.70*ones(length(t1),1)';
w_gg=[w_g2,w_g];
wgss=1.70*ones(length(tt),1)';
%
l_h2=zeros(length(t1),1)';
l_h_1 = 0.125 * ones(1,200);
l_h1=-l_h_1+l_h;
l_hh=[l_h2,l_h1];
l_hss=zeros(length(tt),1)';
%
l_z2=zeros(length(t1),1)';
l_z_1 = 0.125 * ones(1,200);
l_z1=-l_z_1+l_z;
l_zz=[l_z2,l_z1];
l_zss=zeros(length(tt),1)';
%
L2=zeros(length(t1),1)';
L22=ones(1,200)-(l_h+l_z);
L_1=0.75*ones(1,200);
L1=L22-L_1;
LL=[L2,L1];
Lss=zeros(length(tt),1)';
%%
fig = figure(1);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperSize', [8 2.5]);
set(fig, 'PaperPositionMode', 'manual');
set(fig, 'PaperPosition', [0 0 8 2.5]);
set(0, 'DefaultAxesFontSize',11)
set(0,'defaulttextinterpreter','latex')
set(0,'defaultTextFontName', 'latex')
set(0,'defaultAxesTickLabelInterpreter', 'latex')
set(0,'defaultLegendInterpreter', 'latex')
set(fig,'color','w');
x0 = 10;
y0 = 10;
figure_width = 800;
figure_height = 250;
set(fig, 'Position', [x0, y0, figure_width, figure_height])

subplot(1,2,1)
plot(tt,gs,'-','color','black', 'LineWidth', 4);
hold on
plot(tt,gss,':','color','red', 'LineWidth', 1.5);
title('Productivity Growth ($g$)', 'Interpreter', 'latex','FontSize', 11)
ylabel('\%', 'Interpreter', 'latex','FontSize', 10);
axis([-5 50 1 3])

subplot(1,2,2)
p1=plot(tt,w_gg,'-','color','black', 'LineWidth', 4);
hold on
p2=plot(tt,gs,':','color',[0.5 0.5 0.5], 'LineWidth', 4);
hold on
plot(tt,wgss,':','color','red', 'LineWidth', 1.5)
title('Wage Growth vs. Productivity Growth', 'FontSize', 11)
ylabel('\%','Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 -3 3])
legend([p1 p2],{'Wage Growth','Productivity Growth'},'Location','best','FontSize',8)
savefig(fig,'transition1.fig')

fig=figure(2);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [15 10]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 15 10]);
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
set(0, 'DefaultAxesFontSize',11)
set(0,'defaulttextinterpreter','latex')
set(0,'defaultTextFontName', 'latex')
set(0,'defaultAxesTickLabelInterpreter', 'latex')
set(0,'defaultLegendInterpreter', 'latex')
set(gcf,'color','w');
% Set the figure size
x0 = 10;
y0 = 10;
figure_width = 900;    % Adjusted to accommodate the desired plot box size and labels
figure_height = 250;   % Adjusted to accommodate the desired plot box size and labels
set(gcf, 'Position', [x0, y0, figure_width, figure_height])

subplot(1,2,1)
plot(tt,Zs,'-','color','black', 'LineWidth', 4)
hold on
plot(tt,Zss,':','color','red', 'LineWidth', 1.5)
title('Efficiency of Capital ($Z$)', 'FontSize', 11)
ylabel('Log Deviation','Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 -1 1])
yticks([-1  -0.5  0  0.5  1])


subplot(1,2,2)
p3=plot(tt, l_zz, '-',  'color', 'black', 'LineWidth', 4);  % solid line
hold on
p4=plot(tt, l_hh, '--', 'color', 'black', 'LineWidth', 4);  % dashed line
hold on
p5=plot(tt, LL,  '-.', 'color',[0.5 0.5 0.5], 'LineWidth', 4);  % dash-dot line
hold on
plot(tt, Lss, ':', 'color', 'red',   'LineWidth', 1.5); % dotted red
title('Change in Resource Allocation', 'FontSize', 11)
ylabel('Change', 'Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 -0.3 0.2])
legend([p3 p4 p5], {'Capital Design','Labor Skill','Production'}, ...
       'Location','best','FontSize',8)

saveas(gcf,'transition2','epsc')
savefig('transition2.fig')
%

fig=figure(3);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [15 10]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 15 10]);
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
set(0, 'DefaultAxesFontSize',11)
set(0,'defaulttextinterpreter','latex')
set(0,'defaultTextFontName', 'latex')
set(0,'defaultAxesTickLabelInterpreter', 'latex')
set(0,'defaultLegendInterpreter', 'latex')
set(gcf,'color','w');
% Set the figure size
x0 = 10;
y0 = 10;
figure_width = 900;    % Adjusted to accommodate the desired plot box size and labels
figure_height = 250;   % Adjusted to accommodate the desired plot box size and labels
set(gcf, 'Position', [x0, y0, figure_width, figure_height])

subplot(1,2,1)
plot(tt,log_sigmaa,'-','color','black', 'LineWidth', 4)
hold on
plot(tt,log_sigmass,':','color','red', 'LineWidth', 1.5)
title('Relative Share Term $(P_KY_K/P_LY_L)$', 'FontSize', 11)
ylabel('Log Deviation','Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 -1 1])
yticks([-1  -0.5  0  0.5  1])

subplot(1,2,2)
plot(tt,val_block_logg,'-','color','black', 'LineWidth', 4)
hold on
plot(tt,val_block_logss,':','color','red', 'LineWidth', 1.5)
title('Valuation-Growth Term $(r-\tilde{\alpha}g)/(r+\delta_z-g)$', 'FontSize', 11)
ylabel('Log Deviation','Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 -1 1])
yticks([-1  -0.5  0  0.5  1])

saveas(gcf,'transition3','epsc')
savefig('transition3.fig')
%


fig=figure(4);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [15 10]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 15 10]);
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
set(0, 'DefaultAxesFontSize',11)
set(0,'defaulttextinterpreter','latex')
set(0,'defaultTextFontName', 'latex')
set(0,'defaultAxesTickLabelInterpreter', 'latex')
set(0,'defaultLegendInterpreter', 'latex')
set(gcf,'color','w');
% Set the figure size
x0 = 10;
y0 = 10;
figure_width = 900;    % Adjusted to accommodate the desired plot box size and labels
figure_height = 250;   % Adjusted to accommodate the desired plot box size and labels
set(gcf, 'Position', [x0, y0, figure_width, figure_height])


subplot(1,2,1)
plot(tt,ks,'-','color','black', 'LineWidth', 4)
hold on
k1=plot(tt,kss,':','color','red', 'LineWidth', 1.5);
title('Efficient Capital-to-Efficient Labor ($\kappa$)','Interpreter', 'latex', 'FontSize', 10.5)
xlabel('year','Interpreter', 'latex', 'FontSize', 10);
ylabel('Log Deviation','Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 -1 1])
yticks([-1  -0.5  0  0.5  1])

subplot(1,2,2)
plot(tt,Plogs,'-','color','black', 'LineWidth', 4);
hold on
plot(tt,Plogss,':','color','red', 'LineWidth', 1.5);
title('Relative Factor Price ($P_{K}/P_{L}$)','Interpreter', 'latex', 'FontSize', 10.5)
ylabel('Log Deviation','Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 -1 1])
yticks([-1  -0.5  0  0.5  1])

saveas(gcf,'transition4','epsc')
savefig('transition4.fig')

fig=figure(5);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [15 10]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 15 10]);
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
set(0, 'DefaultAxesFontSize',11)
set(0,'defaulttextinterpreter','latex')
set(0,'defaultTextFontName', 'latex')
set(0,'defaultAxesTickLabelInterpreter', 'latex')
set(0,'defaultLegendInterpreter', 'latex')
set(gcf,'color','w');
% Set the figure size
x0 = 10;
y0 = 10;
figure_width = 900;    % Adjusted to accommodate the desired plot box size and labels
figure_height = 250;   % Adjusted to accommodate the desired plot box size and labels
set(gcf, 'Position', [x0, y0, figure_width, figure_height])

subplot(1,2,1)
plot(tt,sigmals,'-','color','black', 'LineWidth', 4);
hold on 
plot(tt,sigmalss,':','color','red', 'LineWidth', 1.5);
title('Labor Income Share','Interpreter', 'latex', 'FontSize', 11)
ylabel('\%','Interpreter', 'latex', 'FontSize', 10);
xlabel('year','Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 52 65])

subplot(1,2,2)
plot(tt,rs,'-','color','black', 'LineWidth', 4);
hold on 
plot(tt,rss,':','color','red', 'LineWidth', 1.5);
title('Rate of Interest','Interpreter', 'latex', 'FontSize', 11)
ylabel('\%','Interpreter', 'latex', 'FontSize', 10);
xlabel('year','Interpreter', 'latex', 'FontSize', 10);
axis([-5 50 6.5 8.5])


saveas(gcf,'transition5','epsc')
savefig('transition5.fig')


%saveas(gcf,'transition','epsc')
%savefig('transition.fig')

%drop unnecessary
%clear g2 g2 gss k2 Plog2 Plogs Plogss r2 r2 rss sigma sigma1 sigma_kc sigmak2 sigmaks sigmakss z Z1 Zs2 zss Zss...
   % burst capitalg deepen gs PL PK part1 part2 kss klh yk yk1

%%
%variables
load ("actual.mat")
load ("growth_bar.mat")
load ("growth_barm.mat")
t_real=actual(:,1);
g_real=actual(:,2);
growth_bar1=growth_bar(:,1);
growth_bar2=growth_bar(:,2);
growth_barm1=growth_barm(:,1);
growth_barm2=growth_barm(:,2);
c_sh = actual(:,3);
c_p = actual(:,4);
w_p = actual(:,5);
t_real=t_real';
g_real=g_real';
c_sh=c_sh';
c_p=c_p';
w_p=w_p';

gap_z=zeros(length(t1),1)';
gapp=[gap_z,gap1];

% Smoothing if needed
[c_shs,scy] = hpfilter(c_sh, smoothing=6.25);
c_shs=c_shs';
a=(1:17);
nr = nan(size(a));
c_shs=[c_shs, nr];

%BGP values
gs_real=1.47*ones(length(t_real),1)';
gs_realm=1.51*ones(length(t_real),1)';
cs_real=56.9*ones(length(t_real),1)';
cs_realm=56.4*ones(length(t_real),1)';
cs_reali=62.6*ones(length(t_real),1)';
cp_real=-0.68*ones(length(t_real),1)';
cp_realm=-0.3572*ones(length(t_real),1)';
cp_reali=0*ones(length(t_real),1)';
cint_realm=0.123*ones(length(t_real),1)';
cint_reali=0*ones(length(t_real),1)';
wp_real=0*ones(length(t_real),1)';
wp_realm=0*ones(length(t_real),1)';
wp_reali=0*ones(length(t_real),1)';
ty=1975:1:2023;

%%
fig=figure(6);
newcolors = [0.00 0.00 0.00; 0.59 0.31 0.59];
colororder(newcolors)
%colororder({'black','m'})
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [15 10]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 15 10]);
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
set(0, 'DefaultAxesFontSize',10)
set(0,'defaulttextinterpreter','latex')
set(0,'defaultTextFontName', 'latex')
set(0,'defaultAxesTickLabelInterpreter', 'latex')
set(0,'defaultLegendInterpreter', 'latex')
set(gcf,'color','w');

subplot(2,2,1)
%plot(tt,gs,'-','color','black', 'LineWidth', 6);
%title('Productivity Growth ($g$) -- Model', 'Interpreter', 'latex','FontSize', 10)
%ylabel('\%', 'Interpreter', 'latex','FontSize', 9);
%axis([-10 40 1.2 2.0])
%xline(0,'color',[0.4660 0.6740 0.1880])
%yline(1.53,'--','color',[0 0.4470 0.7410], 'LineWidth', 3)
%yline(1.62,'--','color','red', 'LineWidth', 3)
yyaxis left
X = categorical({'-25-0' , '1-10', '10+'});
bar(growth_barm1,'FaceColor',[0.380392156862745 0.380392156862745 0.380392156862745],'BarWidth',0.5)
a = (1:size(growth_barm1,1)).';
x = [a a];
for k=1:size(growth_barm1,1)
    for m = 1:size(growth_barm1,2)
        text(x(k,m),growth_barm1(k,m),num2str(growth_barm1(k,m),'%0.2f'),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize', 7)
    end
end
ylim([1.2 2]);
ylabel('BGP, $\%$', 'Interpreter', 'latex', 'FontSize', 9);
title('Productivity Growth ($g$) -- Model', 'Interpreter', 'latex', 'FontSize', 10)
yline(1.51,'--','color',[0 0.4470 0.7410], 'LineWidth', 3)
yline(1.70,'--','color','red', 'LineWidth', 3)
hold on
yyaxis right
X = categorical({'-25-0' , '1-10', '10+'});
bar(growth_barm2,'FaceColor',[0.380392156862745 0.380392156862745 0.380392156862745],'BarWidth',0.5)
a = (1:size(growth_barm2,1)).';
x = [a a];
for k=1:size(growth_barm2,1)
    for m = 1:size(growth_barm2,2)
        text(x(k,m),growth_barm2(k,m),num2str(growth_barm2(k,m),'%0.2f'),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize', 7)
    end
end
ylabel('Transition, $\%$', 'Interpreter', 'latex', 'FontSize', 9);
ylim([0.5 3.25]);
newXticklabel = {'-25-0' , '1-10', '10+'};
set(gca,'XtickLabel',newXticklabel);
ax = gca;
ax.FontSize = 7.5;

subplot(2,2,2)
yyaxis left
X = categorical({'70-95' , '96-05', '06-19'});
bar(growth_bar1,'FaceColor',[0.380392156862745 0.380392156862745 0.380392156862745],'BarWidth',0.5)
a = (1:size(growth_bar1,1)).';
x = [a a];
for k=1:size(growth_bar1,1)
    for m = 1:size(growth_bar1,2)
        text(x(k,m),growth_bar1(k,m),num2str(growth_bar1(k,m),'%0.2f'),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize', 7)
    end
end
ylim([1.2 2]);
ylabel('BGP, $\%$', 'Interpreter', 'latex', 'FontSize', 9);
title('Productivity Growth ($g$) -- Data', 'Interpreter', 'latex', 'FontSize', 10)
yline(1.51,'--','color',[0 0.4470 0.7410], 'LineWidth', 3)
yline(1.47,':','color',[0 0.4470 0.7410], 'LineWidth', 3)
yline(1.70,'--','color','red', 'LineWidth', 3)
hold on
yyaxis right
X = categorical({'70-95' , '96-05', '06-18'});
bar(growth_bar2,'FaceColor',[0.380392156862745 0.380392156862745 0.380392156862745],'BarWidth',0.5)
a = (1:size(growth_bar2,1)).';
x = [a a];
for k=1:size(growth_bar2,1)
    for m = 1:size(growth_bar2,2)
        text(x(k,m),growth_bar2(k,m),num2str(growth_bar2(k,m),'%0.2f'),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize', 7)
    end
end
ylabel('Transition, $\%$', 'Interpreter', 'latex', 'FontSize', 9);
ylim([0.5 3.25]);
newXticklabel = {'70-95' , '96-05', '06-19'};
set(gca,'XtickLabel',newXticklabel);
ax = gca;
ax.FontSize = 7.5;
%hold on
%plot(t_real,g_real,'-','color','black', 'LineWidth', 2.5);
%title('Productivity Growth ($g$)', 'Interpreter', 'latex','FontSize', 9)
%ylabel('\%', 'Interpreter', 'latex','FontSize', 10);
%axis([1985 2025 0 4])
%xticks(1990:10:2025)
%yticks(0.8:0.8:3.2)
%xline(1995,'color',[0.4660 0.6740 0.1880])

subplot(2,2,3)
plot(tt,sigmals,'-','color','black', 'LineWidth', 6);
title('Labor Income Share -- Model','Interpreter', 'latex', 'FontSize', 10)
ylabel('$\%$','Interpreter', 'latex', 'FontSize', 9);
xline(0,'color',[0.4660 0.6740 0.1880])
axis([-25 40 52 65])
yline(56.4,'--','color',[0 0.4470 0.7410], 'LineWidth', 3)
yline(62.6,'--','color','red', 'LineWidth', 3)

subplot(2,2,4)
plot(t_real, c_shs,'-','color','black', 'LineWidth', 6);
%hold on
%plot(t_real,c_shs,'-','color', [1 1 0], 'LineWidth', 0.5);
%title('Labor Share ($\gamma$)', 'Interpreter', 'latex','FontSize', 10)
%ylabel('\%', 'Interpreter', 'latex','FontSize', 10);
hold on
plot(t_real,cs_reali,'--','color','red', 'LineWidth', 3);
hold on
plot(t_real,cs_real,':','color',[0 0.4470 0.7410], 'LineWidth', 3);
hold on
plot(t_real,cs_realm,'--','color',[0 0.4470 0.7410], 'LineWidth', 3);
title('Labor Income Share -- Data', 'Interpreter', 'latex','FontSize', 10)
ylabel('$\%$', 'Interpreter', 'latex','FontSize', 9);
%legend('', 'Initial BGP', 'New BGP (Data)','New BGP (Model)', 'Interpreter', 'latex','FontSize', 8, 'Box','off')
axis([1970 2040 52 65])
xticks(1975:20:2040)
xline(1995,'color',[0.4660 0.6740 0.1880])

fig=figure(7);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [15 10]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 15 10]);
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
set(0, 'DefaultAxesFontSize',10)
set(0,'defaulttextinterpreter','latex')
set(0,'defaultTextFontName', 'latex')
set(0,'defaultAxesTickLabelInterpreter', 'latex')
set(0,'defaultLegendInterpreter', 'latex')
set(gcf,'color','w');

subplot(2,2,1)
plot(tt,gapp,'-','color','black', 'LineWidth', 6);
title('Productivity-Wage Gap -- Model' ,'Interpreter', 'latex', 'FontSize', 10)
ylabel('\% points','Interpreter', 'latex', 'FontSize', 9);
axis([-25 40 -5.5 1])
xline(0,'color',[0.4660 0.6740 0.1880])
yline(0,':','color','red', 'LineWidth', 3)
yline(0,'--','color',[0 0.4470 0.7410], 'LineWidth', 3)

subplot(2,2,2)
plot(t_real, w_p,'-','color','black', 'LineWidth', 6);
yline(0,':','color','red', 'LineWidth', 3)
yline(0,'--','color',[0 0.4470 0.7410], 'LineWidth', 3)
title('Productivity-Wage Gap -- Data', 'Interpreter', 'latex','FontSize', 10)
ylabel('\% points', 'Interpreter', 'latex','FontSize', 9);
axis([1970 2040 -1.5 1])
xticks(1975:20:2040)
xline(1995,'color',[0.4660 0.6740 0.1880])

subplot(2,2,3)
plot(tt,Zs,'-','color','black', 'LineWidth', 6);
title('Efficiency of Capital ($Z$) -- Model' ,'Interpreter', 'latex', 'FontSize', 10)
ylabel('log points','Interpreter', 'latex', 'FontSize', 9);
axis([-25 40 -1 0.5])
xline(0,'color',[0.4660 0.6740 0.1880])
yline(-0.3572,'--','color',[0 0.4470 0.7410], 'LineWidth', 3)
yline(0,'--','color','red', 'LineWidth', 3)

subplot(2,2,4)
plot(t_real, c_p,'-','color','black', 'LineWidth', 6);
%hold on
%plot(t_real,c_shs,'-','color', [1 1 0], 'LineWidth', 0.5);
%title('Labor Share ($\gamma$)', 'Interpreter', 'latex','FontSize', 10)
%ylabel('\%', 'Interpreter', 'latex','FontSize', 10);
hold on
plot(t_real,cp_reali,'--','color','red', 'LineWidth', 3);
hold on
plot(t_real,cp_real,':','color',[0 0.4470 0.7410], 'LineWidth', 3);
hold on
plot(t_real,cp_realm,'--','color',[0 0.4470 0.7410], 'LineWidth', 3);
title('Efficiency of Capital ($Z$) -- Data', 'Interpreter', 'latex','FontSize', 10)
ylabel('log points', 'Interpreter', 'latex','FontSize', 9);
axis([1970 2040 -1 0.5])
xticks(1975:20:2040)
xline(1995,'color',[0.4660 0.6740 0.1880])
legend('', 'Initial BGP', 'New BGP (Data)','New BGP (Model)','', 'Interpreter', 'latex','FontSize', 9, 'Box','off', 'NumColumns',3)







