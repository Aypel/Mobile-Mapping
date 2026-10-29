% Aufgabe 7.1.1: EINFÜHRUNG IN MATLAB
%% Aufgabe 1.1.1: Bild einlesen
% Pfad des Bildes
img_path = './img/HM_Karlstr.jpg';

% Bild einlesen, Spalten, Zeilen und Farbe ausgeben
image = imread(img_path);
img_size = size(image);
imshow(image);
% Daten printen
fprintf('Bildgröße: %d Zeilen, %d Spalten, %d Farbkanäle\n', ...
    img_size(1), img_size(2), size(image, 3));

%% Aufgabe 1.1.2: Bild analysieren und aufbereiten
% Graustufenbild erstellen
grey_img = rgb2gray(image);
figure;
imshow(grey_img);
title('Graustufenbild');
figure;
imshow(image);

% Histogram für Graustufenbild erstellen
hist_grey = imhist(grey_img);
figure;
bar(0:255, hist_grey);
xlim([0 255]);
title('Histogramm des Graustufenbildes');
xlabel('Grauwert');
ylabel('Häufigkeit');

% Histograme für Farbbild erstellen
% Histogram für jeden Farbkanal erstellen
hist_color = [
    imhist(image(:,:,1)), ...
    imhist(image(:,:,2)), ...
    imhist(image(:,:,3))
];
figure;
hold on;
plot(hist_color(:,1), 'r');
xlabel('Farbwert');
ylabel('Anzahl Pixel');

plot(hist_color(:,2), 'g');
xlabel('Farbwert');
ylabel('Anzahl Pixel');

plot(hist_color(:,3), 'b');
xlabel('Farbwert');
ylabel('Anzahl Pixel');
title('Histogramm des Farbbildes')
hold off;
% Dokumentation der Ergebnisse:
% Farbbild:
% Hier fällt auf, dass blaue, gesättigte Pixel, also Werte ganz Links,
% einen Peak haben. Das deutet darauf hin, dass es im Bild Stellen mit
% Blaustich gibt. Zwischen dem Farbwert 130 und 170 laufen alle drei 
% Kanäle (Rot, Grün, Blau) relativ nah beieinander und haben hohe Werte.
% Alle drei Kanäle schießen ganz rechts kurz vor dem Maximum noch einmal 
% steil nach oben

% Graubild:
% Sowohl ganz links als auch Rechts flacht das Histogramm ab, was darauf 
% hindeutet, dass in dem Bild wenige sehr helle bzw. sehr dunkle Stellen
% gibt. Dafür tauchen eher mittlere Helligkeitsstufen vermehrt
% auf --> Hauptteil der Pixel konzentiert sich also im Graustufenbereich 
% 150 bis 170

%% Aufgabe 7.1.3: Bild als Matrix interpretieren
scaled_img = imresize(image, 0.1);
figure;
imshow(scaled_img);
title('Skalierte Bild (10%)');
% Bilddaten nochmal emitteln
[rows, columns, ~] = size(image);
% Ecken des Bildes
minX = 1;
maxX = columns;
minY = 1;
maxY = rows;
% Bildmitte berechnen
centerRow = round(rows / 2);
centerColumn = round(columns / 2);
% Ecken schwarz färben (Farbbild)
image(minY, minX,:) = 0; % oben links
image(minY, maxX, :) = 0; % oben rechts
image(maxY, minX, :) = 0; % unten links
image(maxY, maxX, :) = 0; % unten rechts
% Bildmitte schwarz färben (Farbbild)
image(centerRow, centerColumn, :) = 0;
figure;
imshow(image);
title('Bild mit markierten Ecken und Mittelpunkt');
% Ecken schwarz färben (Graustufenbild)
grey_img(minY, minX) = 0;
grey_img(minY, maxX) = 0;
grey_img(maxY, minX) = 0;
grey_img(maxY, maxX) = 0;
% Bildmitte schwarz Färben (Graustudfenbild)
grey_img(centerRow, centerColumn) = 0;
figure;
imshow(grey_img);
title('Graustufenbild mit markierten Ecken und Mittelpunkt');

%% Aufgabe 7.1.4: MIT BILDERN ARBEITEN
video = VideoWriter('Bildsequenz.avi');
video.FrameRate = 1;
open(video);
figure;
for i=1:9
    file_name = sprintf('000%d.png', i);
    file_path = sprintf('./img/%s', file_name);
    disp(file_path);
    image_seq = imread(file_path);
    frame = im2frame(image_seq);
    writeVideo(video, frame);
    imshow(image_seq);
    new_file_name = sprintf('Sequenz_%s', file_name);
    imwrite(image_seq, new_file_name);
    pause(1);
end
close(video);
implay('Bildsequenz.avi');
montage({
    'Sequenz_0001.png', ...
    'Sequenz_0002.png', ...
    'Sequenz_0003.png', ...
    'Sequenz_0004.png', ...
    'Sequenz_0005.png', ...
    'Sequenz_0006.png', ...
    'Sequenz_0007.png', ...
    'Sequenz_0008.png', ...
    'Sequenz_0009.png'
});

%% Aufgabe 7.1.5: Punktwolke darstellen
point_cloud = pcread('teapotOut.ply');
figure;
pcshow(point_cloud);
title("Punktwolke");
