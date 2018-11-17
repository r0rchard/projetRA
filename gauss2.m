clear all
close all

% Liste des points de d�part
% haut gauche, haut droit, bas gauche, bas droit
angles = [685 411; 1339 234; 628 768; 1432 582];

nbAngles = 8; % dimension "longeur" du tableau, "largeur" = 2

% Param�tres pour l'�tude
radius = 1;
order = (2*radius+1);
threshold = 600;

% Variables pour le d�tecteur de Harris
sigmaG = 2;
sigmaC1 = 3;
sigmaC2 = 5;
k = 0.05;

% Chargement de la vid�o
obj = VideoReader('feuille.mp4');
n = obj.NumberOfFrames;

%historiqueAngles = zeros(8,n);
historiqueAngles = [685 411 1339 234 628 768 1432 582];

%aviobj = VideoWriter('video.avi', 'Uncompressed AVI');
%aviobj.FrameRate = 5;
%open(aviobj)
% Lecture image par image de la vid�o
for i=1:n
    % R�cup�rer la frame i et la transformer en fichier gris double
    A = read(obj,i);
    A = rgb2gray(A); 
    
    D1 = imageGradient(sigmaG,sigmaC1,k,A);
    D2 = imageGradient(sigmaG,sigmaC2,k,A);
    
    D = D1 .* abs(D2);
    
    % Detection max local
    fenetre = 18;
    
    % Avant de pouvoir pr�dire 
    if(i<3)
        for angle=1:2:7
            historiqueAngles(i+1,angle) = historiqueAngles(i,angle);
            historiqueAngles(i+1,angle+1) = historiqueAngles(i,angle+1);
            [A] = dessinerCroix(A,historiqueAngles(i,angle),historiqueAngles(i,angle+1),100,5);
        end  
    else
        for angle=1:2:7
            % Pr�diction de la prochaine position
            historiqueAngles(i,angle) = historiqueAngles(i-1,angle) + round((historiqueAngles(i-1,angle)-historiqueAngles(i-2,angle))/2);
            historiqueAngles(i,angle+1) = historiqueAngles(i-1,angle+1) + round((historiqueAngles(i-1,angle+1)-historiqueAngles(i-2,angle+1))/2);
            
            % Calcul du maxlocal dans la position pr�dite 
            [historiqueAngles(i,angle),historiqueAngles(i,angle+1)] = maxlocal(D, historiqueAngles(i,angle), historiqueAngles(i,angle+1),fenetre);
            
            % Dessin d'une croix pour suivre l'angle 
            [A] = dessinerCroix(A,historiqueAngles(i,angle),historiqueAngles(i,angle+1),100,5);
        end
    end

    imshow(A);
    %imshow(D);
    refresh;
    %writeVideo(aviobj,D);
end

%close(aviobj);
%implay('video.avi');
