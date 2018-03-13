function X=preprocessing(notes)

notes=filter_channel(notes);
%[y,Fs] = midi2audio(notes); 
%soundsc(y,Fs); % play sound

[X, delta] = align(notes);%delta is the minimun duration
%X=oversegmentation(X,delta);
X=normalization(X);
X=chord_classification(X);

end