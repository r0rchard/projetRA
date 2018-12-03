function [X3,Y3,X4,Y4] = position(X1,Y1,X2,Y2,hautImg,largImg)
    %à partir des coordonées initiales et "homographiées", et des dimensions de l'image
    %permet de trouver les points utilisés pour la projection de l'image
    %sur la vidéo.
    
    %détecte si le point projeté est dans l'image
    pos = intersect(intersect(find(Y2>=1),find(Y2<=hautImg)),intersect(find(X2>=1),find(X2<=largImg)));
    
    %points finaux images
    X4=X2(pos);
    Y4=Y2(pos);
    
    %points finaux vidéos
    X3=X1(pos);
    Y3=Y1(pos);
end