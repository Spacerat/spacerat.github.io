---
layout: post
title:  "Following Chapter 1 of Internals of PostgreSQL "
date:   2019-04-24 12:23:37 -0700
categories: databases
---

In this post I will document my efforts to read and understand [Chapter 1] (_Database Cluster, Databases, and Tables_) of the [Internals of PostgreSQL] e-book, and summarize the things I learn.

Before starting to read this book, I installed a PostgreSQL server and created at database called `joe`. I this post, I follow along by using the Postgres server to test the things I've learned myself.

### It's just files on disk

This chapter essentially de-mystifies Postgres's file-structure. All of Postgres's tables are stored on disk. I used my Postgres application's UI
to find my installation's data directory:

    $ cd "/Users/joe/Library/Application Support/Postgres/var-10"

Postgres maintains metadata tables which store data about the you create, and that data can be used to locate your tables on disk.
I created my own table and put some data in it.

    joe=# CREATE TABLE foo (number integer, name text, flag boolean);
    joe=# INSERT INTO foo VALUES (1, 'meep', true), (2, 'moop', false), (null, null, null);

The [`pg_databases`] table catalogs databases and [`pg_class`] catalogs "tables and most everything else that has columns or is otherwise similar to a table". I used these to locate my table on disk, under `./base/<database_oid>/<table_oid>`

    joe=# SELECT datname, oid FROM pg_database;
     datname  |  oid  
    ----------+-------
    postgres  | 13267
    joe       | 16385

    joe=# SELECT oid FROM pg_class WHERE relname = 'foo';
    oid  
    -------
    24576

### Looking at the data

Navigating to the database and taking a look at the file, I expected it to contain the header and tuple data
described in the "Internal Layout of a Heap Table File" section:

    $ cd ./base/16385
    $ cat 24576

The file was empty! And yet the table definitely contains data:


    joe=# select * from foo;
    number | name | flag 
    --------+------+------
        1 | meep  | t
        2 | moop  | f
          |       | 

The chapter doesn't explain this but I figured that PostgreSQL must be storing the data in memory and delaying the write to disk
until necessary. I restarted my Postgres server to test this theory, and it was correct.

    $ cat 24576

    (�u$�  ؟D��D��8�	
                                    moop
                                            meep⏎

I put a pin on "when _exactly_ does Postgres write to disk" and viewed a hex dump of the file in order to
see its contents for myself.

    $ hexdump -C  24576
    00000000  00 00 00 00 28 eb 75 01  00 00 00 00 24 00 90 1f  |....(.u.....$...|
    00000010  00 20 04 20 00 00 00 00  d8 9f 44 00 b0 9f 44 00  |. . ......D...D.|
    00000020  90 9f 38 00 00 00 00 00  00 00 00 00 00 00 00 00  |..8.............|
    00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    *
    00001f90  80 02 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00001fa0  03 00 03 00 01 09 18 01  03 00 00 00 00 00 00 00  |................|
    00001fb0  7f 02 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    00001fc0  02 00 03 00 02 09 18 00  02 00 00 00 0b 6d 6f 6f  |.............moo|
    00001fd0  70 00 00 00 00 00 00 00  7f 02 00 00 00 00 00 00  |p...............|
    00001fe0  00 00 00 00 00 00 00 00  01 00 03 00 02 09 18 00  |................|
    00001ff0  01 00 00 00 0b 6d 65 65  70 01 00 00 00 00 00 00  |.....meep.......|
    00002000

My data is right there. The rows are in reverse order. Looking at the "moop" row:

- `02 00 00 00` is `number` (2 in decimal). 
- `0b` is 11 in decimal. I can only presume this is a prefix for `name`, but "moop" is only four characters. I'm not quite sure what the deal is here.
- `6d 6f 6f 70` is "moop"
- `00` afterwards is `flag` (False). True is represented using `01` for the "meep" row, and apparently `03` for the null row.

Following the book to [chapter 5] then looking up [HeapTupleHeaderData], I learned that 31 bytes preceed each tuple, which can be seen in the hex dump.

This has an interesting consequence: a table with less than 31 bytes of actual data per row (perhaps a link table containing a few 32 bit integers)
will contain more _metadata_ than actual data!

The chapter says that the header will contain `pd_lower` and `pd_upper`. I actually found Postgres's [storage page layout] documentation
useful for clarification:

> These contain byte offsets from the page start to the start of unallocated space, to the end of unallocated space, and to the start of the special space.

These can be found 36 and 38 bytes in to the hex dump, and they are `00 24` and `90 15`. I realized that the [endienness] of the binary data is opposite
to that of the hex dump display's 'line number', so:

- `00 24` is 36 in decimal. 36 bytes in, a long series of 0s begins.
- `90 1f` actually corresponds to line `00001f90` in the hex dump, where non-zero values reappear, and `moop` eventually shows up.


[Internals of PostgreSQL]: http://www.interdb.jp/pg/index.html
[`pg_databases`]: (https://www.postgresql.org/docs/10/catalog-pg-database.html)
[`pg_class`]: (https://www.postgresql.org/docs/10/catalog-pg-class.html)
[storage page layout]: https://www.postgresql.org/docs/10/storage-page-layout.html
[endienness]: https://en.wikipedia.org/wiki/Endianness
[chapter 1]: http://www.interdb.jp/pg/pgsql01.html
[chapter 5]: http://www.interdb.jp/pg/pgsql05.html#_5.2.
[HeapTupleHeaderData]: https://www.postgresql.org/docs/current/storage-page-layout.html
