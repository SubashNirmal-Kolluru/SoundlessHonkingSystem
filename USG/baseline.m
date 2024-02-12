function max_row = baseline(a)
[rows,cols] = size(a);
max = 0;
max_row = 1;
for r = 1: rows
    if sum(a(r,:)) > max
        max = sum(a(r,:));
        max_row = r;
    end
end

% max_row = rows - max_row;
end