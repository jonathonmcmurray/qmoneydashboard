.utl.require"req";
.utl.require"os";

// get landing page & extract verification token
r:.req.g"https://my.moneydashboard.com/landing";
o:first[ss[r;"<input name=\"__RequestVerificationToken"]];
c:first[c where (c:ss[r;"/>"])>o];
d:(!/)"S= "0:(1_r o+til c-o)except"\"";

// set up necessary headers
hd:()!();
hd[enlist"x-newrelic-id"]:enlist"UA4AV1JTGwAJU1BaDgc=";
hd["x-requested-with"]:"XMLHttpRequest";
hd["__requestverificationtoken"]:d`value;
hd["content-type"]:"application/json";

// send login request
/ check login file exists
if[()~key .os.hfile`.mdlogin;'"create ~/.mdlogin";exit 1];
/ use login file to make login payload
b:.j.j (`OriginId`CampaignRef`ApplicationRef`UserRef!("1";"";"";"")),`Email`Password!":"vs .os.hread`.mdlogin;
/ send login request
.req.post["https://my.moneydashboard.com/landing/login";hd;b];

/ retrieve personal data (i.e. transactions)
r:.req.g"https://my.moneydashboard.com/api/personalData";
