public ${name}Procedure() {
	MobEntitySetTargetCallback.EVENT.register((targeting, target) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", targeting);
		dependencies.put("sourceentity", target);
		dependencies.put("x", targeting.getX());
		dependencies.put("y", targeting.getY());
		dependencies.put("z", targeting.getZ());
		dependencies.put("world", targeting.level);
		execute(dependencies);
	});
}