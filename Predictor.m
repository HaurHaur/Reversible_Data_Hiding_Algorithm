classdef Predictor < handle
    %PREDICTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Abstract)
        result = apply(enc)            
    end

    methods(Static)
        function result = errorCorrection(enc, org)
            [nr,nc] = size(enc);
            enc = double(enc);
            result = zeros(nr, nc);            
            org = double(org);
            tmp = mod(org, 128);            
            for i = 1:nr
                for j = 1:nc
                    result(i,j) = tmp(i, j) + setMSB(tmp, enc, i, j);
                end
            end            
            result = uint8(y);
        end

        function msb = setMSB(tmp, enc, i, j)
            df1 = abs(tmp(i, j)+128-enc(i, j));
            df0 = abs(tmp(i, j)-enc(i, j));
            if df1 <= df0
                msb = 128;
            else
                msb = 0;
            end
        end
    end
end

