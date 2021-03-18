## 相关函数流程

### cat blkio.throttle.io_serviced相关流程
入口函数如下

```C/C++
static struct cftype throtl_legacy_files[] = {
	{
    	.name = "throttle.io_serviced",
    	.private = (unsigned long)&blkcg_policy_throtl,
    	.seq_show = blkg_print_stat_ios,
	},
}

//blkg_print_stat_ios函数数流程
int blkg_print_stat_ios(struct seq_file *sf, void *v)
{
    blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
              blkg_prfill_rwstat_field, (void *)seq_cft(sf)->private,
              offsetof(struct blkcg_gq, stat_ios), true);
    return 0;
}

//blkcg_print_blkgs函数流程
void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
               u64 (*prfill)(struct seq_file *,
                     struct blkg_policy_data *, int),
               const struct blkcg_policy *pol, int data,
               bool show_total)
{
    struct blkcg_gq *blkg;
    u64 total = 0;

    rcu_read_lock();
    hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
        spin_lock_irq(&blkg->q->queue_lock);
        if (blkcg_policy_enabled(blkg->q, pol))
            total += prfill(sf, blkg->pd[pol->plid], data);
        spin_unlock_irq(&blkg->q->queue_lock);
    }
    rcu_read_unlock();

    if (show_total)
        seq_printf(sf, "Total %llu\n", (unsigned long long)total);
}
```

