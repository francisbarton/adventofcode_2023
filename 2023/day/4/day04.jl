test_input = (
  "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
);

# Part 1 --------------------------------------------

function split_card(x)
  (y, x) = split(x, ": ")
  x = split(x, " | ")
  x = map(x -> eachmatch(r"\d+", x), x)
  (l, r) = map(x -> map(x -> x.match, collect(x)), x)
  length(filter(x -> x in l, r))
end;

function card_points(x)
  m = split_card(x)
  m > 0 ? 2^(m-1) : 0
end;

# test input
sum(map(card_points, test_input)); # 13

# real input
input = readlines("2023/day/4/input");
sum(map(card_points, input))



# Part 2 --------------------------------------------

mutable struct Card
  matches::Int
  copies::Int
end;

function create_card(x, y = 1)
  Card(x, y)
end;


function update_cards(cards, n = 1)
  if n == length(cards) return(cards) end
  (copies, matches) = (cards[n].copies, cards[n].matches)
  map(x -> cards[n+x].copies += copies, 1:matches)
  update_cards(cards, n + 1)
end;

# test input
cards = map(create_card, map(split_card, test_input));
update_cards(cards);
sum(map(x -> x.copies, cards)); # 30

# real input
cards_full = map(create_card, map(split_card, input));
update_cards(cards_full);
sum(map(x -> x.copies, cards_full))
