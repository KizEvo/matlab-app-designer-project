function [sum,h] = integral_simpson38(f,a,b,N)
    sum = f(a) + f(b);
    h = (b-a)/N;
    for i = 1:(N - 1)
         coef = ~mod(i,3)*2 + (1 - ~mod(i,3))*3;
         sum = sum + coef*f(a+i*h);
    end
    sum = sum * 3 * h / 8;
end