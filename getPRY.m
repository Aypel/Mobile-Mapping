% Aufgabe: 7.1.2.2 DIE RPY DARSTELLUNG (FREIWILLIG) 
function [roll, pitch, yaw] = getPRY(R)
%GETPRY Berechnet aus einer gegebenen Rotation in RPY-Darstellung roll,
%pitch und yaw.
    % Wie im Skript
    yaw = atan2(R(2,1), R(1,1));
    pitch = atan2(-R(3,1), R(1,1)*cos(yaw) + R(2,1)*sin(yaw));
    roll = atan2(R(3,2)/cos(pitch), R(3,3)/cos(pitch));
end