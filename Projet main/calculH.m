%On charge la vid�o
v = VideoReader('feuille.mp4');
%On r�cup�re la premi�re frame de la vid�o
video = rgb2gray(read(v,1));
%On r�cup�re les dimensions de cette frame (hauteur et largeur)
[hautVid,largVid]=size(video);

%Points d�tect�s manuellement
coordonnees = coins();
%R�cup�ration des coordon�es des coins de la feuille
coinVidHG=[coordonnees(1),coordonnees(5)];
coinVidHD=[coordonnees(2),coordonnees(6)];
coinVidBD=[coordonnees(3),coordonnees(7)];
coinVidBG=[coordonnees(4),coordonnees(8)];

%On cherche l'homographie
%Passage de l'image en noir et blanc pour ne travailler que sur une matrice
image = rgb2gray(imread('Clifford.jpg'));

%On r�cup�re les dimensions de l'image
[hautImg,largImg]=size(image);
%Stockage des coordonn�es des 4 coins de l'image
coinImgHG = [1,1];
coinImgHD = [largImg,1];
coinImgBD = [largImg,hautImg];
coinImgBG = [1,hautImg]; 

%R�solution de l'�quation pour retrouver Hp

%Calcul de l'homographie entre deux plans � partir de 8 points
matH = homography(coinVidHG,coinVidHD,coinVidBD,coinVidBG,coinImgHG,coinImgHD,coinImgBD,coinImgBG);

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
%essai

for x=1:length(X3)
        video(Y3(x),X3(x))=image(Y4(x),X4(x));
end
    
figure,imshow(video)