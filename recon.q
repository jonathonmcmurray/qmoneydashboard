recon:{[t]
	t:update `$tag from t;
	select
		totalin:sum amount where (0<amount)&not tag in`Repayments`Transfers`Savings,
		totalout:sum amount where (0>amount)&not tag in`Repayments`Transfers`Savings,
		savingsin:sum amount where (0<amount)&tag=`Savings,
		savingsout:sum amount where (0>amount)&tag=`Savings,
		tfrin:sum amount where (0<amount)&tag=`Transfers,
		tfrout:sum amount where (0>amount)&tag=`Transfers,
		repayin:sum amount where (0<amount)&tag=`Repayments,
		repayout:sum amount where (0>amount)&tag=`Repayments
	by date.month
	from t
	}

