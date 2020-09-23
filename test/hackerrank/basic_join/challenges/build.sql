drop table if exists hackers;
create table hackers(
  hacker_id int(11),
  name varchar(20)
);

drop table if exists challenges;
create table challenges(
  challenge_id int(11),
  hacker_id int(11)
);
