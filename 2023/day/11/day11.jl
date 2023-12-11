# Part 1 ------------------------------------------------------

test_input = [
  "...#......",
  ".......#..",
  "#.........",
  "..........",
  "......#...",
  ".#........",
  ".........#",
  "..........",
  ".......#..",
  "#...#....."
];


double_trouble(x) = occursin(r"^\.+$", x) ? x^2 : x;

w = length(test_input);

t1 = split(join(map(double_trouble, test_input)), "");
w1 = convert(Int, length(t1) / w);
t1 = reshape(stack(t1), (w, w1));
 
t2 = join(map(double_trouble, map(join, eachrow(t1))));

locs = map(x -> x[1], findall("#", t2));

function calc_dist(a::Int64, b::Int64, w::Int64)
    a_x = a % w == 0 ? w : a % w
    a_y = convert(Int64, ceil(a / w))
    b_x = b % w == 0 ? w : b % w
    b_y = convert(Int64, ceil(b / w))
    
    abs(a_x - b_x) + abs(a_y - b_y)
end;
  
function get_dists(locs, w)
    s = 0
    while length(locs) > 1
      g, oth = Iterators.peel(locs)
      s += sum(map(x -> calc_dist(g, x, w), oth))
      locs = collect(oth)
    end
    return(s)
end;

get_dists(locs, w1); # 374

input = readlines("2023/day/11/input");

w = length(input);
  
t1 = split(join(map(double_trouble, input)), "");
w1 = convert(Int, length(t1) / w);
t1 = reshape(stack(t1), (w, w1));

t2 = join(map(double_trouble, map(join, eachrow(t1))));

locs = map(x -> x[1], findall("#", t2));
get_dists(locs, w1)

# Part 2 ------------------------------------------------------

# which rows expand
exp_rows = findall(map(!isnothing, map(x -> match(r"^\.+$", x), input)));
t1 = split(join(input), "");
t1 = reshape(stack(t1), (w, w));
t2 = map(join, eachrow(t1));
# which cols expand
exp_cols = findall(map(!isnothing, map(x -> match(r"^\.+$", x), t2)));

t3 = join(t2);

locs = map(x -> x[1], findall("#", t3));


function calc_dist(a::Int64, b::Int64, w::Int64, exp_rows::Vector{Int64}, exp_cols::Vector{Int64})
  a_x = a % w == 0 ? w : a % w
  a_y = convert(Int64, ceil(a / w))
  b_x = b % w == 0 ? w : b % w
  b_y = convert(Int64, ceil(b / w))

  x_range = a_x >= b_x ? (b_x:a_x) : (a_x:b_x)
  y_range = a_y >= b_y ? (b_y:a_y) : (a_y:b_y)
  
  exp_x = length(intersect(exp_rows, x_range)) * (1e6 - 1)
  exp_y = length(intersect(exp_cols, y_range)) * (1e6 - 1)

  abs(a_x - b_x) + abs(a_y - b_y) + exp_x + exp_y
end;

function get_dists(locs, w, er, ec)
  s = 0
  while length(locs) > 1
    g, oth = Iterators.peel(locs)
    s += sum(map(x -> calc_dist(g, x, w, er, ec), oth))
    locs = collect(oth)
  end
  return(s)
end;

get_dists(locs, w, exp_rows, exp_cols)

