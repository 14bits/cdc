# Architecture

## Usefulness
The developer has only 3 touch points:

1. Their DB with whatever business logic they have.
2. The ETL system to define the views they want .
3. Flutter Views using Widgets.

Everything else is handled for them.



## Stack
Its 100% unidirectional in this order and so no side effects:


1. Legacy DB x n

- These can be any Databases or non databases.
- All we need is the binlog out of them which is what CDC is all about.
- Mongo DB does this natively.


2. CDC gets all changes to the Legacy DB's

- Pumps the changes into NATS queues where each queue represents one Table of the Legacy DB. 

- Legacy DBs with CDC:
	- CR
		- https://www.cockroachlabs.com/docs/stable/change-data-capture.html
	- MySQL and Postresql
		- https://github.com/wal-g/wal-g
  - MySQL and Postresql
    - https://github.com/moiot/gravity
    - this one is impressive, but uses Kafka. Easy to also use NATS i think.

- These events are CUD events per Table.
- Each Legacy DB has its own Namespace so they do not clash.
- Nothing else.
- Minio is likely a perfect Store of the CUC Messages which has NATS integration.
  - SO any new data in Minio produces an Event onto NATS.
  

3. ETL to transform the data into the required View Models needed by each Microservice.

- Benthos looks pretty amazing for this: https://github.com/Jeffail/benthos
  - Very adaptable and all golang.

- This is like a Virtual Spreadsheet.  This is a conceptual iea / approach worth thinking about.
	- Spreadsheet = Legacy System
	- Spreadsheet Sheet = Table of Legacy System
	- Spreadsheet Column = Column / Field of Legacy System
	- Functions are where the streaming mapping takes place. Standard functions are are provided.
		- So "=SUM(A1 * B1)" is the language and we map that to the Golang functions.

- So, the data is in NATS queues with one per CDC Table Column ( where the data came from originally)
- The user uses Spreadsheet Functions that are really just PUB SUB, in that a change event from one queue pumps data into another NATS queue.
	- Its parametric in that you end up with PUB SUB chains.

- Eventually you have the end of a chain, and that is where the data finally goes into the Unified Cloud DB

- So you end up with View Models ready for Consumers like:
	- A GUI View Model
	- A MicroServices's View Model
	- A Reporting systems view Model

- User interaction: This is where a HIL occurs ( Human in the loop) to configure it.

	- They have a Spreadsheet like view of the data.
	- They only have to program Functions.
	- But the Data is just CUD events ? 
		- Its just reconciled at runtime from on all the CUD events in NATS. Just like how a Bank Ledger is created at runtime by calculating the Debits and Credits.
		- For end chains, we can show the data from the Unified Cloud DB.

- Programmer interaction: This is where a developer can extend it.

	- Function are just simple things, but we want to make them plugable.
	- Each is just like a FAAS, in that it gets called by NATS, returns a result.
	- GRPC us the best interface here so that they can be programmed in any language.
		- Because its NATS queues if any Plug goes down the system will just catchup.

	- Some metrics for the Developer would be useful here.
	- See : https://github.com/360EntSecGroup-Skylar/excelize for example
	- Function parser: https://github.com/xuri/efp
	- GUI: We will build a Flutter Excel
	- Export, we will allow Excel sheet export.
		- Allows downstream business processes.

Other lib to use:
https://github.com/AljabrIO/koalja-operator
https://github.com/kocircuit
https://github.com/uw-labs/substrate




4. Unified Cloud DB

- Subscribes to the ETL NATS queue's that have no further chains to sense the last CUD ( Create Update Delete) events and:
	- Updates the Cloud DB (TiDB or CR), Cloud Blob (seaweedfs or minio) and Index (Blast)
	- More storage can be added like TimeSeries, etc

- Every storage type has the ability to detect a change and sent those to Centrifugo as CUD Events so changes are pushed up to Subscribing clients.
	- This is easy because this storage is all bucket like. The data has already been transformed at the ETL stage before.
	- For a Blob it would be that the HASH has changed

- Indexing
	- For a blob it would be all the meta data.
	- For a SQL it be the Bleve standard mapping.


5. Queries are done from the Clients that can be Flutter, Web or other Microservices

- The query is just a Graphql query, so that we get lots of data in one hit for a Page or whatever.
- The query hits the Unified Storage and: 
	- TURNS on the SUBS in Centrifugo for each Table / Index or others storage type in the Unified Storage.
	- returns the data for the Query


6. Client gets the query data and:

- The Page reflects on the data & pushes it into the right widgets.

- The widgets subscribe to the Centrifugo system for updates and slip stream them into the views.
	- When the Query has predicates ( where user = bob & foe=bah) then we must make a NATS queue for each
	- The user is mapped to the Queue. many users can be mapped to one queue
	- When no user maps to the Queue, the queue can be garbage collected.

- The client can choose to store the Data for each Page or not as JSON.
	- Its very simple for them to store it as its just one big JSON blob.
- When the client navigates to another Page, they drop the SUBS or not ?
	- They should NOT IF they are storing the data client side.
	- They should if the are NOT storing the data client side.


7. Client Mutations.

- Any mutation is described as a Command string with a JSON payload.
- This goes back to the Legacy DB's. Hence why the system is Unidirectional.
	- Each Legacy DB is really just a very very dumb MicroService in essense but can be a simple simple DB
	- They get the mutation payload from Centrifugo and then a handler does whatever it needs to do to the DB
	- This then goes back up to Step 1


## Security

https://github.com/gopasspw/gopass
- server
https://github.com/gopasspw/gopassbridge
- Browser. Integrate for Flutter







