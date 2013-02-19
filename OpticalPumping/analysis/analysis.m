%% Notes and Startup

%tableA [ Sweep Rate kHz/s, Resonance Frequency kHz, Standard Deviation kHz ]
%
%       Description:
%		contains sweep rate error analysis. data collected by varying
%		the sweep rate and finding the absorption peak

%tableB [ Current in the X [mA], Current in the Y [mA], Current in the Z [mA],
%         Magnetic Field as Measured by the Magnetometer [mG],
%         Resonance Frequency of the First Peak [s],
%         Resonance Frequency of the Second Peak [s],
%         Beginning of Frequency Sweep [kHz],
%         End of Frequency Sweep [kHz],
%         Duration of Sweep [s]  ]
%
%       Description:
%		contains resonance frequencies for varying magnetic field
%		along the z axis

%tableC [ Average Voltage as Measured by the Oscilloscope [mV], 
%         Current Measure by the Multimeter [mA] ]
%
%       Description:
%       used for the determination of the resistance


home = pwd;

%load the data
cd ../data;
load data.mat;
cd(home);
IEarth = [165.7 -19.3 -33.3];  %currents that buck out Earth's magnetic field

%% Error analysis for sweep rate

sweepRate = tableA(:,1);
resonance = tableA(:,2);
deltaRes  = tableA(:,3);
fitA = linearFit(sweepRate,resonance,deltaRes)
%annotate
xlabel('Sweep Rate [kHz/s]')
ylabel('Resonance Frequency [kHz]')

%% Processing Table B

Btotal = sqrt(i2b(tableB(:,1) - IEarth(1),'x').^2+i2b(tableB(:,2)-IEarth(2),'y').^2+i2b(tableB(:,3)-IEarth(3),'z').^2);
%plot the total B field calculated from Helmholtz currents and measured by
%   the magnetometer
figure
plot(Btotal,tableB(:,4)*0.001,'.')
title('Magnetic Field Consistency Check')
xlabel('Magnitude of B Calculated from Currents [G]')
ylabel('B Measured by Magnetometer [G]')
%seems to be a mismatch between positive and negative readings
figure
plot(Btotal,abs(tableB(:,4)*0.001),'.')
title('Magnetic Field Consistency Check')
xlabel('Magnitude of B Calculated from Currents [G]')
ylabel('Magnitude of B Measured by Magnetometer [G]')

% First Peak
resFreqOne = tableB(:,5)./tableB(:,9); %convert into fraction of sweep
resFreqOne = tableB(:,7)*1000 + resFreqOne.*(tableB(:,8)-tableB(:,7))*1000; %convert into Hz
fitB = linearFit(Btotal,resFreqOne,ones(length(tableB(:,5)),1))
%annotate
xlabel('Total Magnetic Field [G]')
ylabel('Resonance Frequency [Hz]')

% Second Peak

%% Measuring the resistance of the Coil

fitC = linearFit(tableC(:,1),tableC(:,2),0.01*ones(length(tableC),1));