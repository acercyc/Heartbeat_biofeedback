
addpath(genpath('lib'))
para = parameters();

%%
if exist('s', 'var')
    fclose(s)
    delete(s)
    clear('s')
end
instrreset

%%
s = serial('COM3', 'BaudRate', 9600);

% s.BytesAvailableFcn = ;
% s.BytesAvailableFcnCount = para.read.nByteToReadFromBF;
% s.BytesAvailableFcnMode = 'byte';

UserData.t = [];
UserData.stream = [];
UserData.data = [];
UserData.tail = [];
UserData.tLast = [];

s.UserData = UserData;


%% raw read
t0 = GetSecs();
while 1
    d = fread(s, 75);
    fprintf('%f\n', GetSecs-t0);
end


%% use callback
nByte = 20;
s = serial('COM3', 'BaudRate', 9600);
s.BytesAvailableFcn = @test_dataRequest_CB;
s.BytesAvailableFcnCount = nByte;
s.BytesAvailableFcnMode = 'byte';
s.UserData.fs = nByte;

fopen(s);

%% heavy callback
nByte = 20;
s = serial('COM3', 'BaudRate', 9600);
s.BytesAvailableFcn = @GetDataFromBF2;
s.BytesAvailableFcnCount = nByte;
s.BytesAvailableFcnMode = 'byte';

UserData.t = [];
UserData.stream = [];
UserData.data = [];
UserData.tail = [];
UserData.tLast = [];
UserData.fs = [];

s.UserData = UserData;


fopen(s);
