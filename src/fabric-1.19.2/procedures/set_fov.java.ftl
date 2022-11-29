FOVModifierCallback.EVENT.register((player, fov) -> {
	   	fov = (float) ${input$cval};
	   	return fov;
	   });