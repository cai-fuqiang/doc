我们以`trace/events/block.h`文件为例

```
//==================FILE:trace/events/block.h========================
#undef TRACE_SYSTEM
#define TRACE_SYSTEM block			//定义TRACE_SYSTEM，一会我们会看到它的作用

#if !defined(_TRACE_BLOCK_H) || defined(TRACE_HEADER_MULTI_READ)	//防止重复定义
#define _TRACE_BLOCK_H												//防止重复定义

#include <linux/blktrace_api.h>		//以下三个是和block相关的头文件
#include <linux/blkdev.h>
#include <linux/buffer_head.h>
#include <linux/tracepoint.h>		//作为宏第一次展开的头文件

DECLARE_EVENT_CLASS(block_buffer,	//下面开始定义各个tracepoint
	...
);
DEFINE_EVENT(block_buffer, block_touch_buffer,
	...
};	

	...

#include <trace/define_trace.h>		//包含trace/define_trace.h，作为该头文件的第二次展开

```

所以从上面代码来看，第一次宏定义展开是通过`<linux/tracepoint.h>`文件展开

```C/C++
//=======================FILE:linux/tracepoint.h=======================
#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
    extern struct tracepoint __tracepoint_##name;           \
    static inline void trace_##name(proto)              \		//tracepoint func定义
    {                               \
        if (static_key_false(&__tracepoint_##name.key))     \
            __DO_TRACE(&__tracepoint_##name,        \
                TP_PROTO(data_proto),           \
                TP_ARGS(data_args),         \
                TP_CONDITION(cond), 0);         \
        if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {     \
            rcu_read_lock_sched_notrace();          \
            rcu_dereference_sched(__tracepoint_##name.funcs);\
            rcu_read_unlock_sched_notrace();        \
        }                           \
    }                               \
	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),      \
	    PARAMS(cond), PARAMS(data_proto), PARAMS(data_args))    \
	static inline int                       \
	register_trace_##name(void (*probe)(data_proto), void *data)    \	//tracepoint 注册回调函数
	{                               \
	    return tracepoint_probe_register(&__tracepoint_##name,  \
	                    (void *)probe, data);   \
	}                               \
	static inline int                       \
	register_trace_prio_##name(void (*probe)(data_proto), void *data,\
	               int prio)                \
	{                               \
	    return tracepoint_probe_register_prio(&__tracepoint_##name, \
	                      (void *)probe, data, prio); \
	}                               \
	static inline int                       \
	unregister_trace_##name(void (*probe)(data_proto), void *data)  \	//tracepoint反注销函数
	{                               \
	    return tracepoint_probe_unregister(&__tracepoint_##name,\
	                    (void *)probe, data);   \
	}                               \
	static inline void                      \
	check_trace_callback_type_##name(void (*cb)(data_proto))    \
	{                               \
	}                               \
	static inline bool                      \
	trace_##name##_enabled(void)                    \
	{                               \
	    return static_key_false(&__tracepoint_##name.key);  \
	}
```
