
%%%%%%%%% Comparative Statics - PLOT %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load g_L1.mat


minimum=g_L1(:,2);
maximum=g_L1(:,6);
base=floor(minimum);
top=ceil(maximum);

figure(1)
set(0, 'DefaultAxesFontSize',12)
set(0,'defaulttextinterpreter','latex')
set(0,'defaultTextFontName', 'latex')
set(0,'defaultAxesTickLabelInterpreter', 'latex')
set(0,'defaultLegendInterpreter', 'latex')
set(gcf,'color','w');

subplot(4,2,1)
set(gcf,'color','w');
plot(g_L1(:,1),g_L1(:,2),'-','color','black', 'LineWidth', 1);
hold on
plot(g_L1(:,1),g_L1(:,3),'--','color','black', 'LineWidth', 1);
hold on
plot(g_L1(:,1),g_L1(:,4),'-.','color','black', 'LineWidth', 1);
set(gca,'layer','top')
axis([0.20 0.80 -0.65 0])
xline(0.50, ':g','LineWidth',1)
title('$\Delta$ Productivity Growth', 'FontSize', 10)
ylabel('$\%$ point','interpreter', 'latex', 'FontSize', 10);

subplot(4,2,2)
set(0, 'DefaultAxesFontSize',12)
set(0, 'DefaultAxesFontName', 'Bookman Old Style');
set(gcf,'color','w');
p1=plot(g_L1(:,1),g_L1(:,5),'-','color','black', 'LineWidth', 1);
hold on
p2=plot(g_L1(:,1),g_L1(:,6),'--','color','black', 'LineWidth', 1);
hold on
p3=plot(g_L1(:,1),g_L1(:,7),'-.','color','black', 'LineWidth', 1);
axis([0.20 0.80 -15.5 0])
xline(0.50, ':g','LineWidth',1)
title('$\Delta$ Labor Income Share', 'FontSize', 10)%legend('Convergence to New Steady-State', 'Initial Steady-State', 'Location', 'southoutside','boxoff','FontSize', 10);
legend([p1,p2,p3],'$L=.70$', '$L=.75$', '$L=.80$','boxoff','FontSize', 8);
ylabel('$\%$ point','interpreter', 'latex', 'FontSize', 10);


subplot(4,2,3)
set(gcf,'color','w');
h(4)= area(g_L1(:,1),g_L1(:,14),'FaceColor',[0.88,0.77,0.77],'EdgeColor', 'none');
hold on
h(5)= area(g_L1(:,1),g_L1(:,16),'FaceColor', [1 1 1],'EdgeColor', 'none'); 
hold on
p4=plot(g_L1(:,1),g_L1(:,2),'-','color','black', 'LineWidth', 1);
hold on
p5=plot(g_L1(:,1),g_L1(:,3),'--','color','black', 'LineWidth', 1);
hold on
p6=plot(g_L1(:,1),g_L1(:,4),'-.','color','black', 'LineWidth', 1);
axis([0.20 0.80 -0.65 0])
xline(0.50, ':g','LineWidth',1)
title('$\Delta$ Productivity Growth', 'FontSize', 10)
legend([h(4)],'Scenario II','FontSize', 9);
ylabel('$\%$ point', 'interpreter', 'latex', 'FontSize', 10);

subplot(4,2,4)
set(0, 'DefaultAxesFontSize',12)
set(0, 'DefaultAxesFontName', 'Bookman Old Style');
set(gcf,'color','w');
h(2)= area(g_L1(:,1),g_L1(:,17),'FaceColor',[0.85,0.77,0.77],'EdgeColor', 'none');
hold on
h(3)= area(g_L1(:,1),g_L1(:,19),'FaceColor', [1 1 1],'EdgeColor', 'none'); 
hold on
plot(g_L1(:,1),g_L1(:,5),'-','color','black', 'LineWidth', 1)
hold on
plot(g_L1(:,1),g_L1(:,6),'--','color','black', 'LineWidth', 1)
hold on
plot(g_L1(:,1),g_L1(:,7),'-.','color','black', 'LineWidth', 1)
axis([0.20 0.80 -16 0])
xline(0.50, ':g','LineWidth',1)
title('$\Delta$ Labor Income Share', 'FontSize', 10)%legend('Convergence to New Steady-State', 'Initial Steady-State', 'Location', 'southoutside','boxoff','FontSize', 10);
ylabel('$\%$ point','interpreter', 'latex', 'FontSize', 10);

subplot(4,2,5)
set(gcf,'color','w');
h(2)= area(g_L1(:,1),g_L1(:,26),'FaceColor',[0.88,0.77,0.77],'EdgeColor', 'none');
hold on
h(3)= area(g_L1(:,1),g_L1(:,28),'FaceColor', [1 1 1],'EdgeColor', 'none'); 
hold on
p7=plot(g_L1(:,1),g_L1(:,2),'-','color','black', 'LineWidth', 1);
hold on
p8=plot(g_L1(:,1),g_L1(:,3),'--','color','black', 'LineWidth', 1);
hold on
p9=plot(g_L1(:,1),g_L1(:,4),'-.','color','black', 'LineWidth', 1);
axis([0.20 0.80 -0.65 0])
xline(0.50, ':g','LineWidth',1)
title('$\Delta$ Productivity Growth', 'FontSize', 10)
legend([h(2)],'Scenario III','FontSize', 9);
ylabel('$\%$ point', 'interpreter', 'latex', 'FontSize', 10);

subplot(4,2,6)
set(0, 'DefaultAxesFontSize',12)
set(0, 'DefaultAxesFontName', 'Bookman Old Style');
set(gcf,'color','w');
h(2)= area(g_L1(:,1),g_L1(:,29),'FaceColor',[0.85,0.77,0.77],'EdgeColor', 'none');
hold on
h(3)= area(g_L1(:,1),g_L1(:,31),'FaceColor', [1 1 1],'EdgeColor', 'none'); 
hold on
plot(g_L1(:,1),g_L1(:,5),'-','color','black', 'LineWidth', 1)
hold on
plot(g_L1(:,1),g_L1(:,6),'--','color','black', 'LineWidth', 1)
hold on
plot(g_L1(:,1),g_L1(:,7),'-.','color','black', 'LineWidth', 1)
axis([0.20 0.80 -16 0])
xline(0.50, ':g','LineWidth',1)
title('$\Delta$ Labor Income Share', 'FontSize', 10)%legend('Convergence to New Steady-State', 'Initial Steady-State', 'Location', 'southoutside','boxoff','FontSize', 10);
ylabel('$\%$ point','interpreter', 'latex', 'FontSize', 10);


subplot(4,2,7)
set(gcf,'color','w');
h(2)= area(g_L1(:,1),g_L1(:,38),'FaceColor',[0.88,0.77,0.77],'EdgeColor', 'none');
hold on
h(3)= area(g_L1(:,1),g_L1(:,40),'FaceColor', [1 1 1],'EdgeColor', 'none'); 
hold on
p7=plot(g_L1(:,1),g_L1(:,2),'-','color','black', 'LineWidth', 1);
hold on
p8=plot(g_L1(:,1),g_L1(:,3),'--','color','black', 'LineWidth', 1);
hold on
p9=plot(g_L1(:,1),g_L1(:,4),'-.','color','black', 'LineWidth', 1);
axis([0.20 0.80 -0.65 0])
xline(0.50, ':g','LineWidth',1)
title('$\Delta$ Productivity Growth', 'FontSize', 10)
legend([h(2)],'Scenario IV','FontSize', 9);
ylabel('$\%$ point', 'interpreter', 'latex', 'FontSize', 10);
xlabel('$\delta_z$ shock', 'interpreter','latex', 'FontSize', 11);

subplot(4,2,8)
set(0, 'DefaultAxesFontSize',12)
set(0, 'DefaultAxesFontName', 'Bookman Old Style');
set(gcf,'color','w');
h(2)= area(g_L1(:,1),g_L1(:,41),'FaceColor',[0.85,0.65,0.7],'EdgeColor', 'none');
hold on
h(3)= area(g_L1(:,1),g_L1(:,43),'FaceColor', [1 1 1],'EdgeColor', 'none'); 
hold on
plot(g_L1(:,1),g_L1(:,5),'-','color','black', 'LineWidth', 1)
hold on
plot(g_L1(:,1),g_L1(:,6),'--','color','black', 'LineWidth', 1)
hold on
plot(g_L1(:,1),g_L1(:,7),'-.','color','black', 'LineWidth', 1)
axis([0.20 0.80 -16 0])
xline(0.50, ':g','LineWidth',1)
title('$\Delta$ Labor Income Share', 'FontSize', 10)%legend('Convergence to New Steady-State', 'Initial Steady-State', 'Location', 'southoutside','boxoff','FontSize', 10);
ylabel('$\%$ point','interpreter', 'latex', 'FontSize', 10);
xlabel('$\delta$ shock', 'interpreter','latex', 'FontSize', 11);

%%
saveas(gcf,'sensitivity','epsc')
savefig('sensitivity.fig')
