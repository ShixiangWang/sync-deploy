#!/bin/bash
# add sync-deploy path to ~/.bashrc

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "# add path for sync-deploy tool" >> ~/.bashrc
echo 'export' PATH=\""$DIR:\$PATH"\" >> ~/.bashrc
source ~/.bashrc

echo "Add sync-deploy path to your ~/.bashrc successfully!"
echo "==> You can use sync-deploy tool everywhere now."
echo
exit
