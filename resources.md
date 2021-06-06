## Practical SQL, 2nd Edition

[Practical SQL](https://www.nostarch.com/practicalsql2/) by Anthony DeBarros is available from No Starch Press.

### Resources

The Appendix of Practical SQL, 2nd Edition contains a list of resources to help you stay informed about PostgreSQL developments, find additional software, and get help. Below is an ongoing list updated from the original in the book. If you'd like to suggest an addition or edit, please open an issue.

### PostgreSQL Development Environments

Throughout the book, we’ve used the graphical user interface [pgAdmin](https://www.pgadmin.org) to connect to PostgreSQL, run queries, and view database objects. Although pgAdmin is free, open source, and popular, it’s not your only choice for working with PostgreSQL. The wiki entry “PostgreSQL Clients” at [https://wiki.postgresql.org/wiki/PostgreSQL_Clients](https://wiki.postgresql.org/wiki/PostgreSQL_Clients) catalogs many alternatives. 

The following list shows several tools I’ve tried, including free and paid options. The free tools work well for general analysis work. If you wade deeper into database development, you might want to upgrade to the paid options, which typically offer advanced features and support:

[Beekeeper Studio](https://www.beekeeperstudio.io/): Free and open source GUI for PostgreSQL, MySQL, Microsoft SQL Server, SQLite and other platforms. Beekeeper works on Windows, macOS, and Linux and features one of the more refined app designs among database GUIs.

[DBeaver](https://dbeaver.com/): Described as a “universal database tool” that works with PostgreSQL. MySQL, and many other databases, it includes a visual query builder, code auto-completion and other advanced features. Paid and free versions for Windows, macOS, and Linux.

[DataGrip](https://www.jetbrains.com/datagrip/): A SQL development environment that offers code completion, bug detection, and suggestions for streamlining code, among many other features. It’s a paid product, but the company, JetBrains, offers discounts and free versions for students, educators, and nonprofits.

[Navicat](https://www.navicat.com/): A richly featured SQL development environment with versions that support PostgreSQL as well as other databases, including MySQL, Oracle, MongoDB, and Microsoft SQL Server. Navicat is a paid version only, but the company offers a 14-day free trial.

[Postbird](https://github.com/Paxa/postbird/): A simple cross-platform PostgreSQL GUI for writing queries and viewing objects. Free and open source.

[Postico](https://eggerapps.at/postico/): A macOS-only client from the maker of Postgres.app that takes its cues from Apple design. The full version is paid, but a restricted-feature version is available with no time limit.

[PSequel](https://www.psequel.com/): Also macOS-only, PSequel is a free PostgreSQL client that is decidedly minimalist (see ).

A trial version can help you decide whether a paid product is right for you.

### PostgreSQL Utilities, Tools, and Extensions

You can expand the capabilities of PostgreSQL via numerous third-party utilities, tools, and extensions. These range from additional backup and import/export options to improved formatting for the command line to powerful statistics packages. You’ll find a curated list at [https://github.com/dhamaniasad/awesome-postgres/](https://github.com/dhamaniasad/awesome-postgres/), but here are several to highlight:

[Devart Excel Add-In for PostgreSQL](https://www.devart.com/excel-addins/postgresql.html): An add-in that lets you load and edit data from PostgreSQL directly in Excel workbooks.

[MADlib](http://madlib.apache.org/): A machine learning and analytics library for large data sets.

[pgAgent](https://www.pgadmin.org/docs/pgadmin4/development/pgagent.html): A job manager that lets you run queries at scheduled times, among other tasks.

[pgBackRest](https://pgbackrest.org/):An advanced database backup and restore management tool.

[pgcli](https://github.com/dbcli/pgcli/): A replacement for psql that includes improved formatting when writing queries and viewing output.

[pgRouting](https://pgrouting.org/): Enables a PostGIS-enabled PostgreSQL database to perform network analysis tasks, such as finding driving distance along roadways.

[PL/R](http://www.joeconway.com/plr.html): A loadable procedural language that provides the ability to use the R statistical programming language within PostgreSQL functions and triggers.

[pspg](https://github.com/okbob/pspg/): Formats the output of psql into sortable, scrollable tables with support for several color themes.

### PostgreSQL News

Here’s a collection of online resources you can use to stay informed:

[EDB Blog](https://www.enterprisedb.com/blog/): Posts from the team at EnterpriseDB, a PostgreSQL services company that provides the Windows installer referenced in this book.

[Planet PostgreSQL](https://planet.postgresql.org/): A collection of blog posts and announcements from the database community.

[Postgres Weekly](https://postgresweekly.com/): An email newsletter that rounds up announcements, blog posts, and product announcements.

[PostgreSQL Mailing Lists](https://www.postgresql.org/list/): These lists are useful for asking questions of community experts. The pgsql-novice and pgsql-general lists are particularly good for beginners, although note that email volume can be heavy.

[PostgreSQL News Archive](https://www.postgresql.org/about/newsarchive/): Official news from the Postgres team.

[PostgreSQL User Groups](https://www.postgresql.org/community/user-groups/): A list of community groups that offer meetups and other activities.

[PostGIS Blog](http://postgis.net/blog/): Announcements and updates on the PostGIS extension covered in Chapter 15.

Additionally, I recommend paying attention to developer notes for any of the PostgreSQL-related software you use, such as pgAdmin.

### Documentation

You can find documentation for each version of PostgreSQL along with an FAQ and wiki on the [main page](https://www.postgresql.org/docs/). It’s worth reading through various sections of the manual as you learn more about a particular topic, such as indexes, or search for all the options that come with functions. In particular, the Preface, Tutorial, and SQL Language sections cover much of the material presented in the book’s chapters.

Other good resources for documentation are the [Postgres Guide](http://postgresguide.com/) and [Stack Overflow](https://stackoverflow.com/questions/tagged/postgresql/), where you can find questions and answers posted by developers. You can also check out the Q&A site for [PostGIS](https://gis.stackexchange.com/questions/tagged/postgis/).


