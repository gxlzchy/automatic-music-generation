addpath('J:\COMP4912\src');
addpath('J:\COMP4912\src\lib\matlab-midi-master\src');
clc;
prob=[];

for i=3:3
    i
    try
        midi=readmidi(strcat('J:\COMP4912\training\train (',int2str(i),').mid'));
        notes = midiInfo(midi,0);
        notes=filter_channel(notes);
        midi_new = matrix2midi(notes);
        writemidi(midi_new, strcat('J:\COMP4912\training_copy\train (',int2str(i),').mid'));
    catch ME
        warning(strcat('Problem with ',int2str(i)));
        prob=[prob i];
        disp(ME.message);
    end
    
end