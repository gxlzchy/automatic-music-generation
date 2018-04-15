function [X,delta]=align(X)
    [n,temp]=size(X);
    X1=X(:,6);                              %Backup original stop time.
    
    
    %rounding X(:,5) and X(:,6) to facilitate comparing
    X(:,5)=round(X(:,5),3);
    X(:,6)=round(X(:,6),3);
    %aligning end time
    p=0;
    for i=1:n-1
        if X(i,5)~=X(i+1,5)             %Assumption 1
            X(i,6)=X(i+1,5);
            %chord alignment
            p=i-1;
            while ((p>0) && (X(p,5)==X(p+1,5)))
                X(p,6)=X(i+1,5);
                p=p-1;
            end
        end
    end
    
    dur=X(:,6)-X(:,5);
    delta=min(dur(1:p));
    if delta<0.001
        delta=0.001
    end
    for i=p+1:n
        dur(i)=ceil(floor(dur(i)/delta*10000)/10000)*delta;    %Assumption 1 for last one.
    end
%    blank=floor(blank/delta)*delta;
    X(:,6)=dur(:)+X(:,5);
%     for i=1:n
%         if X(i,6)-X1(i)>delta
%             temp=floor((X(i,6)-X1(i))/delta)*delta;
%             X(i,6)=X(i,6)-temp;
%             if (i==n || X(i,5)~=X(i+1,5))
%                 blank=blank+temp;
%             end
%         end
%     end

end