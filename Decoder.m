classdef Decoder < handle
    %DECODER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        predictors
        encrypter
    end
    
    methods
        function obj = Decoder(encrypterr, predictorss)
            obj.encrypter = encrypterr;
            obj.predictors = predictorss;
        end

        function result = apply(varargin)
            if nargin==4
                decoder=varargin{1}; enc=varargin{2}; coefficient=varargin{3}; key=varargin{4};
                if(size(enc) ~= size(key))                   
                    result = decoder.extractData(enc, key);
                else
                    result = decoder.predictImage(enc, coefficient, key);
                end
            elseif nargin==5
                decoder=varargin{1}; enc=varargin{2}; coefficient=varargin{3}; imageKey=varargin{4}; dataKey=varargin{5};
                result = [decoder.predictImage(enc, coefficient, imageKey), decoder.extractData(enc, dataKey)];
            end
        end

       function result = extractData(decoder, org, key)
            [Nr, Nc] = size(org);
            result = zeros(1, Nr*Nc*3/4);
            result(1:Nr*Nc*1/4) = bitshift(reshape(org(1:2:end,2:2:end), 1, Nr*Nc/4), -7);
            result(Nr*Nc/4+1:Nr*Nc/2) = bitshift(reshape(org(2:2:end,1:2:end), 1, Nr*Nc/4), -7);
            result(Nr*Nc/2+1:3*Nr*Nc/4) = bitshift(reshape(org(2:2:end,2:2:end), 1, Nr*Nc/4), -7);
            result = decoder.encrypter.decrypt(result, key);
            result = result';
       end

       function result = predictImage(decoder, enc, coefficient, key)
            org = decoder.encrypter.decrypt(enc, key);
            result = org;
            for i=1:length(decoder.predictors)
                if isa(decoder.predictors{i},'dpcmPredictor')
                    result = decoder.predictors{i}.apply(result, coefficient);
                else
                    result = decoder.predictors{i}.apply(result);
                end
                if i ~= length(decoder.predictors)
                    coefficient = dpcmPredictor.dpcmCoefficient(result);
                end
            end

       end

    end

end

