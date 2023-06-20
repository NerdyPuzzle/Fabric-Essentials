CameraSetupCallback.EVENT.register((info) -> {
info.camera.reset();
return true;
});
