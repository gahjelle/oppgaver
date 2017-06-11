#!/usr/bin/env python3

import os
import sys
import time


class FileListing:

    def __init__(self, file_name):
        self.file_name = file_name
        self._file_listing = None

    @property
    def file_listing(self):
        if self._file_listing is None:
            with open(self.file_name, mode='r') as fid:
                self._file_listing = fid.readlines()
        return self._file_listing

    def __format__(self, format_spec):
        # Find indices for start and end markers
        start_marker, _, end_marker = format_spec.partition(' - ')
        start_idxs = [idx for idx, line in enumerate(self.file_listing)
                      if start_marker and line.strip() == start_marker]
        start_idx = start_idxs[0] + 1 if start_idxs else None
        end_idxs = [idx for idx, line in enumerate(self.file_listing)
                    if end_marker and line.strip() == end_marker]
        end_idx = end_idxs[-1] if end_idxs else None

        # Maybe the indices have been specified directly
        try:
            start_idx, end_idx = [int(idx) - 1 for idx in format_spec.partition('-') if not idx == '-']
        except ValueError:
            pass

        return ''.join(self.file_listing[start_idx:end_idx]).strip()


def main():
    files_to_process = [f for f in sys.argv[1:] if not f.startswith('-')]

    if '-c' in sys.argv:
        file_name = files_to_process[0]
        try:
            run_continuously(file_name)
        except KeyboardInterrupt:
            return

    for file_name in files_to_process:
        source_files = read_source_files(os.path.join(os.path.dirname(file_name), 'src'))
        preprocess_markdown(file_name, source_files)


def preprocess_markdown(file_to_process, source_files):
    file_to_write = file_to_process[:-3] + 'md' if file_to_process.endswith('.pre') else file_to_process + '_post'

    print('{} Processing {}, writing output to {}'.format(time.strftime('%H:%M:%S'), file_to_process, file_to_write))
    with open(file_to_process, mode='r') as f_in, open(file_to_write, mode='w') as f_out:
        for line in f_in:
            indent = len(line) - len(line.lstrip())
            try:
                f_out.write(line.format(**source_files).replace('\n', '\n' + ' ' * indent).rstrip(' '))
            except (IndexError, ValueError):
                f_out.write(line)


def read_source_files(directory):
    source_files = dict()
    for file_name in os.listdir(directory):
        path = os.path.join(directory, file_name)
        key = file_name.replace('.', '-')
        source_files[key] = FileListing(path)
    return source_files


def run_continuously(file_to_watch, timestamp=None):
    if timestamp:
        print('\nWatching for updates to {}. Use Ctrl-C to stop.\n'.format(file_to_watch))

    while True:
        current_timestamp = os.path.getmtime(file_to_watch)
        if current_timestamp != timestamp:
            break
        time.sleep(1)

    source_files = read_source_files(os.path.join(os.path.dirname(file_to_watch), 'src'))
    preprocess_markdown(file_to_watch, source_files)
    return run_continuously(file_to_watch, timestamp=current_timestamp)


if __name__ == '__main__':
    sys.exit(main())
