function [image] = entourerCoin(image, x, y, miTaille, miEp)
    
    for j = y-miTaille : y+miTaille
        for k = -miEp : miEp   
            image(j, x - miTaille + k) = 255;
            image(j, x + miTaille + k) = 255;
        end
    end
    
    for j = x-miTaille : x+miTaille
        for k = -miEp : miEp
            image(y - miTaille + k, j) = 255;
            image(y + miTaille + k, j) = 255;
        end
    end
end