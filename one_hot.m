function matrix = one_hot(seq,length_maxseq)

    seq=upper(seq);
    seq=adjust_uncertain_nt(seq);


    matrix=int8(zeros(length_maxseq,4));
    for j=1:1:min(length_maxseq,size(seq,2))
        if seq(j)=='A'
            matrix(j,:)=[0,0,0,1];
        elseif seq(j)=='C'
            matrix(j,:)=[0,0,1,0];
        elseif seq(j)=='G'
            matrix(j,:)=[0,1,0,0];
        elseif seq(j)=='T'
            matrix(j,:)=[1,0,0,0];
        else
            disp('error')
        end
    end
end


