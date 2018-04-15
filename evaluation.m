%Assumption 1. endtime of current node is defined as start time of next node except for chords. This eliminate slur lines.
%Assumption 2. The 0 time is the start and it is the first non-rest node, no matter which channel it is in.
format short;%display decimals in short
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi');
clc;
close all;
tic;
n=1000;
cnt=0;
prob=[];
avg_cossim=0;
%--------------------------------------------
for i=1:n
    input_distr=zeros(1,326);
    i
    try
        midi=readmidi(strcat('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\training\training_mix\train (',int2str(i),').mid'));
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
    
    
    

    %--------------------------------------------
    %output music
    for j=1:20
        output_distr=zeros(1,326);
        midi=readmidi(strcat('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\output\formal output\1000_mix_1_times\1000_mix_1Times (',int2str(j),').mid'));
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

        %--------------------------------------------
        %cosine similarity
        cossim=1-pdist2(input_distr,output_distr,'cosine');
        if ~isnan(cossim)
            avg_cossim=avg_cossim+cossim;
            cnt=cnt+1;
        end
        %--------------------------------------------
    end
    catch ME
        warning(strcat('Problem with ',int2str(i)));
        prob=[prob i];
        disp(ME.message);
    end
end
avg_cossim=avg_cossim/cnt;
avg_cossim
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
