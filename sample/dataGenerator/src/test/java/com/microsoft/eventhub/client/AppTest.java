package com.microsoft.eventhub.client;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.notNullValue;

import org.junit.jupiter.api.Test;

/**
 * Unit test for simple App.
 */
public class AppTest {
    /**
     * Rigorous Test :-)
     */
    @Test
    public void testGetConfigOK() {
        final Config config = App.getConfig();
        assertThat(config.getEventHubSettings()[0].getEventHubName(), notNullValue());
    }

}
