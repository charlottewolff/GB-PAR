%
close all
f1=openfig('C:\Users\charl\Desktop\insar\fig\cornalle_input.fig');
f2=openfig('C:\Users\charl\Desktop\insar\fig\cornalle_dist.fig');
f3=openfig('C:\Users\charl\Desktop\insar\fig\cornalle_facingfig.fig');
f4=openfig('C:\Users\charl\Desktop\insar\fig\cornalle_az.fig');
f5=openfig('C:\Users\charl\Desktop\insar\fig\cornalle_range.fig');
f6=openfig('C:\Users\charl\Desktop\insar\fig\cornalle_viewfig.fig');
f7=openfig('C:\Users\charl\Desktop\insar\fig\cornalle_plan.fig');
f8=openfig('C:\Users\charl\Desktop\insar\fig\cornalle_foreshortening.fig');
% 
% 
% % Prepare subplots
% figure
% h(1)=subplot(1,2,1);
% h(2)=subplot(1,2,2);


% Load saved figures
% c=hgload('MyFirstFigure.fig');
% k=hgload('MySecondFigure.fig');
% Prepare subplots
figure
h(1)=subplot(4,2,1);
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Height (m)';
grid on
ylabel('W. Longitude')
xlabel('N. Latitude')
view(-50,35)
h(2)=subplot(4,2,2);
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Distance (m)';
grid on
ylabel('W. Longitude')
xlabel('N. Latitude')
view(-50,35)
h(3)=subplot(4,2,3);
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Facing(=1)/Facing away(=-1)';
grid on
ylabel('W. Longitude')
xlabel('N. Latitude')
view(-50,35)
h(4)=subplot(4,2,4);
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Resolution (m)';
grid on
ylabel('W. Longitude')
xlabel('N. Latitude')
view(-50,35)
h(5)=subplot(4,2,5);
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Resolution (m)';
grid on
caxis([0 10])
ylabel('W. Longitude')
xlabel('N. Latitude')
view(-50,35)
h(6)=subplot(4,2,6);
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Heigth (m)';
grid on
ylabel('W. Longitude')
xlabel('N. Latitude')
view(-50,35)
h(7)=subplot(4,2,7);
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Heigth (m)';
grid on
ylabel('W. Longitude')
xlabel('N. Latitude')
view(-50,35)
h(8)=subplot(4,2,8);
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Foreshortening degree';
grid on
ylabel('W. Longitude')
xlabel('N. Latitude')
view(-50,35)
caxis([-1 1])
% Paste figures on the subplots
copyobj(allchild(get(f1,'CurrentAxes')),h(1));
copyobj(allchild(get(f2,'CurrentAxes')),h(2));
copyobj(allchild(get(f3,'CurrentAxes')),h(3));
copyobj(allchild(get(f4,'CurrentAxes')),h(4));
copyobj(allchild(get(f5,'CurrentAxes')),h(5));
copyobj(allchild(get(f6,'CurrentAxes')),h(6));
copyobj(allchild(get(f7,'CurrentAxes')),h(7));
copyobj(allchild(get(f8,'CurrentAxes')),h(8));
% Add legends
l(1)=title(h(1),'Input map');
l(2)=title(h(2),'Distance to Gb-InSAR');
l(3)=title(h(3),'Facing - Shadow');
l(4)=title(h(4),'Azimuthal resolution');
l(5)=title(h(5),'Range resolution');
l(6)=title(h(6),'Illuminated surface');
l(7)=title(h(7),'Mean plan over illuminated surface');
l(8)=title(h(8),'Foreshortening degree');