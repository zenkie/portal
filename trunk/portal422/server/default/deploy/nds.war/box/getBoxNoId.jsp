<%--
  User: zhou
  Date: 2009-10-29
  Time: 17:02:53
  for get boxno id
  param:boxno,boxId
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="nds.query.QueryEngine" %>
<%@ page import="nds.util.Tools" %>
      <%
        response.setContentType("text/html;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        int boxno,boxid;
        try{
            boxno=Integer.parseInt(request.getParameter("boxno"));
            boxid=Integer.parseInt(request.getParameter("boxid"));
        }catch (NullPointerException e){
            boxno=-1;
            boxid=-1;
        }
        int boxNoId=-1;
        if(boxno!=-1&&boxid!=-1){
/*
            Connection conn=null;
            Statement stmt=null;
            ResultSet rs=null;
            try{
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn=DriverManager.getConnection("jdbc:oracle:thin:@192.168.1.225:1521:orcl","neands3","abc123");
                stmt=conn.createStatement();
                rs=stmt.executeQuery("select g.id from m_box t,m_boxitem g where g.m_box_id="+boxid+" and g.boxno="+boxno+" and rownum=1");
                rs.next();
                boxNoId=rs.getInt(0);
            }catch(ClassNotFoundException e){
                e.printStackTrace();
            }catch(SQLException ex){
                ex.printStackTrace();
            }finally {
                 if(rs!=null){
                     try{
                       rs.close();
                     }catch(SQLException ee){
                     }
                     rs=null;
                 }
                if(stmt!=null){
                    try{
                        stmt.close();
                    }catch(SQLException ee){
                    }
                    stmt=null;
                }if(conn!=null){
                    try{
                        conn.close();
                    }catch (SQLException ee){
                    }
                    conn=null;
                }
               }
*/

             boxNoId=Tools.getInt(QueryEngine.getInstance().doQueryOne("select g.id from m_box t,m_boxitem g where g.m_box_id="+boxid+" and g.boxno="+boxno+" and rownum=1"),-1);
        }
         out.print(boxNoId);
        %>
