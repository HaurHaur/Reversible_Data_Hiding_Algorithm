classdef Encoder < handle
    %ENCODER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        originalImage   %Image
        imageKey        %Image
        encryptedImage  %Image
        embeddingData
        embeddingKey
        encryptedData
        result          %Image
    end
    
    methods(Static)
        function obj = Encoder()
            %ENCODER Construct an instance of this class
            %   Detailed explanation goes here
            ORG = Image(Encoder.loadImage());
            obj.originalImage = ORG;
            key = Encoder.generateKey(ORG.Nr, ORG.Nc, 8);
            obj.imageKey = Image(key);
            obj.embeddingData = Encoder.loadEmbedding();
            obj.embeddingKey = Encoder.generateKey(1, ORG.Nr*ORG.Nc*0.75, 1);
        end
        
        function ORG = loadImage()
            [filename,pathname]=uigetfile({'*.bmp; *.tif','(*.bmp);(*.tif)';},'打開圖片');
            if isequal(filename,0)
               disp('Image selection cancelled.');
               return;
            else
               disp(['Image selected: ', fullfile(pathname, filename)])
            end
            
            IMG=imread([pathname,filename]);  
            DIM=size(IMG);
            if length(DIM)==3
                ORG=rgb2gray(IMG);
            elseif length(DIM)==2
                ORG=IMG;
            else
                disp('Image Loading error.');
            end
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

        function ENC = encryption(ORG, key)
            ENC = double(bitxor(uint8(ORG), uint8(key)));
        end
        
    end

    methods(Access = private)
        function dataEmbedding(encoder)
            Nr = encoder.originalImage.Nr;
            Nc = encoder.originalImage.Nc;
            EMB2=reshape(encoder.encryptedData(1:Nr*Nc/4),Nr/2,Nc/2);
            EMB3=reshape(encoder.encryptedData(Nr*Nc/4+1:Nr*Nc/2),Nr/2,Nc/2);
            EMB4=reshape(encoder.encryptedData(Nr*Nc/2+1:3*Nr*Nc/4),Nr/2,Nc/2);         
            encoder.result = Image(double(encoder.encryptedImage.image));
            encoder.result.image(1:2:end,2:2:end)=EMB2*128+mod(encoder.result.image(1:2:end,2:2:end),128);
            encoder.result.image(2:2:end,1:2:end)=EMB3*128+mod(encoder.result.image(2:2:end,1:2:end),128);
            encoder.result.image(2:2:end,2:2:end)=EMB4*128+mod(encoder.result.image(2:2:end,2:2:end),128);       
        end
    end

    methods(Access = public)
        function apply(encoder)
            encoder.encryptedImage = Image(encoder.encryption(encoder.originalImage.image, encoder.imageKey.image));
            encoder.encryptedData = encoder.encryption(encoder.embeddingData, encoder.embeddingKey);
            encoder.dataEmbedding();
        end
    end

end

