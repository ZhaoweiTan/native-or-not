%Input: type:"english"/"mandarin"/...; N:# of samples
%Output: data: cell array; F:sampling rate, F samples/second
function [data,fs] = readData(folder, type, suffix, N)
    %folder = 'Mandarin/';
    %suffix = '.wav';
    %type = 'english';
    
    %create cell array for storing data
    data = cell(N, 1);
    fs = cell(N, 1);

    for i = 1:N
        filename = strcat(folder, type, int2str(i), suffix);
        [data{i}, fs{i}] = audioread(filename);
        data{i} = data{i}(:,1);
        % fs{i}
        % You can also use the following line to obtain the sampling rate
        % However, in our dataset, the default rate is the small
        %[y,Fs] = audioread(filename);
    end
end

