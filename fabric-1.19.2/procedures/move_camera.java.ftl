CameraSetupCallback.EVENT.register((info) -> {
info.camera.move((double) ${input$x}, (double) ${input$y}, (double) ${input$z});
return true;
});