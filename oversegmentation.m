% Refer to milestone report 5.2.2 Oversegmentation.
% Assumption 3: Use delta to normalize duration, since the duration of each
% A note is an multiple of delta, denoted as m. This function repeats the
% note m times.

function Y=oversegmentation(X,delta)
dur=X(:,6)-X(:,5);
X1=[X(:,3), dur(:)];
[n,temp]=size(X1);
Y=[];
for i=1:n
    for j=1:fix(X1(i,2)/delta)
        X2=X(i,:);
        X2(5)=X2(5)+(j-1)*delta;
        X2(6)=X2(5)+delta;
        Y=[Y;X2];
    end
end

end