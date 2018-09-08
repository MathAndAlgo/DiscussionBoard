% system("matlab -nodisplay -r \"run('~/myscript.m'); exit\"",intern = T)

% system("matlab -nodisplay -r \"run('~/myscript.m'); exit\"")
start_tic = tic;

rv = prob.WeibullDistribution();

k = linspace(0.01, 0.99, 6);
b = [0.5 1 2.5 4 10];
R = zeros(length(k), length(b));

eps = 1e-8;
opt = optimset('TolX', 1e-6);

% matlab can't defines functions in script, use func handles instead
% note, the parameter b is passed as a property of rv.
f = @(x, p, k, rv) rv.cdf((1+k).*rv.icdf(p) - k.*rv.icdf(x));
F = @(p, k, rv)integral(@(x)f(x, p, k, rv), 0, 1, 'abstol', eps, 'reltol', eps);
root_p = @(k, rv)fzero(@(p)F(p, k, rv)-p, [0.01, 0.99], opt);


for j = 1:length(b)
    rv.B = b(j);
    for i = 1:length(k)
        R(i,j) = root_p(k(i), rv);
    end
end

R

fprintf('%s elapsed: %f s\n', mfilename, toc(start_tic));
exit