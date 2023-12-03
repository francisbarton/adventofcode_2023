using .Iterators;

test_input = [
  "467..114..",
  "...*......",
  "..35..633.",
  "......#...",
  "617*......",
  ".....+.58.",
  "..592.....",
  "......755.",
  "...\$.*....",
  ".664.598.."
];


# Part 1 -------------------------------------------------

function surr(x, w)
  [
    x - (w + 1), x - w, x - (w - 1),
    x - 1, x + 1,
    x + (w - 1), x + w, x + (w + 1)
  ]
end;


function test_num(x, si = safe_indices)
  o = x.offset
  l = length(x.match) - 1
  pos = o:(o+l)
  any(map(x -> x in si, pos)) ? parse(Int, x.match) : 0
end;


h1 = length(test_input); # 10
w1 = length(test_input[1]); # 10
j1 = join(test_input);

n_all1 = eachmatch(r"\d+", j1);
s_all1 = eachmatch(r"[^(.|0-9)]", j1);

s_indices1 = map(x -> x.offset, s_all1);
safe_indices = filter(x -> x in 1:length(j1), unique(collect(flatmap(x -> surr(x, w1), s_indices1))));

sum(map(test_num, n_all1)); # 4361

input = readlines("2023/day/3/input");

h2 = length(input); # 140
w2 = length(input[1]); # 140
j2 = join(input);

n_all2 = eachmatch(r"\d+", j2);
s_all2 = eachmatch(r"[^(.|0-9)]", j2);

s_indices2 = map(x -> x.offset, s_all2);

safe_indices = filter(x -> x in 1:length(j2), unique(collect(flatmap(x -> surr(x, w2), s_indices2))));

sum(map(test_num, n_all2))



# Part 2 -------------------------------------------------


g_all1 = eachmatch(r"\*", j1);
gear_indices = map(x -> x.offset, g_all1);

function gear_surr(gi, w, input)
  filter(x -> x in 1:length(input), collect(map(x -> surr(x, w), gi)))
end;

function inter_g(gi, num, w, input)
  gs = gear_surr(gi, w, input)
  
  o = num.offset
  l = length(num.match) - 1
  pos = o:(o+l)
  
  any(map(x -> x in gs, pos)) ? parse(Int, num.match) : 0
end;


function gear_nums(gi, nums_rm, w, input)
  filter(x -> x > 0, map(num -> inter_g(gi, num, w, input), nums_rm))
end;

gears_ls = filter(x -> length(x) == 2, map(x -> gear_nums(x, n_all1, w1, j1), gear_indices));

sum(map(x -> reduce(*, x), gears_ls)); # 467835


g_all2 = eachmatch(r"\*", j2);
gear_indices2 = map(x -> x.offset, g_all2);

gears_ls2 = filter(x -> length(x) == 2, map(x -> gear_nums(x, n_all2, w2, j2), gear_indices2));

sum(map(x -> reduce(*, x), gears_ls2))

