function [X1,Y1,X2,Y2] = estimation(largVid,hautVid,matH)
    %à partir des dimensions de la vidéo, et de l'homographie, 
    %projette les coordonées de chaque pixel sur l'image.

    %Création d'une grille de dimension égale à celles de la frame de la vidéo
    [A,B]=meshgrid(1:largVid,1:hautVid);
    dim=largVid*hautVid;
    
    %création de la matrice homogénéisée
    X1 = reshape(A,[1,dim]);
    Y1 = reshape(B,[1,dim]);
    O = ones(1,dim);
    X1p = vertcat(X1,Y1,O);
    
    %application de l'homographie
    X2p=matH*X1p; 
    
    %retour des matrices de coordonées projetées sur l'image
    X2=uint16(X2p(1,:)./X2p(3,:));
    Y2=uint16(X2p(2,:)./X2p(3,:));
end