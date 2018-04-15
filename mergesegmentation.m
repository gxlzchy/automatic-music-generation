function output=mergesegmentation(notes)
    output=[];
    x=1;
    y=1;
    while (x<=size(notes,1))
        y=x;
        while (y<=size(notes,1) && notes(y,3)==notes(x,3)) y=y+1;end
        y=y-1;
        %x to y is a note
        output=[output;notes(x,:)];
        output(end,5)=notes(x,5);
        output(end,6)=notes(y,6);
        x=y+1;
    end
end