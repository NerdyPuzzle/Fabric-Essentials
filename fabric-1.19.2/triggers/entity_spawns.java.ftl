public ${name}Procedure() {
	EntityEvents.ON_JOIN_WORLD.register((entity, world, loadedFromDisk) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", entity);
		dependencies.put("x", entity.getX());
		dependencies.put("y", entity.getY());
		dependencies.put("z", entity.getZ());
		dependencies.put("world", world);
		execute(dependencies);
		return true;
	});
}