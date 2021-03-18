# 代码流程
## mount流程
代码流程
``C/C++
sys_mount
    ksys_mount
        do_mount
           do_new_mount
                do_add_mount
                    graft_tree
                        attach_recursive_mnt
```

### attach_recursive_mnt
1. 参数
|类型|名称|作用|
|-|-|-|
|struct mount *|source_mnt|源mnt|
|struct mount *|dest_mnt|目的mnt|
|struct mountpoint *|dest_mp|目的mountpoint|
|struct path *|parent_path||

关于source_mnt和dest_mnt中的vfsmount, 需要注意的是，
vfsmount是root_dentry和superblock之间的关系

在该函数执行之前，已经申请好source_mnt，准备好dest_mnt，dest_mp,
该函数的作用就是建立他们几个之前的关系

2. 
