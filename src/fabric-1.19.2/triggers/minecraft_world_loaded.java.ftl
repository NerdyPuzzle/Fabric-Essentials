public ${name}Procedure() {
	ClientWorldEvents.LOAD.register((client, world) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("world", world);
		execute(dependencies);
	});
}