function matH = homography(A,B,C,D,E,F,G,H)

%Construction d'une matrice à partir des coordonnées issuées des coins de l'image
matImg = matrice(E,F,G,H);

matSyst=[A(1),A(2),1,0,0,0,-A(1)*E(1),-A(2)*E(1); 
    0,0,0,A(1),A(2),1,-A(1)*E(2),-A(2)*E(2);
    B(1),B(2),1,0,0,0,-B(1)*F(1),-B(2)*F(1);
    0,0,0,B(1),B(2),1,-B(1)*F(2),-B(2)*F(2);
    C(1),C(2),1,0,0,0,-C(1)*G(1),-C(2)*G(1);
    0,0,0,C(1),C(2),1,-C(1)*G(2),-C(2)*G(2);
    D(1),D(2),1,0,0,0,-D(1)*H(1),-D(2)*H(1);
    0,0,0,D(1),D(2),1,-D(1)*H(2),-D(2)*H(2)];

X = linsolve(matSyst,matImg).';
matHp = [X 1];
matH = reshape(matHp,[3 3]).';

end