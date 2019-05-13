 # Integration

we can do this in a Staggered way using GraphQL.
Below presents different ways to use the Archiecture.

The Client can use GRPC with GraphQL inside. So Can use Centrifugo.

This can ALL run in a single Process !! Finally 
https://github.com/systemd/portable-walkthrough-go

## A
Simple where:
- the DB holds all data for Write and Reads.
- We get mutations via DB trigger

 How ?

1. Mine the DB
- Get all Tables
- Create trigers, and so dont need to do any CDC
- Use Gorm for this ?

2. GraphQL
- IDE shows all tables and trigger
	- Like https://github.com/hasura/graphql-engine
- GraphQL Engine should be interpreter, but can code gen if needed.

3. Mutations go directly back into DB with zero code required
- But need Validators somewhere. Can do that in Script.

### Tech

CI
https://github.com/ovh/cds
- supports EVERYTHING
- can run all desktops inside VSPhere.
- Can run all in a single process. Check how they do that !!
- Very nice compared to many others.



GPRC
https://github.com/gunk/gunk-example-server
- go --> GRPC --> All other languages.
- Nice because you get easy support for all other languages.


GraphQL Introspection
- https://github.com/graph-gophers/graphql-go
	- GraphQL interpreted and well maintained
	- Has subscriptions. https://github.com/graph-gophers/graphql-transport-ws
		- Ex: https://github.com/matiasanaya/go-graphql-subscription-example

GraphQL Middleware ( auth, tracing, etc etc)
	- https://github.com/rodrigobotelho/graphql-kit


Security Keys

- https://github.com/mozilla/sops
	- simple golang and allows them to be in Git.

CDC
- Once in NATS, Benthos can be used to push into BLast or minio




---

## B
Same as A, but:
- No triggers and instead parsing WAL

How ?
- Benthos does it.
- Pump into NATS queues

## C
Same as B, but:

- We have a Read only Database

How ?

- Use the WAL and Benthos for everything

- Pump Data into BLast stores

- GraphQL query on top of Blast with GraphQL IDE from the WAL like in A

- Mutations go back to DB like in A.

