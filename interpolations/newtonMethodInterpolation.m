function result = newtonMethodInterpolation(~, xa, ya, x)
            n= length(xa);
            d = ya;
            for i = 1:n
                for j = 1:i-1
                    d(i) = (d(j) -d(i)) / (xa(j) - xa(i));
                end
            end
            
            f = zeros(n,n);
            f(:, 1) = ya;
            for j = 2:n
                for i = 1:n-j+1
                    f(i,j) = (f(i+1,j-1) - f(i, j-1)) / (xa(i+j-1) - xa(i));
                end
            end

            result = f(1,1);
            for j = 2:n
                term = 1;
                for i = 1:j-1
                    term = term * (x - xa(i));
                end
                result = result + f(1,j)*term;
            end
end