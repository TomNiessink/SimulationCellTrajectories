%% Simulation of cell trajectories in Ibidi \mu-slides
close all; clear all; clc;
% This script uses FDM modelling combinded with the Monte Carlo Method
% to simulate trajectories of cells flowing through a rectangular channel.
% This script is written as part of a master thesis by
% Tom Niessink, 11-7-2021


% Constants, belonging to channel, flow rate etc.
w = 5E-3;                %Channel Width (m)
h = 200E-6;              %Channel height (m)
Q = .5*1.667E-8;         %Flow in m^3/s   
L = 5E-2;                %Channel length (m)

% Constants, physical
rho = 1000;                     %Density medium (kg/m3)
Rcell = 5E-6;                   %Cross section cell (m)
eta = 8.14E-3;                  %Viscosity
mu0 = pi*4E-7;                  %Magnetic permeability of vacuum
Vcell = (4/3)*pi*(Rcell^3);     %Volume of a cell (m^3)
m_max0 = 9.2E-14;                 %Average maximum magnetic permeability of a cell (Am^2)

% Flow velocity (= horizontal velocity)
v_h = @(x) -(3/4)*(x.^2-(h/2)^2)*Q/((h/2)^3*w);

% Definition magnetic gradient, particle permeability
%murp = 1.0005;         %Particle relative permeability
%dH2  = 1E15;            %Magnetic gradient (COMSOL)
%H=250000;

% Vertical velocity (attraction towards magnet)
v_v = @(murp,dH2) (1/3)*(Rcell^2/eta)*mu0*((murp-1)/(murp+2))*dH2;

% Simulation variables
dt = 1E-3;              %Time discretization (s)
tfin = 100;             %Simulation end time (s)
CellCount = 120;        %Number of cells per iteration
Iterations = 1;         %Number of Monte Carlo Iterations
tmax=tfin/dt;           %Max no of elements (Change by changing tfin,dt)






%% Simulation 
tic                     %Simulation timer

recoveries = zeros(Iterations,1);       % Pre-allocating data for results

for j = 1:Iterations                %Perform simulation for the amount of Monte-Carlo simulations given




% Allocating dataspace for simulation speed
xpos=zeros(tmax,CellCount);     
ypos=zeros(tmax,CellCount);
recovered=zeros(CellCount,1);

for i = 1:CellCount                 %In each Monte-Carlo iteration, simulate this much cells
    
    
    % Choosing the random starting variables (separate functions, utilizing
    % The normrnd() function)
    xpos(1,i) = xpos_rand(h);       %xpos_rand(height) gives a normal distribution
                                    %With sigma = channel height/8
    m_max = abs(normrnd(m_max0,m_max0*2.2));          

    
    for t=2:tmax                    %Run simulation while the maximum time is not reached
        
        if xpos(t-1,i)>(-h/2)       %Only run the simulation when the cell is in the channel
        
        % Vertical & horizontal velocity, based on the formulas above. 
        % Vertical velocity is calculated based on the drag force & magnetic force,
        % and dependent on the relative magnetic permeability and field
        % gradient
        % Horizontal velocity is dependent on the flow field
        
        [H,dH2] = H_field(xpos(t-1,i),h);
        murp = calc_murp(m_max,H,Vcell);
        
        vvcell= v_v(murp,dH2);       
        vcell = v_h(xpos(t-1,i));
                
        
        %Displacement is calculated with a first order taylor expansion
        %Approximation
        xpos(t,i)=xpos(t-1,i)-vvcell*dt;      
        ypos(t,i)=ypos(t-1,i)+vcell*dt;
        
        else            %If the cell is at the wall, it should stay there
            xpos(t,i)=xpos(t-1,i);
            ypos(t,i)=ypos(t-1,i);
        end
        
        
        
    end
    
    if ypos(t,i)<L  %If the cell is at the wall, it is caught and therefore recovered
            if xpos(t,i)<(-h/2)
                recovered(i)=1;
            end
        end
    
    
end

%Calculate the percentage of cells found in this iteration
recoveries(j)=sum(recovered)/size(recovered,1);         

end



toc                     %Simulation timer

%% Plotting


hold on
plot(ypos,xpos)
scatter(ypos(end,:),xpos(end,:))
xlim([0 0.05])
ylim([-h/2 h/2])
xlabel('Position in channel (m)')
ylabel('Height in channel (m)')

mean(recoveries)
std(recoveries)
