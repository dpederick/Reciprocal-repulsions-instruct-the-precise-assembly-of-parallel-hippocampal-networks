x=dlmread('x 100.txt');
y=dlmread('y 16.txt');
z=dlmread('z mch.txt');
figure
colormap(hot)
imagesc(x,y,z)
colorbar