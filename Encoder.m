classdef Encoder
    %ENCODER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        originalImage
        imageKey
        embeddingKey
        embeddingData
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
            key = reshape(uint8(round(rand(1, Nr*Nc)*(2^Nb-1))), Nr, Nc)
        end
    end

    methods
        
    end

end

