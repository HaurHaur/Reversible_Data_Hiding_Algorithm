classdef test
    %Unit testing
    
    properties
    end
    
    methods(Static)
        function [result, key1, key2] = test_encoder()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [result, key1, key2] = encoder.apply();
        end
        
        function test_decoder()

        end

        function test_encryption()

        end

        function data = test_dataHiding()
            encrypter = xorEncrypter;
            encoder = Encoder(encrypter);
            [result, key1, key2] = encoder.apply();
            decoder = Decoder(encrypter, 0, 0);
            data = decoder.apply(result, key2);
        end
    end
end

