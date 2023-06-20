Executors.newScheduledThreadPool(Runtime.getRuntime().availableProcessors()).schedule(()->{
${statement$do}
},${input$milisecond},TimeUnit.MILLISECONDS);