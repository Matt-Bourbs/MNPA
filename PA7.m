function[] = PA7()

G = zeros(8,8);
C = zeros(8,8);
F = zeros(8,1);
R1 = 1; 
R2 = 2;
R3 = 10;
R4 = 0.1;
R0 = 1000;
c = 0.25;
L = 0.2;
a = 100;

% create G matrix
G(1, 1) = 1/R1;
G(1, 2) = -1/R1;
G(2, 1) = -1/R1;
G(2, 2) = 1/R1+1/R2;
G(3, 3) = 1/R3;
G(4, 4) = 1/R4; 
G(4, 5) = -1/R4;
G(5, 4) = 1/R4;
G(5, 5) = 1/R4+1/R0;
G(6, 1) = 1;
G(7, 2) = 1;
G(7, 3) = -1;
G(8, 3) = -a/R3;
G(8, 4) = 1;
G(1, 6) = 1;
G(2, 7) = 1;
G(3, 7) = -1;
G(4, 8) = 1;

% create C matrix
C(1,1) = c;
C(1,2) = -c;
C(2,2) = c;
C(2,1) = -c;
C(7,7) = -L;

% solve F matrix
Vin = linspace(-10,10,100);
V0 = zeros(length(Vin),1);
V3 = zeros(length(Vin),1);
for i = 1: length(Vin)
    F(6) = Vin(i);
    V = G\F;
    V3(i) = V(3);
    V0(i) = V(5);
end 

figure(1)
plot(Vin, V0)
title('DC Sweep Plot of V0');
xlabel('Vin (V)')
ylabel('V0 (V)')

figure(2)
plot(Vin, V3)
title('DC Sweep Plot of V3');
xlabel('Vin (V)')
ylabel('V3 (V)')

w = 2*pi*linspace(0,80,1000);
V0 = zeros(length(w),1);
gain = zeros(length(w),1);
for i = 1: length(w)
    S = 1i*w(i);
    V = inv((G+S.*C))*F;
    V0(i) = abs(V(5));
    gain(i) = 20*log10(abs(V0(i))/abs(V(1)));
end 

figure(3)
plot(w,V0);
xlabel('Angular Frequency (rad/s)')
ylabel('V0 (V)')
title('AC Plot of V0')

figure(4)
semilogx(w, gain);
xlabel('Angular Frequency (rad/s)')
ylabel('Gain (dB)')
title('AC Plot of the Gain');

V0 = zeros(length(w),1);
gain = zeros(length(w),1);

for i = 1: length(V0)
    p = randn()*0.05;
    C(1, 1)= c*p;
    C(2, 2)= c*p;
    C(1, 2)= -c*p;
    C(2, 1)= -c*p;
    
    s = 2*pi;
    V = inv((G+S.*C))*F;
    V0(i) = abs(V(5));
    gain(i) = 20*log10(abs(V0(i))/abs(V(1)));
end

figure(5)
histogram(gain,100);
xlabel('Gain')
ylabel('Count')
title('Histogram of the Gain')