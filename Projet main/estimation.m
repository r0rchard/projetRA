function [X1,Y1,X2,Y2] = estimation(largVid,hautVid,matH)
    %� partir des dimensions de la vid�o, et de l'homographie, 
    %projette les coordon�es de chaque pixel sur l'image.

    %Cr�ation d'une grille de dimension �gale � celles de la frame de la vid�o
    [A,B]=meshgrid(1:largVid,1:hautVid);
    dim=largVid*hautVid;
    
    %cr�ation de la matrice homog�n�is�e
    X1 = reshape(A,[1,dim]);
    Y1 = reshape(B,[1,dim]);
    O = ones(1,dim);
    X1p = vertcat(X1,Y1,O);
    
    %application de l'homographie
    X2p=matH*X1p; 
    
    %retour des matrices de coordon�es projet�es sur l'image
    X2=uint16(X2p(1,:)./X2p(3,:));
    Y2=uint16(X2p(2,:)./X2p(3,:));
end