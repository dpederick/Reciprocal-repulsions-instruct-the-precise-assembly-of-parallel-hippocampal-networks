x=dlmread('');
Y=dlmread('');
z=dlmread('');
c=dlmread('');
figure
colormap(jet)
z2 = flipud(z);
c2 = flipud(c);
surf(x,Y,z2,c2,'FaceAlpha',1.0)
shading interp
hold on;
surf(x,Y,z2,c2,'EdgeColor','white','FaceColor','none','EdgeAlpha',0.2)
grid off
set(gca,'XTick',[],'YTick',[],'ZTick',[]) 
az = -60;
el = 20;
view(az, el);
