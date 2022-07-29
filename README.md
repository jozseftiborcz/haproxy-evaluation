# HAProxy feature evaulation

## Prerequisites
* docker
* some bash tools
* [asciinema](ascinema.org) for running the demos.

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

The test environment contains a HAProxy load balancher plus two whoami container which returns their container id.

To test the configuration use curl, for example: ``curl http://localhost``. If you repeat this call 5 times within 10 seconds HAProxy will respond with HTTP status code 429.

### Testing the token based rate limits

The HAProxy is configured to use RS256 signed tokens. The key is in the samples directory. The token contains a sub field which is an UUID. Paths under /api is rate limited based on the user's id.

A quick demonstration is here: 
* Working with one token (expired and valid, protected and not protected resources): `asciiname play casts/jwt-limit-part1.cast`
* Working with two tokens, checking stick-table statuses: `asciiname play casts/jwt-limit-part2.cast`


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

