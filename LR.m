% Add folder and its subfolders to search path 
addpath(genpath('..'));
    
% Read Data
[data_m, fs_m] = readData('mandarin/','mandarin_','.wav',50);
[data_e, fs_e] = readData('english/','english','.wav',50);

% Read Seg Info
M = cell(50,2);
for i = 1:50
    M{i,2} = csvread(['seg/english',int2str(i),'.csv']);
end

for i = 1:50
    M{i,1} = csvread(['seg/mandarin',int2str(i),'.csv']);
end


%?Cut Data
data_ee = cell(1,69);
data_mm = cell(1,69);

for i = 1:50
    for j = 1:69
        %[i,j,round(fs_e{i} * (M{i,2}(j,1))),round(fs_e{i} * (M{i,2}(j,2)))]
        data_ee{i,j}=data_e{i}(round(fs_e{i} * (M{i,2}(j,1)) ):round(fs_e{i} * (M{i,2}(j,2))) );
    end
end

for i = 1:50
    for j = 1:69
        data_mm{i,j}=data_m{i}(round(fs_m{i} * (M{i,1}(j,1)) ):round(fs_m{i} * (M{i,1}(j,2))) );
    end
end

clear data_m data_e


% Compress Data
L = 10;
result_m = cell(50,69);
result_e = cell(50,69);

for i = 1:50
    for j = 1:69
        result_e{i,j} = compressData(data_ee{i,j}, L, fs_m{i});
    end
end

%kkk = result_e;

for i = 1:50
    for j = 1:69
        result_m{i,j} = compressData(data_mm{i,j}, L, fs_m{i});
    end
end

clear data_mm data_ee

% Trim data
minl = 490;
for i = 1:50
    for j = 1:69
        result_e{i,j} = result_e{i,j}(1:minl,:);
    end
end

for i = 1:50
    for j = 1:69
        result_m{i,j} = result_m{i,j}(1:minl,:);
    end
end


% mfcc
mandarin = cell(50, 69);
english = cell(50, 69);
for i = 1:50
    for j = 1 : 69
        english{i,j} = featureExtract(result_e{i,j}, fs_e{i});
    end
end
for i = 1:50
    for j = 1 : 69
        mandarin{i,j} = featureExtract(result_m{i,j}, fs_m{i});
    end
end

clear result_m result_e


% format changing
X = cell(1, 69);
Y = [ones(50,1),zeros(50,1);zeros(50,1),ones(50,1)];
%lan = categorical(lan);
for j = 1:69
    for i = 1:50
        X{j}= [X{j};english{i,j}'];
    end
end
for j = 1:69
    for i = 1:50
        X{j}= [X{j};mandarin{i,j}'];
    end
end

clear english mandarin


B = cell(1,69);
for j = 1:69
    B{j} = mnrfit([X{j}(1:40,:);X{j}(61:100,:)],[Y(1:40,:);Y(61:100,:)]);
end

C = cell(1,69);
for j = 1:69
    C{j} = mnrval(B{j},X{j}(41:60,:));
end


D = cell(1,69);

for i = 1:20
    num1 = 0;
    num2 = 0;
    for j = 1:69
        if C{j}(i,1)>C{j}(i,2)
            num1 = num1 + 1;
        else
            num2 = num2 + 1;
        end
    end
    [num1,num2]
end




