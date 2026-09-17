-- Constructora ERP canonical database prototype v0
-- Target: PostgreSQL 16+
--
-- Design rule: imported spreadsheets are evidence, not master data. Rows first
-- enter staging with immutable provenance. Only reviewed identities and business
-- documents enter the canonical schemas below.


create extension if not exists pgcrypto;

create schema if not exists core;
create schema if not exists iam;
create schema if not exists files;
create schema if not exists staging;
create schema if not exists projects;
create schema if not exists catalog;
create schema if not exists procurement;
create schema if not exists workforce;
create schema if not exists billing;
create schema if not exists finance;
create schema if not exists tax;
create schema if not exists accounting;
create schema if not exists fleet;
create schema if not exists reporting;

create domain core.money_amount as numeric(18, 2);
create domain core.quantity_value as numeric(18, 4);
create domain core.unit_rate as numeric(18, 4);

