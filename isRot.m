% Aufgabe: 7.1.2.3 CHECK IF ROTATION 
function isRotation = isRot(R)
%ISROT Prüft ob die übergebene Matrix eine Rotation ist
    % Prüfen ob die Matrix die Form 3x3 erfüllt
    if ~isequal(size(R), [3 3])
        isRotation = false;
        return;
    end
    % Bedingungen aus dem Skript
    if isequal(inv(R), R.') && isequal(det(R), 1)
        isRotation = true;
    else
        isRotation = false;
    end

end