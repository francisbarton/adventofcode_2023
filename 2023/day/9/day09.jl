test_input = [
  "0 3 6 9 12 15",
  "1 3 6 10 15 21",
  "10 13 16 21 30 45"
];

test_input_num = map(x -> parse.(Int, x), map(x -> split(x, " "), test_input));


# Part 1 --------------------------------------------

function get_diffs(n::Vector{Int64}, end_vals::Vector{Int64} = [0])  
  push!(end_vals, n[end])
  m = Iterators.drop(n, 1)
  d = map(x -> x[1] - x[2], zip(m, n))
  if all(d .== 0)
    sum(end_vals)
  else
    get_diffs(d, end_vals)
  end
end;

sum(map(get_diffs, test_input_num)); # 114

input = readlines("2023/day/9/input");
input_num = map(x -> parse.(Int, x), map(x -> split(x, " "), input));

sum(map(get_diffs, input_num))


# Part 2 ------------------------------------------

input_num_rev = map(reverse, input_num);
sum(map(get_diffs, input_num_rev))