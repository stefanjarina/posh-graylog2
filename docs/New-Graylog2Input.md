---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# New-Graylog2Input

## SYNOPSIS
Launch input on this node

## SYNTAX

```
New-Graylog2Input [-inputGlobalNode] [-inputTitle] <String> [-inputType] <String> [[-port] <Int32>]
 [[-bind_address] <String>] [[-fetch_wait_max] <Int32>] [[-threads] <Int32>] [[-zookeeper] <String>]
 [[-fetch_min_bytes] <Int32>] [[-source] <String>] [[-sleep] <Int32>] [[-sleep_deviation] <Int32>]
 [[-topic_filter] <String>] [[-allow_override_date] <String>] [[-store_full_message] <String>]
 [[-force_rdns] <String>] [[-override_source] <String>] [[-headers] <String>] [[-interval] <Int32>]
 [[-path] <String>] [[-target_url] <String>] [[-timeunit] <String>] [[-duration_unit] <String>]
 [[-report_unit] <String>] [[-rate_unit] <String>] [[-report_interval] <Int32>]
 [[-receive_buffer_size] <Int32>] [[-queue] <String>] [[-broker_username] <String>]
 [[-broker_password] <String>] [[-prefetchCount] <Int32>] [[-broker_hostname] <String>]
 [[-broker_vhost] <String>] [[-broker_port] <Int32>] [[-routing_key] <String>] [[-broker_exchange] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
New-Graylog2Input -inputGlobalNode -inputTitle "Dummy Syslog" -inputType "Syslog UDP" -port 9515 -bind_address "0.0.0.0"
```

## PARAMETERS

### -inputGlobalNode
Switch to define if input will be local to selected node or global (all nodes)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -inputTitle
Name of your new input that describes it

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -inputType
Type of input to create (for instance "Syslog UDP")
Use cmdlet Get-Graylog2InputTypes to check for supported types

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -port
Port to listen on

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -bind_address
Address to listen on.
For example 0.0.0.0 or 127.0.0.1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -fetch_wait_max
Wait for this time or the configured minimum size of a message batch before fetching

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -threads
Number of processor threads to spawn

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -zookeeper
Host and port of the ZooKeeper that is managing your Kafka cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -fetch_min_bytes
Wait for a message batch to reach at least this size or the configured maximum wait time before fetching

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -source
What to use as source of the generate messages

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sleep
How many milliseconds to sleep between generating messages

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -sleep_deviation
The deviation is used to generate a more realistic and non-steady message flow

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -topic_filter
Every topic that matches this regular expression will be consumed

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allow_override_date
Allow to override with current date if date could not be parsed?
Must be one of 'true' or 'false'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -store_full_message
Store the full original syslog message as full_message?
Must be one of 'true' or 'false'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -force_rdns
Force rDNS resolution of hostname?
Use if hostname cannot be parsed.
Must be one of 'true' or 'false'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -override_source
The source is a hostname derived from the received packet by default.
Set this if you want to override it with a custom string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -headers
Add a comma separated list of additional HTTP headers.
For example: Accept: application/json, X-Requester: Graylog2

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -interval
Time between every collector run

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -path
Path to the value you want to extract from the JSON response.
Take a look at the documentation for a more detailled explanation

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: $.store.book[1].number_of_orders
Accept pipeline input: False
Accept wildcard characters: False
```

### -target_url
HTTP resource returning JSON on GET

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: Http://example.org/api
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeunit
Interval time unit.
Must be one of "minutes","milliseconds","days","seconds","microseconds","nanoseconds","hours"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: Minutes
Accept pipeline input: False
Accept wildcard characters: False
```

### -duration_unit
The time unit that will be used in for example timer values.
Think of: took 15ms.
Must be one of "minutes","milliseconds","days","seconds","microseconds","nanoseconds","hours"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: Milliseconds
Accept pipeline input: False
Accept wildcard characters: False
```

### -report_unit
Report interval unit.
Must be one of "minutes","milliseconds","days","seconds","microseconds","nanoseconds","hours"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 23
Default value: Seconds
Accept pipeline input: False
Accept wildcard characters: False
```

### -rate_unit
The time unit that will be used in for example meter values.
Think of: 7 per second.
Must be one of "minutes","milliseconds","days","seconds","microseconds","nanoseconds","hours"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 24
Default value: Seconds
Accept pipeline input: False
Accept wildcard characters: False
```

### -report_interval
Time between each report.
Must be one of "minutes","milliseconds","days","seconds","microseconds","nanoseconds","hours"

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 25
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -receive_buffer_size
The size in bytes of the recvBufferSize for network connections to this input

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 26
Default value: 1048576
Accept pipeline input: False
Accept wildcard characters: False
```

### -queue
Name of queue that is created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 27
Default value: Log-messages
Accept pipeline input: False
Accept wildcard characters: False
```

### -broker_username
Username to connect to AMQP broker

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 28
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -broker_password
PAssword to connect to AMQP broker

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 29
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -prefetchCount
For advanced usage: AMQP prefetch count.
Default is 0 (unlimited)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 30
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -broker_hostname
Hostname of the AMQP broker to use

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 31
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -broker_vhost
Virtual host of the AMQP broker to use

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 32
Default value: /
Accept pipeline input: False
Accept wildcard characters: False
```

### -broker_port
Port of the AMQP broker to use (optional)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 33
Default value: 5672
Accept pipeline input: False
Accept wildcard characters: False
```

### -routing_key
Routing key to listen for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 34
Default value: #
Accept pipeline input: False
Accept wildcard characters: False
```

### -broker_exchange
Name of exchange to bind to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 35
Default value: Log-messages
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
