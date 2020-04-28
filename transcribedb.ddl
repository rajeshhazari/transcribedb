--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

CREATE DATABASE transcribedb;

#DROP TRIGGER last_updated ON transcribedb.users;
#DROP TRIGGER last_updated ON transcribedb.unregistered_users;




CREATE TABLE transcribedb.users (
    user_id SERIAL PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email_id text ,
    password text,
    address_id smallint NOT NULL,
    activebool boolean DEFAULT true NOT NULL,
    create_date date DEFAULT ('now'::text)::date NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    active integer
);


ALTER TABLE transcribedb.users OWNER TO postgres;



CREATE SEQUENCE transcribedb.address_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transcribedb.address_address_id_seq OWNER TO postgres;

CREATE TABLE transcribedb.address (
    address_id integer DEFAULT nextval('address_address_id_seq'::regclass) NOT NULL,
    address text NOT NULL,
    address2 text,
    district text NOT NULL,
    city_id smallint NOT NULL,
    postal_code text,
    phone text NOT NULL,
    last_updated timestamp with time zone DEFAULT now() NOT NULL
);



ALTER TABLE transcribedb.address OWNER TO postgres;




--
-- Name: city_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE transcribedb.city_city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transcribedb.city_city_id_seq OWNER TO postgres;

--
-- Name: city; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE transcribedb.city_master (
    city_id integer DEFAULT nextval('city_city_id_seq'::regclass) NOT NULL,
    city text NOT NULL,
    country_id smallint NOT NULL,
    last_updated timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE city_master OWNER TO postgres;

--
-- Name: country_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE transcribedb.country_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transcribedb.country_country_id_seq OWNER TO postgres;

--
-- Name: country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE transcribedb.country_master (
    country_id integer DEFAULT nextval('country_country_id_seq'::regclass) NOT NULL,
    country text NOT NULL,
    last_update timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE country_master OWNER TO postgres;

--
-- Name: users_list_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW transcribedb.users_list_view AS
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
   FROM (((customer cu
     JOIN address a ON ((cu.address_id = a.address_id)))
     JOIN city_master ON ((a.city_id = city.city_id)))
     JOIN country_master ON ((city.country_id = country.country_id)));


ALTER TABLE transcribedb.users_list_view OWNER TO postgres;




CREATE SEQUENCE transcribedb.payment_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transcribedb.payment_payment_id_seq OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE transcribedb.payment (
    payment_id integer DEFAULT nextval('payment_payment_id_seq'::regclass) NOT NULL,
    user_id smallint NOT NULL,
    transcribtion_id integer NOT NULL,
    amount numeric(5,2) NOT NULL,
    payment_date timestamp with time zone NOT NULL
) PARTITION BY RANGE(payment_date);

ALTER TABLE transcribedb.payment OWNER TO postgres;


ALTER TABLE ONLY transcribedb.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


    --
    -- Name: idx_fk_address_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace:
    --

    CREATE INDEX idx_fk_address_id ON transcribedb.customer USING btree (address_id);


    --
    -- Name: idx_fk_city_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace:
    --

    CREATE INDEX idx_fk_city_id ON transcribedb.address USING btree (city_id);



    --
    -- Name: idx_fk_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace:
    --

    CREATE INDEX idx_fk_user_id ON transcribedb.payment USING btree (user_id);








--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER transcribedb.last_updated BEFORE UPDATE ON address FOR EACH ROW EXECUTE PROCEDURE last_updated();



--
-- Name: last_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION transcribedb.last_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END $$;


ALTER FUNCTION transcribedb.last_updated() OWNER TO postgres;
