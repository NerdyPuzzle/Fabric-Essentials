public ${name}Procedure() {
	ServerEntityEvents.EQUIPMENT_CHANGE.register((livingEntity, equipmentSlot, previous, next) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("entity", livingEntity);
		dependencies.put("x", livingEntity.getX());
		dependencies.put("y", livingEntity.getY());
		dependencies.put("z", livingEntity.getZ());
		dependencies.put("world", livingEntity.level);
		dependencies.put("equipmentslot", equipmentSlot);
		execute(dependencies);
	});
}