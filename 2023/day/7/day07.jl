test_input = [
  "32T3K 765",
  "T55J5 684",
  "KK677 28",
  "KTJJT 220",
  "QQQJA 483"
];

# Part 1 -----------------------------------------------------

# define a custom data structure, for clarity/neatness
struct Hand
  hand::String
  weight::String
  score::Int64
end;

function decide_type(hand::String)
  # creates a vector of sorted counts for matches for each string 
  hl::Vector{Int64} = sort(length.(collect.(map(x::Char -> eachmatch(Regex(string(x)), hand), unique(hand)))))
  
  # find type of hand using nested 'if/else' logic  
  hl == [5] ? "7" : hl == [1, 4] ? "6" : hl == [2, 3] ? "5" : hl == [1, 1, 3] ? "4" : hl == [1, 2, 2] ? "3" : hl == [1, 1, 1, 2] ? "2" : hl == [1, 1, 1, 1, 1] ? "1" : "0" # shouldn't happen!
end;

# parse the hand data from input in various ways to create Hand objects
function create_hand(x)
  hand::String, score::String = split(x, " ")
  split_hand::Vector{Char} = only.(split(hand, ""))
  type::String = decide_type(string(hand))
  
  # function to pull the index out of the list of card values and store it
  # as (effectively) a single digit in base 14 (Ace would be 13 which is 'd')
  # (originally I set this up as base 13 but of course A then comes out as 10!)
  # the type digit from decide_type then gets prepended to create effectively
  # a six digit number in base 14 that will just sort (a-d are automatically
  # treated as greater than 1-9 so it just sorts without difficulty).
  pl = "23456789TJQKA" # card priority list
  pr_score(x::Char) = string(findfirst(x, pl), base = 14)
  weight::String = type * join(map(pr_score, split_hand))
  
  Hand(hand, weight, parse(Int, score))
end;

# test input
# create hands and sort them by 'weight'
# the keys (indices) of the resulting vector then become the rank for that hand
ah = sort(map(create_hand, test_input), by = x -> x.weight);
sum(map(x -> x[1] * x[2].score, zip(keys(ah), values(ah)))); # 6440

# real input
input = readlines("2023/day/7/input");
bh = sort(map(create_hand, input), by = x -> x.weight);
sum(map(x -> x[1] * x[2].score, zip(keys(bh), values(bh))))



# Part 2 -----------------------------------------------------


function decide_type2(hand::String)
  # creates a vector of sorted counts for matches for each string 
  hl::Vector{Int64} = sort(length.(collect.(map(x::Char -> eachmatch(Regex(string(x)), hand), unique(hand)))))
  # returns the number of Jokers in the hand
  jl::Int64 = length(collect(eachmatch(Regex("J"), hand)))

  # find type of hand using nested 'if/else' logic  
  # use the j value (if any) to adjust the outcome as appropriate
  # (there are not as many permutations as I had feared!)
  hl == [5] ? "7" :
    hl == [1, 4] && jl in (1, 4) ? "7" : # promote to 5 o-a-k
    hl == [1, 4] ? "6" :
    hl == [2, 3] && jl in (2, 3) ? "7" : # promote to 5 o-a-k
    hl == [2, 3] ? "5" :
    hl == [1, 1, 3] && jl in (1, 3) ? "6" : # promote to 4-o-a-k (beats fh)
    hl == [1, 1, 3] ? "4" :
    hl == [1, 2, 2] && jl == 2 ? "6" : # promote to 4 o-a-k
    hl == [1, 2, 2] && jl == 1 ? "5" : # promote to full house
    hl == [1, 2, 2] ? "3" :
    hl == [1, 1, 1, 2] && jl in (1, 2) ? "4" : # promote to 3 o-a-k
    hl == [1, 1, 1, 2] ? "2" :
    hl == [1, 1, 1, 1, 1] && jl == 1 ? "2" : # promote to one-pair
    hl == [1, 1, 1, 1, 1] ? "1" :
    "0" # shouldn't happen!
end;


# parse the hand data from input in various ways to create Hand objects
function create_hand2(x)
  hand::String, score::String = split(x, " ")
  split_hand::Vector{Char} = only.(split(hand, ""))
  type::String = decide_type2(string(hand))
  
  pl = "J23456789TQKA" # adjusted priority list
  pr_score(x::Char) = string(findfirst(x, pl), base = 14)
  weight::String = type * join(map(pr_score, split_hand))
  
  Hand(hand, weight, parse(Int, score))
end;

# test input
ah2 = sort(map(create_hand2, test_input), by = x -> x.weight);
sum(map(x -> x[1] * x[2].score, zip(keys(ah2), values(ah2)))); # 5905

# real input
bh2 = sort(map(create_hand2, input), by = x -> x.weight);
sum(map(x -> x[1] * x[2].score, zip(keys(bh2), values(bh2))))