function [X3,Y3,X4,Y4] = position(X1,Y1,X2,Y2,hautImg,largImg)
    %� partir des coordon�es initiales et "homographi�es", et des dimensions de l'image
    %permet de trouver les points utilis�s pour la projection de l'image
    %sur la vid�o.
    
    %d�tecte si le point projet� est dans l'image
    pos = intersect(intersect(find(Y2>=1),find(Y2<=hautImg)),intersect(find(X2>=1),find(X2<=largImg)));
    
    %points finaux images
    X4=X2(pos);
    Y4=Y2(pos);
    
    %points finaux vid�os
    X3=X1(pos);
    Y3=Y1(pos);
end