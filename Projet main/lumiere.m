function [H] = lumiere(R,G,B,V,hautM,largM)
    H = zeros(hautM,largM);
    for i = 1:hautM 
        for j = 1:largM
            if (V(i,j) == R(i,j)) 
                H(i,j) = ( G(i,j) - B(i,j))/ min(R(i,j),min(G(i,j),B(i,j)));
            elseif (V(i,j)==G(i,j))
                H(i,j) =  2 + ( V(i,j) - R(i,j) ) / min(R(i,j),min(G(i,j),B(i,j)));
            elseif (V(i,j)==B(i,j))
                H(i,j) =  4 + ( R(i,j) - G(i,j) ) / min(R(i,j),min(G(i,j),B(i,j)));
            end
        end
    end
end