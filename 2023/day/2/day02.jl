test_input = [
  "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
  "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
  "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
  "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
  "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
];


# Part 1 ------------------------------------------

function split_to_dict(x)
  s = split(x, " ")
  s[2] => parse(Int, s[1])
end;

function split_string(x)
  (k, v) = split(x, ": ")
  k = match(r"\d+$", k).match
  d = map(x -> map(string, split(x, ", ")), map(string, split(v, "; ")))
  k => map(x -> map(split_to_dict, x), d)
end;

function filter_by_name(arr, colour)
  filter(x -> x.first == colour, arr)
end;

function check_game(x)
  x = split_string(x)
  k = x.first
  v = x.second
  chk = any(
    [
      collect(maximum(map(x -> filter_by_name(x, "blue"), v)))[1].second > 14,
      collect(maximum(map(x -> filter_by_name(x, "green"), v)))[1].second > 13,
      collect(maximum(map(x -> filter_by_name(x, "red"), v)))[1].second > 12
    ]
  )
  chk ? 0 : parse(Int, k)
end;

# sum(map(check_game, test_input)); # 8

input = readlines("2023/day/2/input");
sum(map(check_game, input))


# Part 2 ------------------------------------------


function game_power(x)
  x = split_string(x)
  v = x.second
  maxs = [
    collect(maximum(map(x -> filter_by_name(x, "blue"), v)))[1].second,
    collect(maximum(map(x -> filter_by_name(x, "green"), v)))[1].second,
    collect(maximum(map(x -> filter_by_name(x, "red"), v)))[1].second
  ]
  reduce(*, maxs)
end;

# sum(map(game_power, test_input)) # 2286
sum(map(game_power, input))
