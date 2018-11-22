function [image] = dessinerCroix(image,x,y,taille,epaisseur)
    demieTaille = round(taille/2);
    demieEpaisseur = round(epaisseur/2);
    
    % Barre verticale de la croix 
    for j=y-demieTaille:y+demieTaille
        for k=0-demieEpaisseur:0+demieEpaisseur
            image(j,x+k) = 255;
        end
    end
    
    % Barre horizontale de la croix 
    for j=x-demieTaille:x+demieTaille
        for k=0-demieEpaisseur:0+demieEpaisseur
            image(y+k,j) = 255;
        end
    end
end