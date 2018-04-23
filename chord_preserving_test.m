%Assumption 1. endtime of current node is defined as start time of next node except for chords. This eliminate slur lines.
%Assumption 2. The 0 time is the start and it is the first non-rest node, no matter which channel it is in.
format short;%display decimals in short
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
clc;
tic;
train_seq=[];
temp=[];
prob=[];
nMusic=3;
nTimes=1;
name='canon';
i=3;
    try
        midi=readmidi(strcat('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\training\training\train (',int2str(i),').mid'));
        notes = midiInfo(midi,0);
        notes=filter_channel(notes);    
        [X, delta] = align(notes);%delta is the minimun duration
        X=oversegmentation(X,delta);
        X=normalization(X);
        X=chord_classification(X);

    end
seq=X(:,3)';








seg_coefficient=2;
len=32*seg_coefficient;%length of music
velo=80;%usually this is irrelevant;
dur=delta*1.91/seg_coefficient;%minimum duration of a note;


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
writemidi(midi_new, 'D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\demo\chord_preserving_demo\chord_preserving_canon.mid');
