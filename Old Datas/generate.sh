#!/bin/sh

echo "drop database if exists vp; create database vp;" | /usr/bin/mysql -uroot -pmysql

perl insert_author.pl
perl insert_articles.pl
