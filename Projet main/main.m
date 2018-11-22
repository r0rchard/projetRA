for i=1:10:n
    %On récupère chaque frame de la vidéo
    video = read(obj,i);
    %On récupère les dimensions de cette frame (hauteur et largeur)
    %[hautVid,largVid]=size(video);
    hautVid=size(video,1);
    largVid=size(video,2);
    

    
    %On stocke les coordonnées des coins de la feuille
    coinVidHG=[historiqueAngles(i,1),historiqueAngles(i,2)];
    coinVidHD=[historiqueAngles(i,3),historiqueAngles(i,4)];
    coinVidBG=[historiqueAngles(i,5),historiqueAngles(i,6)];
    coinVidBD=[historiqueAngles(i,7),historiqueAngles(i,8)];
    
    image = imread('Clifford.jpg');

    %On récupère les dimensions de l'image
    %[hautImg,largImg]=size(image);
    hautImg=size(image,1);
    largImg=size(image,2);
    %Stockage des coordonnées des 4 coins de l'image
    coinImgHG = [1,1];
    coinImgHD = [largImg,1];
    coinImgBG = [1,hautImg];
    coinImgBD = [largImg,hautImg];
    
    
    %Résolution de l'équation pour retrouver Hp
    
    %Calcul de l'homographie entre deux plans à partir de 8 points
    matH = homography(coinVidHG,coinVidHD,coinVidBG,coinVidBD,coinImgHG,coinImgHD,coinImgBG,coinImgBD);
    
    %coordonées des points projetés sur l'image
    [X1,Y1,X2,Y2] = estimation(largVid,hautVid,matH);
    
    %coordonées finales
    %X3,Y3 : coordonées des points de la vidéo
    %X4,Y4 : coordonées des points de l'image
    [X3,Y3,X4,Y4]=position(X1,Y1,X2,Y2,hautImg,largImg);

    %image finale
    video = projection(image,video,X3,Y3,X4,Y4);
    
    imshow(video);
    refresh;
end
