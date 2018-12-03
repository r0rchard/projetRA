function [M] = filtrageMain(M2)
    %à partir de l'image de la main 
    %renvoie une matrice qui vaut 0 dans la zone de la main, 1 ailleurs.

	%création des matrices de couleurs
    R = M2(:,:,1);
    G = M2(:,:,2);
    B = M2(:,:,3);
    
    %Création des seuils pour le vert et le bleu
    SeuilG = 118;
    seuilB = 150;
   
    
    masque1 = find(G > SeuilG & B > seuilB);
    masque2 = find(G < SeuilG & B < seuilB);
    
    R(masque1) = 1 ;
    G(masque1) = 1 ;
    B(masque1) = 1;
     
    R(masque2) = 0 ;
	G(masque2) = 0 ;
	B(masque2) = 0;
    
	M = cat(3,R,G,B);
end
