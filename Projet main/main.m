for i=1:10:n
    %On r�cup�re chaque frame de la vid�o
    video = read(obj,i);
    %On r�cup�re les dimensions de cette frame (hauteur et largeur)
    %[hautVid,largVid]=size(video);
    hautVid=size(video,1);
    largVid=size(video,2);
    

    
    %On stocke les coordonn�es des coins de la feuille
    coinVidHG=[historiqueAngles(i,1),historiqueAngles(i,2)];
    coinVidHD=[historiqueAngles(i,3),historiqueAngles(i,4)];
    coinVidBG=[historiqueAngles(i,5),historiqueAngles(i,6)];
    coinVidBD=[historiqueAngles(i,7),historiqueAngles(i,8)];
    
    image = imread('Clifford.jpg');

    %On r�cup�re les dimensions de l'image
    %[hautImg,largImg]=size(image);
    hautImg=size(image,1);
    largImg=size(image,2);
    %Stockage des coordonn�es des 4 coins de l'image
    coinImgHG = [1,1];
    coinImgHD = [largImg,1];
    coinImgBG = [1,hautImg];
    coinImgBD = [largImg,hautImg];
    
    
    %R�solution de l'�quation pour retrouver Hp
    
    %Calcul de l'homographie entre deux plans � partir de 8 points
    matH = homography(coinVidHG,coinVidHD,coinVidBG,coinVidBD,coinImgHG,coinImgHD,coinImgBG,coinImgBD);
    
    %coordon�es des points projet�s sur l'image
    [X1,Y1,X2,Y2] = estimation(largVid,hautVid,matH);
    
    %coordon�es finales
    %X3,Y3 : coordon�es des points de la vid�o
    %X4,Y4 : coordon�es des points de l'image
    [X3,Y3,X4,Y4]=position(X1,Y1,X2,Y2,hautImg,largImg);

    %image finale
    video = projection(image,video,X3,Y3,X4,Y4);
    
    imshow(video);
    refresh;
end
