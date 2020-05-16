--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--CREATE DATABASE transcribeapp_db;

--DROP TRIGGER last_updated ON users;
--DROP TRIGGER last_updated ON unregistered_users;
-- CREATE SCHEMA transcribe_app;

DROP TABLE IF EXISTS address;
drop SEquence IF EXISTS address_address_id_seq;
drop table IF EXISTS city_master;
drop SEquence IF EXISTS city_city_id_seq;
drop table IF EXISTS  country_master;
drop SEquence IF EXISTS country_country_id_seq;
drop table IF EXISTS users;
drop table IF EXISTS users_pkey;
drop SEquence IF EXISTS users_user_id_seq;



CREATE SEQUENCE address_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE address_address_id_seq OWNER TO devuser;

CREATE TABLE address (
    address_id integer DEFAULT nextval('address_address_id_seq'::regclass) NOT NULL,
    address text NOT NULL,
    address2 text,
    district text NOT NULL,
    city_id smallint NOT NULL,
    postal_code text,
    phone text NOT NULL,
    last_updated timestamp with time zone DEFAULT now() NOT NULL
);



ALTER TABLE address OWNER TO devuser;




--
-- Name: city_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE city_city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE city_city_id_seq OWNER TO devuser;

--
-- Name: city; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE city_master (
    city_id integer DEFAULT nextval('city_city_id_seq'::regclass) NOT NULL,
    city text NOT NULL,
    country_id smallint NOT NULL,
    last_updated timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE city_master OWNER TO devuser;

--
-- Name: country_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE country_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_country_id_seq OWNER TO devuser;

--
-- Name: country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE country_master (
    country_id integer DEFAULT nextval('country_country_id_seq'::regclass) NOT NULL,
    country text NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE country_master OWNER TO devuser;

--
-- Name: users_list_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW users_list_view AS
 SELECT cu.user_id AS id,
    (((cu.first_name)::text || ' '::text) || (cu.last_name)::text) AS name,
    a.address,
    a.postal_code AS "zip code",
    a.phone,
    city_master.city,
    country_master.country,
        CASE
            WHEN cu.activebool THEN 'active'::text
            ELSE ''::text
        END AS notes
   FROM (((users cu
     JOIN address a ON ((cu.address_id = a.address_id)))
     JOIN city_master ON ((a.city_id = city.city_id)))
     JOIN country_master ON ((city.country_id = country.country_id)));


ALTER TABLE users_list_view OWNER TO devuser;




CREATE SEQUENCE payment_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment_payment_id_seq OWNER TO devuser;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE payment (
    payment_id integer DEFAULT nextval('payment_payment_id_seq'::regclass) NOT NULL,
    user_id smallint NOT NULL,
    transcribtion_id integer NOT NULL,
    amount numeric(5,2) NOT NULL,
    payment_date timestamp with time zone NOT NULL
) PARTITION BY RANGE(payment_date);

ALTER TABLE payment OWNER TO devuser;


ALTER TABLE ONLY payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


    --
    -- Name: idx_fk_address_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace:
    --

    CREATE INDEX idx_fk_address_id ON customer USING btree (address_id);


    --
    -- Name: idx_fk_city_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace:
    --

    CREATE INDEX idx_fk_city_id ON address USING btree (city_id);



    --
    -- Name: idx_fk_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace:
    --

    CREATE INDEX idx_fk_user_id ON payment USING btree (user_id);








--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON address FOR EACH ROW EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION last_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END $$;


ALTER FUNCTION last_updated() OWNER TO devuser;
