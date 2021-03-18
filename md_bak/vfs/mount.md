## 重要数据结构
### struct mount
|type|mem|解释|
| - | - | - |
|struct hlist_node|mnt_hash|用于挂入hash表|
|struct mount *|mnt_parent|父mount，也就是挂载源dentry的mount|
|struct dentry *|dentry|挂载点的dentry|
|struct vfsmount |mnt|主要包含被挂载点的信息, mnt_root(dentry)和mnt_sb(superblock)|
|struct list_head|mnt_mounts|作为parenet mount 的根节点，连接child mount -> mnt_child|
|struct list_head|mnt_child|相同parenet mount连接到一个链表|
|struct list_head|mnt_instance|相同superblock的，连接成一个链表|
|struct list_head|mnt_list|相同命名空间的，连接成一个链表|
|struct list_head|mnt_expire||
|struct list_head|mnt_share|clone_mnt()把本次挂载的source mount通过其mnt_share链接到克隆母体的mnt_share链表|
|struct list_head|mnt_slave_list|把本次挂载slave属性的source mount结构链接到克隆母体mount的mnt_slave_list链表。mount结构的mnt_slave_list链表是保存子slave mount的，凡是照着一个mount结构克隆生成的mount，都添加到克隆母体的mnt_slave_list链表，克隆的mount是母体子slave mount|
|struct list_head|mnt_slave| clone_mnt()中，把本次挂载source slave属性的mount结构链接到克隆母体mount的mnt_slave_list链表2 clone_mnt()中，克隆母体是slave属性而本次source mount没有指定属性，则source mount被添加到与克隆母体同一个mount salve组链表具体添加形式是，source mount结构靠其mnt_slave添加到克隆母体的mnt_slave链表。source mount和克隆母体靠各自的mnt_slave构成链表,二者是同一个mount slave组成员。如果source mount靠其mnt_slave添加到克隆母体的mnt_slave_list链表，则二者是父子关系，不是同组关系|
|struct hlist_head|mnt_mp_list|作为head 连接struct mountpoint->m_list|

### struct vfsmount 
|type|mem|解释|
| - | - | - |
|struct dentry *|mnt_root|根dentry|
|struct super_block *|mnt_sb|superblock|
|int |mnt_flags||

### struct mnt_namespace
|type|mem|解释|
| - | - | - |
|struct mount *|root||
|struct list_head|list|连接该命名空间下的所有的struct mount|
|unsigned int|mounts|该命名空间下的mounts的数量|

### struct path

```
struct path {
    struct vfsmount *mnt;
    struct dentry *dentry;
} __randomize_layout;
```

### struct mountpoint
```
struct mountpoint {
    struct hlist_node m_hash;		//以m_dentry指针为索引的哈希表
    struct dentry *m_dentry;
    struct hlist_head m_list;
    int m_count;
};
```

### struct nameidata
```
struct nameidata {
    struct path path;
    struct qstr last;
    struct path root;
    struct inode    *inode; /* path.dentry.d_inode */
    unsigned int    flags;
    unsigned    seq, m_seq;
    int     last_type;
    unsigned    depth;
    int     total_link_count;
    struct saved {
        struct path link;
        struct delayed_call done;
        const char *name;
        unsigned seq;
    } *stack, internal[EMBEDDED_LEVELS];
    struct filename *name;
    struct nameidata *saved;
    struct inode    *link_inode;
    unsigned    root_seq;
    int     dfd;
} __randomize_layout;
```

### struct fs_struct
```
struct fs_struct {                       
    int users;                           
    spinlock_t lock;                     
    seqcount_t seq;                      
    int umask;                           
    int in_exec;                         
    struct path root, pwd;               
} __randomize_layout;                    

```
