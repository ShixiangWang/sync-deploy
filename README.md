# sync deploy 命令工具

[![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/ShixiangWang/sync-deploy/graphs/commit-activity)

该命令集可以非常方便地向远程主机/服务器上传文件、运行远程脚本、下载文件等。

**目录**：

- [目的](https://github.com/ShixiangWang/sync-deploy#目的)
- [下载与使用](https://github.com/ShixiangWang/sync-deploy#下载与使用)
- [准备与配置](https://github.com/ShixiangWang/sync-deploy#准备与配置)
- [命令说明](https://github.com/ShixiangWang/sync-deploy#命令说明)
    
    - [sync-command](https://github.com/ShixiangWang/sync-deploy#sync-command)
    - [sync-upload](https://github.com/ShixiangWang/sync-deploy#sync-upload)
    - [sync-download](https://github.com/ShixiangWang/sync-deploy#sync-download)
    - [sync-run](https://github.com/ShixiangWang/sync-deploy#sync-run)
    - [sync-deploy](https://github.com/ShixiangWang/sync-deploy#sync-deploy)
    - [sync-check](https://github.com/ShixiangWang/sync-deploy#sync-check)
- [计算操作实例](https://github.com/ShixiangWang/sync-deploy#计算操作实例)


## 目的

交互式地输入ssh、scp命令进行远端主机命令/脚本的执行、文件的上传与下载并不是很方便，有时候频繁地键入`hostname@ip`也是一件非常痛苦的事情。另外一方面，如果是向计算平台提交任务脚本，在远端文本命令窗口内修改作业参数以及调试运行脚本也是蛮不方便。所以仓库里脚本是为了能够比较方便地执行这一些任务。

命令集内置`ssh`、`scp`、`qsub`、`qstat`命令，分别用于运行远程脚本、命令、上传/下载文件、提交作业和查看作业状态。

## 下载与使用

[点击下载](https://github.com/ShixiangWang/sync-deploy/releases)

或克隆：

```
git clone https://github.com/ShixiangWang/sync-deploy.git
```

下载后执行`add_path.sh`脚本将命令添加到环境路径中，这样无论你处于什么目录都能使用。

```shell
cd sync-deploy/src
./add_path.sh
```

除了`sync-command`命令没有选项，其他命令基本都有选项需要指定。

**对应地，除了`sync-command`其他命令都有`-h`选项，你可以获取帮助**。

```shell
sync-upload -h
sync-download -h
sync-run -h
sync-deploy -h
sync-check -h
```

## 准备与配置

首先在服务器端配置本地机器的公钥，以便于实现无密码文件传输。

参考文章[ssh-keygen基本用法](https://www.liaohuqiu.net/cn/posts/ssh-keygen-abc/)或其他资料生成公钥和私钥(搜索引擎可以找到一大堆这样的博文，我就不啰嗦了)。

**最简单的方式**是在终端键入`ssh-keygen`然后一路按回车键。

```shell
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

**如果你使用的是windows7或者10，不知道怎么使用ssh，我推荐你安装`git bash`，windows10用户也可以开启Ubuntu子系统以便于使用。**

将公钥`id_sra.pub`（本地机器.ssh子目录下）中文本内容拷贝到服务器.ssh子目录中的`authorized_keys`中，放在已有文本后面。如果该文件不存在则创建。

进行测试，如果不需要密码登录则成功。

**然后点击打开当前目录（src/）的`sync-setting`文件，将远程主机的host名与ip地址改为你自己的**。


*****

**如果你想要在计算平台部署任务**，请点击打开当前目录下的`qsub_header`文件填入PBS参数，设置可以参考[我整理的](https://github.com/ShixiangWang/mytoolkit/blob/master/hpc_info.md)或者百度上的其他资源，例如[1](https://wenku.baidu.com/view/5ab820293169a4517723a3ec.html)，[2](https://wenku.baidu.com/view/14ef7c230722192e4536f6f8.html)等。

**接着在当前目录的`commands`文件夹填入你要运行的命令。如果你想要运行其他脚本，请在该文件中调用执行**。

## 命令说明

### sync-command

这个命令最简单粗暴，直接在`sync-command`后接你想要在远端执行的命令。

```shell
$ sync-command ls -l '~/test'
总用量 0
-rw-rw-r-- 1 liuxs liuxs  12 1月  30 19:20 job_id
-rw-rw-r-- 1 liuxs liuxs  34 1月  30 19:20 result.txt
-rw-rw-r-- 1 liuxs liuxs 110 1月  29 11:40 test.R
-rwxrw-r-- 1 liuxs liuxs 240 1月  30 19:20 work.sh
```

**需要注意的是如果是想使用类似`~`这种映射到某个路径的符号，需要添加引号，不然它会被解析为本地地址，那当然会出问题的**


### sync-upload

上传文件到远程主机。

用法：

```shell
    Usage: sync-upload -n local_files -d 'destdir'
```

`-n`选项后接你要上传的（本地机器）文件/目录路径，`-d`选项接远程主机上的目录路径。

用法示例：

```shell
==> examples:
              sync-upload -n work.sh -d /public/home/liuxs/test
         or
              sync-upload -n work.sh -d '~/test'
```

同样注意使用`~`时需要加引号。

**重点注意不支持-n与-d倒过来写，也就是选项是有顺序的**，为什么如此的原因是为了使`-n`选项后能够接大于1个的路径参数，命令脚本内部利用了`-n`和`-d`的位置特点运用正则表达式抓取所有路径名，你可以利用该命令同时上传不止一个文件/目录（也算是有得有失吧）。

### sync-download

从远程主机下载文件到本地机器。

用法：

```shell
    Usage: sync-download -n 'remote_files' -d localdir
```

这个命令的使用基本和`sync-upload`一致。

用法示例：

```shell
==> examples:
              sync-download -n '~/test/*' -d ./test
         or
              sync-download -n /public/home/liuxs/test/* -d ./test
```

**同样地，不支持`-n`与`-d`选项顺序反着写。**

### sync-run

提交远程主机的作业，内置`qsub`命令向计算平台提交任务脚本。如果只是想要运行远程脚本或命令，请查看`sync-command`命令。

用法：

```shell
    sync-run -f work_script
```

`-f`选项后接你要运行的**一个**脚本（需要指定脚本的路径哈）。

用法示例：

```shell
    sync-run -f /home/wsx/work.sh
```

## sync-deploy

上传文件、提交作业一气呵成。

该命令内置调用`sync-upload`和`sync-run`这两个命令，以及其他几个脚本。在进行相关配置后，它可以根据`qsub_header`和`commands`两个文本自动生成作业脚本`work.sh`，上传指定文档（`work.sh`不指定也会上传），然后提交到任务节点进行运算。

用法：

```shell
    Usage: sync-deploy -n local_files -d 'destdir'
```

同样注意`~`的使用问题，另外，如果你只部署运行`work.sh`文档，那么请在`-n`选项后加`work.sh`，（因为`-n`选项后不加内容会报错）虽然该文本会被上传两次，但不会影响使用。

一个实例如下：

```shell
$ sync-deploy -n work.sh -d '~/test'
==> command used: scp -pr -P 22 work.sh /home/wsx/working/sync-deploy/src/work.sh liuxs@10.15.22.110:~/test
==>
work.sh                                                                                                         100%  240     0.2KB/s   00:00
work.sh                                                                                                         100%  240     0.2KB/s   00:00
==> Files upload successfully.

==> run as batch mode.......
job_id file locate at ~/test/job_id , id is
87728.node1
==>
==> The work deploy successfully.

```

### sync-check

用来查看作业状态。

用法：

```shell
    Usage: sync-deploy -n id
```

如果指定`-n`选项加上作业号，会查询指定的作业状态，如果不指定，会查看所有的作业状态。

任务部署后会返回作业号，刚提交了两个作业，我们来查一查。

```shell
$ sync-check -n 87730
Job ID                    Name             User            Time Use S Queue
------------------------- ---------------- --------------- -------- - -----
87730.node1                work.sh          liuxs           00:00:00 C normal_3

$ sync-check -n 87730.node1
Job ID                    Name             User            Time Use S Queue
------------------------- ---------------- --------------- -------- - -----
87730.node1                work.sh          liuxs           00:00:00 C normal_3

$ sync-check
Job ID                    Name             User            Time Use S Queue
------------------------- ---------------- --------------- -------- - -----
87729.node1                work.sh          liuxs           00:00:00 C normal_3
87730.node1                work.sh          liuxs           00:00:00 C normal_3

```

## 计算操作实例

我们来通过一个完整的实例来了解这些命令。

**我们的任务是**利用远程的计算平台运行一些shell命令，执行一个R脚本。

该R脚本位于`src/`的`test`目录下，这个脚本我们可以看做我们日常工作运行的主脚本。

我们需要准备什么呢？

只需要正确填写`qsub_header`与`commands`文档即可。

我们先看看`qsub_header`的内容：

```
#PBS -l nodes=1:ppn=10
#PBS -S /bin/bash
#PBS -j oe
#PBS -q normal_3

# Please set PBS arguments above
```

上述就是一些PBS选项和参数，按你自己的需求和正确写法填写即可。这里测试我就简单地设定了节点与队列。具体参数你可以百度或者参考说明文档前面提供的信息。

再瞧瞧`commands`文档：

```shell
# This job's working directory
cd ~/test

# Following are commands
sleep 20
echo "Thi mission is run successfully!!" > ~/test/result.txt

# call Rscripts
Rscript ~/test/test.R > ~/test/result2.txt
```

这个文档可能是我们工作主要需要修改的地方，这里我们用`cd`命令设定（作业的）工作目录，为避免任务结束太快，调用`sleep`命令让机器睡几秒，然后调用`echo`将一些文字结果传入一个结果文件，最后调用一个R脚本，并将结果传入另一个文件。

R脚本的内容也非常简单,就是输入几行文本：

```shell
print("==>")
print("==> Hello world!!!!!!!!")
print("==> ")
```

为避免程序找不到或者找错文件，我们最好指定文件所在的全部路径。

**让我们开始跑命令吧～**

任务方案很简单，我们将`test.R`上传到远程主机的工作目录下，注意，`work.sh`也会自动生成并上传，它的内容就是`qsub_header`与`commands`的结合体。然后执行`work.sh`文本，然后将输出结果传回来。

上传与运行可以利用`sync-deploy`命令一步搞定：
```shell
# 利用add_path.sh将命令加入环境路径后，我们可以利用tab补全查找命令
wsx@Desktop-berry:~$ sync-
sync-check     sync-command   sync-deploy    sync-download  sync-run       sync-upload

# 利用sync-command查看目标路径情况
wsx@Desktop-berry:~$ sync-command "ls -al  ~/test"
总用量 8
drwxrwxr-x  2 liuxs liuxs 4096 1月  30 23:52 .
drwx------ 10 liuxs liuxs 4096 1月  30 22:51 ..

# 部署任务到远程

wsx@Desktop-berry:~$ sync-deploy -n ~/working/sync-deploy/src/test/test.R -d '~/test/'
==> command used: scp -pr -P 22 /home/wsx/working/sync-deploy/src/test/test.R /home/wsx/working/sync-deploy/src/work.sh liuxs@10.15.22.110:~/test/
==>
test.R                                                                                                          100%   60     0.1KB/s   00:00
work.sh                                                                                                         100%  300     0.3KB/s   00:00
==> Files upload successfully.

==> run as batch mode.......
job_id file locate at ~/test/job_id , id is
87732.node1
==>
==> The work deploy successfully.

```

可以看到任务成功部署并返回了`job id`，利用`sync-check`命令查询

```shell
wsx@Desktop-berry:~$ sync-check 87732
Job ID                    Name             User            Time Use S Queue
------------------------- ---------------- --------------- -------- - -----
87732.node1                work.sh          liuxs           00:00:00 C normal_3
```

因为任务时间不长，很快就搞定了，已经出现了`C`标志（完成）。

我们查看一下远程目录情况：

```shell
wsx@Desktop-berry:~$ sync-command ls '~/test'
job_id
result2.txt
result.txt
test.R
work.sh
```

`job_id`文件是用来保存作业号信息的，就是前面输出的`87732.node1`。其他不用解释了。

最后一步，将需要的结果下载回本地。

我们创建一个临时目录单独存储，然后查看文件内容：

```shell
wsx@Desktop-berry:~$ mkdir test
wsx@Desktop-berry:~$ sync-download -n "~/test/*" -d ~/test
==> command used: scp -pr -P 22 liuxs@10.15.22.110:~/test/* /home/wsx/test
==>
job_id                                                                                                          100%   12     0.0KB/s   00:00
result2.txt                                                                                                     100%   51     0.1KB/s   00:00
result.txt                                                                                                      100%   34     0.0KB/s   00:00
test.R                                                                                                          100%   60     0.1KB/s   00:00
work.sh                                                                                                         100%  300     0.3KB/s   00:00
==> Files download successfully.

wsx@Desktop-berry:~$ cd test/
wsx@Desktop-berry:~/test$ ls
job_id  result2.txt  result.txt  test.R  work.sh
wsx@Desktop-berry:~/test$ cat result.txt
Thi mission is run successfully!!
wsx@Desktop-berry:~/test$ cat result2.txt
[1] "==>"
[1] "==> Hello world!!!!!!!!"
[1] "==> "
```

**任务完成！**

## 问题

有问题欢迎[提交issue](https://github.com/ShixiangWang/sync-deploy/issues)进行讨论。
