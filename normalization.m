function X=normalization(X)
    X(:,3)=mod((X(:,3)-48),36)+48;
end