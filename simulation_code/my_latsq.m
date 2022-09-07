function [M] = my_latsq(nflips)
M = latsq(7);
for i=1:nflips
    perm = randperm(7);
    col1 = M(:,perm(1));
    M(:,perm(1)) = M(:,perm(2));
    M(:,perm(2)) = col1;
end
end

