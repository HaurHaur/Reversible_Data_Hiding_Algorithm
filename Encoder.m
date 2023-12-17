classdef Encoder < handle
    %ENCODER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        encrypter       %Encrypter
    end
    
    methods(Static)
        function obj = Encoder(Encrypterr)
            %ENCODER Construct an instance of this class
            obj.encrypter = Encrypterr;
        end

        function EMB = loadEmbedding()
            fid=fopen('book.txt');
            data=98304;
            emb=fread(fid,data,'ubit1');
            EMB=[emb',emb'];
            fclose(fid);
        end

        function key = generateKey(Nr, Nc, Nb)
            key = reshape(uint8(round(rand(1, Nr*Nc)*(2^Nb-1))), Nr, Nc);
        end

        function result = dataEmbedding(img, embedding)
            [Nr, Nc] = size(img);
            EMB2=reshape(embedding(1:Nr*Nc/4),Nr/2,Nc/2);
            EMB3=reshape(embedding(Nr*Nc/4+1:Nr*Nc/2),Nr/2,Nc/2);
            EMB4=reshape(embedding(Nr*Nc/2+1:3*Nr*Nc/4),Nr/2,Nc/2); 
            result = double(img);
            result(1:2:end,2:2:end)=EMB2*128+mod(result(1:2:end,2:2:end),128);
            result(2:2:end,1:2:end)=EMB3*128+mod(result(2:2:end,1:2:end),128);
            result(2:2:end,2:2:end)=EMB4*128+mod(result(2:2:end,2:2:end),128);       
        end
        
    end

    methods(Access = public)
        function [result, imageKey, embeddingKey] = apply(encoder)
            org = Image.loadImage();
            [Nr, Nc] = size(org);
            imageKey = encoder.generateKey(Nr, Nc, 8);
            imageEnc = encoder.encrypter.encrypt(org, imageKey);
            emb = encoder.loadEmbedding();
            embeddingKey = encoder.generateKey(1, Nr*Nc*0.75, 1);
            embeddingEnc = encoder.encrypter.encrypt(emb, embeddingKey);
            result = encoder.dataEmbedding(imageEnc, embeddingEnc);
            imwrite(uint8(result), "result.png")
        end
    end
end

