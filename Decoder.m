classdef Decoder < handle
    %DECODER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        predictors
        encrypter
        evaluator
    end
    
    methods
        function obj = Decoder(encrypterr, predictorss, evaluatorr)
            obj.encrypter = encrypterr;
            obj.predictors = predictorss;
            obj.evaluator = evaluatorr;
        end

        function result = apply(varargin)
            if nargin==3
                decoder=varargin{1}; org=varargin{2}; key=varargin{3};
                if(size(org) ~= size(key))                   
                    result = decoder.extractData(org, key);
                end
            end
        end

       function result = extractData(decoder, org, key)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            [Nr, Nc] = size(org);
            result = zeros(1, Nr*Nc*3/4);
            result(1:Nr*Nc*1/4) = bitshift(reshape(org(1:2:end,2:2:end), 1, Nr*Nc/4), -7);
            result(Nr*Nc/4+1:Nr*Nc/2) = bitshift(reshape(org(2:2:end,1:2:end), 1, Nr*Nc/4), -7);
            result(Nr*Nc/2+1:3*Nr*Nc/4) = bitshift(reshape(org(2:2:end,2:2:end), 1, Nr*Nc/4), -7);
            result = decoder.encrypter.decrypt(result, key);
            result = result';
        end
    end

end

