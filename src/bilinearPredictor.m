classdef bilinearPredictor < Predictor
    %BILINEARPREDICTOR Summary of this class goes here
    %   Detailed explanation goes here
       
    methods(Static)        
        function result = apply(enc)
           [Nc, Nr] = size(enc);
            x = enc(1:2:end,1:2:end); x2 = enc(2:2:end,1:2:end);
            x3 = enc(1:2:end,2:2:end); x4 = enc(2:2:end,2:2:end);
            z = imresize(x,2,'bilinear');
            z(1:2:end,1:2:end)=x;
            z1 = z(1:2:end,1:2:end); z2 = z(2:2:end,1:2:end);
            z3 = z(1:2:end,2:2:end); z4 = z(2:2:end,2:2:end);
            result = uint8(zeros(Nr,Nc));
            result(1:2:end,1:2:end) = z1; 
            y2 = Predictor.errorCorrection(z2,x2); y3 = Predictor.errorCorrection(z3,x3); y4 = Predictor.errorCorrection(z4,x4);
            result(2:2:end,1:2:end) = y2; result(1:2:end,2:2:end) = y3; result(2:2:end,2:2:end) = y4;            
        end
    end
end

