test_input = [
    "Time:      7  15   30",
    "Distance:  9  40  200"
]

# Part 1 -----------------------------------------------------

times = map(x -> parse(Int64, x.match), eachmatch(r"\d+", test_input[1]));
dists = map(x -> parse(Int64, x.match), eachmatch(r"\d+", test_input[2]));

function solve(t, r)
    d = map(h -> h*(t-h), 1:t)
    length(d[d .> r])
end;

reduce(*, solve.(times, dists)); 288

input = readlines("2023/day/6/input");
times = map(x -> parse(Int64, x.match), eachmatch(r"\d+", input[1]));
dists = map(x -> parse(Int64, x.match), eachmatch(r"\d+", input[2]));
reduce(*, solve.(times, dists))


# Part 2 -----------------------------------------------------

# solve quadratic equation

# min and max values of solution range = solutions for h^2 - ht = d
# 
# There should be 2 values of (h^2 - ht) that equal d (the distance/record)
# The final answer will be the length of the integer range between those
# values (-2 as we need to beat the record not just equal it?)
#
# We have a quadratic equation to solve: h^2 - ht - d
# (h + x)(h - y) = 0 where x-y = t and xy = d ?? 

# test input
d = 940200;
t = 71530;

using Polynomials;
# p = Polynomial([-d, t, -1]);
# ans = roots(p)
# a_ints = Int(ceil(ans[1])), Int(floor(ans[2]))
# length(a_ints[1]:a_ints[2]); # 71503

# convert stepwise approach just above into a nice function
function get_ans(t::Int, d::Int)
  a = roots(Polynomial([-d, t, -1]))
  a1::Int, a2::Int = Int(ceil(a[1])), Int(floor(a[2]))
  length(a1:a2)
end;

d = parse(Int, reduce(*, string.(dists)));
t = parse(Int, reduce(*, string.(times)));
get_ans(t, d)