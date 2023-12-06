classdef Image < handle
    properties
        image;
        Nr;
        Nc;
        pixels;
    end
    methods
        function obj = Image(img)
            obj.image = img;
            [obj.Nr, obj.Nc] = size(img);
            obj.pixels = obj.Nr * obj.Nc
        end

        function subImage = getSubImage(img, index)
            subImage = img.image(abs(mod(index,2)-2):2:end,floor(index/2)+1:2:end);
        end

        function display(img)
            figure,imshow(uint8(img.image));
        end

    end
end

