# DPS Lite Observability

DPS Lite Observabiility is implemented using OpenTelemetry API and Application Insights and Log Analytics workspace as the collector.

OpenTelemetry Span objects are created to record trace and dependencies.

OpenTelemetry LongCounter and LongHistogram objects are created for each operation to record number of requests and latency respectively.

SpanOperation class is added to encapsulate span and metrics recording. E.g. if you were to add a new AttributeKey, you can add it to SpanOperation and set value where you see fit, and update the DPSLiteObservabilityHelper.endSpan() and DPSLiteObservabilityHelper.updateMetrics() call without updating everywhere.

When recording metrics, metrics on span pattern is applied to ensure consistency between span and metrics. Sample implementation is listed below -

```java
public void registerDevice() {
  long start = System.currentTimeMillis();
  SpanOperation operation = new SpanOperation("spanName");
  // tracer is a singleton
  Span span = tracer.spanBuilder(operation.getName()).startSpan();
  try (io.opentelemetry.context.Scope ss = span.makeCurrent()) {
       //business processing
       span.addEvent(“eventProcessing”); // this gets output to app insights ‘trace’ table and "dependencies" table
       if (error) {
            operation.setStatus(Constants.OPERATION_STATUS_FAILURE);
            operation.setErrorMessage(errorMessage);
       }
  } catch (Exception e) {
    operation.setStatus(Constants.OPERATION_STATUS_FAILURE);
    operation.setErrorMessage(e.getMessage());
  }finally {
    DPSLiteObservabilityHelper.endSpan(span, operation);
    DPSLiteObservabilityHelper.updateMetrics(armCounter, armLatency, operation);
  }
}
```

## Services Required (provisioned before DPS Lite is deployed)

### Log Analytics Workspace

### Application Insights

    - the DPS application user defined identity needs to have "Monitoring Metrics Publisher" role assigned. This is handled by terraform right now
    - You can set up application insights the same time you deploy dpslite. Or the more preferred way is to create app insights in a separate resource group and set up reference of the name and resource group to speed up deployment. It takes about 1 hour to provision application insights using terraform scripts. 

```bash
variable "application_insights_name" {
  description = "Pre-existing application insights name"
  default = "dpslite-app-insight"
}

variable "application_insights_resource_group_name" {
  description = "Pre-existing application insights resource group name"
  default = "rg-ys"
}
```

### Azure Managed Grafana

    - with Azure Monitor Reader role assigned
    - set up Azure Monitor as the data source
    - assign grafana admin role to anyone that needs to do dashboard implementation

## Start DPS Lite service with application insight java agent

1. Set up application insights connection string as an environment variable through DPSLite deployment terraform

1. Create applicationinsights.json where the applicationinsights-agent.jar is located

```bash

cat <<EOF > /app/applicationinsights.json
{
  "role": {
    "name": "DPS Lite"
  },
  "preview": {
    "authentication": {
      "enabled": true,
      "type": "UAMI",
      "clientId": "$AZURE_CLIENT_ID"
    },
    "sampling": {
      "overrides": [
        {
          "telemetryType": "request",
          "attributes": [
            {
              "key": "http.url",
              "value": "https?://[^/]+/health\\\\S*",
              "matchType": "regexp"
            }
          ],
          "percentage": 0
        }
      ]
    }
  },
  "customDimensions": {
    "service.version": "${SERVICE_VERSION:-TBD}",
    "service.environment": "${SERVICE_ENVIRONMENT:-TBD}",
    "service.unit": "${APP_RESOURCE_GROUP:-TBD}"
  }
}
EOF
```

Please don't include

```bash
 "instrumentation": {
-      "springIntegration": {
-        "enabled": true
-      }
-    },
```
in applicationinsights.json. It will mess up the root span ParentId and make the dashboard stop working. 

SERVICE_VERSION, SERVICE_ENVIRONMENT and APP_RESOURCE_GROUP are environment variables that can be set in terraform scripts.

1. Start DPS Lite by adding "-javaagent:/app/agent.jar" to "java" command. e.g. 
   
```bash

java -javaagent:/app/agent.jar -jar /app/app.jar
```

## Import the Dashboard Json File Template

You will need to update the subscription and log analytics workspace name to match what you have. You can update before or after you import the boards. 

### DPSLite.json - sample file to display metrics related to DPSLite

### DPSLite-Scenario-Based.jar - sample file to display a scenario based dashboard. e.g. DPS Lite today serves two requests -

    1. register device
    2. device status inquiry

Each is considered a scenario. The dashboard will display performance related metrics based on AppMetrics and AppDependencies table.

If unregister device, or maintain broker list is accessed in the future, by adding span based metrics, each scenario will automatically show up in the scenario drop down and can be traced that way.

## Future enhancements

Azure service metrics (event grid or AKS) can be exported to log analytics workspace in the future by setting up diagnostic settings so that the board represented by DPSLite.json can be enhanced and the health calculation of the service can be adjusted.

There are also more to the trace(span) and metrics in Open Telemetry. As you learn more about the application, you can adopt more where you see fit.

