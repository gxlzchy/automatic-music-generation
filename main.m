%Assumption 1. endtime of current node is defined as start time of next node except for chords. This eliminate slur lines.
%Assumption 2. The 0 time is the start and it is the first non-rest node, no matter which channel it is in.
format short;%display decimals in short
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi');
midi=readmidi('testing_chord.mid');
%[y,Fs] = midi2audio(midi); 
%soundsc(y,Fs); % play sound
notes = midiInfo(midi);
clc;
[n,temp]=size(notes);
[X, delta] = align(notes);%delta is the minimun duration
X=oversegmentation(X,delta);
X=normalization(X);
X=chord_classification(X);
%midi_new = matrix2midi(Y);
%writemidi(midi_new, 'D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi\out1.mid');


%Utilities
%dur=X(:,6)-X(:,5);
%[X(:,3), dur(:)];
%X(X(:,1)==2,:)%select all high notes;
% midi_new = matrix2midi(A);
%writemidi(midi_new, 'D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi\out1.mid');
%use this to stop playing: clear sound