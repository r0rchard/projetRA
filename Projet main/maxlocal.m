function [x,y] = maxlocal(D, fenetre, absHG, ordHG)
    max = D(ordHG, absHG); 
    x = absHG;
    y = ordHG;
    for i = absHG-fenetre : absHG+fenetre
        for j = ordHG-fenetre : ordHG+fenetre
            if (D(j,i) > max)
                max = D(j,i);
                x = i;
                y = j;
            end
        end
    end
end