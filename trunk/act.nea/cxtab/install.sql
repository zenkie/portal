----------------------------------------------
-- Export file for user NDS3                --
-- Created by yfzhu on 2008-05-21, 15:59:45 --
----------------------------------------------

spool install.log

prompt
prompt Creating function GET_SEQUENCENO
prompt ================================
prompt
create or replace function Get_SequenceNo(p_seqName in varchar2,
                                          p_clientId in number) return varchar2 as
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_preFix      varchar2(30);
    v_postFix     varchar2(30);
    v_format      varchar2(120);
    v_CURRENTNEXT number(10);
    v_id          number(10);
    v_lastDAte    date;
    v_no          varchar2(255);
    v_cycletype   char(1);
    v_sql         varchar2(400);
    pCTX          PLOG.LOG_CTX := PLOG.init('Get_SequenceNo', PLOG.LINFO);

    /**
    *  ����ad_table�����ad_sequence������
    *  vFormat �к������ɵ����еĹ���, ���յı�Ź�����
    *  prefix + vFormat + postfix
    *  vFormat �� yy/mm/dd ��ʾ�꣬9999��ʾ����ѭ��������0000��ʾ��ѭ������
    *  @param p_seqName �� ad_sequence ���name �ֶε�ֵ
    */
begin
    select id, nvl(prefix, ''), nvl(SUFFIX, ''), vformat, currentnext,
           to_date(to_char(lastdate), 'YYYYMMDD'), cycletype
    into v_id, v_prefix, v_postfix, v_format, v_currentnext, v_lastdate,
         v_cycletype
    from ad_sequence
    where name = upper(p_seqName) and ad_client_id = p_clientid
    for update;

    if v_cycletype = 'D' then
        -- cycle by day
        if to_char(v_lastdate, 'yyyymmdd') <> to_char(sysdate, 'yyyymmdd') then
            v_CURRENTNEXT := 0;
        end if;
    elsif v_cycletype = 'M' then
        -- cycle by month
        if to_char(v_lastdate, 'yyyymm') <> to_char(sysdate, 'yyyymm') then
            v_CURRENTNEXT := 0;
        end if;
    elsif v_cycletype = 'Y' then
        -- cycle by year
        if to_char(v_lastdate, 'yyyy') <> to_char(sysdate, 'yyyy') then
            v_CURRENTNEXT := 0;
        end if;
    end if;

    PLOG.info(pCTX,
              'p_seqName=' || p_seqName || ', CURRENTNEXT=' || v_CURRENTNEXT ||
              ', v_lastdate=' || v_lastdate);

    v_CURRENTNEXT := v_CURRENTNEXT + 1;

    update ad_sequence
    set lastdate = to_number(to_char(sysdate, 'YYYYMMDD')),
        currentnext = v_CURRENTNEXT
    where id = v_id;

    v_sql := 'select ' ||
             replace(v_Format, '$nextval', ltrim(to_char(v_CURRENTNEXT))) ||
             ' from dual ';
    execute immediate v_sql
        into v_no;

    commit;
    return v_prefix || v_no || v_postfix;
exception
    when others then
        PLOG.error(pCTX,
                   'Error for Get_SequenceNo(' || p_seqName || ',' ||
                   p_clientId || '):code=' || sqlcode || ', err=' || sqlerrm);
        raise_application_error(-20201,
                                '�޷���������Ϊ ' || p_seqName || ' �ĵ��ݺ�!');
    
end;
/

prompt
prompt Creating function GET_SEQUENCENO2
prompt =================================
prompt
create or replace function Get_SequenceNo2(p_seqName in varchar2,
                                           p_clientId in number,
                                           p_appendix1 in varchar2,
                                           p_appendix2 in varchar2)
    return varchar2 as
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_preFix      varchar2(30);
    v_postFix     varchar2(30);
    v_format      varchar2(120);
    v_CURRENTNEXT number(10);
    v_id          number(10);
    v_lastDAte    date;
    v_no          varchar2(255);
    v_cycletype   char(1);
    v_sql         varchar2(400);
    pCTX          PLOG.LOG_CTX := PLOG.init('Get_SequenceNo', PLOG.LINFO);

    /**
    *  ����ad_table�����ad_sequence������
    *  vFormat �к������ɵ����еĹ���, ���յı�Ź�����
    *  prefix + vFormat + postfix
    *  vFormat �� yy/mm/dd ��ʾ�꣬9999��ʾ����ѭ��������0000��ʾ��ѭ������
    *  $param p_seqName �� ad_sequence ���name �ֶε�ֵ
    *  $param p_appendix1   ������Ϣ1�� ��vformat ���� $appendix1 ��ʾ����ѡ��
    *  $param p_appendix2   ������Ϣ2�� ��vformat ���� $appendix2 ��ʾ����ѡ��
    */
begin
    select id, nvl(prefix, ''), nvl(SUFFIX, ''), vformat, currentnext,
           to_date(to_char(lastdate), 'YYYYMMDD'), cycletype
    into v_id, v_prefix, v_postfix, v_format, v_currentnext, v_lastdate,
         v_cycletype
    from ad_sequence
    where name = upper(p_seqName) and ad_client_id = p_clientid
    for update;

    if v_cycletype = 'D' then
        -- cycle by day
        if to_char(v_lastdate, 'yyyymmdd') <> to_char(sysdate, 'yyyymmdd') then
            v_CURRENTNEXT := 0;
        end if;
    elsif v_cycletype = 'M' then
        -- cycle by month
        if to_char(v_lastdate, 'yyyymm') <> to_char(sysdate, 'yyyymm') then
            v_CURRENTNEXT := 0;
        end if;
    elsif v_cycletype = 'Y' then
        -- cycle by year
        if to_char(v_lastdate, 'yyyy') <> to_char(sysdate, 'yyyy') then
            v_CURRENTNEXT := 0;
        end if;
    end if;

    PLOG.info(pCTX,
              'p_seqName=' || p_seqName || ', CURRENTNEXT=' || v_CURRENTNEXT ||
              ', v_lastdate=' || v_lastdate);

    v_CURRENTNEXT := v_CURRENTNEXT + 1;

    update ad_sequence
    set lastdate = to_number(to_char(sysdate, 'YYYYMMDD')),
        currentnext = v_CURRENTNEXT
    where id = v_id;

    v_sql := 'select ' || replace(replace(replace(v_Format,
                                                  '$nextval',
                                                  ltrim(to_char(v_CURRENTNEXT))),
                                          '$appendix1',
                                          p_appendix1),
                                  '$appendix2',
                                  p_appendix2) || ' from dual ';
    execute immediate v_sql
        into v_no;

    commit;
    return v_prefix || v_no || v_postfix;
exception
    when others then
        PLOG.error(pCTX,
                   'Error for Get_SequenceNo(' || p_seqName || ',' ||
                   p_clientId || '):code=' || sqlcode || ', err=' || sqlerrm);
        raise_application_error(-20201,
                                '�޷���������Ϊ ' || p_seqName || ' �ĵ��ݺ�!');
    
end;
/

prompt
prompt Creating function GET_SEQUENCENO_BY_ID
prompt ======================================
prompt
create or replace function Get_SequenceNo_by_id(p_seq_id in number)
    return varchar2 as
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_preFix      varchar2(30);
    v_postFix     varchar2(30);
    v_format      varchar2(120);
    v_CURRENTNEXT number(10);
    v_lastDAte    date;
    v_no          varchar2(255);
    v_cycletype   char(1);
    v_sql         varchar2(400);
    v_seqName     varchar2(20);
    v_client_id   number(10);
    pCTX          PLOG.LOG_CTX := PLOG.init('Get_SequenceNo', PLOG.LINFO);

    /**
    *  ����ad_table�����ad_sequence������
    *  vFormat �к������ɵ����еĹ���, ���յı�Ź�����
    *  prefix + vFormat + postfix
    *  vFormat �� yy/mm/dd ��ʾ�꣬9999��ʾ����ѭ��������0000��ʾ��ѭ������
    *  @param v_seqName �� ad_sequence ���name �ֶε�ֵ
    */
begin
    select nvl(prefix, ''), nvl(SUFFIX, ''), vformat, currentnext,
           to_date(to_char(lastdate), 'YYYYMMDD'), cycletype, name, ad_client_id
    into v_prefix, v_postfix, v_format, v_currentnext, v_lastdate, v_cycletype,
         v_seqName, v_client_id
    from ad_sequence
    where id = p_seq_id
    for update;

    if v_cycletype = 'D' then
        -- cycle by day
        if to_char(v_lastdate, 'yyyymmdd') <> to_char(sysdate, 'yyyymmdd') then
            v_CURRENTNEXT := 0;
        end if;
    elsif v_cycletype = 'M' then
        -- cycle by month
        if to_char(v_lastdate, 'yyyymm') <> to_char(sysdate, 'yyyymm') then
            v_CURRENTNEXT := 0;
        end if;
    elsif v_cycletype = 'Y' then
        -- cycle by year
        if to_char(v_lastdate, 'yyyy') <> to_char(sysdate, 'yyyy') then
            v_CURRENTNEXT := 0;
        end if;
    end if;

    v_CURRENTNEXT := v_CURRENTNEXT + 1;

    update ad_sequence
    set lastdate = to_number(to_char(sysdate, 'YYYYMMDD')),
        currentnext = v_CURRENTNEXT
    where id = p_seq_id;

    v_sql := 'select ' ||
             replace(v_Format, '$nextval', ltrim(to_char(v_CURRENTNEXT))) ||
             ' from dual ';
    execute immediate v_sql
        into v_no;

    commit;
    return v_prefix || v_no || v_postfix;
exception
    when others then
        PLOG.error(pCTX,
                   'Error for Get_SequenceNo(' || v_seqName || ',' ||
                   v_client_id || '):code=' || sqlcode || ', err=' || sqlerrm);
        raise_application_error(-20201,
                                '�޷���������Ϊ ' || v_seqName || ' �ĵ��ݺ�!');
    
end;
/


spool off
