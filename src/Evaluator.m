classdef Evaluator
    methods(Static)        
        function dB=psnr(F,G)
            F=double(F);
            G=double(G);
            [M,N]=size(F);
            ERR1=abs(F-G);
            ERR2=ERR1.^2;
            dB=10*10*log10(M*N*(255^2)/sum(ERR2(:)))/10;
        end
    end
end

