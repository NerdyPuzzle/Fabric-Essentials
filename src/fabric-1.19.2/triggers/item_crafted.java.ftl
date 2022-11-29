public ${name}Procedure() {
	ItemCraftedCallback.EVENT.register((player, crafted, craftMatrix) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", player);
		dependencies.put("itemstack", crafted);
		dependencies.put("x", player.getX());
		dependencies.put("y", player.getY());
		dependencies.put("z", player.getZ());
		dependencies.put("world", player.level);
		execute(dependencies);
	});
}