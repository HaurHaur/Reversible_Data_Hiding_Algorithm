classdef xorEncrypter < Encrypter
    %XORENCRYPTER Summary of this class goes here
    %   Detailed explanation goes here
        
    methods(Static)
        function enc = encrypt(img, key)
            %XORENCRYPTER Construct an instance of this class
            %   Detailed explanation goes here
            enc = double(bitxor(uint8(img), uint8(key)));
        end

        function org = decrypt(img, key)
            org = double(bitxor(uint8(img), uint8(key)));
        end
    end
end

