# Programming with Mati: KqlDB

# Running Locally
We're deploying the following components with Docker compose:

- Zookeeper
- Kafka
- Create Topics container
- ksqlDB server
- ksqlDB CLI

Feel free to checkout the [ksqlDB Server config][ksqldb-server-config] to see how we're configuring the ksqlDB server in this tutorial. The configuration is pretty basic in this introductory tutorial, but we'll expand on this in later episodes :)

[ksqldb-server-config]: ksqldb-server/ksql-server.properties

When you're ready, you can start the above services by running the following command:

```sh
docker-compose up &
```

[ksqldb-server-config]: files/ksqldb-server/ksql-server.properties
[connect-config]: files/ksqldb-server/connect.properties


Log into the ksqlDB CLI using the following command:

```sh
docker-compose exec ksqldb-cli ksql http://ksqldb-server:8088
```

If you see a `Could not connect to the server` error in the CLI, wait a few seconds and try again. ksqlDB can take several seconds to start.

Then, run this command in the ksqldb-cli:
```sql
SHOW TOPICS;
```

Now, you're ready to run the ksqlDB statements for our hello, world tutorial.

## 1 | Set the Ksql consumer to `earliest`
We want to set the Ksql consumer to `earliest` so that we can see all messages that we will be producing.
Run the following:
```sql
SET 'auto.offset.reset'='earliest';
```
## 2 | Create a Stream of users
```sql
CREATE STREAM users (
    ROWKEY INT KEY,
    USERNAME VARCHAR
) WITH (
    KAFKA_TOPIC='users',
    VALUE_FORMAT='JSON'
);
```
You should receive a message like this:
```sql
 Message        
----------------
 Stream created 
----------------
```
You can verify the Stream was created running:
```sql
SHOW STREAMS;
```

## 3 | Insert data into the Stream

```sql
INSERT INTO users (username) VALUES ('Mati');
INSERT INTO users (username) VALUES ('Michelle');
INSERT INTO users (username) VALUES ('John');
```

## 4 | Consume Stream
```sql
SELECT 'Hello, ' + USERNAME AS GREETING
FROM users
EMIT CHANGES;
```

You should see output similar to the following:

```sql
+--------------------+
|GREETING            |
+--------------------+
|Hello, Mati         |
|Hello, Michelle     |
|Hello, John         |
```
You can also open a Kafka Console Consumer and check what's happening in the `users` topic by running this in a new terminal:
```sh
docker-compose exec kafka kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic users
```
Once you're finished, tear everything down using the following command:

```sh
docker-compose down
```
