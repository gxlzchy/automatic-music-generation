addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi');

load('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\classifier\training_matrix.mat','estTR','estE');

len=32;
velo=80;
dur=0.25;
trans=estTR;
emis=estE;
[seq,temp]=hmmgenerate(len,trans,emis);
seq
output=[];
st_time=[];
cnt=0;
%1-12 is single notes, 13-76 is chords, 77 is unrecognized chords.
for i=1:size(seq,2)
    if mod(i,8)==0
        dur=0.5;
    else
        dur=0.25;
    end
    if seq(i)>=1 && seq(i)<=12
        output=[output seq(i)+59];
        st_time=[st_time cnt];
        cnt=cnt+dur;
        
    elseif seq(i)>=13 && seq(i)<=76
        class_no=floor((seq(i)-13)/8)+1;
        lowest_note=mod((seq(i)-13),8);
        lowest_note=lowest_note+59;
        switch fix(class_no)
            case 1 %[4 3 3 2 4 3 3]
            	output=[output lowest_note lowest_note+4 lowest_note+7 lowest_note+10];
            case 2 %[3 4 3 2 3 4 3]
                output=[output lowest_note lowest_note+3 lowest_note+7 lowest_note+10];
            case 3 %[4 3 4 1 4 3 4]
                output=[output lowest_note lowest_note+4 lowest_note+7 lowest_note+11];
            case 4 %[3 3 4 2 3 3 4]
                output=[output lowest_note lowest_note+3 lowest_note+6 lowest_note+10];
            case 5 %[3 3 3 3 3 3 3]
                output=[output lowest_note lowest_note+3 lowest_note+6 lowest_note+9];
            case 6 %[4 4 3 1 4 4 3]
                output=[output lowest_note lowest_note+4 lowest_note+8 lowest_note+11];
            case 7 %[3 4 4 1 3 4 4]
                output=[output lowest_note lowest_note+3 lowest_note+7 lowest_note+11];
            case 8 %[4 4 2 2 4 4 2]
                output=[output lowest_note lowest_note+4 lowest_note+8 lowest_note+10];
            otherwise
                error('invalid chord class detected!');
        end
        st_time=[st_time cnt cnt cnt cnt];
        cnt=cnt+dur;
        
    elseif seq(i)==77
        output=[output randi(12)+59];
        st_time=[st_time cnt];
        cnt=cnt+dur;
    else
        error('invalid note number detected!');
    end
    n=size(output,2);
    notes=[];
    for i=1:n
        notes=[notes;[1 0 output(i) velo st_time(i) st_time(i)+dur]];
    end
    midi_new = matrix2midi(notes);
    writemidi(midi_new, 'D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\output\out.mid');
end

%%two things to do:
%no normalization
%perhaps no chords