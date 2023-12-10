test_input = [
  "..F7.",
  ".FJ|.",
  "SJ.L7",
  "|F--J",
  "LJ..."
];


# Part 1 ----------------------------------------------------

test_input_join = join(test_input, "");


function get_next_cell(curr_val::Int64, last_val::Int64, input::String, route)
    push!(route, input[curr_val])  
    w = convert(Int64, sqrt(length(input)))

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

# test input
route = get_next_cell(16, 11, test_input_join, ['S']);
convert(Int64, (length(route) - 1) / 2); # 8



# real input
input = readlines("2023/day/10/input");
input_join = join(input, "");


# inspection of the grid
# w = convert(Int64, sqrt(length(input_join)));
# ceil(curr_s_val / w); # row 32
# 4369 % w; # col 29

# input[31][28:30]; # JLJ  animal can't go north
# input[32][28:30]; # FSF  animal can't go east, could go west initially via F
# input[33][28:30]; # |LJ  animal could go south initially, via L


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
