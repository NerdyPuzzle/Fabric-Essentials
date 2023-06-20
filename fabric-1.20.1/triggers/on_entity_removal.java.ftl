public ${name}Procedure() {
	EntityEvents.ON_REMOVE.register((entity, reason) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", entity);
		dependencies.put("x", entity.getX());
		dependencies.put("y", entity.getY());
		dependencies.put("z", entity.getZ());
		dependencies.put("world", entity.level);
		dependencies.put("removalreason", reason);
		execute(dependencies);
	});
}