# HAProxy feature evaulation

## Prerequisites
* docker
* some bash tools

Building the docker image used for testing HAProxy with Lua extensions: 

 ./lua-proxy/build.sh

## Supporting scripts

Under `scripts`  directory we have:
* `gen-token.sh`: this generates various tokens for JWT based evaluations.
* `flood-and-wait.sh`: for rate limit testing.
* `haproxy-cli.sh`: queries haproxy api.

## Rate limiting

Starting the test enviornment:

 docker-compose --profile <profile> up

where profile is one of the following:
* **basic**: jsut basic infrastructure no rate limit. 
* **rl**: simple rate limit (block after 5 calls within 10s) for every path by IP address.
* **jwt**: jwt token validation (here you can use `gen-token.sh`) for path under `/api`
* **jwt-limit**: like profile jwt but api calls have a limit (5 calls within 5s per user) 

### Links
* [The original repository taken as an example](https://medium.com/@already.late/understanding-rate-limiting-on-haproxy-b0cf500310b1)
* [Blog post about how to extend HAProxy with Lua](https://www.haproxy.com/blog/5-ways-to-extend-haproxy-with-lua/)
* [HAProxy blog post about different rate limiting configurations](https://www.haproxy.com/blog/four-examples-of-haproxy-rate-limiting/)
* [An another rate limiting example with a little more sophisticated abuse detection](https://faun.pub/understanding-rate-limiting-on-haproxy-b0cf500310b1)
* [Onelogin's blog post explaining path based limits](https://www.onelogin.com/blog/rate-limiting-haproxy)
* [Stick table explanation](https://www.haproxy.com/blog/introduction-to-haproxy-stick-tables/)
* [JWT processing library from HAProxytech](https://github.com/haproxytech/haproxy-lua-oauth/)
## Links
* [HAProxy api explanation](https://www.haproxy.com/blog/haproxy-apis/)

