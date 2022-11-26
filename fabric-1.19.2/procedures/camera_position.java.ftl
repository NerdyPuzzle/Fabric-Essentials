CameraSetupCallback.EVENT.register((info) -> {
info.camera.setPosition((double) ${input$x}, (double) ${input$y}, (double) ${input$z});
return true;
});
