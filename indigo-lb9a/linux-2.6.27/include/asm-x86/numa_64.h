#ifndef _ASM_X8664_NUMA_H
#define _ASM_X8664_NUMA_H 1

#include <linux/nodemask.h>
#include <asm/apicdef.h>

struct bootnode {
	u64 start;
	u64 end;
};

extern int compute_hash_shift(struct bootnode *nodes, int numblks,
			      int *nodeids);

#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))

extern void numa_init_array(void);
extern int numa_off;

extern void srat_reserve_add_area(int nodeid);
extern int hotadd_percent;

extern s16 apicid_to_node[MAX_LOCAL_APIC];

extern unsigned long numa_free_all_bootmem(void);
extern void setup_node_bootmem(int nodeid, unsigned long start,
			       unsigned long end);

#ifdef CONFIG_NUMA
extern void __init init_cpu_to_node(void);
extern void __cpuinit numa_set_node(int cpu, int node);
extern void __cpuinit numa_clear_node(int cpu);
extern void __cpuinit numa_add_cpu(int cpu);
extern void __cpuinit numa_remove_cpu(int cpu);
#else
static inline void init_cpu_to_node(void)		{ }
static inline void numa_set_node(int cpu, int node)	{ }
static inline void numa_clear_node(int cpu)		{ }
static inline void numa_add_cpu(int cpu, int node)	{ }
static inline void numa_remove_cpu(int cpu)		{ }
#endif

#endif
