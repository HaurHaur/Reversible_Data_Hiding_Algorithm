classdef Encrypter < handle
    %ENCRYPTER Summary of this class goes here
    %   Detailed explanation goes here
       
    methods(Abstract)
        encrypt(img, key);        
        decrypt(img, key);
    end
end

