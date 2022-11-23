public ${name}Procedure() {
	LivingEntityUseItemEvents.LIVING_USE_ITEM_FINISH.register((entity, item, duration, result) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", entity);
		dependencies.put("itemstack", item);
		dependencies.put("duration", duration);
		dependencies.put("x", entity.getX());
		dependencies.put("y", entity.getY());
		dependencies.put("z", entity.getZ());
		dependencies.put("world", entity.level);
		execute(dependencies);
		return item;
	});
}