
%function [historiqueAngles] = gauss2(video)
video = 'feuille.mp4';
    % Liste des points de départ
    % haut gauche, haut droit, bas gauche, bas droit
    %angles = [685 411; 1339 234; 628 768; 1432 582];

    %nbAngles = 8; % dimension "longeur" du tableau, "largeur" = 2

    % Paramètres pour l'étude
    %radius = 1;
%     order = (2*radius+1);
%     threshold = 600;

    % Variables pour le détecteur de Harris
    sigmaG = 2;
    sigmaC1 = 3;
    sigmaC2 = 5;
    k = 0.05;

    % Chargement de la vidéo
    obj = VideoReader(video);
    n = obj.NumberOfFrames;

    %historiqueAngles = zeros(8,n);
    historiqueAngles = [685 411 1339 234 628 768 1432 582];

    % Lecture image par image de la vidéo
    for i=1:n
        % Récupérer la frame i et la transformer en fichier gris double
        A = read(obj,i);
        A = rgb2gray(A); 

        D1 = imageGradient(sigmaG,sigmaC1,k,A);
        D2 = imageGradient(sigmaG,sigmaC2,k,A);

        D = D1 .* abs(D2);

        % Detection max local
        fenetre = 18;

        % Avant de pouvoir prédire 
        if(i<3)
            for angle=1:2:7
                historiqueAngles(i+1,angle) = historiqueAngles(i,angle);
                historiqueAngles(i+1,angle+1) = historiqueAngles(i,angle+1);
            end  
        else
            for angle=1:2:7
                % Prédiction de la prochaine position
                historiqueAngles(i,angle) = historiqueAngles(i-1,angle) + round((historiqueAngles(i-1,angle)-historiqueAngles(i-2,angle))/2);
                historiqueAngles(i,angle+1) = historiqueAngles(i-1,angle+1) + round((historiqueAngles(i-1,angle+1)-historiqueAngles(i-2,angle+1))/2);

                % Calcul du maxlocal dans la position prédite 
                [historiqueAngles(i,angle),historiqueAngles(i,angle+1)] = maxlocal(D, historiqueAngles(i,angle), historiqueAngles(i,angle+1),fenetre);
            end
        end
    end
%%end
