function generate(nMusic,nTimes,name)
addpath('J:\COMP4912\src');
addpath('J:\COMP4912\src\lib\matlab-midi-master\src');
load(strcat('J:\COMP4912\src\classifier\training_matrix_',int2str(nMusic),'_',name,'_',int2str(nTimes),'_Times.mat'),'estTR','estE','delta');

for pp=1:20
%parameters
seg_coefficient=2;
len=64*seg_coefficient;%length of music
velo=80;%usually this is irrelevant;
dur=delta*4/seg_coefficient;%minimum duration of a note;

%genrate melody
trans=estTR;
emis=estE;
%trial: delete incomplete music sentence
seq=[];
while size(seq,2)<len
    [seq,states]=hmmgenerate(len+10,trans,emis);
    i=size(states,2);
    while (states(i)==states(i-1)) i=i-1;end
    seq=seq(1:i);
    whos seq;whos states;
end

notes=[];
for j=1:size(seq,2)
    notes=[notes;[1 0 seq(j) velo (j-1)*dur j*dur]];
end
notes=mergesegmentation(notes);

output=[];
%1-12 is single notes, 13-76 is chords, 77 is unrecognized chords.
for i=1:size(notes,1)
    if notes(i,3)>=1 && notes(i,3)<=36
        output=[output;notes(i,:)];
        output(end,3)=output(end,3)+47;
        
    elseif notes(i,3)>=37 && notes(i,3)<=324
        class_no=floor((notes(i,3)-36)/36)+1;
        lowest_note=mod((notes(i,3)-36),36);
        lowest_note=lowest_note+47;
        output=[output;notes(i,:);notes(i,:);notes(i,:)];
        switch fix(class_no)
            case 1 %[4 3 3 2 4 3 3]
                output(end-2,3) =lowest_note;
                output(end-1,3) =lowest_note+4;
                output(end,3)   =lowest_note+7;
            case 2 %[3 4 3 2 3 4 3]
                output(end-2,3) =lowest_note;
                output(end-1,3) =lowest_note+3;
                output(end,3)   =lowest_note+7;
            case 3 %[4 3 4 1 4 3 4]
                output(end-2,3) =lowest_note;
                output(end-1,3) =lowest_note+4;
                output(end,3)   =lowest_note+7;
            case 4 %[3 3 4 2 3 3 4]
                output(end-2,3) =lowest_note;
                output(end-1,3) =lowest_note+3;
                output(end,3)   =lowest_note+6;
            case 5 %[3 3 3 3 3 3 3]
                output(end-2,3) =lowest_note;
                output(end-1,3) =lowest_note+3;
                output(end,3)   =lowest_note+6;
            case 6 %[4 4 3 1 4 4 3]
                output(end-2,3) =lowest_note;
                output(end-1,3) =lowest_note+4;
                output(end,3)   =lowest_note+8;
            case 7 %[3 4 4 1 3 4 4]
                output(end-2,3) =lowest_note;
                output(end-1,3) =lowest_note+3;
                output(end,3)   =lowest_note+7;
            case 8 %[4 4 2 2 4 4 2]
                output(end-2,3) =lowest_note;
                output(end-1,3) =lowest_note+4;
                output(end,3)   =lowest_note+8;
            otherwise
                error('invalid chord class detected!');
        end
        
    elseif notes(i,3)==325
        output=[output;notes(i,:)];
        output(end,3)=randi(36)+47;
    else
        error('invalid note number detected!');
    end   
end
midi_new = matrix2midi(output);
writemidi(midi_new, strcat('J:\COMP4912\src\output\',int2str(nMusic),'_',name,'_',int2str(nTimes),'Times',' (',int2str(pp),').mid'));

end
end