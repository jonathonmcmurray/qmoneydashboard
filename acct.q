.utl.require"qutil";
.utl.require"os";
.utl.require"req";
.utl.require`:lib/moneydash.q;
.utl.require`:lib/plot.q;

.utl.addOpt["noplot";0b;`plot];
.utl.parseArgs[];

t:.md.preparedata[];

/ remove credit card repayments
t:delete from t where tag like "Repayments",tag2 like "Credit Card*";
/* TODO add something here to flag unmatched credit card repayments */

if[plot;.md.plot .md.dailybalance t];