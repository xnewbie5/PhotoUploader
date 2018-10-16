<!-- HOMEWORK #2 -->
<!-- Gerry Su #16325043 -->
<!-- EECS 118 -->

<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<%
	String funcID = request.getParameter("funcID");
	String name = request.getParameter("name");
%>
<!-- LOADING THE DRIVER -->
<%
try {
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    }
    catch(Exception e) {
    out.println("can't load mysql driver");
    out.println(e.toString());
}
%>
<!-- TO CREATE A CONNECTION WITH MySQL SERVER FOR THE DATABASE "gallery" -->
<%! Connection con;
String url="jdbc:mysql://127.0.0.1:3306/gallery";
String id="gallery";
String pwd="eecs118";
%>
<%-- style --%>
<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 15px;
    text-align: left;
}
p{
    padding-left:5em
}
</style>

 <!-- TO PERFORM SQL QUERIES -->
 <!-- List all Galleries and Select gallery Function -->
 <%!
 public void list_Gallery(JspWriter out) throws IOException{
    try{
        con= DriverManager.getConnection(url,id,pwd);
        Statement stmt = con.createStatement();
        String sql="SELECT * FROM gallery";
        ResultSet rs=stmt.executeQuery(sql);
        //prepare table and form FORM NAME : 
        out.println("<form NAME=\"gallerytable\" method=\"POST\">");
        out.println("<Table>");
        out.println("Table of Galleries");
        out.println("<tr>");
        out.println("<td> ID </td>" + "<td> Gallery Name </td>" + "<td> Description </td>");
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>"+rs.getString("gallery_id")+"</td>");
            out.println("<td>"+rs.getString("name")+"</td>");
            out.println("<td>"+rs.getString("description")+"</td>");
            out.println("<td> <input type=\"radio\" name=\"galleryselect\" value=\""+rs.getString("gallery_id")+"\" </td>");
            out.println("</tr>");
        }
        out.println("</Table>");
        out.println("<input type = \"submit\" value = \"View Gallery\"/>");
        out.println("</form>");
    }
    catch(SQLException ex){
        String message = "ERROR: " + ex.getMessage();
        out.println(message);
        ex.printStackTrace();
    }
    finally {
        //close connection to database
        closeconnection();
     }
 }
 %>
 <%-- View a gallery and display its images. --%>
 <%!
 public void view_Gallery(int gallery_num, JspWriter out) throws IOException{
    try{
        con= DriverManager.getConnection(url,id,pwd);
        Statement stmt = con.createStatement();
        String sql="SELECT * FROM gallery.image WHERE gallery_id='"+gallery_num+"';";
        ResultSet rs=stmt.executeQuery(sql);
        //prepare table and form FORM NAME : 
        out.println("<form NAME=\"imagetable\" method=\"POST\">");
        out.println("<Table>");
        out.println("Viewing Gallery #" + gallery_num + ".");
        out.println("<tr>");
        out.println("<td> Title </td>" + "<td> Image </td>" + "<td> Gallery ID </td>" + "<td> Artist ID </td>" + "<td> Detail ID </td>");
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>"+rs.getString("title")+ "<br><input type=\"radio\" name=\"imageselect\" value=\""+rs.getString("detail_id")+"\"" +"</td>");
            out.println("<td><img src = \"" + rs.getString("link")+ "\" alt=\"ERROR\"> </td>");
            out.println("<td>"+rs.getString("gallery_id")+"</td>");
            out.println("<td>"+rs.getString("artist_id")+"</td>");
            out.println("<td>"+rs.getString("detail_id")+"</td>");
            out.println("</tr>");
        }
        out.println("</Table>");
        out.println("<input type = \"submit\" value = \"View Image Details\"/>");
        out.println("</form>");
    }
    catch(SQLException ex){
        String message = "ERROR: " + ex.getMessage();
        out.println(message);
        ex.printStackTrace();
    }
    finally {
        //close connection to database
        closeconnection();
     }
 }
 %>

 
 <!-- Close connection function -->
 <%!
 public void closeconnection(){
    if (con != null) {
        // closes the database connection
        try {
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
 }
 %>

 <!-- To Add a Tuple into a Table -->
 <!-- <% /*
    PreparedStatement pstmt = con.prepareStatement("insert into customer values
    (default,?,?,?)",Statement.RETURN_GENERATED_KEYS);
    pstmt.clearParameters();
    pstmt.setString(1, name);
    pstmt.setString(2, street);
    pstmt.setString(3, city);
    pstmt.executeUpdate();
    rs=pstmt.getGeneratedKeys();
    while (rs.next()) {
    out.println("Successfully added. Customer_ID:"+rs.getInt(1));
    }*/
 %> -->

<html>

<h2><center> Web application with Database</center></h2>
<h3><center> MiniProject #2 by Gerry Su 16325043</center></h3>
<body>

 <!-- Reload Page button -->
<center>
<input type="button" value="Refresh Page" onClick="window.location.href=window.location.href">
</center>

<%-- List all galleries button --%>
 <FORM NAME="form1" METHOD="POST">
     <INPUT TYPE="HIDDEN" NAME="buttonName">
     <INPUT TYPE="BUTTON" VALUE="List all Galleries" ONCLICK="list_Gallery()">
 </FORM>

 <SCRIPT LANGUAGE="JavaScript">
     function list_Gallery()
     {
         document.form1.buttonName.value = "List_gallery";
         form1.submit();
     } 
 </SCRIPT>

<!-- List_Gallery Table will appear here -->
<%
String check = request.getParameter("buttonName");
if(check != null && check.equals("List_gallery")) {
       list_Gallery(out);
}
%>
<%-- check which gallery the user selected --%>
<%
check = request.getParameter("galleryselect");
if(check != null) {
       out.println("You selected gallery #"+ check+".");
       //execute gallery function
       view_Gallery(Integer.valueOf(check), out);
}
%>

<h3>Add a Gallery</h3>
<form method="post" action="querypage.jsp">
<input type= "hidden" name ="AddGallery" value = "">
Gallery Name:<br>
<input type="text" name="name">
<br>
Description:<br>
<input type="text" name="description">
<input type="submit" value="submit">
</form>

<h3>Add an Artist</h3>
<form method="post" action="querypage.jsp">
<input type= "hidden" name ="AddArtist" value = "">
Artist Name:<br>
<input type="text" name="name">
<br>
Birth Year:<br>
<input type="text" name="year">
<br>
Country:<br>
<input type="text" name="country">
<br>
Description:<br>
<input type="text" name="description">
<input type="submit" value="submit">
</form>

<h3>Add an Image</h3>
<h4>Please fill in all the blanks</h4>
<form method="post" action="querypage.jsp">
<input type= "hidden" name ="AddImage" value = "">
Title:
<input type="text" name="title">
<br></td>
Link to Image (URL):&emsp;
<input type="text" name="urlInput" maxlength="200">
<br>
Gallery ID:
<input type="text" name="gallery_id" style="width: 35px">
<br>
Artist ID:
<input type="text" name="artist_id" style="width: 35px">
<br>
Year:
<input type="text" name="picture_year" style="width: 50px">
<br>
Type:
<input type="text" name="picture_type" style="width: 100px">
<br>
Width:
<input type="text" name="picture_width" style="width: 75px">
<br>
Height:
<input type="text" name="picture_height" style="width: 75px">
<br>
Location:
<input type="text" name="picture_location">
<br>
Description:<br>
<textarea name="picture_description" cols="30" rows="6" maxlength="45"></textarea>
<input type="submit" value="submit">
</form>



</body>
</html>
