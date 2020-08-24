Query all columns for all American cities in the **CITY** table with populations larger than 100000. The **CountryCode** for America is USA

The structure:

```sql
create table city(
  id int,
  name varchar(255),
  countrycode varchar(255),
  district varchar(255),
  population int
);
```