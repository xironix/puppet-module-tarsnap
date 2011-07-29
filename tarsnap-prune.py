#!/usr/bin/env python
#
# Prunes all tarsnap archives except:
#   today:         keep all 
#   yesterday:     keep upto 12
#   2 days ago:    keep upto 6
#   3-6 days ago:  keep upto 2 per day
#   7-30 days ago: keep upto 1 per day
#   30-X days ago: keep upto 1 per month     
#
# Usage:
#   tarsnap --list-archives -v | sort -k2r | tarsnap-prune | \
#      sed -e 's/^/-f /' | xargs tarsnap -d

import sys
import fileinput
import datetime

DATE_FORMAT = "%Y-%m-%d %H:%M:%S"

def parse_archive_list(archive_list):
    parsed_lines = []
    for line in archive_list:
        key, date_str = line.split("\t")
        if date_str:
            date = datetime.datetime.strptime(date_str.strip(), DATE_FORMAT)
            parsed_lines.append(dict(key=key, date=date))
    return parsed_lines


def partition_archives(archives):
    partitioned = {
        'today': [],
        'yesterday': [],
        '2_days_ago': [],
        '3_to_6_days_ago': [],
        '7_to_30_days_ago': [],
        'more_than_30_days_ago': [],
    }
    today = datetime.datetime.now().replace(hour=0, minute=0,
                                            second=0, microsecond=0)
    for archive in archives:
        if archive['date'] > today:
            partitioned['today'].append(archive)
        elif archive['date'] > today - datetime.timedelta(days=1):
            partitioned['yesterday'].append(archive)
        elif archive['date'] > today - datetime.timedelta(days=2):
            partitioned['2_days_ago'].append(archive)
        elif archive['date'] > today - datetime.timedelta(days=6):
            partitioned['3_to_6_days_ago'].append(archive)
        elif archive['date'] > today - datetime.timedelta(days=30):
            partitioned['7_to_30_days_ago'].append(archive)
        else:
            partitioned['more_than_30_days_ago'].append(archive)
    return partitioned


def archives_to_keep(partitions):
    to_keep = partitions['today']
    to_keep.extend(to_keep_per_interval(partitions['yesterday'], 12))
    to_keep.extend(to_keep_per_interval(partitions['2_days_ago'], 6))
    to_keep.extend(to_keep_per_interval(partitions['3_to_6_days_ago'], 2))
    to_keep.extend(to_keep_per_interval(partitions['7_to_30_days_ago'], 1))
    to_keep.extend(to_keep_per_interval(partitions['more_than_30_days_ago'],
                                       1, by_month=True))
    return to_keep


def to_keep_per_interval(archives, keep_per_interval, by_month=False):
    to_keep = []

    intervals = partition_archives_by_date(archives, by_month)
    for interval, archives_for_interval in intervals.items():
        if len(archives_for_interval) > keep_per_interval:
            step = len(archives_for_interval) / keep_per_interval
            to_keep.extend(archives_for_interval[::step][:keep_per_interval])
        else:
            to_keep.extend(archives_for_interval)

    return to_keep


def partition_archives_by_date(archives, by_month):
    dates = {}
    for archive in archives:
        date = datetime.date(archive['date'].year,
                             archive['date'].month,
                             1 if by_month else archive['date'].day)
        if date in dates:
            dates[date].append(archive)
        else:
            dates[date] = [archive]
    return dates


if __name__ == "__main__":
    archives = parse_archive_list([line for line in fileinput.input()])
    to_keep = archives_to_keep(partition_archives(archives))
    if len(to_keep) > 0:
        all_keys = set([archive['key'] for archive in archives])
        keys_to_keep = set([archive['key'] for archive in to_keep])
        for key in (all_keys - keys_to_keep):
            print key
    else:
        sys.stderr.write("Error: all archives would be deleted\n")
        sys.exit(1)
