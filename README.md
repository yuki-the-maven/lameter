# lameter

ideally, check if you already posted an image + report how many times posted

## requirements

- tor
- curl
- jq
- make

## usage

get an api id & api secret (oauth application credentials, not user. user should be ok anyway.)

write them in form `<id>:<secret>` in a file named `.credentials`

`make`

this is going to download all jpgs found in last 10 tweets of my timeline in the `media` dir.

to tweak the target user or the tweet limit open `Makefile` and change the variables on top
