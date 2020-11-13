function newSavedTimes = deleteSavedTime(array, idx)
    idx = idx+1;
    newSavedTimes = array(:, :);
    n = length(array);
    for i=idx:n-1
        newSavedTimes(1, i) = newSavedTimes(1, i+1);
    end
    newSavedTimes(1, n) = 0;
end
 
