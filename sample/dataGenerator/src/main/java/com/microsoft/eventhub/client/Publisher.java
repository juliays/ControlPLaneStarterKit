package com.microsoft.eventhub.client;

import com.azure.messaging.eventhubs.*;

import java.util.List;
import java.util.logging.Logger;

public class Publisher implements Runnable {

    private final static Logger LOGGER = Logger.getLogger(Publisher.class.getName());

    private EventHubProducerClient producer;
    private String name;
    private String eventHubName;

    public Publisher(Config.EventHubSettings config) {
        // create a producer client 
        producer = new EventHubClientBuilder()
                .connectionString(config.getEventHubConnectionString(), config.getEventHubName())
                .buildProducerClient();
        eventHubName = config.getEventHubName();
    }

    public void run() {
        name = Thread.currentThread().getName();
        LOGGER.info(String.format("publisher %s started",  name + " : " + eventHubName));
        publishEvents();
    }

    /**
     * Code sample for publishing events.
     *
     * @throws IllegalArgumentException if the EventData is bigger than the max batch size.
     */
    public void publishEvents() {
        try {
            List<EventData> allEvents = JsonDataGenerator.getEventData();
            // create a batch
            EventDataBatch eventDataBatch = producer.createBatch();
            //LOGGER.info(String.format("publisher %s after creating batch", name +" : " + eventHubName));

            for (EventData eventData : allEvents) {
                // try to add the event from the array to the batch
                if (!eventDataBatch.tryAdd(eventData)) {
                    // if the batch is full, send it and then create a new batch
                    producer.send(eventDataBatch);
                    eventDataBatch = producer.createBatch();
                    //LOGGER.info(String.format("%s published to eventHub and creating new batch", name));
                    // Try to add that event that couldn't fit before.
                    if (!eventDataBatch.tryAdd(eventData)) {
                        //LOGGER.warning(String.format("%s event too big to publish", name));
                        throw new IllegalArgumentException("Event is too large for an empty batch. Max size: "
                                + eventDataBatch.getMaxSizeInBytes());
                    }
                }
            }
            // send the last batch of remaining events
            if (eventDataBatch.getCount() > 0) {
                producer.send(eventDataBatch);
                //LOGGER.info(String.format("%s published to eventHub", name));
            }
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.info(e.toString());
        }
    }
}