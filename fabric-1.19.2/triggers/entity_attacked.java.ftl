public ${name}Procedure() {
	LivingEntityEvents.ATTACK.register((entity, source, amount) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", entity);
		dependencies.put("immediatesourceentity", source.getDirectEntity());
		dependencies.put("sourceentity", source.getEntity());
		dependencies.put("amount", amount);
		dependencies.put("x", entity.getX());
		dependencies.put("y", entity.getY());
		dependencies.put("z", entity.getZ());
		dependencies.put("world", entity.level);
		execute(dependencies);
		return false;
	});
}