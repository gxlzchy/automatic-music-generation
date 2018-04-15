%Assumption 1. endtime of current node is defined as start time of next node except for chords. This eliminate slur lines.
%Assumption 2. The 0 time is the start and it is the first non-rest node, no matter which channel it is in.
format short;%display decimals in short
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi');
clc;
close all;
tic;
pitch=zeros(1,1000);
note_distr=zeros(1,326);
note_trans=zeros(326,326);
prob=[];

for i=1:1000
    i
    try
    midi=readmidi(strcat('E:\capstone project large files\midi data\training\train (',int2str(i),').mid'));
    notes = midiInfo(midi,0);
    %pitches
    notes=filter_channel(notes);
    X=notes(:,3)';
    X=fix(X);
    for j=1:size(X,2)
        pitch(X(j))=pitch(X(j))+1;
    end
    
    
    %Converted Note Number Distribution
    notes=normalization(notes);
    notes=chord_classification(notes);
    X=notes(:,3)';
    X=fix(X);
    for k=1:size(X,2)-1
        note_trans(X(k),X(k+1))=note_trans(X(k),X(k+1))+1;
        note_distr(X(k))=note_distr(X(k))+1;
    end
    k=k+1;
    note_distr(X(k))=note_distr(X(k))+1;
    
    catch ME
        warning(strcat('Problem with ',int2str(i)));
        prob=[prob i];
        disp(ME.message);
    end
    
end

toc;

save('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\statistics\statistics','note_distr','note_trans');
plot(15:120,pitch(15:120))
title('Distribution of Pitches')
xlabel('Pitches')
ylabel('Frequencies');
figure;
plot(1:325,note_distr(1:325))
title('Distribution of Converted Notes')
xlabel('Converted Note Number')
ylabel('Frequencies');
