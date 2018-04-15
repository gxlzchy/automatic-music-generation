%Assumption 1. endtime of current node is defined as start time of next node except for chords. This eliminate slur lines.
%Assumption 2. The 0 time is the start and it is the first non-rest node, no matter which channel it is in.
format short;%display decimals in short
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi');
clc;
close all;
tic;

input_distr=zeros(1,326);
output_distr=zeros(1,326);
prob=[];
%--------------------------------------------
for i=1:3
    i
    try
        midi=readmidi(strcat('E:\capstone project large files\midi data\training_game_copy\train (',int2str(i),').mid'));
        notes = midiInfo(midi,0);
        %Converted Note Number Distribution
        notes=normalization(notes);
        notes=chord_classification(notes);
        X=notes(:,3)';
        X=fix(X);
        for k=1:size(X,2)-1
            input_distr(X(k))=input_distr(X(k))+1;
        end
        k=k+1;
        input_distr(X(k))=input_distr(X(k))+1;
    
    catch ME
        warning(strcat('Problem with ',int2str(i)));
        prob=[prob i];
        disp(ME.message);
    end
    
end
%--------------------------------------------
%output music
for i=1:20
    midi=readmidi(strcat('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\output\formal output\3_game_100_times\3_game_100Times (',int2str(i),').mid'));
    notes = midiInfo(midi,0);
    %Converted Note Number Distribution
    notes=normalization(notes);
    notes=chord_classification(notes);
    X=notes(:,3)';
    X=fix(X);
    for k=1:size(X,2)-1
        output_distr(X(k))=output_distr(X(k))+1;
    end
    k=k+1;
    output_distr(X(k))=output_distr(X(k))+1;
end
%--------------------------------------------
%cosine similarity
cossim=1-pdist2(input_distr,output_distr,'cosine');
cossim
%--------------------------------------------


toc;
% 
% 
% plot(1:325,input_distr(1:325))
% title('Distribution of Converted Notes')
% xlabel('Converted Note Number')
% ylabel('Frequencies');
% 
% figure;
% 
% plot(1:325,input_distr(1:325))
% title('Distribution of Converted Notes')
% xlabel('Converted Note Number')
% ylabel('Frequencies');
