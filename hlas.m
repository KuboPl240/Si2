[x, Fs]=audioread("77.wav");
x = x(:,1);
len = (length(x)-1)/Fs;

segment = 3.14;
segment_length = 0.03;



figure
t_start = segment*Fs;
t_stop = floor((segment+segment_length)*Fs);
time = 0:(1/Fs):len;
plot(time(1:t_start),x(1:t_start),"blue");
hold on
plot(time(t_start:t_stop), x(t_start:t_stop),"red");
hold on
plot(time(t_stop:end), x(t_stop:end),"blue");
xlabel('Cas (s)');
ylabel('Amplitúda');
hold off





% subplot(2,1,2)
% spektrum = fft(x(t_start:t_stop));
% spektrum = abs(spektrum);
% spektrum = log(1 + spektrum);
% spektrum = spektrum(1:floor(length(spektrum)/2))
% f = linspace(0, Fs/2, floor(length(spektrum)));
% stem(f,spektrum);
% ylabel('Amplitúda');


disp(strcat('samohlaska= ',detekuj_samohlasku(x(t_start:t_stop), Fs)))

function samohlaska = detekuj_samohlasku(signal, Fs)
    spektrum = fft(signal);
    spektrum = abs(spektrum);
    spektrum = log(1 + spektrum);

    f = linspace(0, Fs/2, floor(length(spektrum)/2));
    X = spektrum(1:floor(length(spektrum)/2));

    A_energie = trapz(f(f >= 650 & f <= 800), X(f >= 650 & f <= 800)) + ...
                trapz(f(f >= 1100 & f <= 1250), X(f >= 1100 & f <= 1250));

    E_energie = trapz(f(f >= 450 & f <= 600), X(f >= 450 & f <= 600)) + ...
                trapz(f(f >= 1300 & f <= 1700), X(f >= 1300 & f <= 1700)); 

    U_energie = trapz(f(f >= 250 & f <= 350), X(f >= 250 & f <= 350)) + ...
                trapz(f(f >= 550 & f <= 700), X(f >= 550 & f <= 700));


    if ((30>A_energie) & (30>E_energie) & (30>U_energie)) 
        samohlaska = '-';
    elseif ((A_energie>E_energie) & (A_energie>U_energie))
        samohlaska = 'A';
    elseif ((E_energie>A_energie) & (E_energie>U_energie))
        samohlaska = 'E';
    elseif ((U_energie>E_energie) & (U_energie>A_energie))
        samohlaska = 'U';
    end
end




