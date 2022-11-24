public ${name}Procedure() {
		BlockPlaceCallback.EVENT.register((event) -> {
			Map<String, Object> dependencies = new HashMap<>();
			dependencies.put("px", event.getPlayer().getX());
			dependencies.put("py", event.getPlayer().getY());
			dependencies.put("pz", event.getPlayer().getZ());
			dependencies.put("world", event.getLevel());
			dependencies.put("entity", event.getPlayer());
			dependencies.put("x", (event.replacingClickedOnBlock() ? event.getHitResult().getBlockPos().getX() : event.relativePos.getX()));
			dependencies.put("y", (event.replacingClickedOnBlock() ? event.getHitResult().getBlockPos().getY() : event.relativePos.getY()));
			dependencies.put("z", (event.replacingClickedOnBlock() ? event.getHitResult().getBlockPos().getZ() : event.relativePos.getZ()));
			dependencies.put("blockstate", (((BlockItem) event.getItemInHand().getItem()).getBlock().defaultBlockState()));
			dependencies.put("placedagainst", (event.getLevel().getBlockState(event.getHitResult().getBlockPos())));
			dependencies.put("event", event);
			execute(dependencies);
			return InteractionResult.PASS;
	});
}