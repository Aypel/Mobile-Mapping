% Aufgabe 7.1.2 KOORDINATENSYSTEMEN (WOCHE 2) 
% 7.1.2.1 ARBEITEN MIT KOORDINATENTRANSFORMATIONEN 

% Koordinatensystem K1
% Orientierung des Koordinatensystems
angles = [0,0,0];
% Aus Eulerwinkel Rotationsmatrix erstellen
R = eul2rotm(angles);
% homogene Rotationsmatrix
T_rotation = rotm2tform(R);
disp('t_rotation');
disp(T_rotation);
% Location des Koordinatensystems
t = [0,0,0];
% Aus Translationsvektor homogene Translationsmatrix erstellen
T_translation = trvec2tform(t);
disp('T_translation');
disp(T_translation);

% Homogene Transformationsmatrix nach der Definition in der Vorlesung
% (K1 -> Welt, Kameraposition in Welt)
T = T_translation * T_rotation;
disp("Homogene Transformationsmatrix")
disp(T);
% Mit plotCamera Koordindatensystem darstellen
figure;
hold on;
grid on;
axis equal;
view(3);

% Koordinatensystem darstellen
plotCamera('Orientation', R, 'Location', t, 'Size', 0.5);

% Koordinatensystem K2
% 90 Grad Drehung um Y -> Einheitskreis
angles2 = [0, pi/2, 0];
R2 = eul2rotm(angles2);

% 5 m Verschiebung entlang Z
t2 = [0, 0, 5];
% Homogene Transformationsmatrix
T_rotation2 = rotm2tform(R2);
T_translation2 = trvec2tform(t2);
T2 = T_translation2 * T_rotation2;

% K2 darstellen
plotCamera('Orientation', R2.', 'Location', t2,'Size', 0.5);

% Koordinatensystem K3

% -90 Grad Drehung um Y
angles3 = [0, 3*pi/2, 0];
R3 = eul2rotm(angles3);

% 5 m Verschiebung entlang X
t3 = [5, 0, 0];

% Homogene Transformationsmatrix
T_rotation3 = rotm2tform(R3);
T_translation3 = trvec2tform(t3);
T3 = T_translation3 * T_rotation3;

% K3 darstellen
plotCamera('Orientation', R3.', 'Location', t3, 'Size', 0.5);
% Achsenbereich +/- 10 m
xlim([-10 10]);
ylim([-10 10]);
zlim([-10 10]);

% Transformation T23, um einen Punkt von K2 nach K3 umzurechnen
% Also: K2 --> Welt --> K3
%       T2    inv(T3)
% Zuerst wird der Punkt mit T2 von K2 in das Weltkoordinatensystem
% transformiert. Anschließend wird mit der inversen Transformation
% von T3 vom Weltkoordinatensystem nach K3 transformiert
T23 = inv(T3) * T2;
t23 = tform2trvec(T23);
% Translation extrahieren
disp('Translation von K2 nach K3:');
disp(t23);
% Eulerwinkel transformieren
angles23 = tform2eul(T23);
disp('Eulerwinkel von K2 nach K3:');
disp(angles23);