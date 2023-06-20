public ${name}Procedure() {
	ExplosionEvents.DETONATE.register((level, explosion, list, diameter) -> {
			Map<String, Object> dependencies = new HashMap<>();
			dependencies.put("x", explosion.x);
			dependencies.put("y", explosion.y);
			dependencies.put("z", explosion.z);
			dependencies.put("world", level);
			execute(dependencies);
	});
}