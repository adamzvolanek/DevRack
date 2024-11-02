## Using keep2memos.py

I have my own copy of the script should [original owners](https://github.com/MatthieuTinnes/move-keep-to-memos) repo disappear for some reason.

- Go to [Google Takeout](https://takeout.google.com/) and export Keep data
- Extract the ZIP
- Download the python script from [this repo](https://raw.githubusercontent.com/MatthieuTinnes/move-keep-to-memos/refs/heads/main/keep2memos.py)
- Put this script in the extracted archive, alongside Takeout folder
- Get a token for your memos instance, in parameters menu / my account
- Use this command with instance url and token : `python3 keep2memos.py --instance https://memos.myserver.com --token XXXX`
You can change the default folder with the --folder parameter

### What does this script import

This script import text and original creation date. Images are not supported for now.
