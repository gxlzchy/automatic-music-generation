function Y=chord_classification(X)
    X=sortrows(X,5);
    [n,temp]=size(X);
    Y=[];
    chord=[];
    
    for i=1:n
       if (i~=n)
           if X(i,5)==X(i+1,5) 
               continue;
           end
       end
       
       %detect chord
       chord=X(i,:);
       p=i-1;
       while ((p>0) && (X(p,5)==X(p+1,5)))
          chord=[chord;X(p,:)];
          p=p-1;
       end
       
       chord(:,3)=fix(chord(:,3));
       
       %select distinct chord pitches after normalization
       chord=sortrows(chord,3);
       i=1;
       while (i<=size(chord,1)-1)
           if chord(i,3)==chord(i+1,3)
               chord(i+1,:)=[];
           else
               i=i+1;
           end
       end
       note=chord_to_note(chord);
       Y=[Y;note];
    end
end

function note=chord_to_note(chord)
    chord(:,3)=chord(:,3)-47;
    lowest_note=min(chord(:,3));
    [temp,index]=max(chord(:,3));
    highest_notes=chord(index,:);
    %normalize and remove duplicated chords
    chord(:,3)=mod((chord(:,3)-1),12)+1;
    chord=sortrows(chord,3);
    i=1;
    while (i<=size(chord,1)-1)
       if chord(i,3)==chord(i+1,3)
           chord(i+1,:)=[];
       else
           i=i+1;
       end
   end
%------------------------------------------------------     
    %do not care about too complex chord
    if size(chord,1)>4 
        chord=chord(1:4,:);
    end
%------------------------------------------------------     
    %trivial case
    if size(chord,1)==1
        note=chord;
        return
    end
%------------------------------------------------------     
    %double chord
    if size(chord,1)==2
        note=highest_notes;
        return
    end
    
    
%------------------------------------------------------     
    %triads
    if size(chord,1)==3
        offset=[chord(2,3)-chord(1,3),
                chord(3,3)-chord(2,3)];
        offset=fix(offset);
        if match_chord_triad(offset,[4 3 3 2 4 3 3])==1
            note=chord(1,:);
            class_no=1;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #2 Minor seventh
        if match_chord_triad(offset,[3 4 3 2 3 4 3])==1
            note=chord(1,:);
            class_no=2;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #major seventh
        if match_chord_triad(offset,[4 3 4 1 4 3 4])==1
            note=chord(1,:);
            class_no=3;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #4 Half-deminished seventh
        if match_chord_triad(offset,[3 3 4 2 3 3 4])==1
            note=chord(1,:);
            class_no=4;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #5 Diminished seventh
        if match_chord_triad(offset,[3 3 3 3 3 3 3])==1
            note=chord(1,:);
            class_no=5;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #6 Augmented major seventh
        if match_chord_triad(offset,[4 4 3 1 4 4 3])==1
            note=chord(1,:);
            class_no=6;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #7 Minor major seventh
        if match_chord_triad(offset,[3 4 4 1 3 4 4])==1
            note=chord(1,:);
            class_no=7;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #8 Augmented seventh
        if match_chord_triad(offset,[4 4 2 2 4 4 2])==1
            note=chord(1,:);
            class_no=8;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #9 others
            note=chord(1,:);
            note(3)=325;
            return;
    end
    
    
%------------------------------------------------------ 
    %seventh Chord
    if size(chord,1)==4
        % #1 Dominant seventh
        if match_chord(chord,[4 3 3 2 4 3 3])==1
            note=chord(1,:);
            class_no=1;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #2 Minor seventh
        if match_chord(chord,[3 4 3 2 3 4 3])==1
            note=chord(1,:);
            class_no=2;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #major seventh
        if match_chord(chord,[4 3 4 1 4 3 4])==1
            note=chord(1,:);
            class_no=3;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #4 Half-deminished seventh
        if match_chord(chord,[3 3 4 2 3 3 4])==1
            note=chord(1,:);
            class_no=4;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #5 Diminished seventh
        if match_chord(chord,[3 3 3 3 3 3 3])==1
            note=chord(1,:);
            class_no=5;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #6 Augmented major seventh
        if match_chord(chord,[4 4 3 1 4 4 3])==1
            note=chord(1,:);
            class_no=6;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #7 Minor major seventh
        if match_chord(chord,[3 4 4 1 3 4 4])==1
            note=chord(1,:);
            class_no=7;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #8 Augmented seventh
        if match_chord(chord,[4 4 2 2 4 4 2])==1
            note=chord(1,:);
            class_no=8;
            note(3)=36+(class_no-1)*36+lowest_note;
            return;
        end
        % #9 others
            note=chord(1,:);
            note(3)=325;
            return;
    end
    
    
end

function flag=match_chord_triad(offset,chord_seq)
    flag=0;
    %Case 1, not big skip
    if offset(1)<=4 && offset(2)<=4
        for i=1:6
            if (offset(1)==chord_seq(i)) && ...
            (offset(2)==chord_seq(i+1))
                flag=1;
                return;
            end
        end
    end
    
    %Case 2, one big skip
    if offset(1)<=4 && offset(2)>4
        for i=1:5
            if (offset(1)==chord_seq(i)) && ...
            (offset(2)==chord_seq(i+1)+chord_seq(i+2))
                flag=1;
                return;
            end
        end
    end
    
    %Case 3, one big skip
    if offset(1)>4 && offset(2)<=4
        for i=1:5
            if (offset(1)==chord_seq(i)+chord_seq(i+1)) && ...
            (offset(2)==chord_seq(i+2))
                flag=1;
                return;
            end
        end
    end
    
    %it is not possible to have two big skips.
end

% use a sliding window of size 3 to match the chord with the sequence.
function flag=match_chord(chord, chord_seq)
    offset=[chord(2,3)-chord(1,3),
            chord(3,3)-chord(2,3),
            chord(4,3)-chord(3,3)];
    offset=fix(offset);
    flag=0;
	for i=1:5
        if (offset(1)==chord_seq(i)) && ...
            (offset(2)==chord_seq(i+1)) && ...
            (offset(3)==chord_seq(i+2))
           flag=1;
           return;
        end
    end
end