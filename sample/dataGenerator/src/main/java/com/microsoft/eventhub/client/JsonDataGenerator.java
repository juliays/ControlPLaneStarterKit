package com.microsoft.eventhub.client;

import org.json.JSONArray;
import org.json.JSONObject;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import com.azure.messaging.eventhubs.EventData;

public class JsonDataGenerator {

    // create instance of Random class
    private static final Random RAND = new Random();
    private static final int MESSAGE_COUNT = 10;
    private static final DateTimeFormatter DATE_TIME_FORMATTER
            = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");

    /**
     * setting up JSONArray with string value. This is the version we want to go with
     */
    public static JSONArray getJsonSensorDataArray(int count) {

        JSONArray array = new JSONArray();
        for (int i = 0; i < count; i++) {
            int randomNumber = RAND.nextInt(1000);
            JSONObject object = new JSONObject();
            object.put("specversion", "1.0");
            object.put("type", "com.microsoft.eh.client.model.CloudEvent");
            object.put("source", "/test-context");
            UUID uuid = UUID.randomUUID();
            object.put("id", uuid);
            object.put("time", DATE_TIME_FORMATTER.format(LocalDateTime.now()));
            object.put("datacontenttype", "application/json");
            JSONObject sensor = new JSONObject();
            sensor.put("temp", randomNumber % 45);
            sensor.put("humidity", randomNumber % 100);
            object.put("data", sensor.toString());
            array.put(object);
        }
        return array;
    }

    /** create List<EventData> to publish to eventhub */
    public static List<EventData> getEventData() {
        List<EventData> list = new ArrayList<>();
        int randomNumber = RAND.nextInt(1000);
        int messageCount = randomNumber % MESSAGE_COUNT;
        if (messageCount == 0) messageCount = 10;
        for (int i = 0; i < messageCount; i++) {
            int count = RAND.nextInt() % MESSAGE_COUNT;
            list.add(new EventData(getJsonSensorDataArray(count).toString()));
        }
        return list;
    }
}
