function [gradientImage] = gradientImage(image, k, sigmaG, sigmaC)
    [X1,Y1] = meshgrid(-3 * sigmaG : 3 * sigmaG);
    [X2,Y2] = meshgrid(-3 * sigmaC : 3 * sigmaC);

    %dérivée de la gausienne 
    Gx = -X1 .* (exp(-(X1 .^ 2 + Y1 .^ 2) / (2 * sigmaG ^ 2)) / (2 * pi * sigmaG ^ 4));
    Gy = -Y1 .* (exp(-(X1 .^ 2 + Y1 .^ 2) / (2 * sigmaG ^ 2)) / (2 * pi * sigmaG ^ 4));
    
    Ix = conv2(image,Gx,'same');
    Ix2 = Ix .^ 2;
        
    Iy = conv2(image,Gy,'same');
    Iy2 = Iy .^ 2;
    
    Ixy = Ix .* Iy;
    
    %calcul de Cxx, Cyy et Cxy
    G = exp(-(X2 .^ 2 + Y2 .^ 2) / (2 * sigmaC ^ 2)) / (2 * pi * sigmaC ^ 2);
    
    Cxx = conv2(Ix2, G, 'same');
    Cyy = conv2(Iy2, G, 'same');
    Cxy = conv2(Ixy, G, 'same');

    gradientImage = Cxx .* Cyy - Cxy .^ 2 - k .*(Cxx + Cyy) .^ 2;
end