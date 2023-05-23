package com.microsoft.eventhub.client;

import lombok.Getter;
import lombok.Setter;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Config {
    private EventHubSettings[] eventHubSettings;
    
    public EventHubSettings[] getEventHubSettings() {
        return this.eventHubSettings;
    }

    public void setEventHubSettings(EventHubSettings[] settings) {
        this.eventHubSettings = settings;
    }
    
    public class EventHubSettings {
        private String eventHubConnectionString;
        private String eventHubName;
    
        public String getEventHubName() {
            return this.eventHubName;
        }
    
        public String getEventHubConnectionString() {
            return this.eventHubConnectionString;
        }
    
    }
}
