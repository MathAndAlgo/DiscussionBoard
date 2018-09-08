start = tic;
f = @(x)gamcdf(x,1,1);
for i = 1:1E4
    b = integral(f,0,1);
end
disp(b)
fprintf('%s elapsed: %f s ', mfilename,toc(start)) 
