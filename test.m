classdef test
    %Unit testing
    
    properties
    end
    
    methods(Static)
        function [result, key1, key2, coefficient] = test_encoder()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [result, key1, key2, coefficient] = encoder.apply();
        end
        
        function pred = test_bilinear_prediction()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [result, imageKey, ~, coefficient] = encoder.apply();
            predictor = bilinearPredictor;
            decoder = Decoder(encrypter, predictor, 0);
            pred = decoder.apply(result, coefficient, imageKey);
            Image.showImage('預測影像', pred);
        end

        function pred = test_dpcm_prediction()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [result, imageKey, ~, coefficient] = encoder.apply();
            predictor = dpcmPredictor;
            decoder = Decoder(encrypter, predictor, 0);
            pred = decoder.apply(result, coefficient, imageKey);
            Image.showImage('預測影像', pred);            
        end

        function data = test_dataHiding()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [result, ~, key2, ~] = encoder.apply();
            decoder = Decoder(encrypter, 0, 0);
            data = decoder.apply(result, key2);
            Image.writeData('data.txt', data);
        end
    end
end

