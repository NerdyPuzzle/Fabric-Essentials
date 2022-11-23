public ${name}Procedure() {
	LivingEntityEvents.ACTUALLY_HURT.register((source, damaged, amount) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", damaged);
		dependencies.put("sourceentity", source);
		dependencies.put("amount", amount);
		dependencies.put("x", damaged.getX());
		dependencies.put("y", damaged.getY());
		dependencies.put("z", damaged.getZ());
		dependencies.put("world", damaged.level);
		execute(dependencies);
		return amount;
	});
}