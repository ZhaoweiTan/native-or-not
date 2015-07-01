% Add folder and its subfolders to search path 
addpath(genpath('..'));


n_m = 50;
n_e = 150;

% Read Data
[data_m, fs_m] = readData('mandarin/','mandarin_','.wav', n_m);
[data_e, fs_e] = readData('english/','english','.wav', n_e);

% Read Seg Info
M = cell(n_e,2);
for i = 1:n_e
    M{i,2} = csvread(['seg/grid/english',int2str(i),'.csv']);
end

for i = 1:n_m
    M{i,1} = csvread(['seg/grid/mandarin',int2str(i),'.csv']);
end



%?Cut Data
data_ee = cell(n_e,69);
data_mm = cell(n_m,69);

for i = 1:n_e
    for j = 1:69
        %[i,j,round(fs_e{i} * (M{i,2}(j,1))),round(fs_e{i} * (M{i,2}(j,2)))]
        data_ee{i,j}=data_e{i}(round(fs_e{i} * (M{i,2}(j,1)) ):round(fs_e{i} * (M{i,2}(j,2))) );
    end
end

for i = 1:n_m
    for j = 1:69
        data_mm{i,j}=data_m{i}(round(fs_m{i} * (M{i,1}(j,1)) ):round(fs_m{i} * (M{i,1}(j,2))) );
    end
end

clear data_m data_e M


% Compress Data
L = 10;
result_m = cell(n_m,69);
result_e = cell(n_e,69);

for i = 1:n_e
    for j = 1:69
        result_e{i,j} = compressData(data_ee{i,j}, L, fs_e{i});
    end
end

%kkk = result_e;

for i = 1:n_m
    for j = 1:69
        result_m{i,j} = compressData(data_mm{i,j}, L, fs_m{i});
    end
end

clear data_mm data_ee

% Trim data
minl = 490;
for i = 1:n_e
    for j = 1:69
        result_e{i,j} = result_e{i,j}(1:minl,:);
    end
end

for i = 1:n_m
    for j = 1:69
        result_m{i,j} = result_m{i,j}(1:minl,:);
    end
end


% mfcc
mandarin = cell(n_m, 69);
english = cell(n_e, 69);
for i = 1:n_e
    for j = 1 : 69
        english{i,j} = featureExtract(result_e{i,j}, fs_e{i});
    end
end
for i = 1:n_m
    for j = 1 : 69
        mandarin{i,j} = featureExtract(result_m{i,j}, fs_m{i});
    end
end

clear result_m result_e


% format changing
X = cell(1, 69);
Y = [ones(n_e,1),zeros(n_e,1);zeros(n_m,1),ones(n_m,1)];
%lan = categorical(lan);
for j = 1:69
    for i = 1:n_e
        X{j}= [X{j};english{i,j}'];
    end
end
for j = 1:69
    for i = 1:n_m
        X{j}= [X{j};mandarin{i,j}'];
    end
end

clear english mandarin


%K-means

Km = cell(1,69);
for j = 1:69
    Km{j} = kmeans(X{j},2);
end

for i = 1:n_m+n_e
    res1 = 0;
    res2 = 0;
    ttt = zeros(n_m+n_e);
    for j = 1:69
        if Km{j}(i)==1
            res1 = res1 + 1;
        else 
            res2 = res2 + 1;
        end
    end
    if res1 > res2
        ttt(i)=0;
    else
        ttt(i)=1;
    end
end

right1 = 0;
right2 = 0;
for i = 1:1:n_m+n_e
    if ttt(i)==0 && Y(i,1)==0
        right1 = right1 + 1;
    end
    if ttt(i)==1 && Y(i,1)==1
        right1 = right1 + 1;
    end
end

for i = 1:1:n_m+n_e
    if ttt(i)==0 && Y(i,1)==1
        right2 = right2 + 1;
    end
    if ttt(i)==1 && Y(i,1)==0
        right2 = right2 + 1;
    end
end

[right1, right2]







%LR
tres1 = 115;
tres2 = 156;

LRmodel = cell(1,69);
for j = 1:69
    LRmodel{j} = mnrfit([X{j}(1:tres1,:);X{j}(tres2:(n_m+n_e),:)],[Y(1:tres1,:);Y(tres2:(n_m+n_e),:)]);
end

LRres = cell(1,69);
for j = 1:69
    LRres{j} = mnrval(LRmodel{j},X{j}(tres1+1:tres2-1,:));
end


%MV
LRmv = 0;

for i = 1:tres2-tres1-1
    num1 = 0;
    num2 = 0;
    for j = 1:69
        if LRres{j}(i,1)>LRres{j}(i,2)
            num1 = num1 + 1;
        else
            num2 = num2 + 1;
        end
    end
    if num1>num2 && Y(i+tres1,1)==1
        LRmv = LRmv + 1;
    end
    
    if num1<num2 && Y(i+tres1,1)==0
        LRmv = LRmv + 1;
    end
end

LRmv = LRmv / (tres2-tres1-1);



%MP
LRmp = 0;

for i = 1:tres2-tres1-1
    num1 = 1;
    num2 = 1;
    for j = 1:69
        num1 = num1 * LRres{j}(i,1);
        num2 = num2 * LRres{j}(i,2);
    end
    
    if num1>num2 && Y(i+tres1,1)==1
        LRmp = LRmp + 1;
    end
    
    if num1<num2 && Y(i+tres1,1)==0
        LRmp = LRmp + 1;
    end
end

LRmp = LRmp / (tres2-tres1-1);

[LRmv, LRmp]


