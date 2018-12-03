function [M] = filtrageMain(M2)
     R = M2(:,:,1);
     G = M2(:,:,2);
     B = M2(:,:,3);

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
