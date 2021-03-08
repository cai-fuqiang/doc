struct request_queue {                                                                      
    struct list_head    queue_head;             //待处理请求链表                            
    struct request      *last_merge;            //指向队列中首先可能合并的request           
    struct elevator_queue   *elevator;          //指向调度器
                                                                                            
    make_request_fn     *make_request_fn;       //将一个bio组封装成一个request并添加到reques
    const struct blk_mq_ops *mq_ops;            //同struct blk_mq_tag_set->ops，由驱动程序定义

    /* sw queues */                                                                         
    struct blk_mq_ctx __percpu  *queue_ctx;     //软队列, 每个cpu对应一个软件队列
    unsigned int        nr_queues;              //硬件队列的个数
                                                                                            
    unsigned int        queue_depth;			//硬件队列深度
                                                                                            
    /* hw dispatch queues */                                                                
    struct blk_mq_hw_ctx    **queue_hw_ctx;     //维护一个CPU和队列关系之间的映射表         
    unsigned int        nr_hw_queues;           //硬件队列数量             
};

struct blk_mq_tag_set {         //用于描述存储器件的tag集合
    //软件队列(ctx)到硬件队列(hctx)的映射表, blk-mq中将一个或多个软件队列映射到
    //一个硬件队列，一个软件队列可以支持多种类型的硬件队列
    struct blk_mq_queue_map map[RH_HCTX_MAX_TYPES];
    unsigned int        nr_maps;    									//映射表的数量
    const struct blk_mq_ops *ops;           							//设备驱动mq操作集合
    unsigned int        nr_hw_queues;   /* nr hw queues across maps */  //硬件队列数量
    unsigned int        queue_depth;    /* max hw supported */          //队列深度
    unsigned int        reserved_tags;                              	//块设备保留的tag数量
    unsigned int        cmd_size;   /* per-request extra data */    	//为每个request分配的额外空间大小
    int         numa_node;                                          	//numa节点，分配request内存的时候，会使用
    unsigned int        timeout;                        				//请求处理的超时时间，单位是jiffies
    unsigned int        flags;      /* BLK_MQ_F_* */
    void            *driver_data;                       				//块设备驱动的私有数据

    struct blk_mq_tags  **tags;                         				//块设备的mq_tag数组

    struct mutex        tag_list_lock;
    struct list_head    tag_list;
};

struct blk_mq_tags {                                                                       
    unsigned int nr_tags;                   //tags最大数量, 一般来说要等于最大队列深度     
    unsigned int nr_reserved_tags;          //保留tags数量                                 
                                                                                           
    atomic_t active_queues;                 //活跃队列数量                                 
                                                                                           
    struct sbitmap_queue bitmap_tags;       //保留tag的位图，如果使用了，相应的bit为1      
    struct sbitmap_queue breserved_tags;                                                   
                                                                                           
    //分配staic_rqs时，会分配多个连续的pages,                                              
    //将pages分为多个如下大小，当需要request时，                                           
    //就从这里面分配，类似slab                                                             
    struct request **rqs;                   //这个应该是预分配的rqs                        
    struct request **static_rqs;                                                           
    struct list_head page_list;                                                            
}; 
                                                              
