# Sample Data Generator for Event Hub

This is a simple application that generates random sensor reading data to send to event hub to generate some traffic.

Traffic is generated for each event hub specified in config.json. It will loop through the list with a counter, if counter % 3 == 0, it will keep the current threadCount to generate a pool with the threadCount passed in. It counter % 3 = 1, it will create a thread pool with 10 times the threadCount number of threads. If counter % 3 == 2, it will create a thread pool with 2 times the threadCount number of threads. 

At the default 90ms delay between each request, this will consistently produce traffic to trigger healthy (%3==0)/degraded (%3 ==2)/unhealthy (%3==1) based on the number of eventhub incoming request.

If you want to see all units healthy, set -d=5000 or some big numbers so that messages are not coming down too fast. 

The format of the data is defined in [this design doc](https://dev.azure.com/CSECodeHub/516011C%20-%20HIGHLY%20CONFIDENTIAL%20-%20General%20Motors/_git/516011C%20-%20HIGHLY%20CONFIDENTIAL%20-%20General%20Motors?path=/docs/initial-unit-defintion.md).

## How to run

This program can be run in either a single iteration or generate some load.

A launch.json.template is provided. You can rename it to launch.json and it will run with 10 concurrent requests for 100 seconds with 90 ms delay between each request.

Or, you can use "mvn exec:java" to run.

Run with parameters set up in maven exec goal

```
mvn exec:java
```

Override commandline parameters

```

mvn exec:java -Dexec.mainClass="pcom.microsoft.eventhub.client.App" -Dexec.args="-c=10 -d=100 -t=1800" 


-c # number of concurrent requests. if not set, one 1 request will be sent. that's single iteration
-t # number of seconds for the program to run. If not set, it's default to 3600 seconds.
-d # number of milliseconds to delay in between each request. If not set, it will default to 90 milliseconds

If none of the parameter is set, the program will run through single iteration.
```

### prerequisite

event hub and shared access policies set up in an azure subscription.
Set up the eventHubConnectionString and eventHubName in config.json file

### single iteration

```

 mvn exec:java -Dexec.mainClass="pcom.microsoft.eventhub.client.App" -Dexec.args=""  
```

### load

```
mvn exec:java 

or 

mvn exec:java -Dexec.mainClass="pcom.microsoft.eventhub.client.App" 

Either of the above will run with parameters set by "pom.xml". 

or 

mvn exec:java -Dexec.mainClass="pcom.microsoft.eventhub.client.App" -Dexec.args="-c=10 -d=100 -t=1800" 

-c # number of concurrent requests. if not set, one 1 request will be sent. that's single iteration
-t # number of seconds for the program to run. If not set, it's default to 3600 seconds.
-d # number of milliseconds to delay inbetween each request. If not set, it will default to 10 milliseconds

If none of the parameter is set, the program will run through single iteration.
```
