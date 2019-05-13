# cdc

cdc for databases into NATS.

This is for CQRS style architecture.

The basic theory:

The DB is the write side and we "watch" for changes to them and feed the CUD ( Create, Update, Delete) events into NATS.
Once you have this in place it is a very powerful pattern because you can keep all other GUI's and MicroServices up to Date since they subscribe to the Changes.

See the Architecture Doc for more indepth info on the theory.






## todo

1. Write a CLi for pushing content into mySQL and Postresql, so we can use as a Test harness

2. Write a CLI for watching the messages hitting Minio and then goin into NATS topic.


## bits of bobs

SQLite WAL
https://github.com/CovenantSQL/CovenantSQL/blob/develop/xenomint/sqlite/sqlite.go
- shows how to do CDC with sqlite

