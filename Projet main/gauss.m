function [listeCoins,numFrames] = gauss(video)
    numFrames = get(video, 'NumberOfFrames');
    
    %parametres et variables
    k = 0.05;
    sigmaG = 2;
    sigmaC1 = 3;
    sigmaC2 = 5;
    f = 18; %taille de la fenetre de detection pour la prediction

    %selection des coins de la premiere frame
    frame1 = read(video,1);
    figure, image(frame1);
    title('Ordre des clics : haut gauche, haut droite, bas gauche, bas droite');

    coinHG = ginput(1);
    coinHD = ginput(1);
    coinBG = ginput(1);
    coinBD = ginput(1);

    coinHG = round(coinHG);
    coinHD = round(coinHD);
    coinBG = round(coinBG);
    coinBD = round(coinBD);

    listeCoins = [coinHG coinHD coinBG coinBD];

    for i = 1 : numFrames %lecture de la video frame par frame
        frameI = read(video,i); %on utilise la i-eme frame
        frameI = rgb2gray(frameI); 

        D1 = gradient(frameI, k, sigmaG, sigmaC1);
        D2 = gradient(frameI, k, sigmaG, sigmaC2);
        D = D1 .* abs(D2);

        for coin = 1 : 8
            if(i < 3)
                listeCoins(i+1, coin) = listeCoins(i, coin);
            else
                listeCoins(i, coin) = listeCoins(i-1, coin) + floor((listeCoins(i-1, coin)-listeCoins(i-2, coin))/2);
            end

            if (mod(coin,2)==0 && i>2)
                [listeCoins(i, coin-1),listeCoins(i, coin)] = maxlocal(D, f, listeCoins(i, coin-1), listeCoins(i, coin));
                [frameI] = entourerCoin(frameI, listeCoins(i,coin-1), listeCoins(i,coin), 5, 3);
            elseif (mod(coin,2)==0)
                [frameI] = entourerCoin(frameI, listeCoins(i,coin-1), listeCoins(i,coin), 5, 3);
            end
        end
    end
end