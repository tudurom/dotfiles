#!/bin/sh
#
# Deploy dotfiles
#

# Check for conflicts
echo "Checking for conflicts"
for dir in */; do
	dir="$(echo "$dir" | tr -d '/')"
	(test "$dir" = "firefox" || test "$dir" = "startpage") && continue

	conflicts="$(xstow -i README.md -c "${dir}" 2>&1 )"
	printf "%s" "- ${dir}:"
	if [ -z "$conflicts" ]; then
		printf " NONE"
	else
		echo " $conflicts" && exit 1
	fi
	echo
done

# Symlink
echo "Deploying"
for dir in */; do
	(test "$dir" = "firefox/" || test "$dir" = "startpage/") && continue

	echo "- ${dir}"
	xstow -i README.md "$dir"
done

./pre_magic.sh
