public ${name}Procedure() {
	LivingEntityEvents.FALL.register((event) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", event.getEntity());
		dependencies.put("x", event.getEntity().getX());
		dependencies.put("y", event.getEntity().getY());
		dependencies.put("z", event.getEntity().getZ());
		dependencies.put("distance", event.getDistance());
		dependencies.put("damagemultiplier", event.getDamageMultiplier());
		dependencies.put("world", event.getEntity().level);
		execute(dependencies);
	});
}