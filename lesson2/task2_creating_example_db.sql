create database if not exists example;
use example;

create table if not exists users (
	id serial primary key,
	name varchar(50)
);