.utl.require"qutil";
.utl.require"os";
.utl.require"req";
.utl.require`:lib/moneydash.q;
.utl.require`:lib/plot.q;

.utl.addOpt["noplot";0b;`plot];
.utl.parseArgs[];

t:.md.preparedata[];

if[plot;.md.plot .md.dailybalance t];

-1"Savings (last 3 months):";
show -3#select sum amount by date.month from t where accttype=`savings;

-1"\nCurrent budgets:";
b:.md.getbudgets[];
show delete goal from update pct:100*spend%goal,`$name from flip `name`goal`spend!flip b[;`Name`AmountGoal`AmountSpent];

-1"\nTotal spending (last 3 months):";
/* TODO - remove where clause once matched transactions are being removed */
show -3#select income:sum amount where 0<amount,outgoing:sum amount where 0>amount,total:sum amount by date.month from t where not tag in ("Repayments";"Savings";"Transfers")