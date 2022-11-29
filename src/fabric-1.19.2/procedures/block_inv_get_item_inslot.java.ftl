(new Object() {
	public ItemStack getItemStack(LevelAccessor world, BlockPos pos, int slotid) {
		AtomicReference<ItemStack> stack = new AtomicReference<>(ItemStack.EMPTY);
		BlockEntity _ent = world.getBlockEntity(pos);
		if (_ent != null)
		stack.set(((RandomizableContainerBlockEntity) _ent).getItem(slotid).copy());
		return stack.get();
	}
}.getItemStack(world, (new BlockPos(${input$x}, ${input$y}, ${input$z})), ${opt.toInt(input$slotid)}))