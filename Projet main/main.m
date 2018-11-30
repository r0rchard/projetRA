% %%
 aviobj=VideoWriter('video.avi','Uncompressed AVI');
 aviobj.FrameRate=24;open(aviobj)
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
    

    
   

%-------
    
    image = imread('Clifford.jpg');

    %On r�cup�re les dimensions de l'image
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
    video2 = projection(image,video,X3,Y3,X4,Y4);
 % d�tection main
    
    %Zone de la main
    coinZHG = [coinVidHG(1)+round(3/4*(coinVidHD(1)-coinVidHG(1))),coinVidHD(2)+round(1/4*(coinVidHG(2)-coinVidHD(2)))];
    coinZHD = coinVidHD;
    coinZBG = [coinVidBG(1)+round(3/4*(coinVidBD(1)-coinVidBG(1))),coinVidBD(2)+round(1/4*(coinVidBG(2)-coinVidBD(2)))];
    coinZBD = coinVidBD;
    
    %Cr�ation de N
    largM=360;
    hautM=1080;
    N = uint8(ones(hautM,largM,3));
    
    %Stockage des coordonn�es des 4 coins de M
    coinMHG = [1,1];
    coinMHD = [largM,1];
    coinMBG = [1,hautM];
    coinMBD = [largM,hautM];

    %Homographie de la zone vers M
    matH2 = homography(coinZHG,coinZHD,coinZBG,coinZBD,coinMHG,coinMHD,coinMBG,coinMBD);
    
    %Projecion des pixels de la vid�o sur M
    [X5,Y5,X6,Y6] = estimation(largVid,hautVid,matH2);
    
    %Correspondances entre les pixels de la zone et de M
    [X7,Y7,X8,Y8]=position(X5,Y5,X6,Y6,hautM,largM);
    
    %Projection des pixels de la zone dans M2
    M2 = projection(video,N,X8,Y8,X7,Y7);
   
    %Filtrage
    M3 = filtrageMain(M2);
    
    %Application sur la vid�o
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
    
    
    %video3=cat(3,video3R,video3G,video3B);
    video3 = projection(M2,video,X7,Y7,X8,Y8);
    writeVideo(aviobj, video3);

 end
 close(aviobj);