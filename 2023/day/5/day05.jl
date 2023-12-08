test_input = [
  "seeds: 79 14 55 13",
  
  "seed-to-soil map:",
  "50 98 2",
  "52 50 48",
  
  "soil-to-fertilizer map:",
  "0 15 37",
  "37 52 2",
  "39 0 15",
  
  "fertilizer-to-water map:",
  "49 53 8",
  "0 11 42",
  "42 0 7",
  "57 7 4",
  
  "water-to-light map:",
  "88 18 7",
  "18 25 70",
  
  "light-to-temperature map:",
  "45 77 23",
  "81 45 19",
  "68 64 13",
  
  "temperature-to-humidity map:",
  "0 69 1",
  "1 0 69",
  
  "humidity-to-location map:",
  "60 56 37",
  "56 93 4"
];


# Part 1 --------------------------------------------------

seeds1 = map(x -> parse(Int, x.match), eachmatch(r"\d+", popfirst!(test_input)));

push!(test_input, "location-end");

function make_ranges(x::String, input::Vector)
    rx_results::Vector = map(l -> match(Regex("$x"), l), input)
    (b::Int, e::Int) = findall(!isnothing, rx_results)
    data_lines::Vector = input[(b+1):(e-1)]
    data_matches::Vector = map(x::String -> eachmatch(r"\d+", x), data_lines)
    range_data::Vector = map(x -> map(x::RegexMatch -> parse(Int, x.match), x), data_matches)
    build_range(x::Int, y::Int, z::Int) = (y-x) => [x:(x+z-1), y:(y+z-1)]
    Dict(map(x::Vector -> build_range(x[1], x[2], x[3]), range_data))
end;

function bump_in_range(x::Int, ranges::Pair)
    check_range(x::Int, y::UnitRange, z::UnitRange) = x in z ? x + (y[1] - z[1]) : x
    check_range(x, ranges[2][1], ranges[2][2])
end;


function next_val(type, seed, input)
    ranges = make_ranges(type, input)
    d = setdiff(accumulate(bump_in_range, ranges, init = seed), seed)
    isempty(d) ? seed : d[1]
end;


function process_seed(seed, input)
    sol = next_val("soil", seed, input)
    frt = next_val("fertilizer", sol, input)
    h20 = next_val("water", frt, input)
    lux = next_val("light", h20, input)
    tmp = next_val("temperature", lux, input)
    hdy = next_val("humidity", tmp, input)
    next_val("location", hdy, input)
end;

# test input
minimum(map(x -> process_seed(x, test_input), seeds1)); # 35

# real input
input = readlines("2023/day/5/input");
filter!(x -> length(x) > 0, input);
seeds2 = map(x -> parse(Int, x.match), eachmatch(r"\d+", popfirst!(input)));
push!(input, "location-end");

minimum(map(x -> process_seed(x, input), seeds2))


# Part 2 --------------------------------------------------

function get_seed_ranges(seeds)
  s = seeds[1:2:length(seeds)]
  r = seeds[2:2:length(seeds)]
  z = zip(s, r)
  map(x -> x[1]:(x[1] + x[2] -1), z)
end;

# test input

r1 = get_seed_ranges(seeds1);
all_seeds1 = reduce(vcat, r1);

all_locs1 = map(x -> process_seed(x, test_input), all_seeds1);
minimum(all_locs1); # 46
minimum(intersect(all_seeds1, all_locs1)); # 55




# real input...
# it gets real real, real quick


# variable setup (only required once - not really involved in functions below)
sr2 = get_seed_ranges(seeds2);
# all_seeds2 = reduce(vcat, r2); # yikes

all_types = (
  "soil", "fertilizer", "water", "light", "temperature", "humidity", "location"
);


function make_ranges(x::String, input::Vector)
  rx_results::Vector = map(l -> match(Regex("$x"), l), input)
  (b::Int, e::Int) = findall(!isnothing, rx_results)
  data_lines::Vector = input[(b+1):(e-1)]
  data_matches::Vector = map(x::String -> eachmatch(r"\d+", x), data_lines)
  range_data::Vector = map(x -> map(x::RegexMatch -> parse(Int, x.match), x), data_matches)
  build_range(x::Int, y::Int, z::Int) = (x-y) => [x:(x+z-1), y:(y+z-1)]
  Dict(map(x::Vector -> build_range(x[1], x[2], x[3]), range_data))
end;


function make_all_ranges(input, all_types)
  map(x -> make_ranges(x, input), all_types)
end;

all_ranges = make_all_ranges(input, all_types);
rev_ranges = reverse(all_ranges);

# part 2 functional functions


function pull_prev_loc(loc::Int64, dict::Dict)
  k = keys(dict)
  v = values(dict)
  lookup_ranges = map(x -> x[1], v)
  res = in.(loc, lookup_ranges)
  any(res) ? loc + collect(k)[res][1] : loc
end;


function get_next_loc(loc::Int64, dict::Dict)
  k = keys(dict)
  v = values(dict)
  lookup_ranges = map(x -> x[2], v)
  res = in.(loc, lookup_ranges)
  any(res) ? loc + collect(k)[res][1] : loc
end;



# function find_location_seed(ranges::Vector, seed::Int, all_seed_ranges::Vector)
#     t::Int = reduce(get_next_loc, ranges, init = seed)
#     return(any(t .∈ all_seed_ranges) ? t : Inf)
# end;
function find_location_seed(ranges::NTuple, seed::Int)
    reduce(get_next_loc, ranges, init = seed)::Int
end;

# 3719063518
minimum(map(x -> find_location_seed(all_ranges, x), r2[4][1:10000000]))
# 3729063518
minimum(map(x -> find_location_seed(all_ranges, x), r2[4][10000001:20000000]))
# 3739063518
minimum(map(x -> find_location_seed(all_ranges, x), r2[4][20000001:30000000]))


function find_start_seed(ranges::NTuple, seed_ranges::Vector, loc)
  t::Int = reduce(pull_prev_loc, ranges, init = loc)
  return(any(t .∈ seed_ranges) ? loc : Inf)
end;

loc_range6 = map(x -> x[1], values(all_ranges[7]))[6];
steprange1 = vcat(collect(loc_range6[1]:10000000:loc_range6[end]), loc_range6[end]);

res1 = map(x -> find_start_seed(rev_ranges, sr2, x), steprange1);

steprange2 = (loc_range6[1] + (10000000 * 15)):1000000:(loc_range6[1] + (10000000 * 18));
res2 = map(x -> find_start_seed(rev_ranges, sr2, x), steprange2);


steprange3 = (loc_range6[1] + (10000000 * 15)):100000:(loc_range6[1] + (10000000 * 15) + (1000000 * 17));
res3 = map(x -> find_start_seed(rev_ranges, sr2, x), steprange3);

steprange4 = (loc_range6[1] + 150654385):(loc_range6[1] + 150654395);
res4 = map(x -> find_start_seed(rev_ranges, sr2, x), steprange4)

loc_range6[1] + 150654385
loc_range6[1] + 150654386


loc_range1 = map(x -> x[1], values(all_ranges[7]))[3];
length(loc_range1)
steprange1 = collect(loc_range1[61212370]:loc_range1[61212400]);
res1 = map(x -> find_start_seed(rev_ranges, sr2, x), steprange1)
filter(x -> x < Inf, res1)


# 2969496342

loc_range1 = map(x -> x[1], values(all_ranges[7]))[7];
length(loc_range1)
steprange1 = collect(loc_range1[20605840]:loc_range1[20605860]);
res1 = map(x -> find_start_seed(rev_ranges, sr2, x), steprange1)
filter(x -> x < Inf, res1)



rev_ranges = reverse(all_ranges);

function find_start_seed(ranges, seeds, seed_ranges, n)
  t = reduce(pull_prev_loc, ranges, init = seeds[n])

  if any(t .∈ seed_ranges)
      return(t)
  elseif n == length(seed_ranges)
      return(Nothing)
  else 
      find_start_seed(ranges, seeds, seed_ranges, n + 1)
  end
end;


function find_all_start_seeds(ranges, loc_range, seed_ranges)
  function find_start_seed(ranges, loc)
      t = reduce(pull_prev_loc, ranges, init = loc)
      return(any(t .∈ seed_ranges) ? t : 0)
  end
  map(x -> find_start_seed(ranges, x), loc_range)
end;


location_ranges = map(x -> x[1], values(all_ranges[7]));

map(x -> find_start_seed(rev_ranges, x, r2, 1), location_ranges);
length(location_ranges[5])

min_range2 = minimum(find_all_start_seeds(rev_ranges, location_ranges[2], r2) .> 0)
min_range5 = minimum(find_all_start_seeds(rev_ranges, location_ranges[5], r2))
min_range8 = minimum(find_all_start_seeds(rev_ranges, location_ranges[8], r2))
min_range13 = minimum(find_all_start_seeds(rev_ranges, location_ranges[13], r2) .> 0)

# should find `Nothing`...
min_range1 = minimum([x > 0 ? x : Nothing for x in find_all_start_seeds(rev_ranges, location_ranges[1], r2)])




process_seed(min_sec2, input)
location_ranges[5][10000001]

process_seed(367508399, input)

reduce(pull_prev_loc, rev_ranges, init = 367508399)
process_seed(603678319, input)