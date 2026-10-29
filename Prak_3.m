% Vergleich Original und entzerrte Bilder
%% Vergleich Original und entzerrte Bilder

comparisonImages = cell(1,20);
projectFolder = fileparts(mfilename('fullpath'));
title('Vergleich der Original- und entzerrten Stereo-Bilder (01–05)');
cameraParams1 = stereoParams.CameraParameters1;
cameraParams2 = stereoParams.CameraParameters2;

% Stereo-Parameter
stereoParams = stereoParameters( ...
    cameraParams1, ...
    cameraParams2, ...
    stereoParams.RotationOfCamera2, ...
    stereoParams.TranslationOfCamera2);
% Ich habe die Bilder in zwei figures dargestellt, da sonst die Bilder im
% figure sonst sehr klein werden
%% Bilder 1 - 5 darstellen
for i = 1:5

    % Originalbilder laden
    I1 = imread(fullfile(projectFolder, ...
        'img', 'left', sprintf('left%02d.png', i)));

    I2 = imread(fullfile(projectFolder, ...
        'img', 'right', sprintf('right%02d.png', i)));

    % Bilder entzerren
    I1_undistorted = undistortImage(I1, cameraParams1);
    I2_undistorted = undistortImage(I2, cameraParams2);

    % Vergleich:
    % Original left | entzerrt left | Original right | entzerrt right
    comparisonImages{4*i-3} = I1;
    comparisonImages{4*i-2} = I1_undistorted;
    comparisonImages{4*i-1} = I2;
    comparisonImages{4*i}   = I2_undistorted;

end

figure('Position', [100 100 1600 900]);

montage(comparisonImages, ...
    'Size', [5 4], ...
    'ThumbnailSize', [400 300], ...
    'BorderSize', [10 10]);

title('Vergleich der Original- und entzerrten Stereo-Bilder (01–05)');
%% Bilder 6 - 10 darstellen
for i = 6:10

    % Originalbilder laden
    I1 = imread(fullfile(projectFolder, ...
        'img', 'left', sprintf('left%02d.png', i)));

    I2 = imread(fullfile(projectFolder, ...
        'img', 'right', sprintf('right%02d.png', i)));

    % Bilder entzerren
    I1_undistorted = undistortImage(I1, cameraParams1);
    I2_undistorted = undistortImage(I2, cameraParams2);

    % Position innerhalb der Montage
    j = i - 5;

    comparisonImages{4*j-3} = I1;
    comparisonImages{4*j-2} = I1_undistorted;
    comparisonImages{4*j-1} = I2;
    comparisonImages{4*j}   = I2_undistorted;

end

figure('Position', [100 100 1600 900]);

montage(comparisonImages, ...
    'Size', [5 4], ...
    'ThumbnailSize', [400 300], ...
    'BorderSize', [10 10]);

title('Vergleich der Original- und entzerrten Stereo-Bilder (06–10)');
