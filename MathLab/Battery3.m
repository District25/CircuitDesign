%% Définition des tensions de référence
VDD = 3.7;     % Tension d'alimentation initiale (ex: régulateur ou microcontrôleur)
Vbat = 4.2;    % Tension maximale de la batterie (pleine charge)
Vbh = 3.6;     % Seuil haut de batterie (fin de décharge "acceptable")
Vbl = 3.25;    % Seuil bas de batterie (décharge critique)
Vref = 2.5;    % Tension de référence (référence ADC ou régulateur de référence)

%% Calcul des coefficients intermédiaires
x = 0.5;               
z = VDD / (x * (Vbh - Vbl) + VDD);    % Ajustement de la pente du pont diviseur
w = (x * z * Vbh) / Vref;      % Rapport de pondération basé sur Vref
y = 1;                      % Coefficient de rapport de diviseur global

%% Calcul des résistances idéales
R1 = 1e6;               % Résistance fixe choisie pour le diviseur R1-R2
Rth1 = x * R1;            % Valeur équivalente de Rth1 selon le rapport x
R2 = (R1 * Rth1) / (R1 - Rth1);  % Résistance complémentaire à R1 pour obtenir Rth1
R3 = (z * Rth1) / (1 - z);       % Résistance R3 ajoutée au pont intermédiaire

R45 = 1e6;               % Deuxième résistance fixe (autre diviseur)          % Valeur équivalente de Rth2 selon y
R6 = (w * R45) / (1 - w);       % Résistance R6 ajoutée au second pont

%% Normalisation des résistances avec tolérances de série E24 et E96
nR1 = NormaliseComp(R1, 24);     % Normalisation E24 (série standard)
nR2 = NormaliseComp(R2, 96);     % E96 pour plus de précision
nR3 = NormaliseComp(R3, 24);
nR45 = NormaliseComp(R4, 24);
nR6 = NormaliseComp(R6, 24);

%% Application d'une erreur de tolérance simulée (ici : sign = 0 donc aucune variation)
sign = 0;
nR1 = nR1 * (1 + sign * (1/100));
nR2 = nR2 * (1 + sign * (0.1/100));
nR3 = nR3 * (1 + sign * (1/100));
nR45 = nR45 * (1 + sign * (1/100));
nR6 = nR6 * (1 + sign * (1/100));

%% Nouvelle configuration avec VDD = 4.2 V (simulation en conditions réelles max)
VDD = 4.2;
nX = nR2 / (nR1 + nR2);         % Rapport du premier diviseur
nY = 1;         % Rapport du second diviseur
nRth1 = nX * nR1;               % Résistance équivalente Rth1

nZ = nR3 / (nRth1 + nR3);       % Coefficient de pondération Z
nW = nR45 / (nR45 + nR6);       % Coefficient de pondération W

%% Calcul des tensions mesurées pour la batterie 3S (gamme [6.4V, 8.4V])
Vb3 = [8.4, 6.4];   % Tension sur 2 cellules (cellule 2+3)

% Calcul de la tension estimée au point de mesure
Vb4h = (nW * nY * Vb3 + (1 - nW) * Vref) / (nX * nZ);    % Tension haute estimée
Vb4L = (nW * nY * Vb3 + (1 - nW) * Vref - (1 - nZ) * VDD) / (nX * nZ);  % Tension basse estimée

% Recalcul des seuils
Vbh = Vb4h - Vb3;   % Tension de seuil haut réelle
Vbl = Vb4L - Vb3;   % Tension de seuil bas réelle

%% Génération de la chaîne de paramètres pour simulation SPICE ou affichage
strA = sprintf('.param R1=%e R2=%e R3=%e R45=%e R6=%e', nR1, nR2, nR3, nR45, nR6);
disp(strA);
