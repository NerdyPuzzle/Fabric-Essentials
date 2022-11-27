<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
{
	BlockEntity _ent = world.getBlockEntity(${toBlockPos(input$x,input$y,input$z)});
	if (_ent != null) {
		final int _slotid = ${opt.toInt(input$slotid)};
		final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)};
		_setstack.setCount(${opt.toInt(input$amount)});
		_ent.SlotItemHandler.getItemHandler().ifPresent(capability -> {
			if (capability instanceof ItemStackHandler)
				((ItemStackHandler) capability).setStackInSlot(_slotid, _setstack);
		});
	}
}
<#-- @formatter:on -->