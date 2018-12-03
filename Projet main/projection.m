function [video] = projection(image,video,X1,Y1,X2,Y2)
    %à partir de l'image, de la vidéo, des positions des pixels de la vidéo, 
    %et des positions des pixels projetés, crée la projection de l'image
    %sur la vidéo.

    %division chaque matrice
    videoR=video(:,:,1);
    videoG=video(:,:,2);
	videoB=video(:,:,3);
    imageR=image(:,:,1);
    imageG=image(:,:,2);
	imageB=image(:,:,3);
    
    %application de l'image sur la video
    for x=1:length(X1)
        videoR(Y1(x),X1(x))=imageR(Y2(x),X2(x));
        videoB(Y1(x),X1(x))=imageB(Y2(x),X2(x));
        videoG(Y1(x),X1(x))=imageG(Y2(x),X2(x));
    end
    video=cat(3,videoR,videoG,videoB);
end