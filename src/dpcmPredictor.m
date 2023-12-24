classdef dpcmPredictor < Predictor
    methods(Static)      
        function result = apply(enc, coefficient)
            [Height,Width] = size(enc);
            A1 = double(enc);
            result=zeros(Height,Width);
            result(1:2:Height,1:2:Width)=A1(1:2:Height,1:2:Width);
            for i=1:2:Height-1
                for j=2:2:Width-2
                    result(i,j)=(result(i,j-1))*coefficient(1)+(result(i,j+1)*coefficient(2));
                    result(i,Width)=result(i,Width-1);
                end
            end

            for i=2:2:Height-2
                for j=1:2:Width-1
                    result(i,j)=(result(i+1,j))*coefficient(3)+(result(i-1,j)*coefficient(4));                          
                    result(Height,j)=result(Height-1,j);
                end
            end

            for i=2:2:Height
               for j=2:2:Width-2
                   result(i,j)=coefficient(5)*result(i,j-1)+coefficient(6)*result(i-1,j)+coefficient(7)*result(i-1,j-1)+coefficient(8)*result(i-1,j+1);
                   result(i,Width)=coefficient(5)*result(i,j-1)+coefficient(6)*result(i-1,j)+coefficient(7)*result(i-1,j-1);
                   
               end
            end
            result(2:2:end,1:2:end)=dpcmPredictor.errorCorrection(result(2:2:end,1:2:end),enc(2:2:end,1:2:end));
            result(1:2:end,2:2:end)=dpcmPredictor.errorCorrection(result(1:2:end,2:2:end),enc(1:2:end,2:2:end));
            result(2:2:end,2:2:end)=dpcmPredictor.errorCorrection(result(2:2:end,2:2:end),enc(2:2:end,2:2:end));
        end

        function coefficient = dpcmCoefficient(org)
            A = org;
            [Height,Width] = size(A);       
            I1=double(A);
            r00 = mean2(I1 .* I1);
            r01 = sum(sum(I1(:,2:Width).* I1(:,1:Width-1)))/(Height*(Width-1));
            r02 = sum(sum(I1(1:Height,3:Width).* I1(1:Height,1:Width-2)))/(Height*(Width-2));
            r10 = sum(sum(I1(2:Height,:).* I1(1:Height-1,:)))/((Height-1)*Width);
            r11 = sum(sum(I1(2:Height,2:Width).* I1(1:Height-1,1:Width-1)))/((Height-1)*(Width-1));
            r12 = sum(sum(I1(2:Height,3:Width).* I1(1:Height-1,1:Width-2)))/((Height-1)*(Width-2));
            r20 = sum(sum(I1(3:Height,1:Width).* I1(1:Height-2,1:Width)))/((Height-2)*Width);
            beta2=[r00 r02;r02 r00]\[r01 r01]'; beta2_1=beta2(1,1);beta2_2=beta2(2,1);            
            gama2=[r00 r20 ;r20 r00]\[r10 r10]'; gama2_1=gama2(1,1);gama2_2=gama2(2,1);
            alfa1 = [r00 r11 r10 r12; r11 r00 r01 r01; r10 r01 r00 r02 ;r12 r01 r02 r00]\[r01 r10 r11 r11]';
            alfa1_1=alfa1(1,1); alfa1_2=alfa1(2,1); alfa1_3=alfa1(3,1); alfa1_4=alfa1(4,1);
            coefficient = [beta2_1,beta2_2,gama2_1,gama2_2,alfa1_1,alfa1_2,alfa1_3,alfa1_4];
        end

    end
end

