# Sync-deploy command tool

[![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/ShixiangWang/sync-deploy/graphs/commit-activity)

 :arrows_counterclockwise: Tools to easily deploy script/command task on remote host, including up/download files, run script on remote.
 
When you work with remote machine, it is usual that the network connection is not stable, the tool is for running your task quickly after you add your content of ssh `pub` key to `authorized_keys` of remote machine.

```shell
# generate ssh key
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/wangshx/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /c/Users/wangshx/.ssh/id_rsa.
Your public key has been saved in /c/Users/wangshx/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:XaNcpRZHmMp65eHKDzYIzbXYB0ZAb3EHYc7T3azgQD4 wangshx@wsx-liuxslab
The key's randomart image is:
+---[RSA 2048]----+
|       .o.+ **=  |
|         = *oB o.|
|         .E.@ . +|
|       o Oo@o+ . |
|      . S.*+o..  |
|       .....o    |
|        .o+.     |
|         .oo     |
|           ..    |
+----[SHA256]-----+

```

You can get rid of using `ssh command` every time, the tool will run automatically for you.

There are 7 command available now.
 
6 of them all can get usage by add `-h` option.

```
sync-upload -h
sync-download -h
sync-run -h
sync-template -h
sync-deploy -h
sync-check -h
 ```
 
 The first three commands are useful when you want to upload files to remote machine, download files to remote machine and run script on remote machine.
 
 Once you add tool path by 
 
 ```
 cd sync-deploy/src
./add_path.sh
```

You can use the commands everywhere on your terminal.

The left three commands are useful when you want deploy computation task in PBS script format.

You can use `sync-template` to generate a template, and use `sync-deploy` to deploy task script on high performance platform (HPC) and use `sync-check` to check the status of you job.

The last command is `sync-command`, you can use it to run any commands on remote.
