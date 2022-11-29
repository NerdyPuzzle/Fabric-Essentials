public ${name}Procedure() {
	ItemTooltipCallback.EVENT.register((stack, context, lines) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("itemstack", stack);
		dependencies.put("tooltip", lines);
		dependencies.put("entity", Minecraft.getInstance().player);
		execute(dependencies);
	});
}