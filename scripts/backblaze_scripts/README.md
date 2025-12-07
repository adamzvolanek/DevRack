# backblaze_scripts

Automated set of scripts that backup and restore (Unraid) shares to backblaze by bucket name with output logging to a defined location.

Verify and test at your own risk! Assumes 8 transfer threads at script execution.

Always use `--dry-run` prior to running these commands!

## Usage

Paste the contents of the script into Unraid's User Scripts and create a new script. Replace the following items:

- `ShareName`= with the Unraid share name
- `BucketName`= with B2 bucket name
- `LogLocation`= with logging location, e.g. `/mnt/user/logs/BackBlaze_Logs`

### Flags and Options

`--progress`

- Displays a live progress indicator of the sync operation, showing transferred files, speed, and estimated time remaining.

`--transfers 8`

- Sets the number of file transfers to run in parallel.
  - In this case, 8 files will be uploaded/downloaded simultaneously, which can improve performance.

`--verbose`

- Provides detailed information about the operation. Useful for debugging or monitoring activity.

`--exclude .Recycle.Bin/**`

- Excludes all files and folders under .Recycle.Bin/ from syncing.
  - The /** ensures all nested contents are also ignored.

`--links`

- Preserves symbolic links (symlinks) instead of copying the files they point to.

`--log-file "${LogLocation}/${ShareName}.log"`

- Writes all output, including errors, to the specified log file.
  - Quoting the path ensures compatibility with spaces or special characters.
