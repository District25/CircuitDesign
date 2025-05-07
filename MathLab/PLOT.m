%visaresource = 'USB0::2733::470::203458::0::INSTR';   %define visa resource name

if(~exist('vsdev'))
    if(~exist('visaresource')||~any(visaresource))
        visadevlist
        return
    else
        vsdev = visadev(visaresource);
    end

end

ch1 = 0;
ch2 = 0;
ch3 = 0;
ch4 = 0;

Navg = 4;

for k=1:Navg
    k
    [ch1tmp, time] = RSscopeReadData(vsdev,1);
    ch1=ch1+ch1tmp;
    %ch2 = ch2+RSscopeReadData(vsdev,2);
    %ch3 = ch3+RSscopeReadData(vsdev,3);
    %ch4 = ch4+RSscopeReadData(vsdev,4);
    pause(0.1);
end
ch1 = ch1/Navg;
% ch2 = ch2/Navg;
% ch3 = ch3/Navg;
% ch4 = ch4/Navg;


plot(time,ch1)
