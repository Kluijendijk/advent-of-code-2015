%parameters
int: n;
set of int: items = 1..n;
array [items] of int: cost;
array [items] of int: damage;
array [items] of int: armor;

int: bosshp;
int: bossdamage;
int: bossarmor;
int: hp = 100;

%variable solved for
array [items] of var int: amounts;

%damage functions
var 0..bosshp: damage_dealt = max(1, sum(i in items)(damage[i] * amounts[i]) - bossarmor);
var 1..bossdamage: damage_taken = max(1, bossdamage - sum(i in items)(amounts[i] * armor[i]));

%time to kill and time to die
var float: ttk = bosshp / damage_dealt;
var float: ttd = hp / damage_taken;

%used to compute ttk and ttd ceilings
var int: ttkceil;
var int: ttdceil;

%total cost
var int: total_cost = sum(i in items)(cost[i] * amounts[i]);

%constraints

%must have between 0 and 1 of each item (no dup. rings)
constraint forall(i in items)(amounts[i] >= 0);
constraint forall(i in items)(amounts[i] <= 1);

%sum of weapon amounts must be exactly 1
constraint sum(i in 1..5)(amounts[i]) == 1;

%sum of armor amounts must be <= 1
constraint sum(i in 6..10)(amounts[i]) <= 1;

%sum of ring amounts must be <= 2
constraint sum(i in 11..16)(amounts[i]) <= 2;

%ceil constraints
constraint ttkceil >= ttk;
constraint ttkceil < ttk + 1;
constraint ttdceil >= ttd;
constraint ttdceil < ttd + 1;

%must kill before or same turn as death
constraint ttkceil <= ttdceil;

%minimize total cost
solve minimize(total_cost);

output [ "cost: " ++ show(total_cost) ++
        " amounts: " ++ show(amounts) ++
        " ttk: " ++ show(ttk) ++ " ttd: " ++ show(ttd) ++
        " damage_dealt: " ++ show(damage_dealt) ++ 
        " damage_taken: " ++ show(damage_taken) ++ 
        ""];
