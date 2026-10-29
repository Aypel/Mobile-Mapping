%% Aufgabe 1.4.2 Koordinatensysteme und Kameras definieren

%% 1. Weltkoordinatensystem (W)
% Orientierung: Keine Drehung
angles_W = [0, 0, 0];
R_W = eul2rotm(angles_W);

% Ursprung von W
t_W = [0, 0, 0];
location_W = -t_W * R_W';

figure;
hold on;
grid on;
axis equal;
view(3);

% Weltkoordinatensystem (Schwarz, Name 'World')
plotCamera('Orientation', orientation_W, 'Location', location_W, 'Size', 0.2, ...
    'Color', [0 0 0], 'Label', 'World');

%% 2. Kamera K1
% Orientierung K1: Keine Drehung
angles_K1 = [0, 0, 0];
R_K1 = eul2rotm(angles_K1);
t_K1 = -[-0.5, 0, 1] * R_K1; 

% Ursprung K1: [-0.5, 0, 1]
% Exakt die beiden Zeilen aus dem Skript (7.1.4.1):
orientation_K1 = R_K1';
location_K1 = -t_K1 * R_K1';

% Homogene Transformationsmatrix T1 (K1 -> Welt, Kameraposition in Welt)
T_rotation_K1 = rotm2tform(R_K1);
T_translation_K1 = trvec2tform(location_K1);
T1 = T_translation_K1 * T_rotation_K1;

% Kamera K1 (Rot, Name 'K1')
plotCamera('Orientation', orientation_K1, 'Location', location_K1, 'Size', 0.2, ...
    'Color', [1 0 0], 'Label', 'K1');

%% 3. Kamera K2
% Orientierung K2: Keine Drehung
angles_K2 = [0, 0, 0];
R_K2 = eul2rotm(angles_K2);
t_K2 = -[0.5, 0, 1] * R_K2; 

% Exakt die beiden Zeilen aus dem Skript (7.1.4.1):
orientation_K2 = R_K2';
location_K2 = -t_K2 * R_K2';

% Homogene Transformationsmatrix T2 (K2 -> Welt)
T_rotation_K2 = rotm2tform(R_K2);
T_translation_K2 = trvec2tform(location_K2);
T2 = T_translation_K2 * T_rotation_K2;

% Kamera K2 (Blau, Name 'K2')
plotCamera('Orientation', orientation_K2, 'Location', location_K2, 'Size', 0.2, ...
    'Color', [0 0 1], 'Label', 'K2');

% Achsenbeschriftungen und Grenzen setzen
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
xlim([-3 3]);
ylim([-3 3]);
zlim([0 4]);

%% 5. Transformation T12, um Punkte von K2 nach K1 umzurechnen
% K2 --> Welt --> K1
% T2    inv(T1)
T21 = inv(T1) * T2;
T12 = inv(T2) * T1;

%% Aufgabe 7.1.4.4 3D Punkte simulieren und auf Bildebene projizieren

N = 80;
% Startpunkt der Punktestrecke
p0 = [-4, -4, 3];
% Endpunkt der Punktestrecke
e0 = [4, 4, 3];
Points = zeros(N, 3);
% Welt -> K1
invT1 = inv(T1);
invT2 = inv(T2);

figure;
hold on;
grid on;
axis equal;

for i = 1:N
    % Skalierungsfaktor -> t = 0 -> Startpunkt, t = 1 -> Endpunkt,
    % dazwischen 79 gleiche Abschnitte
    t = (i - 1) / (N - 1);
    Points(i, :) = p0 + t * (e0 - p0);
    scatter3(Points(i,1), Points(i,2), Points(i,3), 25, 'filled');
end

% Brennweite 
f = 0.002;
pl = zeros(N, 2); % K1 (links)
pr = zeros(N, 2); % K2 (rechts)

for i = 1:N
    % 1. Weltpunkt in homogene Koordinaten (4x1)
    P_W = [Points(i, :)'; 1];
    % Welt -> K1
    P_K1 = invT1 * P_W;
    % Welt -> K2
    P_K2 = invT2 * P_W;
    % 4. Projektion K1 (Strahlensatz)
    pl(i, 1) = f * (P_K1(1) / P_K1(3));
    pl(i, 2) = f * (P_K1(2) / P_K1(3));
    
    % 5. Projektion K2 (Strahlensatz)
    % Skript: 3.2.2.2 zur Zentralprojektion und 3.2.2.4 zur Transformation
    % in die reale Bildebene über die verwendung von f
    pr(i, 1) = f * (P_K2(1) / P_K2(3));
    pr(i, 2) = f * (P_K2(2) / P_K2(3));
end

%% Aufgabe 7.1.4.5 Punkte 3D Rekonstruieren
f = 0.002;
% Basisabstand d_B
d_B = norm(location_K2 - location_K1);
P_rec = zeros(N, 3);

for i = 1:N
    xl = pl(i, 1);
    yl = pl(i, 2);
    xr = pr(i, 1);
    yr = pr(i, 2);
    
    d = xl - xr;
    if abs(d) < 1e-12
        warning('Punkt %d hat Disparität 0 oder liegt im Unendlichen!', i);
        continue;
    end
    
    Z_c1 = d_B * f / d;
    X_c1 = xl * Z_c1 / f;
    Y_c1 = yl * Z_c1 / f;
    
    P_K1 = [X_c1; Y_c1; Z_c1; 1];
    P_W = T1 * P_K1;
    P_rec(i, :) = P_W(1:3)';
end

feh_exakt = max(abs(Points - P_rec), [], 'all');
fprintf('Maximaler Abweichungsfehler ohne Rauschen: %e m\n', feh_exakt);

%% 2. Modifikation der Bildpunkte mit zufallsverteilten Fehlern (Rauschen)
faktor = 1e-4; % 0.01 mm maximale Abweichung
% Zufallsfehler mit rand auf pl und pr aufaddieren
pl_noisy = pl + (rand(size(pl)) - 0.5) * faktor;
pr_noisy = pr + (rand(size(pr)) - 0.5) * faktor;

%% 3. Wiederholung der Rekonstruktion mit gestörten Pixeln
P_rec_noisy = zeros(N, 3);

for i = 1:N
    xl = pl_noisy(i, 1);
    yl = pl_noisy(i, 2);
    xr = pr_noisy(i, 1);
    yr = pr_noisy(i, 2);
    
    d = xl - xr;
    Z_c1 = (f * d_B) / d;
    X_c1 = (xl * Z_c1) / f;
    Y_c1 = (yl * Z_c1) / f;
    
    P_K1 = [X_c1; Y_c1; Z_c1; 1];
    P_W = T1 * P_K1;
    P_rec_noisy(i, :) = P_W(1:3)';
end

% Vergleich der berechneten Werte mit den simulierten Originaldaten
abweichungen = abs(Points - P_rec_noisy);
max_fehler = max(abweichungen, [], 'all');
mittlerer_fehler = mean(abweichungen, 'all');

fprintf('Maximaler Rekonstruktionsfehler mit Rauschen: %.4f m\n', max_fehler);
fprintf('Mittlerer Rekonstruktionsfehler mit Rauschen:  %.4f m\n', mittlerer_fehler);

%% Visualisierung im 3D-Raum
figure;
hold on; grid on; axis equal; view(3);

scatter3(Points(:,1), Points(:,2), Points(:,3), 40, 'k', 'filled', 'DisplayName', 'Original 3D Punkte');
scatter3(P_rec(:,1), P_rec(:,2), P_rec(:,3), 20, 'g', 'filled', 'DisplayName', 'Rekonstruiert (Ohne Rauschen)');
scatter3(P_rec_noisy(:,1), P_rec_noisy(:,2), P_rec_noisy(:,3), 25, 'r', 'x', 'DisplayName', 'Rekonstruiert (Mit Rauschen)');

xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
title('Vergleich: Originale vs. Rekonstruierte 3D-Punkte');
legend('Location', 'best');
