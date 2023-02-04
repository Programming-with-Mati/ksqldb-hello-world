kafka-console-consumer --topic possible-fraud-alert \
--bootstrap-server localhost:9092 \
--property print.key=true \
--property key.separator=" : " \
--key-deserializer "org.apache.kafka.common.serialization.LongDeserializer" \
--value-deserializer "org.apache.kafka.common.serialization.StringDeserializer"
