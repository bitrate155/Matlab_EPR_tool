function ans = rescalib_TR( T )

if T>=17
    ans = 1;
else
    ans = -0.01794 + 0.1339 * T - 0.00581 * T*T + 8.38129E-5 * T*T*T;
end

end

