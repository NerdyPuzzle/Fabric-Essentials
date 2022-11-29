public ${name}Procedure() {
	ModsLoadedCallback.EVENT.register((envType) -> {
		Map<String, Object> dependencies = new HashMap<>();
		execute(dependencies);
	});
}