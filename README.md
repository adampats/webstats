
### A simple Apache log parsing tool

Provided an Apache access.log, parse and output top N IPs based on count.

Usage:

```bash
ruby webstats.rb -f access.log -n 10 -m GET
```

The `-n` and `-m` arguments are optional.

Output:
```text
52.25.97.224    10
52.32.234.132   10
52.27.26.101    4
52.25.230.119   4
52.33.208.100   2
52.24.5.208     1
```
