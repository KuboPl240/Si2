

% Načítanie hlasu pre testovanie
[x, Fs] = audioread('caj.wav');
disp(strcat('Slovo= ', detekuj_slovo(x, Fs)));

[x, Fs] = audioread('med.wav');
disp(strcat('Slovo= ', detekuj_slovo(x, Fs)));

[x, Fs] = audioread('rum.wav');
disp(strcat('Slovo= ', detekuj_slovo(x, Fs)));

% Vykreslenie grafov
figure;
for i = 1:2:5
    Slovo = "";
    switch i
        case 1
            Slovo = "caj";
            [x, Fs] = audioread('caj.wav'); 
        case 3
            Slovo = "med"; 
            [x, Fs] = audioread('med.wav'); 
        case 5
            Slovo = "rum"; 
            [x, Fs] = audioread('rum.wav'); 
    end
    t = (0:length(x)-1) / Fs; % Vytvorenie časovej osi
    subplot(3,2,i)
    plot(t, x); % Zobrazenie signálu
    xlabel('Čas (s)');
    ylabel('Amplitúda');
    title(Slovo);

   
    dlzka = 0.01; % Dĺžka okna
    [energia, dlzka_okna, pocet_okien] = energia_signalu(x, dlzka, Fs);

    cas = (0:pocet_okien-1) * dlzka; % Časová os pre energiu
    subplot(3,2,i+1)
    plot(cas, energia); % Zobrazenie energie
    xlabel('Čas (s)');
    ylabel('Krátkodobá energia');
    title('Priebeh krátkodobej energie signálu');
end

% Funkcia na detekciu samohlásky v signáli
function samohlaska = detekuj_samohlasku(signal, Fs)
    spektrum = fft(signal); % Výpočet spektra
    spektrum = abs(spektrum);
    spektrum = log(1 + spektrum);

    f = linspace(0, Fs/2, floor(length(spektrum)/2));
    X = spektrum(1:floor(length(spektrum)/2));

    % Výpočet energie v rôznych frekvenčných pásmach
    A_energie = sum(spektrum(f >= 650 & f <= 800)) + sum(spektrum(f >= 1100 & f <= 1450));
    E_energie = sum(spektrum(f >= 800 & f <= 1100)) + sum(spektrum(f >= 1450 & f <= 1700)); 
    U_energie = sum(spektrum(f >= 250 & f <= 350)) + sum(spektrum(f >= 350 & f <= 550));

    % Detekcia samohlásky na základe energie
    if ((A_energie > E_energie) & (A_energie > U_energie))
        samohlaska = 'A';
    elseif ((E_energie > A_energie) & (E_energie > U_energie))
        samohlaska = 'E';
    elseif ((U_energie > E_energie) & (U_energie > A_energie))
        samohlaska = 'U';
    end
end

% Funkcia na výpočet energie signálu
function [energia, dlzka_okna, pocet_okien] = energia_signalu(signal, dlzka, Fs)
    dlzka_okna = round(dlzka * Fs); % Dĺžka okna v počtoch vzoriek
    pocet_okien = floor(length(signal) / dlzka_okna); % Počet okien
    energia = zeros(1, pocet_okien); 
    for j = 1:pocet_okien
        okno = signal((j-1)*dlzka_okna + 1 : j*dlzka_okna); % Výber okna
        energia(j) = sum(okno .^ 2); % Výpočet energie okna
    end
end

% Funkcia na detekciu slova na základe signálu
function Slovo = detekuj_slovo(signal, Fs)
    [energia, dlzka_okna, pocet_okien] = energia_signalu(signal, 0.01, Fs); % Výpočet energie
    [maximum, index] = max(energia); % Nájdenie maxima energie
    zaciatok = find(energia > (maximum / 2.3)); % Nájdenie začiatku slova
    zaciatok = zaciatok(1) * dlzka_okna;
    samohlaska = signal(zaciatok:(zaciatok + floor(0.03 * Fs))); % Výber časti signálu obsahujúcej samohlásku
    switch detekuj_samohlasku(samohlaska, Fs) % Detekcia samohlásky
        case 'A'
            Slovo = "caj"; 
        case 'E'
            Slovo = "med"; 
        case 'U'
            Slovo = "rum"; 
        otherwise
            Slovo = "-"; 
    end
end