public ${name}Procedure() {
	AdvancementCallback.EVENT.register((player, advancement) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", player);
		dependencies.put("advancement", advancement);
		dependencies.put("x", player.getX());
		dependencies.put("y", player.getY());
		dependencies.put("z", player.getZ());
		dependencies.put("world", player.level);
		execute(dependencies);
	});
}