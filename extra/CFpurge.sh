#!/bin/bash
#
# Clear CloudFlare cache
# Lauched on app deploy
#

cat > "$APP_CHECKOUT_DIR"/.profile.d/CFpurge.sh <<EOF
  #!/bin/bash

  purgeCache() {
  local result=$(curl -L --write-out %{http_code} --silent --output /dev/null \
    -X DELETE "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/purge_cache" \
	-H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_AUTH_KEY}" \
	-H "Content-Type: application/json" \
    --data '{"purge_everything":true}')
    echo "$result"
  }

  if [ -n "\$CF_EMAIL" ] && [ -n "\$CF_AUTH_KEY" ] && [ -n "\$CF_ZONE_ID" ] ; then
    echo "-----> Purging Cloudflare cache"

  	result=$(purgeCache)

    if [ $result -ne "200" ]; then
      echo "-----> Cache Purge Failed: ${result}"
    else
      echo "-----> Cache Purge Success: ${result}"
    fi

  else
  	echo "-----> Purging Cloudflare Issue: check CF_ZONE_ID, CF_AUTH_KEY & CF_EMAIL"
  fi

EOF
