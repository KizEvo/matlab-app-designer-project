function [sum,h] = integral_hinhthang(f,a,b,N)
    sum = f(a) + f(b);
    h = (b-a)/N;
    for i = 1:(N - 1)
         sum = sum + 2*f(a+i*h);
    end
    sum = sum * h / 2;
end