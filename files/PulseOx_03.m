% PULSE-OXIMETER SERIAL DATA ACQUISITION ROUTINES
% FIRST, ESTABLISH COMMUNICATIONS WITH THE PULSE-OXIMETER AND SEE HOW TO
%   GET DATA 
% 
% FILENAME: PulseOx_03.m
% 
% 2008-09-06 21:52
% 
% UPDATE:   2017-02-14
% 

% exist s1

% % for k1 = 107:-1:1
% %     pages(k1,:) = [k1  107-k1];
% % end
% % midbook = find((pages(:,2)-pages(:,1)) == 1);
% % pages(midbook,:)
% % brea

close all
clear all

fprintf(1,'\n')
for k1 = 1:20
    fprintf(1,'÷×');
end
fprintf(1,'  %s  ', datestr(now));
for k1 = 1:20
    fprintf(1,'÷×');
end
fprintf(1,'\n\n\n')

fprintf(1,'\n\n\t\t\t\t\t\t\t\t\t\t—— LINE %d ——\n\n', 32);

PortIn = getpulsoxport
% PortIn = 'COM4'
TestPortStr = 'COM4'

fprintf(1,'\n\n\t\t\t\t\t\t\t\t\t\t—— LINE %d ——\n\n', 36);

% % DIAGNOSTIC IN CASE THINGS DON'T GO QUITE AS PLANNED 
% VblsEtc = whos;
% VrblNames = VblsEtc.name
% VrblSizes = VblsEtc.size
% VrblBytes = VblsEtc.bytes
% VrblClass = VblsEtc.class
% VrblGlobl = VblsEtc.global
% VrblPerst = VblsEtc.persistent

% set(instrfindall,'ObjectVisibility','on')

% break

% ORIENT SELF
myname = 'PulseOx_03.m';
imhere = which(myname);
dirsep = findstr(imhere,'\');
myfilidx = findstr(imhere,'\My_Files\');
datpatlim = dirsep(find(dirsep > myfilidx,1,'first'));
myfildatpat = [imhere(1:datpatlim) 'Data\'];
myfiloutpat = [imhere(1:datpatlim) 'Results\'];

Grafont = 'Consolas';
Texfont = 'Candara';

% INLINE FUNCTIONS
rng = @(X,dim) max(X,[],dim)-min(X,[],dim);
QuikStats = @(X) [median(X)  mode(X)  std(X);    mean(X)-1.96*std(X)  mean(X)  mean(X)+1.96*std(X);    min(X)  [max(X)-min(X)]  max(X)];   % Quick Summary Statistics
RngXpnd = @(X,F) (X-min(X)).*F./(max(X)-min(X)) + (max(X)-min(X))*0.1;      % "X" is array argument, "F" is expansion factor
ZroX = @(dx) dx(1:end-1) .* dx(2:end);
LimAx = @(Mtx,dim) [min(Mtx,[],dim)-abs(min(Mtx,[],dim))*0.05;    max(Mtx,[],dim)+abs(max(Mtx,[],dim))*0.05]);
dB = @(X) 20*log10(abs(X));
% help serial

fprintf(1,'\n\n\t\t\t\t\t\t\t\t\t\t—— LINE %d ——\n\n', 72);

fprintf(1,'\n\tStart %s ...\n\n',myname);

fprintf(1,'\n\n\t\tDEFINE PORT, BEGIN RECORDING\t\t\t\t\t—LINE %d—\n\n', 76);

s1 = serial(PortIn);

% s1.ByteOrder
% help serial/fopen

TagClock = clock;
s1.Tag = sprintf('Pulse Oximeter Data %04d/%02d/%02d-%02d.%02d.%07.4f',TagClock);

BffrSz = 2^19;                   % Buffer size to set = 4096

set(s1,'InputBufferSize',BffrSz)     %,'OutputBufferSize',BffrSz)

% BitsPerWord = 12;            % Bits per word (Byte+4bits) See: asychronous serial protocol for details
BitsPerWord = 16;            % Bits per word (Byte+8bits) See: asychronous serial protocol for details
Timeout = 40.00;                % Data Acquisition Time (Seconds) **********
BaudRate = 19200;
RealBaudRate = 19231;

BytesPerSec = RealBaudRate/BitsPerWord;


s1.Timeout = Timeout;       % Time Interval = 1.654837360799331E-002 seconds
s1.BaudRate = BaudRate;



% fopen(s1);

% fprintf(s1, '*IDN?');
% idn = fscanf(s1)

s1.RecordDetail = 'verbose';
s1.RecordName = [myfiloutpat sprintf('PulsOxSerialFile_%04d%02d%02d_%02d%02d%02d.txt',floor(TagClock))];

fprintf(1,'\n\n\tOpen serial port to pulse-oximeter.\n\n');

fopen(s1);
record(s1,'on')
% fprintf(1,'\n\n\tSERIAL PORT CONFIGURATION INFORMATON\n');
St01 = get(s1)

fprintf(s1,['\\\\\\\\.\\\\' '%s\n'], PortIn);     %   NOTE: String sent to instrument
                                    %       should be "\\\\.\\COMx"
% fprintf(s1,'\\\\\\\\.\\\\%s\n', PortIn);    
                        % Silicon Laboratories CP210x "Open" Command
                        %   See: Silicon Laboratories AN197 for
                        %        full documentation
                        % NOTE: String sent to instrument
                        %       should be "\\\\.\\COMx"
                                    
SerRdFmt = 'uint8';                 % All values are (+)ve by definition

CheckRead243 = fscanf(s1)

fprintf(1,'\n\n\t\tStart %8.2f second recording . . .\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t— "Timeout" on —LINE %d—\t—LINE %d—\n\n',Timeout, 92, 132);
NowTime = now;
NowVct = datevec(NowTime);
EndTime = NowTime + Timeout/(60*60*24);
EndVec = datevec(EndTime);
fprintf(1,'\n\tStart Recording  = %02d:%02d:%06.3f\n\nFinish Recording = %02d:%02d:%06.3f\n\n', NowVct(4:6), EndVec(4:6));
T0 = clock;
[PulsOxIn,DataIn,pulsoxmsg] = fread(s1,BffrSz,SerRdFmt);
T1 = clock;
ReadTime = etime(T1,T0);                        % Read Time Duration (sec)
fprintf(1,'\n\t\t\t\t\t\t\t\t. . . Stop recording.\n\t\t\t\t\t\t\t\t\t\t—LINE %d—\n\n', 388);
EndRcdSgnl = sin(2*pi*[0:0.001:750]./1000);
soundsc(EndRcdSgnl*1,1000)
if ~isempty(pulsoxmsg)
    fprintf(1,'\n\t*** NOTE: %s\n\n\n',pulsoxmsg);
    if DataIn < 100
        fprintf(1, '\n\n');
        fprintf(1,' %c ', PulsOxIn);
        fprintf(1, '\n\n');
    end
end

record(s1,'off')

% DataIn = s1.ValuesReceived;

% CLOSE & DELETE SERIAL PORT
fclose(s1)
delete(s1)

DeltaT = ReadTime/DataIn;             % Bytes/sec

if DataIn <= 5
    fprintf(1,'\n\n\tTotal of %d values read aren''t enough.\n\tYou sure you turned on the Pulse-Oximeter?\n\n\tExiting.\n\n\n',DataIn);
    break
end

FieldsPerRec = 5;                                % Fields/Record (Defined again for "reshape" below)
BytesPerField = 1;                                   % Bytes per data field

BytesPerSec = RealBaudRate/BitsPerWord;
Fs1 = BytesPerSec/FieldsPerRec;                  % Sampling Frequency (records/sec)
% F0 = (DataIn/FieldsPerRec)/Timeout;             % Fundamental Frequency
% (Hz) For Spectral Analyses (FFT)

% XsBytes = [(RealBaudRate*Timeout)/(DataIn*8);  (RealBaudRate*ReadTime)/(DataIn*8)]

FieldsPerSec = DataIn/ReadTime;
Fs2 = FieldsPerSec/FieldsPerRec;

% FsMtx = [Fs1;  Fs2;  Fs1/Fs2]

Fs = Fs2;

SetPrSec = DataIn/(ReadTime*FieldsPerRec);       % Read Speed as Records/sec (Data field quintads/sec)
SecPrSet = 1/SetPrSec;
Tot_bits = RealBaudRate*Timeout;                % Total bits read
ByteRate = RealBaudRate/BitsPerWord;             % Bytes read per second
TotBytes = Tot_bits/BitsPerWord;                 % Total Bytes read
DeltaT_SpB = BitsPerWord/RealBaudRate;           % Sec/Byte = Fields/sec (6.25E-004)
DeltaT_SpR = DeltaT_SpB*FieldsPerRec;            % Sec/Record (5 Fields/record)
FrRecPrSec = 1/DeltaT_SpR;                      % Records/Sec
DataBitRate = DataIn*8/ReadTime                 % Data bits/sec
% OvhdBits = [BaudRate;  RealBaudRate] - [DataBitRate;  DataBitRate]
fprintf(1,'\n\tRequired %8.3f seconds to read %d bytes\n\t\tequivalent to %11.3E sec/record or %11.3E records/sec\n\n\tCompletely filling the %d byte buffer requires %11.3E sec (%02d:%02d:%02d.%03d)\n\n',ReadTime,DataIn,DeltaT_SpR,FrRecPrSec,BffrSz,BffrSz/SetPrSec,hmsdv(BffrSz/SetPrSec));

% % SavFilNm = sprintf('PulseOximeterData   _%04d%02d%02d_%02d%02d%02d.mat',floor(TagClock));
% % 
% % save([feffiloutpat  SavFilNm], 'PulsOxIn', 'DataIn', 'pulsoxmsg', 'ReadTime', 'DataIn', 'SerRdFmt', 'BaudRate')

% record(s1,'off')
% 
% fclose(s1)
% 
% delete(s1)

fprintf(1,'\n\n\t%s closed and deleted successfully ... begin analysis\n\n\n','s1');
% fprintf(1,'\n\n\t%s closed successfully ... begin analysis\n\n\n','s1');

fprintf(1,'\n\n\t\t\t\t\t\t\t\t\t\t—— LINE %d ——\n\n', 462);

% PulsOxStats = QuikStats(PulsOxIn)
PulsOxPlot = PulsOxIn;

% RESHAPE INPUT DATA VECTOR INTO A MATRIX OF QUINTADS
PulsOxAryCols = FieldsPerRec;
PulsOxRmdr = mod(DataIn,PulsOxAryCols);
DataInTrm = DataIn - PulsOxRmdr;
% fprintf(1,'\n\n\n\t\t"DataInTrm" = %f\t\t%d\n\n\n', DataInTrm, exist(DataInTrm))
PulsOxInTrm = PulsOxIn(1:(DataIn-PulsOxRmdr));
PulsOxRows = fix(DataIn/PulsOxAryCols)
% PulsOxInTrm = PulsOxIn(1:DataInTrm);
PulsOxLen = PulsOxRows;
% PulsOxInTrm = 1:(size(PulsOxIn,1)-PulsOxRmdr);
% PulsOxLen = (size(PulsOxIn,1)-PulsOxRmdr)/PulsOxAryCols;
PulsOxVct = 1:PulsOxLen;
PulsOxLim = ceil(DataIn/PulsOxAryCols);
PulsOxPlot = zeros(PulsOxLim,3);
% PulsOxAry = reshape(PulsOxAry,PulsOxAryCols,PulsOxLen)';
PulsOxAry = reshape(PulsOxInTrm,FieldsPerRec,PulsOxRows)';
% PulsOxPlot = PulsOxAry;
% TotTime = PulsOxLen/Fs;      % #Bytes*(Rec/Byte)*(Sec/Rec)
TotTime = PulsOxLen * SecPrSet;
F0 = 1/TotTime;                 % Fundamental Frequency (Hz) For Spectral Analyses (FFT)
                                %   F0 = (samples/sec) * (1/samples) = 1/sec

% FIGURE OUT SIGNALS AND CHANNELS (VARIES WITH EACH READ)
%   ASSIGN CHANNELS THUSLY:
%       Index #1:   Highest Std = Plethysmogram 
%       Index #2:   Second = SaO2 
%       Index #3:   Third = HR
PulsOxSts = [mean(PulsOxAry,1);  std(PulsOxAry,[],1)];
PulsOxCtV = PulsOxSts(2,:) ./ PulsOxSts(1,:);       % COEFFICENTS OF VARIATION
PulsOxRtg = max(PulsOxAry,[],1) ./ mean(PulsOxAry,1);       % INV COEFFICENTS OF VARIATION
PulsOxRng = max(PulsOxAry,[],1)-min(PulsOxAry,[],1);
PulsOxMdn = median(PulsOxAry,1);
PulsOxMin = min(PulsOxAry,[],1);
PulsOxMax = max(PulsOxAry,[],1);

% FIND ELEMENTS AT MIN & MAX
for k1 = 1:size(PulsOxSts,2)
    MaxNr(k1) = size(find(PulsOxAry(:,k1) >= PulsOxMax(k1)-PulsOxRng(k1)/20),1);
    MinNr(k1) = size(find(PulsOxAry(:,k1) <= PulsOxMin(k1)+PulsOxRng(k1)/20),1);
end
% MnMxDv = MinNr./MaxNr;              % Pulse Signal SHOULD have highest ratio
MnMxPrd = PulsOxMax .* max(PulsOxMin,[ones(size(PulsOxMin))*1]);
MaxMxMdn = find( (max(PulsOxMax >= max(PulsOxMax))) & (PulsOxMdn >= max(PulsOxMdn)) );

% [SrtMn,MnIdx] = sort(PulsOxSts(1,:),'descend');
% [SrtSd,SdIdx] = sort(PulsOxSts(2,:),'descend');
% [SrtCt,CtIdx] = sort(PulsOxCtV,'descend');
% [SrtRt,RtIdx] = sort(PulsOxRtg,'descend');
% [SrtRg,RgIdx] = sort(PulsOxRng,'descend');
% [SrtMd,MdIdx] = sort(PulsOxMdn,'descend');
% [SrtLo,LoIdx] = sort(MnMxDv,'descend');
% [SrtHi,HiIdx] = sort(PulsOxMax,'descend');

% SHIFT RETURNED MATRIX BY COLUMN SO "PLETHYSMOGRAM" INDEX IS FIRST
HRSgnlIdx2 = MaxMxMdn;
HRSgnlIdx1 = find(MnMxPrd >= max(MnMxPrd));
HRSgnlIdx = HRSgnlIdx2;
SbsVct = [1:size(PulsOxAry,2)];
if (HRSgnlIdx ~= size(PulsOxAry,2)) % & (HRSgnlIdx ~= 1)
    RotnVct = circshift(SbsVct,[0  5-HRSgnlIdx]);  % "RotnVct" = Rotation Vector
else
    RotnVct = SbsVct;
end

fprintf(1,'\n\n\t\t\t\t\t\t\t\t\t\t—— LINE %d ——\n\n', 528);

fprintf(1,'\n\tHeart Rate Indices\n\t\tMax-Min-Mean\t%d\n\t\tMinMax Prod\t\t%d\n\n',HRSgnlIdx2,HRSgnlIdx);  

% MAP VARIABLES ROTATED TO PUT PLETHYSMOGRAM FIRST ...
PulsOxStsRot = PulsOxSts(:,RotnVct);
PulsOxMaxRot = PulsOxMax(RotnVct);
PulsOxMinRot = PulsOxMin(RotnVct);
PulsOxSav = PulsOxAry(:,RotnVct);
PulsOxLbls = ['Plthysmgrm';  'OxyHemglbn';  'Heart Rate';  'PaO2 Trend';  'Pulse Sgnl'];

% ... THEN SAVE ALL DATA WITH VARIABLE LABELS
SavFilNm = sprintf('PulseOximeterData(NewFmt)_%04d%02d%02d_%02d%02d%02d.mat',floor(TagClock));
save([myfiloutpat  SavFilNm], 'PulsOxSav', 'PulsOxLbls', 'DataIn', 'pulsoxmsg', 'ReadTime', 'DataIn', 'SerRdFmt', 'BaudRate', 'DeltaT_SpR')
% SAVE COMPLETE

% ROTATE ORIGINAL DATA TO PRODUCE "PulsOxPlot"
PulsOxPlot = PulsOxAry(:,RotnVct);   % DEFINE DATA TO BE PLOTTED

LimPr = 2/(size(PulsOxAry,1));
ZCILmPr = -sqrt(2) * erfcinv(2*[1.0-LimPr]);
NCILmPr = [[PulsOxSts(1,RotnVct)-ZCILmPr*PulsOxSts(2,RotnVct)];  [PulsOxSts(1,RotnVct)+ZCILmPr*PulsOxSts(2,RotnVct)]]';  
Xtrms = [NCILmPr  PulsOxMin(RotnVct)'  PulsOxMax(RotnVct)'];

% LOG-TRANSFORMED STATISTICS FOR PLETHYSMOGRAM AND SaO2
LnPlsOxPlt = log(PulsOxPlot(:,1:2)+0.001);
LnMn = mean(LnPlsOxPlt,1);
LnSd = std(LnPlsOxPlt,[],1);
LnCI = [LnMn-ZCILmPr*LnSd;  LnMn+ZCILmPr*LnSd];
ExpLnSts = exp([LnMn;  LnSd;  LnCI]);
fprintf(1,'\n\n\tPlethysmogram Log Distribution Statistics\n');
fprintf(1,'\n\t\t\tMean\t\t\t\t%11.4f\n\t\t\tStDev\t\t\t\t%11.4f\n\t\t\tCI  2.5%%le\t\t\t%11.4f\n\t\t\tCI 97.5%%le\t\t\t%11.4f\n\n',ExpLnSts(:,1));


for k1 = 1:size(PulsOxSts,2)
    if (PulsOxMaxRot(k1) > NCILmPr(k1,2)) | (PulsOxMinRot(k1) < NCILmPr(k1,1))
        PulsOxMinRot(k1) = max(PulsOxMinRot(k1),NCILmPr(k1,1));
    end
end

% IdxCmpr = [MnIdx; SdIdx; CtIdx; RtIdx; RgIdx; MdIdx];
Y_Lo1 = PulsOxMinRot - abs(PulsOxMinRot)*0.05;
Y_Hi1 = PulsOxMaxRot + abs(PulsOxMaxRot)*0.05;
PulsOxY = LimAx(PulsOxPlot,1);
Y_Lo = PulsOxY(1,:);
Y_Hi = PulsOxY(2,:);

% MAP THE INDICES SO VARIABLES ARE ALWAYS THE SAME
% RotnVct = RotnVct;
fprintf(1,'\n\n\tIndex Map\n\t\tRotnVct\t\tInputOrder\n');
for k1 = 1:size(PulsOxSts,2)
    fprintf(1,'\t\t  %2d\t\t\t\t%2d\n',k1,RotnVct(k1));
end

% PulsOxPlot = PulsOxAry(:,RotnVct);   % DEFINE DATA TO BE PLOTTED

for k1 = 1:size(PulsOxSts,2)
    YScl(k1,:) = [Y_Lo(k1)  Y_Hi(k1)];
end

% PulsOxPlot(1:25,:)

% ASSIGN LABELS TO VARIABLES FOR AXIS LABELING AND LEGENDS
PulsOxLbls = ['Plthysmgrm';  'OxyHemglbn';  'Heart Rate';  'PaO2 Trend';  'Pulse Sgnl'];
for k1 = 1:size(PulsOxSts,2)-1;
    LgndStr(k1,:) = sprintf('%s ', PulsOxLbls(k1,:)');
end
LgndStr(k1+1,:) = sprintf('%s ',PulsOxLbls(size(PulsOxSts,2),:));

InpLen = size(PulsOxPlot,1);
AryPrtSlct = [1 : round(InpLen/20) : InpLen]';      % PRINT 20 ROWS
fprintf(1,'\n\n\tPulsOxPlot sample (interval = %d):\n',round(InpLen/20));
fprintf(1,'\n\t\tIndex');
for k1 = 1:size(PulsOxPlot,2)
    fprintf(1,'\t\t%s',LgndStr(k1,:));
end
fprintf(1,'\n');
fprintf(1,'\t\t%6d\t\t\t%3d\t\t\t\t%3d\t\t\t\t%3d\t\t\t\t%3d\t\t\t\t%3d\n',[AryPrtSlct  PulsOxPlot(AryPrtSlct,RotnVct)]');


DeltaT5Byt = DeltaT*PulsOxAryCols;          % Calculate time interval between consecutive 5-byte fields
PlsOxTm = [0:size(PulsOxAry,1)-1]*DeltaT5Byt;
fprintf(1,'\n\tSample / \b_\\T = %23.15E sec\n\n',DeltaT5Byt);

% Color4 = [255  168  006]/255;       % BURNT ORANGE!  Hue = 026,  Sat = 240,  Lum = 123
Color4 = [255  128  000]/255;       % BRIGHT ORANGE!  H = 196,  S = 190,  L = 090  
Color5 = [156  020  171]/255;       % PURPLE!  H = 210,  S = 185,  L = 092
% Color5 = [231  225  012]/255;       % YELLOW!  H = 039,  S = 216,  L = 114


figure(169)
plot(PlsOxTm,PulsOxPlot(:,1),'Color','b')
hold on
plot(PlsOxTm,PulsOxPlot(:,2),'Color','r')
plot(PlsOxTm,PulsOxPlot(:,3),'Color','g')
plot(PlsOxTm,PulsOxPlot(:,4),'Color',Color4,'LineStyle','-')
plot(PlsOxTm,PulsOxPlot(:,5),'Color',Color5)
hold off
set(gca,'FontName',Grafont,'FontSize',8)
% LgndStr = sprintf('''%s\n'', ',PulsOxLbls(1:4,:)')
% LgndStr = [LgndStr sprintf('''%s''',PulsOxLbls(5,:))];
legend(LgndStr,1)
title('Detailed Time Domain Plot','FontName',Texfont,'FontSize',16)
xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
ylabel('Amplitude','FontName',Texfont,'FontSize',12)
% axis([0  max(PlsOxTm)    0  250])
axis([0  (max(PlsOxTm)/10)    0  255])
grid

orient landscape


figure(170)
subplot(5,1,1)
plot(PlsOxTm,PulsOxPlot(:,1),'-b')
set(gca,'FontName',Grafont,'FontSize',8)
% axis([0  max(PlsOxTm)    0  250])
% ylabel('Amplitude Variable #1','FontName',Texfont,'FontSize',12)
title('Pulse Oximeter Channel Signals','FontName',Texfont,'FontSize',16)
ylabel(PulsOxLbls(1,:),'FontName',Texfont,'FontSize',12)
axis([0  max(PlsOxTm)/1    YScl(1,:)])
grid

subplot(5,1,2)
plot(PlsOxTm,PulsOxPlot(:,2),'-r')
set(gca,'FontName',Grafont,'FontSize',8)
% axis([0  max(PlsOxTm)    0  250])
% xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
ylabel(PulsOxLbls(2,:),'FontName',Texfont,'FontSize',12)
% ylabel('Amplitude Variable #3','FontName',Texfont,'FontSize',12)
axis([0  max(PlsOxTm)/1    YScl(2,:)])
grid

subplot(5,1,3)
plot(PlsOxTm,PulsOxPlot(:,3),'-g')
set(gca,'FontName',Grafont,'FontSize',8)
% axis([0  max(PlsOxTm)    0  250])
ylabel(PulsOxLbls(3,:),'FontName',Texfont,'FontSize',12)
% ylabel('Amplitude Variable #2','FontName',Texfont,'FontSize',12)
axis([0  max(PlsOxTm)/1    YScl(3,:)])
grid

subplot(5,1,4)
plot(PlsOxTm,PulsOxPlot(:,4),'Color',Color4)
set(gca,'FontName',Grafont,'FontSize',8)
% axis([0  max(PlsOxTm)    0  250])
% xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
ylabel(PulsOxLbls(4,:),'FontName',Texfont,'FontSize',12)
% ylabel('Amplitude Variable #3','FontName',Texfont,'FontSize',12)
axis([0  max(PlsOxTm)/1    YScl(4,:)])
grid

subplot(5,1,5)
plot(PlsOxTm,PulsOxPlot(:,5),'Color',Color5)
set(gca,'FontName',Grafont,'FontSize',8)
% axis([0  max(PlsOxTm)    0  250])
xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
ylabel(PulsOxLbls(5,:),'FontName',Texfont,'FontSize',12)
% ylabel('Amplitude Variable #3','FontName',Texfont,'FontSize',12)
text(-max(PlsOxTm)/10,(YScl(5,1)-0.5*diff(YScl(5,:))),sprintf('%04d/%02d/%02d-%02d:%02d:%07.4f',TagClock),'FontName',Grafont,'FontSize',9)
axis([0  max(PlsOxTm)/1    YScl(5,:)])
grid

orient landscape

% subplot(4,1,4)
% plot(PlsOxTm,PulsOxPlot(:,4),'Color',Color4)
% set(gca,'FontName',Grafont,'FontSize',8)
% % axis([0  max(PlsOxTm)    0  250])
% xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
% ylabel('Amplitude Variable #4','FontName',Texfont,'FontSize',12)
% axis([0  max(PlsOxTm)/50    0  255])
% grid



cntrs = [0:1:255];
for k1 = 1:PulsOxAryCols
    kount(:,k1) = histc(PulsOxPlot(:,k1),cntrs);
end

figure(171)
stairs(cntrs,100*kount(:,1)./size(PulsOxPlot(:,1),1),'-b')
hold on
stairs(cntrs,100*kount(:,2)./size(PulsOxPlot(:,2),1),'-r')
stairs(cntrs,100*kount(:,3)./size(PulsOxPlot(:,3),1),'-g')
stairs(cntrs,100*kount(:,4)./size(PulsOxPlot(:,4),1),'Color',Color4)
stairs(cntrs,100*kount(:,5)./size(PulsOxPlot(:,5),1),'Color',Color5)
hold off
set(gca,'FontName',Grafont,'FontSize',8)
legend(LgndStr,1)
title('Histogram of Byte Value Data From Pulse-Oximeter','FontName',Texfont,'FontSize',14)
xlabel('Byte Value  (Unsigned)','FontName',Texfont,'FontSize',12)
ylabel('Frequency  (%)','FontName',Texfont,'FontSize',12)
axis([0  255    0  100*max(max(kount,[],1))/size(PulsOxPlot,1)])
grid

orient landscape

for k1 = 1:PulsOxAryCols
    PulsOxFFT(:,k1) = fft(PulsOxPlot(:,k1));
    PulsOxVctLen = floor(size(PulsOxFFT(:,k1),1)/2);
    PulsOxMgn(:,k1) = abs(PulsOxFFT(1:PulsOxVctLen,k1));
    PulsOxAng(:,k1) = angle(PulsOxFFT(1:PulsOxVctLen,k1));
    PulsOxFrq(:,k1) = [0:PulsOxVctLen-1]*F0;  
end

figure(172)
subplot(2,1,1)
semilogy(PulsOxFrq(:,1),PulsOxMgn(:,1),'-b')
hold on
semilogy(PulsOxFrq(:,2),PulsOxMgn(:,2),'-r')
semilogy(PulsOxFrq(:,3),PulsOxMgn(:,3),'-g')
semilogy(PulsOxFrq(:,4),PulsOxMgn(:,4),'Color',Color4)
semilogy(PulsOxFrq(:,5),PulsOxMgn(:,5),'Color',Color5)
hold off
set(gca,'FontName',Grafont,'FontSize',8)
legend(LgndStr,1)
title('Freqeuency Spectrum of Pulse-Oximeter Byte Data','FontName',Texfont,'FontSize',14)
ylabel('Amplitude','FontName',Texfont,'FontSize',12)
axis([0  max(max(PulsOxFrq,[],1))    1  1E+005])
grid

subplot(2,1,2)
plot(PulsOxFrq(:,1),PulsOxAng(:,1),'-b')
hold on
plot(PulsOxFrq(:,2),PulsOxAng(:,2),'-r')
plot(PulsOxFrq(:,3),PulsOxAng(:,3),'-g')
semilogy(PulsOxFrq(:,4),PulsOxAng(:,4),'Color',Color4)
semilogy(PulsOxFrq(:,5),PulsOxAng(:,5),'Color',Color5)
set(gca,'FontName',Grafont,'FontSize',8)
xlabel('Frequency  (Hz)','FontName',Texfont,'FontSize',12)
ylabel('Phase  (Radians)','FontName',Texfont,'FontSize',12)
axis([0  max(max(PulsOxFrq,[],1))    -3.5  3.5])
grid

orient tall


FrqLimVct = [0  max(max(PulsOxFrq,[],1))];
FrqLimVct = FrqLimVct./3;

figure(173)
subplot(2,5,1)
semilogy(PulsOxFrq(:,1),PulsOxMgn(:,1),'-b')
set(gca,'FontName',Grafont,'FontSize',8)
% title('FFT of Pulse-Oximeter Plethysmogram Byte Data','FontName',Texfont,'FontSize',11)
ylabel([PulsOxLbls(1,:) ' Amplitude'],'FontName',Texfont,'FontSize',10)
axis([FrqLimVct    1  1E+005])
grid

subplot(2,5,6)
plot(PulsOxFrq(:,1),PulsOxAng(:,1),'-b')
set(gca,'FontName',Grafont,'FontSize',8)
xlabel('Frequency  (Hz)','FontName',Texfont,'FontSize',10)
ylabel('Phase  (Radians)','FontName',Texfont,'FontSize',10)
text(-2,(-1.75*pi),sprintf('%04d/%02d/%02d-%02d:%02d:%07.4f',TagClock),'FontName',Grafont,'FontSize',9)
axis([FrqLimVct    -3.5  3.5])
grid


subplot(2,5,2)
semilogy(PulsOxFrq(:,1),PulsOxMgn(:,2),'-r')
set(gca,'FontName',Grafont,'FontSize',8)
% title('FFT of Pulse-Oximeter S_{A O_2} Byte Data','FontName',Texfont,'FontSize',11)
ylabel([PulsOxLbls(2,:) ' Amplitude'],'FontName',Texfont,'FontSize',9)
axis([FrqLimVct    1  1E+005])
grid

subplot(2,5,7)
plot(PulsOxFrq(:,1),PulsOxAng(:,2),'-r')
set(gca,'FontName',Grafont,'FontSize',8)
xlabel('Frequency  (Hz)','FontName',Texfont,'FontSize',9)
ylabel('Phase  (Radians)','FontName',Texfont,'FontSize',9)
axis([FrqLimVct    -3.5  3.5])
grid

PageTitle = sprintf('\\fontsize{14}FFT of Pulse Oximeter Data Components\\rm\\fontsize{9}');

subplot(2,5,3)
semilogy(PulsOxFrq(:,1),PulsOxMgn(:,3),'-g')
set(gca,'FontName',Grafont,'FontSize',8)
title(PageTitle,'FontName',Texfont)
% title('FFT of Pulse-Oximeter #3 Byte Data','FontName',Texfont,'FontSize',11)
ylabel([PulsOxLbls(3,:) ' Amplitude'],'FontName',Texfont,'FontSize',9)
axis([FrqLimVct    1  1E+005])
grid

subplot(2,5,8)
plot(PulsOxFrq(:,1),PulsOxAng(:,3),'-g')
set(gca,'FontName',Grafont,'FontSize',8)
xlabel('Frequency  (Hz)','FontName',Texfont,'FontSize',10)
ylabel('Phase  (Radians)','FontName',Texfont,'FontSize',10)
axis([FrqLimVct    -3.5  3.5])
grid


subplot(2,5,4)
semilogy(PulsOxFrq(:,1),PulsOxMgn(:,4),'Color',Color4)
set(gca,'FontName',Grafont,'FontSize',8)
% title('FFT of Pulse-Oximeter #4 Byte Data','FontName',Texfont,'FontSize',11)
ylabel([PulsOxLbls(4,:) ' Amplitude'],'FontName',Texfont,'FontSize',9)
axis([FrqLimVct    10  1E+005])
grid

subplot(2,5,9)
plot(PulsOxFrq(:,1),PulsOxAng(:,4),'Color',Color4)
set(gca,'FontName',Grafont,'FontSize',8)
xlabel('Frequency  (Hz)','FontName',Texfont,'FontSize',9)
ylabel('Phase  (Radians)','FontName',Texfont,'FontSize',9)
axis([FrqLimVct    -3.5  3.5])
grid


subplot(2,5,5)
semilogy(PulsOxFrq(:,1),PulsOxMgn(:,5),'Color',Color5)
set(gca,'FontName',Grafont,'FontSize',8)
% title('FFT of Pulse-Oximeter #5 Byte Data','FontName',Texfont,'FontSize',11)
ylabel([PulsOxLbls(5,:) ' Amplitude'],'FontName',Texfont,'FontSize',9)
axis([FrqLimVct    1  1E+005])
grid

subplot(2,5,10)
plot(PulsOxFrq(:,1),PulsOxAng(:,5),'Color',Color5)
set(gca,'FontName',Grafont,'FontSize',8)
xlabel('Frequency  (Hz)','FontName',Texfont,'FontSize',9)
ylabel('Phase  (Radians)','FontName',Texfont,'FontSize',9)
axis([FrqLimVct    -3.5  3.5])
grid

orient landscape



% FIND DICROTIC NOTCH
%   NOTE: "PulsOxPlot" is already rotated!  
%           See: Line 210 PulsOxPlot = PulsOxAry(:,RotnVct);   % DEFINE DATA TO
%               BE PLOTTED

% GENERATE FILTER FOR "DDtPulsOxPlot"

% Design & Implement Butterworth Filter With Cutoff Frequency = Fs
%   H(s) = G/(1 + (2*pi*f/Fs)^2n) for n-th order filter 
Gb = 1;                     % Gain at f = 0

Hbs2 = Gb

DDtPulsOxPlot(:,1) = [0; diff(PulsOxPlot(:,1))];



D2DtPulsOxPlot(:,1) = [0; diff(DDtPulsOxPlot(:,1))];
VctZroDt = [0; DDtPulsOxPlot(1:end-1,1) .* DDtPulsOxPlot(2:end,1)];
VctZroDt2 = [0; DDtPulsOxPlot(1:2:end-1,1) .* DDtPulsOxPlot(2:2:end,1)];
VctZroD2t = [0; D2DtPulsOxPlot(1:end-1,1) .* D2DtPulsOxPlot(2:end,1)];
InflPts0 = find( (VctZroDt == 0) );
InflPts1 = find( (VctZroDt < 0) );
InflPts3 = find( (VctZroDt > 0) );
InflPts12 = find( (VctZroDt2 < 0) );
InflPts4 = find((D2DtPulsOxPlot > 0) & (DDtPulsOxPlot == 0));   % Minima
InflPts5 = find((D2DtPulsOxPlot < 0) & (DDtPulsOxPlot == 0));   % Maxima
InflPts = InflPts0;
% InflPts2 = 
InflPts2 = find( (VctZroD2t > 0) );
InflPtTm = PlsOxTm(InflPts);
InflPtTm2 = PlsOxTm(InflPts2);
DDtInflPtTm = diff(InflPtTm);
% DDtInflPtTm2 = diff(InflPtTm2);
% LclMinIdx0 = intersect(InflPts,InflPts2);

figure(899)
% plot(PlsOxTm,DDtPulsOxPlot(:,1),'-b', PlsOxTm,D2DtPulsOxPlot(:,1),'-r')
plot(PlsOxTm,PulsOxPlot(:,1),'-k',  PlsOxTm(InflPts4),PulsOxPlot(InflPts4,1),'vr',  PlsOxTm(InflPts5),PulsOxPlot(InflPts5,1),'^b')
set(gca,'FontName',Grafont,'FontSize',8)
legend('Phingertip Photoplethysmogram','Local Minima','Local Maxima',1)
axis([min(PlsOxTm)  max(PlsOxTm)    LimAx(PulsOxPlot(:,1),1)'])
grid

orient landscape


cntrs2 = [0:min(DDtInflPtTm):max(DDtInflPtTm)];
kount2 = histc(DDtInflPtTm,cntrs2);

% PulsOxStsRot = PulsOxSts(:,RotnVct);
% PulsOxMaxRot = PulsOxMax(RotnVct);
% PulsOxMinRot = PulsOxMin(RotnVct);
PulsIndrIdx0 = find(PulsOxPlot(:,5) >= 0.80*PulsOxMaxRot(5)); 
PulsIndrIdx  = PulsIndrIdx0(1:2:end);
PlsDifVct = diff([0;  PulsIndrIdx]);
PlsDifSts = [mean(PlsDifVct);  std(PlsDifVct);  mean(PlsDifVct)-ZCILmPr*std(PlsDifVct);  mean(PlsDifVct)+ZCILmPr*std(PlsDifVct)];
% InflPtMtx = zeros(size(PulsIndrIdx,1)-1,300);

for k1 = 1:size(PulsIndrIdx,1)-1
    % FIRST, INTERPOLATE TO ADD DETAIL
    RngVct = PulsIndrIdx(k1):PulsIndrIdx(k1+1);
    IntrpRng(k1,:) = [PlsOxTm(PulsIndrIdx(k1))  PlsOxTm(PulsIndrIdx(k1+1))];
    IntrpVct = linspace(IntrpRng(k1,1),IntrpRng(k1,2),round(PlsDifSts(1)*5));
%     PlsWvIntrp(k1,:) = interp1(PlsOxTm(RngVct),PulsOxPlot(RngVct,1),IntrpVct,'spline'); 
    % SECOND, CALCULATE DERIVATIVES FROM THE PIECEWISE POLYMOMIAL
%     PlsWvPwPly = interp1(PlsOxTm(RngVct),PulsOxPlot(RngVct,1),'spline','pp');
%     [Brk,Coef,Lp,Ordk,TgtDm] = unmkpp(PlsWvPwPly);
    Coef(k1,:) = polyfit(PlsOxTm(RngVct),PulsOxPlot(RngVct,1)',3);
    Dt1Coef(k1,:) = polyder(Coef(k1,:));
    Dt2Coef(k1,:) = polyder(Dt1Coef(k1,:));
    InflPtVct = roots(Dt1Coef(k1,:));
    InflPtChr = polyval(Dt2Coef(k1,:),InflPtVct);
    InflPtMin(k1,:) = InflPtVct(find( (InflPtChr > 0) & (InflPtVct > 0), 1, 'first'));
    InflPtMag(k1,:) = PulsOxPlot(find(PlsOxTm <= InflPtMin(k1,:), 1, 'last'),1);
    
%     for k2 = 1:size(Coef,1)
%         D1tCoef(k2,:) = polyder(Coef(k2,:));
%         D2tCoef(k2,:) = polyder(D1tCoef(k2,:));
%         InflPtVct = roots(D1tCoef(k2,:));
%         if isreal(InflPtVct)
%             InflPtMtx(k2,:) = InflPtVct;
%         else
%             InflPtMtx(k2,:) = NaN(size(InflPtVct));
%         end
%     end
%         D2tPwPly = mkpp(Brk,D2tCoef,TgtDm);
%         InflPtD2Val = ppval(D2tPwPly,InflPtMtx);
%         InflPtChr(k1,:,:) = InflPtD2Val;

    % THIRD, SOLVE DERIVATIVES FOR ZEROS
%     InflPtVct(k1,:) = roots(D1tCoef(k1,:));
%     InflPtChr(k1,:) = polyval(D1tCoef(k1,:),InflPtVct(k1,:));
%     DtPWI(k1,:) = diff([0  PlsWvIntrp(k1,:)]);
%     InflPtIdx = find(ZroX(DtPWI(k1,:)) < 0);
%     InflPtMtx(k1,1:size(InflPtIdx,2)) = InflPtIdx;
%     InflPtPlot(k1,1:size(InflPtIdx,2)) = PlsWvIntrp(k1,InflPtIdx);
%     InflPtTm(k1,1:size(InflPtIdx,2)) = IntrpVct(InflPtIdx);
end

% Coef
% D1tCoef
% D2tCoef
% InflPtMtx
InflPtMin

% break

figure(900)
plot(PlsOxTm,PulsOxPlot(:,1),'-b')
hold on
% plot(InflPtTm,InflPtPlot,'+r') 
plot(InflPtMin,InflPtMag,'*g')
hold off
set(gca,'FontName', Grafont, 'FontSize',9)
legend('Photoplethysmogram','Inflection Points',1)
xlabel('Time  (sec)','FontName', Texfont, 'FontSize',11)
ylabel('Photoplethysmogram Amplitude','FontName', Texfont, 'FontSize',11)
axis([min(PlsOxTm)  max(PlsOxTm)    LimAx(PulsOxPlot(:,1),1)'])
grid
orient landscape

InflPtOfst = [];
for k1 = 1:size(PulsIndrIdx,1)-1
    InflPtNxt = find( InflPts > PulsIndrIdx(k1), 1, 'first');
    IdxRngNxt = PulsIndrIdx(k1):PulsIndrIdx(k1+1);
    LclMinNxt = PulsIndrIdx(k1) + find(PulsOxPlot(IdxRngNxt,1) <= min(PulsOxPlot(IdxRngNxt,1)), 1, 'first');
%     PulsIndrNxt = find(PulsIndrIdx > InflPtNxt, 1, 'first');
%     InflPtIdxRng = [InflPtNxt:PulsIndrIdx(PulsIndrNxt+1)];
%     LclMinNxt = find( PulsOxPlot(InflPtIdxRng,1) <= min(PulsOxPlot(InflPtIdxRng,1)), 1, 'first');
%     LclMin = InflPtNxt + LclMinNxt;
    if ~isempty(InflPtNxt)
        DcrtNchIdxAbs(k1) = InflPts(InflPtNxt);
        DcrtNchTmAbs(k1) = PlsOxTm(DcrtNchIdxAbs(k1));
    else
        break
    end
    if ~isempty(LclMinNxt)
        LclMinIdxAbs(k1) = LclMinNxt;
        LclMinTmAbs(k1) = PlsOxTm(LclMinIdxAbs(k1));
    else
        break
    end
%     DcrtNchIxAbs(k1) = find(PlsOxTm == DcrtNchTm(DcrtNchIdx(k1)));
%     DcrtNchTmAbs(k1) = PlsOxTm(DcrtNchIxAbs(k1));
%     LclMinIxAbs(k1) = find(PlsOxTm == DcrtNchTm2(LclMinIdx(k1)));
%     LclMinTmAbs(k1) = PlsOxTm(LclMinIxAbs(k1));
%     DcrtNchAbs(k1) = PlsOxTm(PulsIndrIdx(k1) + DcrtNchOfst(k1));
end

Fig174_10 = [PlsOxTm(PulsIndrIdx(1:end-1))'  DcrtNchTmAbs'  LclMinTmAbs'  PulsOxPlot(DcrtNchIdxAbs,:)]
Fig174_11 = diff(Fig174_10(:,1:3),[],1);
IntrpulsIntvls = Fig174_11;
Fig174Sts = [mean(Fig174_11,1);  std(Fig174_11,[],1)]
Fig174_12 = diff([zeros(size(Fig174_10(:,1))) Fig174_10(:,1:3)],[],2);
PlsIndIx = PulsIndrIdx(find(PulsIndrIdx-2 > 0));

figure(174)
subplot(2,1,1)
plot(PlsOxTm,PulsOxPlot(:,1),'-b')
hold on
plot(PlsOxTm(PlsIndIx),PulsOxPlot(PlsIndIx,1),'Color',[1.0  0.5  0.0],'LineStyle','p','LineWidth',2)
plot(DcrtNchTmAbs,PulsOxPlot(DcrtNchIdxAbs,1),'+r')
plot(LclMinTmAbs,PulsOxPlot(LclMinIdxAbs,1),'Color',[1.0  0.5  0.0],'LineStyle','d','LineWidth',2)
hold off
set(gca,'FontName',Grafont,'FontSize',8)
legend('Plethysmogram','Systole','Dicrotic Notch','Diastole',1)
% axis([0  max(PlsOxTm)    0  250])
% ylabel('Amplitude Variable #1','FontName',Texfont,'FontSize',12)
title('Pulse Oximeter Channel Signals','FontName',Texfont,'FontSize',16)
ylabel(PulsOxLbls(1,:),'FontName',Texfont,'FontSize',12)
axis([0  max(PlsOxTm)/1    YScl(1,:)])
grid

subplot(2,1,2)
plot(PlsOxTm,DDtPulsOxPlot(:,1),'-g')
hold on
plot(PlsOxTm(PlsIndIx),DDtPulsOxPlot(PlsIndIx,1),'Color',[1.0  0.5  0.0],'LineStyle','p','LineWidth',2)
plot(DcrtNchTmAbs,DDtPulsOxPlot(DcrtNchIdxAbs,1),'+r')
plot(LclMinTmAbs,DDtPulsOxPlot(LclMinIdxAbs,1),'Color',[1.0  0.5  0.0],'LineStyle','d','LineWidth',2)
hold off
set(gca,'FontName',Grafont,'FontSize',8)
% axis([0  max(PlsOxTm)    0  250])
% xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
% ylabel(PulsOxLbls(2,:),'FontName',Texfont,'FontSize',12)
ylabel([sprintf('^{\\partial %s(\\itt\\rm)}/_{\\partial\\itt\\rm} ', PulsOxLbls(1,:))],'FontName',Texfont,'FontSize',12)
% ylabel('Amplitude Variable #3','FontName',Texfont,'FontSize',12)
text(-max(PlsOxTm)/10, min(DDtPulsOxPlot(:,1))-rng(DDtPulsOxPlot(:,1),1)/5, sprintf('%04d/%02d/%02d-%02d:%02d:%06.3f',TagClock),'FontName',Grafont,'FontSize',9)
axis([0  max(PlsOxTm)/1    min(DDtPulsOxPlot(:,1))  max(DDtPulsOxPlot(:,1))])
grid

% subplot(5,1,3)
% plot(PlsOxTm,VctZroDt,'-g')
% % plot(DcrtNchTmAbs,ones(size(DcrtNchTmAbs)),'k')
% set(gca,'FontName',Grafont,'FontSize',8)
% % axis([0  max(PlsOxTm)    0  250])
% % xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
% ylabel(PulsOxLbls(2,:),'FontName',Texfont,'FontSize',12)
% % ylabel('Amplitude Variable #3','FontName',Texfont,'FontSize',12)
% axis([0  max(PlsOxTm)/1    min(VctZroDt)  max(VctZroDt)])
% grid
% 
% subplot(5,1,4)
% stairs(cntrs2,kount2,'Color',Color4)
% % plot(PlsOxTmAbs,DDtPulsOxPlot(:,RotnVct(1)),'-r')
% set(gca,'FontName',Grafont,'FontSize',8)
% % axis([0  max(PlsOxTm)    0  250])
% % xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
% % ylabel(PulsOxLbls(2,:),'FontName',Texfont,'FontSize',12)
% % ylabel('Amplitude Variable #3','FontName',Texfont,'FontSize',12)
% axis([cntrs2(2)*1.5  max(cntrs2)/1    0  max(kount2(3:end))*1.25])
% grid
% 
% subplot(5,1,5)
% plot(PlsOxTm,VctZroDt,'-g')
% % plot(DcrtNchTmAbs,ones(size(DcrtNchTmAbs)),'k')
% set(gca,'FontName',Grafont,'FontSize',8)
% % axis([0  max(PlsOxTmAbs)    0  250])
% % xlabel('Time  (sec)','FontName',Texfont,'FontSize',12)
% ylabel(PulsOxLbls(2,:),'FontName',Texfont,'FontSize',12)
% % ylabel('Amplitude Variable #3','FontName',Texfont,'FontSize',12)
% axis([0  max(PlsOxTmAbs)/1    min(VctZroDt)  max(VctZroDt)])
% grid

orient landscape

% PEAKS DETERMINED MANUALLY FROM AN EARLIER RUN OF FIGURE 175 (X Hz, Y dB, INDEX)
PeaksFig175 = [ 8.96013E-002,  6.14058E+001, 10;   2.58848E-001,  8.05060E+001, 27;   4.08184E-001,  5.38363E+001, 42;   5.27652E-001,  7.19570E+001, 54;   5.67475E-001,  5.58817E+001, 58;   7.56633E-001,  6.26209E+001, 77];
Prds175 = 1./PeaksFig175(:,1);      % Periods in Seconds
FrqPrMin = PeaksFig175(:,1)*60;

Frq3HzIx = find(PulsOxFrq(:,1) <= 3.00, 1, 'last');
Frq3HzRg = 1:Frq3HzIx;
SymFrqIdx = [fliplr(Frq3HzRg(2:end)) Frq3HzRg(2:end)];
[Prms175,S175,Mu175] = polyfit(PulsOxFrq(SymFrqIdx,1), dB(PulsOxMgn(SymFrqIdx,1)), 53);
[Fit175,Delta175] = polyval(Prms175,PulsOxFrq(SymFrqIdx,1),S175,Mu175);
% [Prms175] = polyfit(PulsOxFrq(SymFrqIdx,1), dB(PulsOxMgn(SymFrqIdx,1)), 45);
% [Fit175] = polyval(Prms175,PulsOxFrq(SymFrqIdx,1));
D1f175 = diff(Fit175);
D2f175 = diff(D1f175);

ZroGen1 = ZroX(D1f175);
ZroDct1 = find(ZroGen1 < 0);
MnMx175 = find(D2f175(ZroDct1) < 0);
MnMxIx = SymFrqIdx(ZroDct1(MnMx175));
MnMxIdx = MnMxIx(fix(size(MnMxIx,2)/2):end)+1;
MnMxFrq175 = PulsOxFrq(MnMxIdx,1);
[Peaks175,DPks175] = polyval(Prms175,MnMxFrq175,S175,Mu175);

FreqPridMtx = [MnMxFrq175  MnMxFrq175.*60  1./MnMxFrq175]

Frq2HzIx = find(PulsOxFrq(:,1) <= 2.00, 1, 'last');
Frq2HzRg = 1:Frq2HzIx;

figure(175)
subplot(2,1,1)
plot(PulsOxFrq(:,1),dB(PulsOxMgn(:,1)),'-b')
hold on
plot(PulsOxFrq(SymFrqIdx,1),Fit175,'-r')
plot(PulsOxFrq(MnMxIdx,1),Peaks175,'+g')
% plot(MxFrqs,Fit175(MxFrqsIdx),'+r')
hold off
set(gca,'FontName',Grafont,'FontSize',8)
title('Pulse-Oximeter Plethysmogram Spectrum','FontName',Texfont,'FontSize',11)
ylabel([PulsOxLbls(1,:) ' Amplitude  (dB)'],'FontName',Texfont,'FontSize',10)
axis([0  2.50    LimAx(dB(PulsOxMgn(:,1)),1)'])
grid

subplot(2,1,2)
plot(PulsOxFrq(:,1),PulsOxAng(:,1),'-b')
set(gca,'FontName',Grafont,'FontSize',8)
xlabel('Frequency  (Hz)','FontName',Texfont,'FontSize',10)
ylabel('Phase  (Radians)','FontName',Texfont,'FontSize',10)
text(-2,(-1.75*pi),sprintf('%04d/%02d/%02d-%02d:%02d:%07.4f',TagClock),'FontName',Grafont,'FontSize',9)
axis([0  2.50    -3.5  3.5])
grid

orient landscape

fprintf(1,'\n\n\t\t\t\t\t\t\t\t\t\t—— LINE %d ——\n\n', 1141);

fprintf(1,'\n\tClean up and exit ...\n')
delete(s1)
fprintf(1,'\n\t\t\t\t... %s deleted successfully, ...\n','s1');
clear s1
fprintf(1,'\n\n\t\t\t\t\t\t... %s cleared successfully.\n','s1');

fprintf(1,'\n\t\t\t\tThink about using "timeseries" in a separate (but otherwise duplicate) M-File.\n\t\t\t\t(Don''t do it here and risk screwing everything up!)\n');

fprintf(1,'\n\n\tYIPPEE!  %s ran successfully!\n\n\n\n',myname)



% ====================  END  PulseOx_01.m  ====================