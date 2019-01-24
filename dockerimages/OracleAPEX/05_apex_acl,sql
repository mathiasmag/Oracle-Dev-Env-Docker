alter session set container=XEPDB1;
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace => xs$ace_type(privilege_list => xs$name_list('connect'),
                           principal_name => 'apex_180200',
                           principal_type => xs_acl.ptype_db));
END;
/
