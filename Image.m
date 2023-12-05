classdef Image
    properties
        image;
        heigt;
        weight;
    end
    methods
        function subImage = getSubImage(img, index)
            subImage = img.image(abs(mod(index,2)-2):2:end,floor(index/2)+1:2:end);
        end
    end
end

