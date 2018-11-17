for i=1:10:n
    %On r�cup�re chaque frame de la vid�o
    video = read(obj,i);
    %On r�cup�re les dimensions de cette frame (hauteur et largeur)
    %[hautVid,largVid]=size(video);
    hautVid=size(video,1);
    largVid=size(video,2);
    
    %division chaque matrice
    videoR=video(:,:,1);
    videoG=video(:,:,2);
	videoB=video(:,:,3);
    
    %On stocke les coordonn�es des coins de la feuille
    coinVidHG=[historiqueAngles(i,1),historiqueAngles(i,2)];
    coinVidHD=[historiqueAngles(i,3),historiqueAngles(i,4)];
    coinVidBG=[historiqueAngles(i,5),historiqueAngles(i,6)];
    coinVidBD=[historiqueAngles(i,7),historiqueAngles(i,8)];
    
    %On cherche l'homographie
    %Passage de l'image en noir et blanc pour ne travailler que sur une matrice
    image = imread('Clifford.jpg');
    imageR=image(:,:,1);
    imageG=image(:,:,2);
	imageB=image(:,:,3);
    
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
    
    %Cr�ation d'une grille de dimension �gale � celles de la frame de la vid�o
    [A,B]=meshgrid(1:largVid,1:hautVid);
    
    %creation matrices
    dim=largVid*hautVid;
    X1 = reshape(A,[1,dim]);
    Y1 = reshape(B,[1,dim]);
    O = ones(1,dim);
    X1p = vertcat(X1,Y1,O);
    
    X2p=matH*X1p; %homographie
    
    X2=uint16(X2p(1,:)./X2p(3,:));
    Y2=uint16(X2p(2,:)./X2p(3,:));
    
    %find /!\ correspondance
    pos = intersect(intersect(find(Y2>=1),find(Y2<=hautImg)),intersect(find(X2>=1),find(X2<=largImg)));
    
    X4=X2(pos);
    Y4=Y2(pos);
    
    X3=X1(pos);
    Y3=Y1(pos);

%     posVideo = Y3 + (X3 - 1)*hautVid;
%     posImg = Y4 + (X4 - 1)*hautImg;
%     video([(posVideo) (posVideo + largVid*hautVid) (posVideo + 2*largVid*hautVid)]) = image([(posImg) (posImg + largImg*hautImg) (posImg + 2*largImg*hautImg)]);
%     video(posVideo)=image(posImg);
    for x=1:length(X3)
%       video(Y3(x),X3(x))=image(Y4(x),X4(x));
        videoR(Y3(x),X3(x))=imageR(Y4(x),X4(x));
        videoB(Y3(x),X3(x))=imageB(Y4(x),X4(x));
        videoG(Y3(x),X3(x))=imageG(Y4(x),X4(x));
    end
    video2=cat(3,videoR,videoG,videoB);
    imshow(video2);
    refresh;
end
