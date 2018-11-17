% enlever round de la fonction, donner une taille déjà div / 2 etc 
function [x,y] = maxlocal(D,xhg,yhg,taille)
    max = D(yhg,xhg); % changer nom var 
    x = xhg;
    y = yhg;
    % round à l'appel pas dans le for 
    for i=xhg-taille:xhg+taille
        for j=yhg-taille:yhg+taille
            if(D(j,i) > max)
                max = D(j,i);
                x = i;
                y = j;
            end
        end
    end
end