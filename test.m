classdef test
    %Unit testing
    
    properties
    end
    
    methods(Static)
        function [result, key1, key2, coefficient] = test_encoder()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [org, result, key1, key2, coefficient] = encoder.apply();
            Image.showImage('原圖', org);
            Image.showImage('加密影像', result);
        end
        
        function pred = test_bilinear_prediction()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [org, result, imageKey, ~, coefficient] = encoder.apply();
            predictor = bilinearPredictor;
            decoder = Decoder(encrypter, predictor);
            pred = decoder.apply(result, coefficient, imageKey);
            disp(['PSNR: ', num2str(Evaluator.psnr(org, pred)), 'dB']);
            Image.showImage('預測影像', pred);
        end

        function pred = test_dpcm_prediction()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [org, result, imageKey, ~, coefficient] = encoder.apply();
            predictor = dpcmPredictor;
            decoder = Decoder(encrypter, predictor);
            pred = decoder.apply(result, coefficient, imageKey);
            disp(['PSNR: ', num2str(Evaluator.psnr(org, pred))]);
            Image.showImage('預測影像', pred);            
        end

        function data = test_dataHiding()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [~, result, ~, key2, ~] = encoder.apply();
            decoder = Decoder(encrypter, 0);
            data = decoder.apply(result, key2);
            Image.writeData('data.txt', data);
        end

        function pred = test_2level_predictor()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [org, result, imageKey, ~, coefficient] = encoder.apply();
            predictor = {bilinearPredictor, dpcmPredictor};
            decoder = Decoder(encrypter, predictor);
            pred = decoder.apply(result, coefficient, imageKey);
            disp(['PSNR: ', num2str(Evaluator.psnr(org, pred))]);
            Image.showImage('預測影像', pred);             
        end
    end
end

