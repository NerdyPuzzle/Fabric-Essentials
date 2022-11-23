public ${name}Procedure() {
		BlockEvents.BLOCK_BREAK.register((event) -> {
			Map<String, Object> dependencies = new HashMap<>();
			dependencies.put("x", event.getPos().getX());
			dependencies.put("y", event.getPos().getY());
			dependencies.put("z", event.getPos().getZ());
			dependencies.put("px", event.getPlayer().getX());
			dependencies.put("py", event.getPlayer().getY());
			dependencies.put("pz", event.getPlayer().getZ());
			dependencies.put("blockstate", event.getState());
			dependencies.put("xpAmount", event.getExpToDrop());
			dependencies.put("world", event.getPlayer().level);
			dependencies.put("entity", event.getPlayer());
			execute(dependencies);
	});
}