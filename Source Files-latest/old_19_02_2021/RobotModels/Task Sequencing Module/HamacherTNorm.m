% calculate Hamacher T-norm
function THab=HamacherTNorm(a, b)

% please refer to: https://en.wikipedia.org/wiki/T-norm

if a~=0 && b~=0
    THab=a*b/(a+b-a*b);
else
    THab=0.0;
end