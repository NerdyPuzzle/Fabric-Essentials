public ${name}Procedure() {
	UseBlockCallback.EVENT.register((player, level, hand, hitResult) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("world",level);
		dependencies.put("entity", player);
		dependencies.put("x", player.getX());
		dependencies.put("y", player.getY());
		dependencies.put("z", player.getZ());
		dependencies.put("blockstate", (level.getBlockState(new BlockPos(
				player.level.clip(new ClipContext(player.getEyePosition(1f), player.getEyePosition(1f).add(player.getViewVector(1f).scale(5)),
						ClipContext.Block.OUTLINE, ClipContext.Fluid.NONE, player)).getBlockPos().getX(),
				player.level.clip(new ClipContext(player.getEyePosition(1f), player.getEyePosition(1f).add(player.getViewVector(1f).scale(5)),
						ClipContext.Block.OUTLINE, ClipContext.Fluid.NONE, player)).getBlockPos().getY(),
				player.level.clip(new ClipContext(player.getEyePosition(1f), player.getEyePosition(1f).add(player.getViewVector(1f).scale(5)),
						ClipContext.Block.OUTLINE, ClipContext.Fluid.NONE, player)).getBlockPos().getZ()))));
		execute(dependencies);
		return InteractionResult.PASS;
	});
}