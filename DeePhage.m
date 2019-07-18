% releasing as a software
function DeePhage(input_file,output_name,t)
if nargin==2
    t ='0';
end
if exist([pwd,'/temp_file'],'dir')
    cmd=['rm -rf ',pwd,'/temp_file'];
    unix(cmd);
end
cmd=['mkdir ',pwd,'/temp_file'];
unix(cmd);
name = char(output_name);
fasta_file = fastaread(input_file);
reads_number = length(fasta_file);
fasta_file_30000 = calculate_lengthspace(reads_number,30000);
for k = 1:length(fasta_file_30000)
    if k==length(fasta_file_30000)
        reads_30000 = fasta_file_30000(k): reads_number;
    else
        reads_30000 = fasta_file_30000(k): fasta_file_30000(k+1)-1;
    end
    current_reads_number = length(reads_30000);
    c = 1;
    for i =  reads_30000 %% encode the seqence into one-hot mode
       
        seq = fasta_file(i).Sequence;
        seq_length = length(seq);
        calculate = calculate_lengthspace(seq_length,1800);  
        for j = 1:length(calculate)
            if j==length(calculate)
                seq_1 = fasta_file(i).Sequence(calculate(j):end);
                len_seq_1 = length(seq_1);
                if len_seq_1<=400
                    test_matrix{c,j} =one_hot(seq_1,400); 
                elseif (400<len_seq_1)&&(len_seq_1<=800)
                    test_matrix{c,j} =one_hot(seq_1,800);
                elseif (800<len_seq_1)&&(len_seq_1<=1200)
                    test_matrix{c,j} =one_hot(seq_1,1200);  
                else 
                    test_matrix{c,j} =one_hot(seq_1,1800);     
                end
            else
                seq_1 = fasta_file(i).Sequence(calculate(j):calculate(j)+1799);
                test_matrix{c,j} =one_hot(seq_1,1800);  
            end
        end
        c = c +1;
    end
    size2 = size(test_matrix,2);
    str1 = strcat('save(''temp_file/encode_onehot_',num2str(k),'.mat'',''test_matrix'',''current_reads_number'',''size2'');');
    eval(str1);
    cmd2 = strcat('python software_model_prediction_all_train.py ',32,'encode_onehot_',num2str(k),'.mat',32,'current_contig_',num2str(k),'.csv');   %%%%%
    unix(cmd2);
    clear test_matrix
       
end
clearvars -except input_file output_name t fasta_file
csv_file = dir('temp_file/*.csv');
data = [];
for s = 1:length(csv_file)
    str2 = strcat('load temp_file/current_contig_',num2str(s),'.csv');
    eval(str2);
    str3 = strcat('contig_3000 = current_contig_',num2str(s),';');
    eval(str3);
    data = [data;contig_3000];
end
t = str2num(t);
if (t<0) || (t>=1)
    disp('Warning!! The value of cutoff must be [0,1).');
    disp('The cutoff has been changed to : 0 ');
    t = 0 ;
    disp(newline)
end   

for i= 1:length(fasta_file)
    Group(i,1).Header = fasta_file(i).Header;
    Group(i,1).Length = length(fasta_file(i).Sequence);
    Group(i,1).lifestyle_score = data(i);
    if data(i)<=(0.5 - t/2)
        Group(i,1).possible_lifestyle = 'temperate';
    elseif ((0.5 - t/2)< data(i)) && (data(i)<0.5)
        Group(i,1).possible_lifestyle = 'uncertain_temperate';
    elseif ((0.5 + t/2)<= data(i)) && (data(i)<=1) 
        Group(i,1).possible_lifestyle = 'virulent';
    else
        Group(i,1).possible_lifestyle = 'uncertain_virulent';
    end
end

for i= 1:1:size(Group,1)
    data1{i,1}=Group(i,1).Header;
    data1{i,2}=Group(i,1).Length;
    data1{i,3}=Group(i,1).lifestyle_score;
    data1{i,4}=Group(i,1).possible_lifestyle;
end
disp(newline)

if size(output_name,2)<4 || ~strcmp(output_name(end-3:end),'.csv')
    disp('Warning!! The name of the output file has been changed to:')
    disp([output_name,'.csv'])
    disp('Note: The current version of DeePhage uses "Comma-Separated Values (CSV)" as the format of the output file!!')
    output_name=[output_name,'.csv'];
end

data1=cell2table(data1,'VariableNames',{'Header','Length','lifestyle_score','possible_lifestyle'});
writetable(data1,output_name);
cmd=['rm -rf ',pwd,'/temp_file'];
unix(cmd);
disp(' ')
disp('Finished.') 

end


  
