#!/bin/bash
set -o errexit -o pipefail -o noclobber

function acquire_lock {
	if [ -e .tmp/lock_stats ]
	then
		[[ "$$" -eq "`cat .tmp/lock_stats`" ]] || return 1
	else
		mkdir -p .tmp/
		echo -n "$$" > .tmp/lock_stats
		chmod -wx .tmp/lock_stats
		[[ "$$" -eq "`cat .tmp/lock_stats`" ]] || return 1
	fi
}

function delete_lock {
	rm -f .tmp/lock_stats
}

acquire_lock || exit 1

trap delete_lock EXIT

rm -f files_count.stats
for dir in "$@"
do
	echo $(find $dir -type f | wc -l; echo $dir) >> files_count.stats
done

rm -f disk_usage.stats
du -s "$@" > disk_usage.stats

chmod -R a-w "$@"
