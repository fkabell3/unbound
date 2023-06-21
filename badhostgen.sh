#!/bin/sh

url='https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts'
tmp="$(mktemp)"

printf "%s" "Downloading bad host..."
curl -s "$url" > badhost
if test "$?" -eq "0"; then
	printf "%s\n" " done."
else
	printf "\n%s\n" "curl failed!"
	exit 1
fi

printf "%s" "Generating unbound config file..."
grep '^0.0.0.0 ' badhost | sed '1d' | cut -d ' ' -f 2 > "$tmp"
while read line; do
	printf "%s\n%s\n" "local-zone: \"$line\" redirect" \
			  "local-data: \"$line A 0.0.0.0\""
	printf "\n"
done < "$tmp" > badhost.conf
printf "%s\n" " done."

rm "$tmp" badhost
exit 0
