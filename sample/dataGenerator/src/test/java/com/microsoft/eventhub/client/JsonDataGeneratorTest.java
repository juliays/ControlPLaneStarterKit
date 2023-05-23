package com.microsoft.eventhub.client;

import org.junit.jupiter.api.Test;
import org.json.JSONArray;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class JsonDataGeneratorTest {
    /**
     *
     */
    @Test
    public void testGetJSonSensorDataArray1Element() {
        final JSONArray array = JsonDataGenerator.getJsonSensorDataArray(1);
        assertThat("json array contains 1 element", array.length(), equalTo(1));
    }

    /**
     *
     */
    @Test
    public void testGetJSonSensorDataArray6Element() {
        final JSONArray array = JsonDataGenerator.getJsonSensorDataArray(6);
        //System.out.println (array.toString());
        assertThat("json array contains 6 elements", array.length(), equalTo(6));
    }

    /**
     *
     @Test public void testDeserializeJsonStringToCloudEvent()
     {

     String json = null;
     try {
     json = JsonDataGenerator.getJsonSensorData();
     } catch (Exception e) {
     Assert.assertFalse("failed to create json string", true);
     }

     ObjectMapper mapper = new ObjectMapper();
     try {
     CloudEvent[] data = mapper.readValue(json, CloudEvent[].class);
     //System.out.println ("data size " + data.length);
     //System.out.println (data[0].getTime());
     String jsonString = mapper.writeValueAsString(data);
     System.out.println (jsonString);
     List<EventData> list = new ArrayList<>();
     Assert.assertTrue("cloudevent is not null", data.length>0);
     } catch (Exception e) {
     e.printStackTrace();
     Assert.assertTrue("failed to deserialize json back to CloudEvent", false);
     }
     }
     */
}
