%% Importing and plotting H-field from COMSOL 
clear all;

Hfield = readmatrix('H-Field(COMSOL) (1).csv');

%%
%Hfield(:,2)=Hfield(:,2)*1E-3; 
P = fit(Hfield(:,2),Hfield(:,3),'exp1');


x=110:0.01:112;

%H = @(x) P.p1*x.^2+P.p2*x+P.p3;
gradH = @(x) P.a*P.b*exp(P.b*x);
figure(1);
hold on
plot(Hfield(:,2),Hfield(:,3),'*');
plot(x,P(x));
ylabel('Magnetic Field (A/m)')
xlabel('Y location in COMSOL (mm)')
hold off

figure(2)
plot(x,(gradH(x)).^2)
%%
