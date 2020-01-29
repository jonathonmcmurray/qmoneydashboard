// mapping for field names
.md.cmap:()!()
.md.cmap[`Account]:`acct
.md.cmap[`Date]:`date
.md.cmap[`CurrentDescription]:`description
.md.cmap[`OriginalDescription]:`origdescription
.md.cmap[`Amount]:`amount
.md.cmap[`L1Tag]:`tag
.md.cmap[`L2Tag]:`tag2
.md.cmap[`L3Tag]:`tag3

// get landing page & extract verification token
.md.getrvt:{[]
		r:.req.g"https://my.moneydashboard.com/landing";
		o:first[ss[r;"<input name=\"__RequestVerificationToken"]];
		c:first[c where (c:ss[r;"/>"])>o];
		d:(!/)"S= "0:(1_r o+til c-o)except"\"";
		:d`value;
	}

//authenticate with API - get & store authenication cookie
.md.auth:{[]
		// set up necessary headers
		hd:()!();
		hd[enlist"x-newrelic-id"]:enlist"UA4AV1JTGwAJU1BaDgc=";
		hd["x-requested-with"]:"XMLHttpRequest";
		hd["__requestverificationtoken"]:.md.getrvt[];
		hd["content-type"]:"application/json";

		// check login file exists
		if[()~key .os.hfile`.mdlogin;'"create ~/.mdlogin";exit 1];
		// use login file to make login payload
		b:.j.j (`OriginId`CampaignRef`ApplicationRef`UserRef!("1";"";"";"")),`Email`Password!":"vs .os.hread`.mdlogin;
		// send login request
		.req.post["https://my.moneydashboard.com/landing/login";hd;b];
	}

// retrieve personal data (i.e. transactions)
.md.getdata:{[]
		r:.req.g"https://my.moneydashboard.com/api/personalData";
		t:r`Transactions;
		t:update "D"$10#'Date from t;
		t:.md.cmap[cols t] xcol t;
		t:update description:count[i]#enlist"" from t where 10h<>type each description;
		:t;
	}

// overwrite data for a field in transactions
.md.overwrite:{[t;field;file]
		o:("*D *F***";1#",")0:file;
		o:(cols[o]except field) xkey o;
		:t lj o;
	}

// add manual transactions
.md.manual:{[t;file]
		:t uj ("*D *F***";1#",")0:file;
	}

// add initial account balances
.md.initial:{[t;file]
		:t uj ("*FD*";1#",")0:file;
	}

// prepare full data set including overwrites, manual etc.
.md.preparedata:{[]
		.md.auth[];
		t:.md.getdata[];
		t:.md.overwrite[t;`date;`:overwrite.csv];
		t:.md.manual[t;`:manual.csv];
		t:.md.initial[t;`:initial.csv];
		:`date xasc t;
	}

// get daily balance
.md.dailybalance:{[t]
		t:update sums amount^balance by acct from t;
		d:exec distinct date from t;
		b:{[x;y]sum exec last balance by acct from x where date<=y}[t]'[d];
		:([] date:d;balance:b);
	}