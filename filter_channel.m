function notes=filter_channel(notes)
    indices = notes(:,2) == 0;
    notes=notes(indices,:);%select channel 0 notes.
end