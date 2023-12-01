
test_input = [
  "1abc2",
  "pqr3stu8vwx",
  "a1b2c3d4e5f",
  "treb7uchet"
];


pull_digits = function(x)
  d = filter(isdigit, map(only, split(x, "")))
  n = d[1]*d[end]
  parse(Int64, n)
end;

# sum(map(pull_digits, test_input)); # 142

input = readlines("2023/day/1/input");
sum(map(pull_digits, input))


test_input2 = [
  "two1nine",
  "eightwothree",
  "abcone2threexyz",
  "xtwone3four",
  "4nineeightseven2",
  "zoneight234",
  "7pqrstsixteen"
];

subs = Dict(
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"
);



pull_digits2 = function(x, subs)
  filt = join([join(keys(subs), "|"), join(values(subs), "|")], "|")
  ms = collect(eachmatch(Regex("$(filt)"), x, overlap = true))
  ds = map(x -> x in keys(subs) ? subs[x] : x, map(x -> x.match, ms))
  n = ds[1]*ds[end]
  parse(Int64, n)
end;

# sum(map(x -> pull_digits2(x, subs), test_input2)); # 281
sum(map(x -> pull_digits2(x, subs), input));

