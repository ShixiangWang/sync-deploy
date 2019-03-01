# sync deploy 命令工具

[![DOI](https://zenodo.org/badge/119467219.svg)](https://zenodo.org/badge/latestdoi/119467219) [![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/ShixiangWang/sync-deploy/graphs/commit-activity)

[Read in English](README_english.md)

该命令集可以非常方便地向远程主机/服务器上传文件、运行远程脚本、下载文件等。

<details>
<summary>目录</summary>

1. [sync deploy 命令工具](#sync-deploy-命令工具)
   1. [目的](#目的)
   2. [下载与使用](#下载与使用)
   3. [准备与配置](#准备与配置)
      1. [查看可用资源与计算节点状态](#查看可用资源与计算节点状态)
      2. [编写PBS脚本](#编写pbs脚本)
   4. [命令说明](#命令说明)
      1. [sync-command](#sync-command)
      2. [sync-upload](#sync-upload)
      3. [sync-download](#sync-download)
      4. [sync-run](#sync-run)
   5. [sync-template](#sync-template)
   6. [sync-deploy](#sync-deploy)
      1. [sync-check](#sync-check)
   7. [New feature](#new-feature)
      1. [sync-hostadd](#sync-hostadd)
      2. [sync-hostdel](#sync-hostdel)
      3. [sync-switch](#sync-switch)
      4. [sync-hostlist](#sync-hostlist)
      5. [PBS脚本批量生成与提交](#pbs脚本批量生成与提交)
         1. [sync-qgen](#sync-qgen)
         2. [sync-qsub](#sync-qsub)
   8. [提交Bug](#提交bug)

</details>

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
sync-template -h
sync-deploy -h
sync-check -h
```

## 准备与配置

首先在服务器端配置本地机器的公钥，以便于实现无密码文件传输。


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

如果ssh服务还没有开启，请参考<https://www.linuxidc.com/Linux/2015-01/112045.htm>解决。

*****

**如果你想要在计算平台部署任务**，请点击打开当前目录下的`qsub_header`文件填入PBS参数，设置可以参考[我整理的](https://github.com/ShixiangWang/mytoolkit/blob/master/hpc_info.md)或者百度上的其他资源，例如[1](https://wenku.baidu.com/view/5ab820293169a4517723a3ec.html)，[2](https://wenku.baidu.com/view/14ef7c230722192e4536f6f8.html)等。


### 查看可用资源与计算节点状态

在提交任务之前，务必检查一下各个节点的状态，例如资源是否充足，当前有多少正在执行的任务等。

使用

```
$ pbsnodes -a

```

命令可以显示所有计算节点的状态，如下图。状态为free时计算机空闲。

![pbsnodes](http://bicmr.pku.edu.cn/~wenzw/img/pbsnodes.png)


### 编写PBS脚本

我学校提供的说明不是很清楚，我Copy了[某个工作站](http://bicmr.pku.edu.cn/~wenzw/pages/pbs.html)更清晰的描述。


一个PBS脚本的模板如下：

```shell
#!/bin/sh
#PBS -N <作业名>
#PBS -a <作业开始运行时间>
#PBS -l walltime=hh:mm:ss 作业最长运行时间
#PBS -l nodes=X:ppn=Y 在 X 个节点上申请 Y 个 CPU 核心
#PBS -l mem=XXmb 申请最大内存为 XX MB

#PBS -q <队列名>
#PBS -o <标准输出流文件路径>
#PBS -e <标准错误流输出路径>

# 在输入表示计算任务的命令之前，需要强制设置当前的工作路径
cd $PBS_O_WORKDIR
# 设置运行环境
# 输入要执行的Shell脚本

```

其中，第一行是固定的，表示使用/bin/sh来执行脚本。其余的说明如下：

- 申请资源（例如节点，运行时间等）的选项名为小写的字母‘L’，**不是大写字母‘I’**。
- 作业开始运行时间的格式为CCYYMMDDHHMM.SS，为了方便，可以直接写HHMM的部分，这样默认的日期就是当前日期。
- 总共的节点数为 4，每个节点的最大 CPU 核心数量为 48 个，申请时请不要超过最大值。建议**使用pestat命令**查看剩余资源数量，**在确定申请 CPU 核心数量之前，请确认你的程序是否真的需要这些计算资源**。如果程序的并行程度不高，申请过多的 CPU 核心数会造成资源的浪费（多数 CPU 占用率会较低），并且会影响他人使用。在这里我们建议申请的节点数为 1（目前的 MATLAB 不支持跨节点运行），CPU 核心数不超过 24。 PS：**这里说的是该工作站的资源，配置详情请参考官方手册或者询问工作站/计算平台的工作人员。**
- 当前有两个队列，debug，batch，默认提交到 debug 队列中。

以上的所有#PBS属性均可以不设置，当缺少某属性时，系统将使用默认值。

请在使用时估计自己任务的开销，适量申请计算资源，避免造成资源的浪费。

队列的限制（以下限制均为对每个用户的限制）

| 队列    | 优先度  | 任务最大数 | 默认运行时间   | 最长运行时间   | 备注                |
| ----- | ---- | ----- | -------- | -------- | ----------------- |
| debug | 高    | 2     | 00:30:00 | 03:00:00 | 用于提交短期调试任务或者交互式任务 |
| batch | 低    | 20    | 00:30:00 | ---      | 用于提交批处理任务         |

此外，由于我们的计算资源较少，因此我们对每个用户使用的总计算资源也有限制。

- CPU核心数：同一时间内，单个用户正在运行的任务占用的总核心数限制为 144 。

一个PBS脚本的例子

```shell
#!/bin/sh
#PBS -N test
#PBS -q debug
#PBS -l nodes=1:ppn=1

cd $PBS_O_WORKDIR
module add gcc/4.8.5
./hello

```

该脚本任务名为 test，加入到 debug 队列中，申请 1 个节点上的一个 CPU 核心，任务内容为运行指定目录下的 hello 程序。此程序的运行环境为 gcc/4.8.5。

**在`qsub_header`文件中填入所需要的PBS参数后，接着在当前目录的`commands`文件夹填入你要运行的命令。如果你想要运行其他脚本，请在该文件中调用执行**。

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

## sync-template

生成pbs模板文件，可以指定模板，也可以使用默认模板进行修改。

```
Usage: sync-template [-f] <template_file> [-n] <pbs_script.pbs>
```


## sync-deploy

上传pbs文件、提交作业一气呵成。

该命令内置调用`sync-upload`和`sync-run`这两个命令，以及其他几个脚本。先通过`sync-template`命令生成模板文件，然后根据任务需求修改`pbs`脚本，最后使用`sync-deploy`提交到任务节点进行运算。

用法：

```shell
    Usage: sync-deploy -n local_files -d 'destdir'
```


一个实例如下：

```shell
$ sync-deploy -n work.sh -d '~/test'
==> command used: scp -pr -P 22 work.sh /home/wsx/working/sync-deploy/src/work.sh liuxs@10.15.22.110:~/test
==>
work.sh                                                                                                         100%  240     0.2KB/s   00:00
==> Files upload successfully.

==> run as batch mode.......
job id is
87728.node1
==>
==> The work deploy successfully.

```

### sync-check

用来查看作业状态。

用法：

```shell
    Usage: sync-check -n id
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

## New feature

To easily work with multiple hosts, `sync-hostadd`, `sync-hostdel` and `sync-switch` has been added to this tool for add/delete and switch host.

### sync-hostadd

```shell
$ sync-hostadd -h

Usage: sync-hostadd -u host_name -d host_ip -p host_port
==> examples:
              sync-hostadd -u wangshx -d 10.15.22.110 -p 22
```

### sync-hostdel

```shell
$ sync-hostdel -h

Usage: sync-hostdel -u host_name -d host_ip -p host_port
==> examples:
              sync-hostdel -u wangshx -d 10.15.22.110 -p 22
```

### sync-switch

```shell
$ sync-switch -h

Usage: sync-switch -u host_name [-d] <host_ip> [-p] <host_port>
[]<> mark optional argument and corresponding value.
==> examples:
              sync-switch -u wangshx -d 10.15.22.110 -p 22
```

### sync-hostlist

没有参数，列出可用和保存的所有主机列表。

```shell
$ sync-hostlist
>>> Current Host
user=wangshx
ip=10.15.22.110
port=22

>>> Available Hosts:
liuxs,10.15.22.110,22
wangshx,10.15.22.110,22
```



### PBS脚本批量生成与提交

有时候为每一个处理的样本（对）提交一个pbs确实可以带来极大的便利，下面两个命令参考@[BioAmelie](https://github.com/BioAmelie)的一些想法和代码编写而成。

#### sync-qgen

命令说明，`-h`选项可以获取帮助：

```shell
$ ./sync-qgen -h

Usage: sync-qgen -f template -s samplefile -m mapfile -d outdir
>>> template: a pbs template file.
>>> samplefile: a csv file with columns used to iterate.
>>> mapfile: a csv file contains mapping between labels and column index (0-based) in samplefile.
>>> outdir: output directory.
```

这里template是一个pbs模板，samplefile则是一个包含1列及以上的csv文件，第一列必须为处理样本的id或唯一的Job id，mapfile是一个包含1行及以上的csv文件，**第一列标定pbs模板中要更改（替换）的标签，如`<head>`，第2列则标定替换后的标签，为samplefile的（基于0）整数索引，即0表示替换`<head>`为samplefile的第1列**，最后outdir指定存储pbs的目录（命令会自动创建目录，最好每个任务新建一个）。

下面是测试：

```shell
$ cd test-pbs
$ ../src/sync-qgen -f pbs-template -s samplefile -m mapping -d pbs

Parsing parameters...
=====================
PBS Template: pbs-template
Sample file : samplefile
Mapping file: mapping
Output path : pbs


Working...
  Modify <head> to TCGA-2A-A8VO-01
  Modify <head2> to TCGA-2A-A8VO-01-01
  Modify <head> to TCGA-2A-A8VT-01
  Modify <head2> to TCGA-2A-A8VT-01-01
  Modify <head> to TCGA-2A-A8VV-01
  Modify <head2> to TCGA-2A-A8VV-01-01
  Modify <head> to TCGA-2A-A8VX-01
  Modify <head2> to TCGA-2A-A8VX-01-01
Done.

```

#### sync-qsub

这个命令配合`sync-qgen`输出的目录使用，它批量把pbs提交上去。

```shell
$ ./sync-qsub -h

Usage: sync-qsub -d pbs_dir
>>> pbs_dir: a directory store submitting pbs files.

```

## 提交Bug

有问题欢迎[提交issue](https://github.com/ShixiangWang/sync-deploy/issues)进行讨论。
