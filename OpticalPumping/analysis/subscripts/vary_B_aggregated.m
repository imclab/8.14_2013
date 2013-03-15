% fixed X,Y currents
Bfixed_D = [166.0 -19.28];
Bfixed_E = [165.0 -20];
Bfixed_G = [148.4 -19.24];

% create the aggregated data table
% agg = [RF fixed freq, peak 2, peak 1, uncert 2, uncert 1, fixed I_x,
% fixed I_y]
agg = [tableD(:,1:5) Bfixed_D(1)*ones(size(tableD,1),1) ...
    Bfixed_D(2)*ones(size(tableD,1),1) ...
    ; tableE(:,1:5) Bfixed_E(1)*ones(size(tableE,1),1) ...
    Bfixed_E(2)*ones(size(tableE,1),1) ... 
    ; tableG(:,1) (tableG(:,3)+tableG(:,5))/2 ...
    (tableG(:,2)+tableG(:,4))/2 tableG(:,7) tableG(:,6) ...
    Bfixed_G(1)*ones(size(tableG,1),1) Bfixed_G(2)*ones(size(tableG,1),1)];

% Peak 1

% get total Bfield
Btotal = sqrt(i2b(agg(:,6) - IEarth(1),'x').^2+i2b(agg(:,7)-IEarth(2),'y').^2 ...
    +i2b(v2i(1e-3*agg(:,3))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
figure
subplot(2,1,1)
fitagg = linearFit(agg(:,1),Btotal,i2b(v2i(1e-3*agg(:,5)),'z'))
%plot model
hold on
plot(agg(:,1),fitagg.a*agg(:,1)+fitagg.b,'-r')
%annotate
title({'Agg :: Fixed Frequency, Varied B','Peak 1'})
xlabel('Resonance Frequency [kHz]')
ylabel('Total Magnetic Field [G]')
fontSize(16)


% Peak 2

% get total Bfield
Btotal = sqrt(i2b(agg(:,6) - IEarth(1),'x').^2+i2b(agg(:,7)-IEarth(2),'y').^2 ...
    +i2b(v2i(1e-3*agg(:,2))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
subplot(2,1,2)
fitagg = linearFit(agg(:,1),Btotal,i2b(v2i(1e-3*agg(:,4)),'z'))
%plot model
hold on
plot(agg(:,1),fitagg.a*agg(:,1)+fitagg.b,'-r')
%annotate
title({'Agg :: Fixed Frequency, Varied B','Peak 2'})
xlabel('Resonance Frequency [kHz]')
ylabel('Total Magnetic Field [G]')
fontSize(16)