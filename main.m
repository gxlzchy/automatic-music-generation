%Assumption 1. endtime of current node is defined as start time of next node except for chords. This eliminate slur lines.
%Assumption 2. The 0 time is the start and it is the first non-rest node, no matter which channel it is in.
format short;%display decimals in short
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi');
clc;
tic;
train_seq=[];
for i=1:117
    midi=readmidi(strcat('E:\capstone project large files\midi data\training_copy\train (',int2str(i),').mid'));
    notes = midiInfo(midi,0);
    notes=preprocessing(notes);
    X=notes(:,3)';
    X=fix(X);
    train_seq{end+1}=X;
    i
end

load('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\classifier\training_matrix.mat','estTR','estE');trans=estTR;emis=estE;
%[trans,emis]=initial_matrix();%estTR=trans;estE=emis;
celldisp(train_seq);

[estTR, estE]=hmmtrain(train_seq,trans,emis);
save('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\classifier\training_matrix','estTR','estE');
%midi_new = matrix2midi(Y);
%writemidi(midi_new, 'D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi\out1.mid');

toc;
%Utilities
%dur=X(:,6)-X(:,5);
%[X(:,3), dur(:)];
%X(X(:,1)==2,:)%select all high notes;
% midi_new = matrix2midi(A);
%writemidi(midi_new, 'D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi\out1.mid');
%use this to stop playing: clear sound