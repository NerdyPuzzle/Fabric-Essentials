public ${name}Procedure() {
	AttackAirCallback.EVENT.register((player) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", player);
		dependencies.put("x", player.getX());
		dependencies.put("y", player.getY());
		dependencies.put("z", player.getZ());
		dependencies.put("world", player.level);
		execute(dependencies);
	});
}