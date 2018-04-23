addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src');
addpath('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\lib\matlab-midi-master\src');
clc;
prob=[];

for i=3:3
    i
    try
        midi=readmidi(strcat('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\training\training\train (',int2str(i),').mid'));
        notes = midiInfo(midi,0);
        notes=filter_channel(notes);
        notes=normalization(notes)
        midi_new = matrix2midi(notes);
        writemidi(midi_new, strcat('D:\OneDrive\Year 4\COMP4911 CAPSTONE PROJECT\src\training\training_channel_0\train (',int2str(i),').mid'));
    catch ME
        warning(strcat('Problem with ',int2str(i)));
        prob=[prob i];
        disp(ME.message);
    end
    
end