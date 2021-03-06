alter session set container=XEPDB1;
-- Based on Tim Hall - https://oracle-base.com/articles/misc/oracle-application-express-apex-5-0-installation
BEGIN
    APEX_UTIL.set_security_group_id( 10 );
    
    APEX_UTIL.create_user(
        p_user_name                    => 'ADMIN'
       ,p_email_address                => 'me@example.com'
       ,p_web_password                 => '$$$$$$$$'
       ,p_developer_privs              => 'ADMIN'
       ,p_change_password_on_first_use => 'N');
        
    APEX_UTIL.set_security_group_id( null );
    COMMIT;
END;
/