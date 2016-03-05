BASE=https://api.twitter.com/
PROXY=socks5://localhost:9050
LIMIT=10
F_CREDS=.credentials
F_TOKEN=.token
E_TOKEN=$(BASE)/oauth2/token
E_TL=$(BASE)/1.1/statuses/user_timeline.json?count=$(LIMIT)&include_rts=false&screen_name=
MEDIA=media
USER=yuki_the_maven

.PHONY: all clean token retoken dlrecent
all: dlrecent


.token:
	curl -X POST $(E_TOKEN) -u '$(shell cat $(F_CREDS) | head -n1)' --data 'grant_type=client_credentials' -H 'Content-type: application/x-www-form-urlencoded;charset=UTF-8' -x $(PROXY) -s | jq -r '.access_token' > $(F_TOKEN)

token: .token
	
retoken:
	$(MAKE) -B $(F_TOKEN)
	
media:
	mkdir -p $(MEDIA)

# bah, good enough as a starting point
dlrecent:
	curl '$(E_TL)$(USER)' -H 'Authorization: Bearer $(shell cat $(F_TOKEN) | head -n1)' -x $(PROXY) -s \
	| jq -r '.[] | .entities.media | select(. != null) | .[] | .media_url_https' \
	| xargs $(MAKE)

%.jpg: | media
	cd $(MEDIA) && \
	curl '$@' -x $(PROXY) -s > $(notdir $@)

clean:
	rm -rf $(MEDIA)

# ok so twtr compresses imgs in jpg, & downscales. will need to play worund with imagemagick's compare....
# gifs are converted to mp4. keep them out of mvp.
