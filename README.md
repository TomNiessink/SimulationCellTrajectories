# SimulationCellTrajectories

This MATLAB script contains a model which can simulate the trajectories of cells which are immunomagnetically enriched in a rectangular channel. 
This model utilizes a combination of FMD modelling and the Monte-Carlo method. 

Cell_Trajectories_Monte_Carlo.m is the main file containing the simulation.

calc_murp.m is a function which calculates the particle relative permeability of the cell.

murp_rand.m is a function which pulls a 'random' permeability from a distribution with CV = 220%.

xpos_rand.m is a function which pulls a 'random' starting positon from a distribution with sigma = (channel height)/6.

H_field.m is a function which calculates the H field for a certain defined place in the channel.

H_field_Calculation.m shows how the H field was fitted with the MATLAB function 'fit'.

The excel file contains a COMSOL simulated magnetic field.

This model is built as part of a master thesis by Tom Niessink (2021), University of Twente
