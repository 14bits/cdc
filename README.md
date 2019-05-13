# cdc

cdc for databases into NATS.

This is for CQRS style architecture.

The basic theory:

The DB is the write side and we "watch" for changes to them and feed the CUD ( Create, Update, Delete) events into NATS.
Once you have this is very powerful pattern because you can keep all other GUI's and MicroServices up to Date since they subscribe ot the Changes.

We use this library:
https://github.com/wal-g/wal-g


Often you need to transforma the data also to your "common" Domain Mobel" or just for managing the DB changing but the Domain Model not changing. So you need a piped transformation engine. This is where Benthos can help.

We use this library:
https://github.com/Jeffail/benthos





## todo

1. Write a CLi for pushing content into mySQL and Postresql, so we can use as a Test harness

2. Write a CLI for watching the messages hitting Minio and then goin into NATS topic.
