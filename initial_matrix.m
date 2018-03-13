function [trans,emis]=initial_matrix()

    state_num=77;
    trans=rand(state_num,state_num);
    emis=rand(state_num,77);
    for i=1:state_num
        srow=sum(trans(i,:));
        trans(i,:)=1/srow;
        srow=sum(emis(i,:));
        emis(i,:)=1/srow;
    end
%{
    states=77;
    
    trans=zeros(states,states);
    trans(1:12,1:12)=0.3/11;%single notes->other single notes;
    trans(1:12,13:76)=0.3/64;%single notes->chords;
    trans(13:76,1:12)=0.3/12;%single chords->single notes;
    trans(13:76,13:76)=0.3/63;
    trans(77,:)=0.6/76;
    for i=1:states          % a state has higer prob. transiting to itself.
        trans(i,i)=0.4;
    end
    
    emis=zeros(states,states);
    emis(:,:)=0.5/76;
    for i=1:states          % a state has higer prob. emitting itself.
        emis(i,i)=0.5;
    end
%}    
end