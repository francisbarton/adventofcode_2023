test_input = [
  "..F7.",
  ".FJ|.",
  "SJ.L7",
  "|F--J",
  "LJ..."
];


# Part 1 ----------------------------------------------------

test_input_join = join(test_input, "");


# recursive function - it won't work for the full input though
function get_next_cell(curr_val::Int64, last_val::Int64, input::String, route)
    push!(route, input[curr_val])  
    w = convert(Int64, sqrt(length(input))) # joined input version!

    if input[curr_val] == 'S'
        return(route)
    elseif input[curr_val] == '|'
        next_val = setdiff([curr_val + w, curr_val - w], last_val)
    elseif input[curr_val] == 'F'
        next_val = setdiff([curr_val + w, curr_val + 1], last_val)
    elseif input[curr_val] == 'J'
        next_val = setdiff([curr_val - w, curr_val - 1], last_val)
    elseif input[curr_val] == '7'
        next_val = setdiff([curr_val + w, curr_val - 1], last_val)
    elseif input[curr_val] == 'L'
        next_val = setdiff([curr_val - w, curr_val + 1], last_val)
    elseif input[curr_val] == '-'
        next_val = setdiff([curr_val - 1, curr_val + 1], last_val)
    else
        next_val = Nothing
    end

    if !isnothing(next_val)
        get_next_cell(next_val[1], curr_val, input, route)
    else 
        println("Error")
    end
end;

# test input - route vector needs to be initialised with a Char
# 16 and 11 are chosen by visual inspection of the grid
route = get_next_cell(16, 11, test_input_join, ['S']);
convert(Int64, (length(route) - 1) / 2); # 8 as expected



# real input
input = readlines("2023/day/10/input");
input_join = join(input, "");


# inspection of the grid
w = length(input)   # grid width and height
# w = convert(Int64, sqrt(length(input_join))); # grid width and height
# ceil(curr_s_val / w); # S is on row 32 for me
# curr_s_val % w; # S is in col 29 for me

# look at possible first move options
# input[31][28:30]; # JLJ  animal can't go north
# input[32][28:30]; # FSF  animal can't go east, could go west initially via F
# input[33][28:30]; # |LJ  animal could go south initially, via L


# refactor so we can use it non-recursively
# (attempting to use get_next_cell() failed due to stack overflow)
function get_next_cell_val(curr_val::Int64, last_val::Int64, input::String)
  w = convert(Int64, sqrt(length(input)))
  
  if input[curr_val] == 'S'
    next_val = 'S'
  elseif input[curr_val] == '|'
    next_val = setdiff([curr_val + w, curr_val - w], last_val)
  elseif input[curr_val] == 'F'
    next_val = setdiff([curr_val + w, curr_val + 1], last_val)
  elseif input[curr_val] == 'J'
    next_val = setdiff([curr_val - w, curr_val - 1], last_val)
  elseif input[curr_val] == '7'
    next_val = setdiff([curr_val + w, curr_val - 1], last_val)
  elseif input[curr_val] == 'L'
    next_val = setdiff([curr_val - w, curr_val + 1], last_val)
  elseif input[curr_val] == '-'
    next_val = setdiff([curr_val - 1, curr_val + 1], last_val)
  else
    next_val = Nothing
  end
  return(next_val[1])
end;

# s_val = match(r"S", input_join).offset; # 4369
# init_val = s_val - 1; # in this instance where we start by going west
# init_val = s_val + w; # if we had started by going south

# while loop version, using get_next_cell_var function above
function get_route2(input::String)
    route = ['S'] # dummy entry to initialise the vector
    last_val = match(r"S", input).offset # cell value for start point S
    init_val = last_val - 1 # we choose to start off going west
    push!(route, input[init_val]) # add first pipe value to route, then...
    
    while route[end] != 'S'
      next_val = get_next_cell_val(init_val, last_val, input)
      push!(route, input[next_val])
      last_val = init_val
      init_val = next_val
    end
    return(route)
  end;

real_route = get_route2(input_join);
convert(Int64, (length(real_route) - 1) / 2)


# Part 2 -----------------------------------------------------------

# Thanks to tips from the subreddit via the very patient Tom Jemmett...

# https://rosettacode.org/wiki/Shoelace_formula_for_polygonal_area#Julia
function shoelace_area(x, y)
  a = sum(i * j for (i, j) in zip(x, append!(y[2:end], y[1])))
  b = sum(i * j for (i, j) in zip(append!(x[2:end], x[1]), y))
  abs(a - b) / 2
end;


# return coordinates instead of pipe types
function get_route3(input::String)
  last_val = match(r"S", input).offset # cell value for start point S
  route = [last_val] # dummy entry to initialise the vector
  init_val = last_val - 1 # we choose to start off going west
  push!(route, init_val) # add first pipe value to route, then...
  
  while input[route[end]] != 'S'
    next_val = get_next_cell_val(init_val, last_val, input)
    push!(route, next_val)
    last_val = init_val
    init_val = next_val
  end
  return(route)
end;

route_ints = get_route3(input_join);
route_len = length(route_ints) - 1; # remove 1 for the repeated start/end point
x = map(x -> x % w == 0 ? w : x % w, route_ints);
y = map(x -> convert(Int64, ceil(x / w)), route_ints);

# via Shoelace
route_area = convert(Int, shoelace_area(x, y));

# Pick's theorem 
# https://en.wikipedia.org/wiki/Pick's_theorem
# A = i + (b/2) -1
# route_area = i + (route_len / 2) - 1
route_area + 1 - (route_len / 2) # = i (the answer)
