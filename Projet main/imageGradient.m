function [imageGradient] = imageGradient(sigmaG,sigmaC,k,image)

    [X,Y]=meshgrid(-3 * sigmaG : 3 * sigmaG);
    
    % Dérivée de la gausienne 
    Gx = -X .* (exp(-(X .^ 2 + Y .^ 2) / (2 * sigmaG ^ 2)) / (2 * pi * sigmaG ^ 4));
    Gy = -Y .* (exp(-(X .^ 2 + Y .^ 2) / (2 * sigmaG ^ 2)) / (2 * pi * sigmaG ^ 4));
    
    Ix = conv2(image,Gx,'same');
    Iy = conv2(image,Gy,'same');
    
    Ixy = Ix .* Iy;
    Ix2 = Ix .^ 2;
    Iy2 = Iy .^ 2;
    
    % Calcul de Cxx, Cyy, Cxy avec G(x,y) et un nouveau sigma
    [X,Y] = meshgrid(-3 * sigmaC : 3 * sigmaC);
    
    G = exp(-(X .^ 2 + Y .^ 2) / (2 * sigmaC ^ 2)) / (2 * pi * sigmaC ^ 2);
    
    Cxx = conv2(Ix2, G, 'same');
    Cyy = conv2(Iy2, G, 'same');
    Cxy = conv2(Ixy, G, 'same');

    imageGradient = Cxx .* Cyy - Cxy .^ 2 - k .*(Cxx + Cyy) .^ 2;
    
end