# qmoneydashboard

kdb+/q scripts for my.moneydashboard.com

# `acct.q`

Main entry script, loads libraries etc. & gets transactions in memory, does
some data clean up (manual transactions from `manual.csv`, overwriting dates
from `overwrite.csv`, adding initial balances from `initial.csv`). Removes
payments tagged as credit card repayments (to avoid dips/spikes where payment
is "sent" & "received" on different dates).

If started with `--noplot` on cmd line, does nothing after loading data.
Otherwise uses `lib/plot.q` to launch a plotly.js based plot of total balance
over time.

# `lib/moneydash.q`

Loads landing page to get request verification token for login

Sends POST request to login endpoint with username & password (read from
`$HOME`)

Requests personal data JSON via API (authenticated via cookies) & stores in `r`

Dependencies:

```bash
$ conda install -c jmcmurray req os
```

## Authentication

Username & password should be stored in `~/.mdlogin` in format `user:pass`

# `lib/plot.q`

Makes a plotly.js based plot, serves over HTTP & launches a web browser to plot
(on Linux desktops).

# To-do

- [ ] Exclude only repayments that are "matched"
- [ ] Flag up unmatched repayments?
- [ ] Also exclude "matched" transfers etc.
- [ ] Make exclusions optional as cmd line arg
- [ ] Add summary table(s) etc. to HTML page
- [ ] Allow plotting per account etc.
- [ ] Generate an email-able report (e.g. weekly/monthly report of in/out/saving etc.)