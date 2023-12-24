classdef Image < handle
    methods(Static)
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

        function showImage(name, img)
            figure('Name', name, 'NumberTitle','off'),imshow(uint8(img));
        end

        function writeData(name, data)
            fid=fopen(name, 'w');
            fwrite(fid, data, 'ubit1');
            fclose(fid);
        end

    end
end

