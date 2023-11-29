function result = lagrangeMethodInterpolation(~, xa, ya, x)
            sum = 0;
            for i = 1: length(xa)
                product = ya(i);
                for j = 1: length(xa) 
                    if i ~= j 
                        product = product*(x - xa(i))/(xa(i) - xa(j));
                    end 
                end 
                sum = sum + product;
            end 
            result = sum;
end