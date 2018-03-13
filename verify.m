addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\midi');

load('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\classifier\training_matrix.mat','estTR','estE');

trans=estTR;
emis=estE;
HUM=100;
RAM=500;
len=10;%only verify first 10 notes.
threshold=0.5;
prediction=[];

%human set
for i=1:HUM
    midi=readmidi(strcat('E:\capstone project large files\midi data\testing_real\testingHUM (',int2str(i),').mid'));
    notes = midiInfo(midi,0);
    notes=preprocessing(notes);
    X=notes(:,3)';
    X=fix(X(1:len));
    [temp,logpseq]=hmmdecode(X,trans,emis);
    prediction=[prediction;logpseq];
    i
end

%random set
for i=1:RAM
    midi=readmidi(strcat('E:\capstone project large files\midi data\testing_real\testingRAM (',int2str(i),').mid'));
    notes = midiInfo(midi,0);
    notes=preprocessing(notes);
    X=notes(:,3)';
    X=fix(X(1:len));
    [temp,logpseq]=hmmdecode(X,trans,emis);
    prediction=[prediction;logpseq];
    i
end

prediction
prediction(isnan(prediction))=-inf;%replace NaN with -infinity
[score,index]=sort(prediction,'descend');
score(HUM)
human=index(1:HUM);human=human(human<HUM);
random=index(HUM+1:HUM+RAM);random=random(random>HUM);
precision=(size(human,1)+size(random,1))/(HUM+RAM);