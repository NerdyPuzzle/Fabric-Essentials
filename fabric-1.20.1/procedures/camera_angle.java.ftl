CameraSetupCallback.EVENT.register((info) -> {
	   	info.${field$angle} = (float) ${input$cval};
	   	return true;
	   });