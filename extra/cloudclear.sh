#!/bin/bash
#
# Clear CloudFlare cache / Lauched on app deploy
#


# API used: https://api.cloudflare.com/#zone-purge-all-files
purgeCache() {
	local result=$(curl -L --write-out %{http_code} --silent --output /dev/null \
	-X DELETE "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/purge_cache" \
	-H "X-Auth-Email: ${CF_EMAIL}" \
	-H "X-Auth-Key: ${CF_AUTH_KEY}" \
	-H "Content-Type: application/json" \
	--data '{"purge_everything":true}')
	echo "$result"
}

# Check if all config vars necessary are present
if [ -n "\$CF_EMAIL" ] && [ -n "\$CF_AUTH_KEY" ] && [ -n "\$CF_ZONE_ID" ] ; then
	echo "-----> Purging CloudFlare cache..."

	# launching the purging of cache
	result=$(purgeCache)

	# print result of API call
	if [ $result -ne "200" ]; then
		echo "-----> Failure: CloudFlare Cache Not Purged (${result} status)"
	else
		echo "-----> Success: CloudFlare Cache Purged (${result} status)"
	fi

else
	echo "-----> Purging CloudFlare Cache Issue: check configs vars CF_ZONE_ID, CF_AUTH_KEY & CF_EMAIL"
fi
