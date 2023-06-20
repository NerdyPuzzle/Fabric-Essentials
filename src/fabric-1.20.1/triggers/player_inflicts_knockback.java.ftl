public ${name}Procedure() {
	LivingEntityEvents.KNOCKBACK_STRENGTH.register((strength, player) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", player);
		dependencies.put("amount", strength);
		dependencies.put("x", player.getX());
		dependencies.put("y", player.getY());
		dependencies.put("z", player.getZ());
		dependencies.put("world", player.level);
		execute(dependencies);
		return strength;
	});
}