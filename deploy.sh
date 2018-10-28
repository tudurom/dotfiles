#!/bin/sh
#
# Deploy dotfiles
#

OPTS="-ire README\..*"

IGNORE="firefox startpage meta kde"

isignored() {
	local ign="$1"

	for i in $IGNORE; do
		test "$i" = "$ign" && return 0
	done

	return 1
}

check_conflicts() {
	# Check for conflicts
	echo "Checking for conflicts"
	for dir in */; do
		dir="$(echo "$dir" | tr -d '/')"
		isignored "$dir" && continue

		conflicts="$(xstow $OPTS -c "${dir}" 2>&1 )"
		printf "%s" "- ${dir}:"
		if [ -z "$conflicts" ]; then
			printf " NONE"
		else
			echo " $conflicts" && exit 1
		fi
		echo
	done
}

# Symlink
echo "Deploying"
case "$1" in
	-o)
		xstow $OPTS "$2"
		;;
	*)
		check_conflicts
		for dir in */; do
			isignored "$(echo "$dir" | tr -d '/')" && continue

			echo "- ${dir}"
			xstow $OPTS "$dir"
		done
esac

./pre_magic.sh
