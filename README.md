# Telcon (Telnet Console)

Telcon is a bash script that uses DNS SRV records to directly access reverse telnet terminal server connections.

## Installation

Fetch via git.

```bash
git fetch https://github.com/seancrites/telcon.git
```

## Usage

```bash
./telcon.sh rtr.domain.com
```

Telcon will first try to lookup a DNS SRV record and use it's target and port information to initiate a telnet session. If the SRV lookup fails, it will fall back on trying to resolve 'con.rtr.example.com' which is usually a CNAME for an end device that is providing the telnet gateway to the console of the device you're trying to reach.

## Example

DNS SRV record example:

zone: domain.com

_con._tcp.[NAME]	IN	SRV	1 1 [PORT] [TARGET]

Example:

_con._tcp.rtr		IN	SRV	1 1 2015 ts.domain.com.

Cisco configuration:

ip host [NAME] [PORT] [LOOPBACK]

Example:

ip host rtr 2015 172.21.1.1

The [NAME] field do not need to match between the DNS record and the router config. The [TARGET] must be the hostname of the device serving as the terminal server.

## Reference
SRV Records: https://en.wikipedia.org/wiki/SRV_record
Cisco Terminal Servers: https://www.cisco.com/c/en/us/support/docs/dial-access/asynchronous-connections/5466-comm-server.html
Cisco Press: http://www.ciscopress.com/articles/article.asp?p=27650&seqNum=5

## License
[GPLv3](https://www.gnu.org/licenses/gpl-3.0.html)
