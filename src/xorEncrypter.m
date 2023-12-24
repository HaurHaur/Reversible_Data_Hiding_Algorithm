classdef xorEncrypter < Encrypte        
    methods(Static)
        function enc = encrypt(img, key)
            enc = double(bitxor(uint8(img), uint8(key)));
        end

        function org = decrypt(img, key)
            org = double(bitxor(uint8(img), uint8(key)));
        end
    end
end

