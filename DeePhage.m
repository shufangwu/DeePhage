% releasing as a software
function DeePhage(input_file,output_name,t)

if nargin==2
    t='0';
end

if exist([pwd,'/tmp'],'dir')
    cmd=['rm -rf ',pwd,'/tmp'];
    unix(cmd);
end
cmd=['mkdir ',pwd,'/tmp'];
unix(cmd);

fasta_file = fastaread(input_file);
reads_number = length(fasta_file);
for i = 1:length(fasta_file)    %% encode the seqence into one-hot mode
    seq = fasta_file(i).Sequence;
    seq_length = length(seq);
    calculate = calculate_lengthspace(seq_length,1800);  
    for j = 1:length(calculate)
        if j==length(calculate)
            seq_1 = fasta_file(i).Sequence(calculate(j):end);
            len_seq_1 = length(seq_1);
            if len_seq_1<=400
                test_matrix{i,j} =one_hot(seq_1,400); 
            elseif (400<len_seq_1)&&(len_seq_1<=800)
                test_matrix{i,j} =one_hot(seq_1,800);
            elseif (800<len_seq_1)&&(len_seq_1<=1200)
                test_matrix{i,j} =one_hot(seq_1,1200);  
            else 
                test_matrix{i,j} =one_hot(seq_1,1800);     
            end
        else
            seq_1 = fasta_file(i).Sequence(calculate(j):calculate(j)+1799);
            test_matrix{i,j} =one_hot(seq_1,1800);  
        end
    end
end
size2 = size(test_matrix,2);
save('tmp/encode_onehot.mat' ,'test_matrix' ,'reads_number' ,'size2')

cmd2 = 'python software_model_prediction.py ';
unix(cmd2);

clearvars -except fasta_file input_file  t output_name
t = str2num(t);
load tmp/data.csv

if (t<0) || (t>=0.5)
    disp('Warning!! The value of uncertain rate must be [0,0.5).');
    disp('The uncertain rate has been changed to : 0 ');
    t = 0 ;
    disp(newline)
end   

for i= 1:length(fasta_file)
    Group(i,1).Header = fasta_file(i).Header;
    Group(i,1).Length = length(fasta_file(i).Sequence);
    Group(i,1).lifestyle_score = data(i);
    if data(i)<=(0.5 - t)
        Group(i,1).possible_lifestyle = 'temperate';
    elseif ((0.5 - t)< data(i)) && (data(i)<0.5)
        Group(i,1).possible_lifestyle = 'uncertain_temperate';
    elseif ((0.5 + t)<= data(i)) && (data(i)<=1) 
        Group(i,1).possible_lifestyle = 'virulent';
    else
        Group(i,1).possible_lifestyle = 'uncertain_virulent';
    end
end

for i= 1:1:size(Group,1)
    result{i,1}=Group(i,1).Header;
    result{i,2}=Group(i,1).Length;
    result{i,3}=Group(i,1).lifestyle_score;
    result{i,4}=Group(i,1).possible_lifestyle;
end
disp(newline)

if size(output_name,2)<4 || ~strcmp(output_name(end-3:end),'.csv')
    disp('Warning!! The name of the output file has been changed to:')
    disp([output_name,'.csv'])
    disp('Note: The current version of DeePhage uses "Comma-Separated Values (CSV)" as the format of the output file!!')
    output_name=[output_name,'.csv'];
end

result=cell2table(result,'VariableNames',{'Header','Length','lifestyle_score','possible_lifestyle'});
writetable(result,output_name);
cmd=['rm -rf ',pwd,'/tmp'];
unix(cmd);
disp(' ')
disp('Finished.') 

end


  
