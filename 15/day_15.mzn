% Use this editor as a MiniZinc scratch book

%parameters
int: n;
set of int: ingredients = 1..n;
array [ingredients] of string: names;
array [ingredients] of int: capacities;
array [ingredients] of int: durabilities;
array [ingredients] of int: flavours;
array [ingredients] of int: textures;
array [ingredients] of int: calories;

%variable solved for
array [ingredients] of var int: amounts;

%summing functions
var int: cap = max(0,sum(i in ingredients)(amounts[i] * capacities[i]));
var int: dur = max(0,sum(i in ingredients)(amounts[i] * durabilities[i]));
var int: fla = max(0,sum(i in ingredients)(amounts[i] * flavours[i]));
var int: tex = max(0,sum(i in ingredients)(amounts[i] * textures[i]));
var int: cal = max(0,sum(i in ingredients)(amounts[i] * calories[i]));

%final score function
var int: score = cap*dur*fla*tex;

%constraints
constraint forall(i in ingredients)(amounts[i] >= 0);
constraint forall(i in ingredients)(amounts[i] <= 100);
constraint sum(i in ingredients)(amounts[i]) == 100;

%part two constraint, uncomment for part 1
constraint cal = 500;

solve maximize(score);

output [ "score: " ++ show(score) ++ 
         " amounts:" ++ show(amounts) ++
         " values:" ++ show([cap, dur, fla, tex])];