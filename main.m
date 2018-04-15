function main(nMusic,nTimes,name)
%Assumption 1. endtime of current node is defined as start time of next node except for chords. This eliminate slur lines.
%Assumption 2. The 0 time is the start and it is the first non-rest node, no matter which channel it is in.
format short;%display decimals in short
addpath('J:\COMP4912\src');
addpath('J:\COMP4912\src\lib\matlab-midi-master\src');
clc;
tic;
train_seq=[];
prob=[];

for i=1:nMusic
    i
    try
        midi=readmidi(strcat('J:\COMP4912\training\train (',int2str(i),').mid'));
        notes = midiInfo(midi,0);
        notes=filter_channel(notes);

    %     midi_new = matrix2midi(notes);
    %     [y,Fs] = midi2audio(midi_new);
    %     soundsc(y,Fs);
    


        [notes,delta]=preprocessing(notes);
        X=notes(:,3)';
        X=fix(X);
        if size(X,2)>5
            train_seq{end+1}=X;
        end
    catch ME
        warning(strcat('Problem with ',int2str(i)));
        prob=[prob i];
        disp(ME.message);
    end
end

temp=train_seq;
for i=1:nTimes-1
    train_seq=[train_seq temp];
end

%load('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\classifier\training_matrix.mat','estTR','estE');trans=estTR;emis=estE;
[trans,emis]=initial_matrix();%estTR=trans;estE=emis;
%celldisp(train_seq);

[estTR, estE]=hmmtrain(train_seq,trans,emis);
save(strcat('J:\COMP4912\src\classifier\training_matrix_',int2str(nMusic),'_',name,'_',int2str(nTimes),'_Times'),'estTR','estE','delta');
generate(nMusic,nTimes,name);
% midi_new = matrix2midi(notes);
% writemidi(midi_new, 'D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi\out1.mid');
%  [y,Fs] = midi2audio(midi_new);
%  soundsc(y,Fs);
toc;
%Utilities
%dur=X(:,6)-X(:,5);
%[X(:,3), dur(:)];
%X(X(:,1)==2,:)%select all high notes;
% midi_new = matrix2midi(A);
%writemidi(midi_new, 'D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi\out1.mid');
%use this to stop playing: clear sound