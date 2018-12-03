clear all
close all
<<<<<<< HEAD

feuille = 'feuille.mp4'; %vidéo fournie pour le sujet
feuilleReader = VideoReader(feuille);

%historiqueAngles stock les 4 coins de la feuille
%on stock le nombre d'images de la vidéo
[historiqueAngles,n] = gauss(feuilleReader); 

=======

feuille = 'feuille.mp4'; %vidéo fournie pour le sujet
feuilleReader = VideoReader(feuille);

%historiqueAngles stock les 4 coins de la feuille
%on stock le nombre d'images de la vidéo
[historiqueAngles,n] = gauss(feuilleReader); 
%%
>>>>>>> master
%dessinAnime stock la vidéo à projeter sur l'image
dessinAnime = VideoReader('Chien.mp4');

%Initialisation et ouverture du rédacteur de vidéo
aviobj=VideoWriter('video.avi','Motion JPEG AVI');
aviobj.FrameRate=24;
open(aviobj);

%On traite la vidéo image par image
<<<<<<< HEAD
for i=1:n
=======
%for i=1:n
i=20;
>>>>>>> master
    video = read(feuilleReader,i); %On lit un frame de la vidéo
    
    %On récupère les dimensions de cette frame (hauteur et largeur)
    hautVid=size(video,1);
    largVid=size(video,2);
    

    
    %On stocke les coordonnées des coins de la feuille
    coinVidHG=[historiqueAngles(i,1),historiqueAngles(i,2)];
    coinVidHD=[historiqueAngles(i,3),historiqueAngles(i,4)];
    coinVidBG=[historiqueAngles(i,5),historiqueAngles(i,6)];
    coinVidBD=[historiqueAngles(i,7),historiqueAngles(i,8)];
    

    
   

%-------
    %l'image à projeté est la i_ème image de la vidéo
    image  = read(dessinAnime,i); 
    
    %On récupère les dimensions de l'image
    hautImg=size(image,1);
    largImg=size(image,2);
    
    %Stockage des coordonnées des 4 coins de l'image
    coinImgHG = [1,1];
    coinImgHD = [largImg,1];
    coinImgBG = [1,hautImg];
    coinImgBD = [largImg,hautImg];

    %Calcul de l'homographie entre les deux images à partir de 8 points
    matH = homography(coinVidHG,coinVidHD,coinVidBG,coinVidBD,coinImgHG,coinImgHD,coinImgBG,coinImgBD);
    
    %coordonées des points projetés sur l'image
    %X1,Y1 : coordonnées des pixels de la vidéo
    %X2,Y2 : coordonnées des pixels projetés
    [X1,Y1,X2,Y2] = estimation(largVid,hautVid,matH);
    
    %coordonées finales
    %X3,Y3 : coordonées des pixels de la vidéo devant être modifiés
    %X4,Y4 : coordonées des points de l'image correspondant
    [X3,Y3,X4,Y4]=position(X1,Y1,X2,Y2,hautImg,largImg);

    %image finale
    video2 = projection(image,video,X3,Y3,X4,Y4);
    
 % détection main
    
    %Zone de la main
    %première zone
    %elle prend 1/4 de la feuille
    coinZHG2 = [coinVidHG(1)+round(3/4*(coinVidHD(1)-coinVidHG(1))),coinVidHD(2)+round(1/4*(coinVidHG(2)-coinVidHD(2)))];
    coinZHD2 = coinVidHD;
    coinZBG2 = [coinVidBG(1)+round(3/4*(coinVidBD(1)-coinVidBG(1))),coinVidBD(2)+round(1/4*(coinVidBG(2)-coinVidBD(2)))];
    coinZBD2 = coinVidBD;
    
    %deuxième zone
    %elle prend la motié de la première zone
    coinZHD = [coinVidHD(1)+round(1/6*(coinVidBD(1)-coinVidHD(1))),coinVidBD(2)+round(5/6*(coinVidHD(2)-coinVidBD(2)))];
    coinZBD = [coinVidHD(1)+round(4/6*(coinVidBD(1)-coinVidHD(1))),coinVidBD(2)+round(2/6*(coinVidHD(2)-coinVidBD(2)))];
    coinZHG = [coinZHG2(1)+round(1/6*(coinZBG2(1)-coinZHG2(1))),coinZBG2(2)+round(5/6*(coinZHG2(2)-coinZBG2(2)))];
    coinZBG = [coinZHG2(1)+round(4/6*(coinZBG2(1)-coinZHG2(1))),coinZBG2(2)+round(2/6*(coinZHG2(2)-coinZBG2(2)))];
    
    %Création de M
    largM=largImg/6;
    hautM=hautImg/6;
    M = uint8(ones(hautM,largM,3));

    %Stockage des coordonnées des 4 coins de M
    coinMHG = [1,1];
    coinMHD = [largM,1];
    coinMBG = [1,hautM];
    coinMBD = [largM,hautM];

    %Homographie de la zone vers M
    matH2 = homography(coinZHG,coinZHD,coinZBG,coinZBD,coinMHG,coinMHD,coinMBG,coinMBD);
    
    %coordonées des points projetés sur M
    %X5,Y5 : coordonnées des pixels de la vidéo
    %X6,Y6 : coordonnées des pixels projetés
    [X5,Y5,X6,Y6] = estimation(largVid,hautVid,matH2);
    
    %Correspondances entre les pixels de la zone et de M
    %X7,Y7 : coordonées des pixels de la vidéo dont la projection se trouve
    %dans M
    %X8,Y8 : coordonées des points de M correspondant
    [X7,Y7,X8,Y8]=position(X5,Y5,X6,Y6,hautM,largM);
    
    %Projection des pixels de la zone dans M2
    M2 = projection(video,M,X8,Y8,X7,Y7);
    
    %Filtrage
    %M3 est un filtre qui vaut 0 dans la zone de la main, 1 ailleurs.
    M3 = filtrageMain(M2);


    %Application sur la vidéo
    video3R=video2(:,:,1);
    video3G=video2(:,:,2);
	video3B=video2(:,:,3);
    vR=video(:,:,1);
    vG=video(:,:,2);
	vB=video(:,:,3);
    
    for x=1:length(X7)
        if M3(Y8(x),X8(x))==0
        video3R(Y7(x),X7(x))=vR(Y7(x),X7(x));
        video3B(Y7(x),X7(x))=vG(Y7(x),X7(x));
        video3G(Y7(x),X7(x))=vB(Y7(x),X7(x));
        end
    end
    video3=cat(3,video3R,video3G,video3B);
    writeVideo(aviobj, video3);
%end
close(aviobj);