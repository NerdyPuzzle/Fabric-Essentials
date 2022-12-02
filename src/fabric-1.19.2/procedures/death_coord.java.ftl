(new Object() {
	public double getDeathCoord(Entity entity){
		if (entity instanceof Player _player){
		if (_player.getLastDeathLocation().isEmpty())
			return 0.0;
		return _player.getLastDeathLocation().get().pos().get${field$coord}();
		}
		return 0.0;
	}
}.getDeathCoord(${input$entity}))