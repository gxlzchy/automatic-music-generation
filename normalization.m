function X=normalization(X)
    X(:,3)=mod((X(:,3)-60),12)+60;
end