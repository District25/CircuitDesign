function Rn = NormaliseComp(R, serie)
    % Normalise la résistance R à la série normalisée E24 ou E96 la plus proche

    % Séries normalisées E24 et E96
    E24 = [1.0 1.1 1.2 1.3 1.5 1.6 1.8 2.0 2.2 2.4 2.7 3.0 ...
           3.3 3.6 3.9 4.3 4.7 5.1 5.6 6.2 6.8 7.5 8.2 9.1];

    E96 = [1.00 1.02 1.05 1.07 1.10 1.13 1.15 1.18 1.21 1.24 1.27 1.30 ...
           1.33 1.37 1.40 1.43 1.47 1.50 1.54 1.58 1.62 1.65 1.69 1.74 ...
           1.78 1.82 1.87 1.91 1.96 2.00 2.05 2.10 2.15 2.21 2.26 2.32 ...
           2.37 2.43 2.49 2.55 2.61 2.67 2.74 2.80 2.87 2.94 3.01 3.09 ...
           3.16 3.24 3.32 3.40 3.48 3.57 3.65 3.74 3.83 3.92 4.02 4.12 ...
           4.22 4.32 4.42 4.53 4.64 4.75 4.87 4.99 5.11 5.23 5.36 5.49 ...
           5.62 5.76 5.90 6.04 6.19 6.34 6.49 6.65 6.81 6.98 7.15 7.32 ...
           7.50 7.68 7.87 8.06 8.25 8.45 8.66 8.87 9.09 9.31 9.53 9.76];

    % Choix de la série
    if serie == 24
        E = E24;
    elseif serie == 96
        E = E96;
    else
        error('Série non prise en charge (seulement E24 ou E96)');
    end

    decade = 10.^floor(log10(R));          % Décennie
    value = R ./ decade;                   % Valeur ramenée à la base de la décennie
    [~, idx] = min(abs(E - value));        % Trouver la valeur la plus proche
    Rn = E(idx) * decade;                  % Résistance normalisée
end
