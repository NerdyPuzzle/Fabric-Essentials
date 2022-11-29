if (world.isClientSide()) {
		Minecraft.getInstance().getTextureManager().bindForSetup(new ResourceLocation(${input$newtexture}));
			Minecraft.getInstance().getTextureManager().register(new ResourceLocation(${input$texturetochange}),
					Minecraft.getInstance().getTextureManager().getTexture(new ResourceLocation(${input$newtexture})));
}