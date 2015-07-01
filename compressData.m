%Input: data: cell array; L: length of output, unit:second
function result = compressData(data, L, fs) %number of samples
    %disp('This is '), i
    q = size(data,1);
    
    result = resample(data,round((L * fs)/100000), round(q/100));
end