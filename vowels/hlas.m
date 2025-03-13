[x, Fs]=audioread("recording.wav");
x = x(:,1);
segment = 16.7;
segment_length = 0.3;
time = 1:size(x);



figure;
t_start = segment*Fs;
t_stop = floor((segment+segment_length)*Fs);
subplot(2,1,1)
plot(time(1:t_start),x(1:t_start),"blue");
hold on
plot(time(t_start:t_stop), x(t_start:t_stop),"red");
hold on
plot(time(t_stop:end), x(t_stop:end),"blue");
hold off



Y = fft(x(t_start:t_stop));
L = 998;
f = Fs*(0:(L))/L;


subplot(2,1,2)
Y = abs(Y/(t_stop-t_start));
Y = log(1 + Y);
stem(Y(2:1000))
xlabel('Frekvencia (Hz)');
ylabel('Amplitúda');

plocha = trapz(Y(2:400))
plocha = trapz(Y(400:600))
plocha = trapz(Y(600:1000))





