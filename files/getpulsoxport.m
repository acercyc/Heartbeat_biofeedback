function PortIn = getpulsoxport()

                            % fprintf(s1,'\\\\\\\\.\\\\%s\n', PortIn);    
                            % Silicon Laboratories CP210x "Open" Command
                            %   See: Silicon Laboratories AN197 for
                            %        full documentation
                            % NOTE: String sent to instrument
                            %       should be "\\\\.\\COMx"

% GET RELEVANT REGISTRY CONTENTS —
%   Get Registry contents with DOS call.  
%   (Do 'REG QUERY /?' for details of this DOS command)
[regreplystatus, regreplyresult] = dos('REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB\ /t REG_SZ /s /z')

% DEFINE TARGET STRINGS —
%   It will be necessary to look though the registry to find the VID_ &
%   PID_ hex values if they're not already available.  Start by looking
%   through "regreplyresult" for the necessary key combination.  Read them
%   as strings.  MATLAB won't care.  
hklm_usb_str = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB\';
hklm_usb_full_str = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB\VID_10C4&PID_EA60\0001\Device Parameters';

% GET STRING LOCATIONS WITHIN "regreplyresult" —
len_hklm_usb_str = length(hklm_usb_full_str);                                       % Define offset for subsequent read
[hklm_usb_full_idx] = strfind(regreplyresult, hklm_usb_full_str);                   % Find specific string with VID_ & PID_
[hklm_usb_idx] = strfind(regreplyresult, hklm_usb_str);                             % Find all occurrences of HKLM USB entries
next_key_idx = hklm_usb_idx(find(hklm_usb_idx > hklm_usb_full_idx, 1, 'first'));    % Define end of search

% GET CELL ARRAY OF REGISTRY DATA OVER DEFINED RANGE —
[vrbl, type, nr, value] = strread(regreplyresult(hklm_usb_full_idx+len_hklm_usb_str : next_key_idx-1), '%s %s %s %s', 'delimiter',' ') 

% DETERMINE WHERE "PortName" IS —
portnameidx = strmatch('PortName', vrbl);
getport = value(portnameidx);
PortIn = char(getport);

return
% ========================  END:  getpulsoxport.m  ========================