# qmoneydashboard

kdb+/q scripts for my.moneydashboard.com

# moneydash.q

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
