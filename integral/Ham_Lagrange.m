function results = Ham_Lagrange(xa,ya)
    syms x;
    n = length(xa);
    results = 0;
    for i = (1:n)
        temp = 1;
        for j = (1:n)
            if i ~= j
                temp = simplify( temp * ( (x - xa(j)) / (xa(i) - xa(j)))); 
            end
        end
        results = results + temp*ya(i);
        simplify(results);
    end
    results(x) = results;
end