function [sum,h] = integral_simpson13(f,a,b,N)
    sum = f(a) + f(b);
    h = (b-a)/N;
    for i = 1:(N - 1)
         sum = sum + 2*(mod(i,2) + 1)*f(a+i*h);
    end
    sum = sum * h / 3;
end