% Aufgabe: 7.1.2.2 DIE RPY DARSTELLUNG (FREIWILLIG) 
function R = setPRY(roll, pitch, yaw)
%SETPRY Funktion zur RPY-Darstellung aus drei Winkeln
    % Rotationsmatrix für Roll um x
    Rx = [1 0 0;
          0 cos(roll) -sin(roll);
          0 sin(roll) cos(roll)];

    % Rotationsmatrix für Pitch um y
    Ry = [cos(pitch) 0 sin(pitch);
          0 1 0;
          -sin(pitch) 0 cos(pitch)];

    % Rotationsmatrix für Yaw um z
    Rz = [cos(yaw) -sin(yaw) 0;
          sin(yaw) cos(yaw) 0;
          0 0 1];

     R = Rz * Ry * Rx;
end