// in & out per month ignoring repayments, savings & transfers
update net:income+outgoing from select income:sum amount where amount>0,outgoing:sum amount where amount<0 by date.month from t where not tag in ("Repayments";"Savings";"Transfers")

