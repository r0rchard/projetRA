% %%
aviobj=VideoWriter('video.avi','Uncompressed AVI');
aviobj.FrameRate=5;open(aviobj)
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
    

    
   

%-------
    
    image = imread('Clifford.jpg');

    %On récupère les dimensions de l'image
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
    video2 = projection(image,video,X3,Y3,X4,Y4);
%%



    % détection main
    
    %zone de la main
    
    coinZHG = [coinVidHG(1)+round(3/4*(coinVidHD(1)-coinVidHG(1))),coinVidHD(2)+round(1/4*(coinVidHG(2)-coinVidHD(2)))];
    coinZHD = coinVidHD;
    coinZBG = [coinVidBG(1)+round(3/4*(coinVidBD(1)-coinVidBG(1))),coinVidBD(2)+round(1/4*(coinVidBG(2)-coinVidBD(2)))];
    coinZBD = coinVidBD;
    
    % création M
    largM=360;
    hautM=1080;
    M = ones(hautM,largM);
    
    %Stockage des coordonnées des 4 coins de M
    coinMHG = [1,1];
    coinMHD = [largM,1];
    coinMBG = [1,hautM];
    coinMBD = [largM,hautM];
    
    %Taille de la zone
    
    %Homographie de la zone vers M
    matH2 = homography(coinZHG,coinZHD,coinZBG,coinZBD,coinMHG,coinMHD,coinMBG,coinMBD);
    
    %Projecion des pixels de la vidéo sur M
    [X5,Y5,X6,Y6] = estimation(largVid,hautVid,matH2);
    
    %Correspondances entre les pixels de la zone et de M
    [X7,Y7,X8,Y8]=position(X5,Y5,X6,Y6,hautM,largM);
    
    % test X7Y7
%     mask2 = zeros(hautVid,largVid);
%     for x=1:length(X7)
%         mask2(Y7(x),X7(x))=1;
%     end
%     figure, imshow(mask2);

    %test X8Y8
%     mask3 = zeros(hautM,largM);
%     for x=1:length(X8)
%         mask3(Y8(x),X8(x))=1;
%     end
%     figure('Name','mask 3'), imshow(mask3);
    
    %Projection des pixels de la zone dans M2
    videoR=video(:,:,1);
    videoG=video(:,:,2);
	videoB=video(:,:,3);
    
    N = uint8(ones(hautM,largM,3));
%     figure('Name','N'), imshow(N(:,:,1));
    M2 = projection(video,N,X8,Y8,X7,Y7);
%     figure('Name','M2'), imshow(M2);
%       
      
    
%     %filtrage
    R = M2(:,:,1);
    G = M2(:,:,2);
    B = M2(:,:,3) ;
    
    SeuilG = 125;
    seuilB = 140;
    mask = find(G>SeuilG & B>seuilB);
    mask2 = find(G<SeuilG & B<seuilB);
    R(mask) = 1 ;
    G(mask) = 1 ;
    B(mask) = 1;
    R(mask2) = 0 ;
    G(mask2) = 0 ;
    B(mask2) = 0;
    M3 = cat(3,R,G,B);
    
%     V = max(R,max(G,B));
%     S = ( V - min(R,min(G,B)) )./ V;
%     H = lumiere(R,G,B,V,hautM,largM);   
%     M3 = double(V>124);
%     figure('Name','V'),imshow(V),
%     impixelinfo;
%     figure('Name','M3'),imshow(M5),

    % création du masque
%     mask = zeros(hautVid,largVid);
%     for x=1:length(X3)
%         mask(Y3(x),X3(x))=1;
%     end
%     figure('Name','mask'), imshow(mask);%vérification masque
    
    %Projection du masque sur la vidéo
    %vérification masque M projeté
%     mask4 = zeros(hautVid,largVid);
%     for x=1:length(X7)
%         if M3(Y8(x),X8(x))==1
%            mask4(Y7(x),X7(x))=1;
%         end
%     end
%     figure('Name','mask4'), imshow(mask4);
            
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

 end
 close(aviobj);