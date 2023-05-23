package com.microsoft.eventhub.client;


import java.io.*;
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import com.google.gson.Gson;


import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.util.logging.Logger;
import java.util.List;
import java.util.ArrayList;
/**
 * driver program to send messages to EventHub
 */

@Command(name = "publish", mixinStandardHelpOptions = true,
        description = "publish to eventhub", version = "1.0")
public class App implements Callable<Integer> {
    private final static Logger LOGGER = Logger.getLogger(App.class.getName());

    @Option(names = "-c",
            required = false,
            description = "the number of concurrent request. If this value is not set, the program will run through one iteration and send random messages to eh")
    int threadCount = -1;

    @Option(names = "-d",
            required = false,
            description = "delay between calls. default to 10 if not set.")
    int delay = 90;

    @Option(names = "-t",
            required = false,
            description = "number of seconds to run. default to 3600 seconds if not set")
    long time = 3600;

    private static Config config;

    public static Config getConfig() {
        if (config == null) {
            populateConfig();
        }
        return config;
    }

    public static void setConfig(Config config) {
        App.config = config;
    }

    @Override
    public Integer call() {
        // when the program is run with no parameters, it will run publish once

        System.out.println ("==============");
        System.out.println ("threadCount: " + threadCount);
        System.out.println ("delay: "+ delay);
        System.out.println ("time: " + time);
        System.out.println ("==============");
        if (threadCount == -1) {
            System.out.println ("Single iteration");
            Publisher publisher = new Publisher(config.getEventHubSettings()[0]);
            publisher.publishEvents();
        } else {
            int schedulerCount = config.getEventHubSettings().length;
            List<ScheduledExecutorService> list = new ArrayList<>();
            
            // threadCount is the only required if anything is being passed in
            for (int j= 0; j  < schedulerCount; j ++) {                
                if (threadCount != -1) {
                    int currentThreadCount = getCurrentThreadCount(j, threadCount);
                    ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(currentThreadCount);
                    list.add(scheduler);
                    for (int i = 0; i < threadCount; i++) {
                        try {
                            scheduler.scheduleAtFixedRate(new Publisher(config.getEventHubSettings()[j]), 0, delay, TimeUnit.MILLISECONDS);
                        } catch (Exception e) {
                            System.out.println (" each scheduler");
                            shutdownAndAwaitTermination(scheduler);
                        }
                    }
                }
            }
            
            try {
                Thread.sleep(time * 1000);
            } catch (final Exception e) {
                LOGGER.info("interrupted");
            } 
            for (int i = 0 ;i < schedulerCount; i ++) {
                ScheduledExecutorService scheduler = list.get(i);               
                shutdownAndAwaitTermination(scheduler);
                LOGGER.info(config.getEventHubSettings()[i].getEventHubName() +" Publishing complete");
            } 
        }
        return 0;
    }

    void shutdownAndAwaitTermination(ExecutorService pool) {
        System.out.println ("=============================================");
        System.out.println (" === In shutdownAndAwaitTerminination =======");
        System.out.println ("=============================================");
        pool.shutdown(); // Disable new tasks from being submitted
        try {
          // Wait a while for existing tasks to terminate
          if (!pool.awaitTermination(60, TimeUnit.SECONDS)) {
            pool.shutdownNow(); // Cancel currently executing tasks
            // Wait a while for tasks to respond to being cancelled
            if (!pool.awaitTermination(60, TimeUnit.SECONDS))
                System.err.println("Pool did not terminate");
          }
        } catch (InterruptedException ie) {
          // (Re-)Cancel if current thread also interrupted
          pool.shutdownNow();
          // Preserve interrupt status
          Thread.currentThread().interrupt();
        }
      }

    @Command(name = "publish", description = "Publish messages to event hub", mixinStandardHelpOptions = true)
    static public void main(String ... args) {
        populateConfig();
        System.exit(new CommandLine(new App()).execute(args));
    }

    private int getCurrentThreadCount(int j, int threadCount) {
        int currentThreadCount = 0; 
        if (j % 3 == 2) {
            currentThreadCount = threadCount / 2;
        } else if (j % 3 == 1) {
            currentThreadCount = threadCount * 10;
        }
        return currentThreadCount;
    }
    private static void populateConfig() {
        //Create a new Gson object
        Gson gson = new Gson();
        //since this is the command entry point, load up the config
        //cehck if file is present
        File configFile = new File("config.json");
        if (configFile.exists()) {
            //Read the json file
            try (final BufferedReader br = new BufferedReader(new FileReader("config.json"))) {
                //convert the json to  Java object (Config)
                setConfig(gson.fromJson(br, Config.class));
            } catch (final IOException e) {
                LOGGER.info("Error reading config file: " + e.getLocalizedMessage());
            }
        } else {
            LOGGER.info("No config.json found. Please check your setup");
        }
    }
}
