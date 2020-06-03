begin;

  create table static_host_catalog (
    public_id wt_public_id primary key,
    scope_id wt_public_id not null
      references iam_scope (public_id)
      on delete cascade
      on update cascade,
    name text,
    description text,
    create_time wt_timestamp,
    update_time wt_timestamp,
    unique(scope_id, name)
  );

  create trigger
    update_time_column
  before update on static_host_catalog
    for each row execute procedure update_time_column();

  create trigger
    immutable_create_time
  before
  update on static_host_catalog
    for each row execute procedure immutable_create_time_func();

  create trigger
    default_create_time_column
  before
  insert on static_host_catalog
    for each row execute procedure default_create_time();

  create table static_host (
    public_id wt_public_id primary key,
    static_host_catalog_id wt_public_id not null
      references static_host_catalog (public_id)
      on delete cascade
      on update cascade,
    name text,
    description text,
    address text not null
    check(
      length(trim(address)) > 6
      and
      length(trim(address)) < 256
    ),
    create_time wt_timestamp,
    update_time wt_timestamp,
    unique(static_host_catalog_id, name)
  );

  create trigger
    update_time_column
  before update on static_host
    for each row execute procedure update_time_column();

  create trigger
    immutable_create_time
  before
  update on static_host
    for each row execute procedure immutable_create_time_func();

  create trigger
    default_create_time_column
  before
  insert on static_host
    for each row execute procedure default_create_time();

  create table static_host_set (
    public_id wt_public_id primary key,
    static_host_catalog_id wt_public_id not null
      references static_host_catalog (public_id)
      on delete cascade
      on update cascade,
    name text,
    description text,
    create_time wt_timestamp,
    update_time wt_timestamp,
    unique(static_host_catalog_id, name)
  );

  create trigger
    update_time_column
  before update on static_host_set
    for each row execute procedure update_time_column();

  create trigger
    immutable_create_time
  before
  update on static_host_set
    for each row execute procedure immutable_create_time_func();

  create trigger
    default_create_time_column
  before
  insert on static_host_set
    for each row execute procedure default_create_time();

  create table static_host_set_member (
    static_host_set_id wt_public_id
      references static_host_set (public_id)
      on delete cascade
      on update cascade,
    static_host_id wt_public_id
      references static_host (public_id)
      on delete cascade
      on update cascade,
    primary key(static_host_set_id, static_host_id)
  );

  insert into oplog_ticket (name, version)
  values
    ('static_host_catalog', 1),
    ('static_host', 1),
    ('static_host_set', 1),
    ('static_host_set_member', 1);

commit;