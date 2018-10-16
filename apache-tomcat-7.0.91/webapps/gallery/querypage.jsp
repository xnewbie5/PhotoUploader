<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>

<html>
   <head>
      <title>Query Page</title>
   </head>
   
   <body>
    <%
    //Add gallery
    if(request.getParameter("AddGallery")!=null){
        String name=request.getParameter("name");
        String description=request.getParameter("description");
        Connection conn = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");
            String url="jdbc:mysql://127.0.0.1:3306/gallery";
            String id="gallery";
            String pwd="eecs118";
            conn = DriverManager.getConnection(url,id,pwd);
            Statement st=conn.createStatement();
            
            if(name.equals("")){
                out.println("Please enter a name.");
            }

            if(!name.equals("")){
                int i=st.executeUpdate("INSERT INTO gallery(name, description)values('"+name+"','"+description+"')");
                if (i>0){
                    out.println("Gallery is successfully inserted!");
                }
                else{
                    out.println("Gallery failed to insert! Try again?");
                }
            }
        }
        catch(Exception e){
            System.out.print(e);
            e.printStackTrace();
        }
        finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
    else if (request.getParameter("AddArtist")!=null){
        String name=request.getParameter("name");
        String year = request.getParameter("year");
        String country = request.getParameter("country");
        String description=request.getParameter("description");
        Connection conn = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");
            String url="jdbc:mysql://127.0.0.1:3306/gallery";
            String id="gallery";
            String pwd="eecs118";
            conn = DriverManager.getConnection(url,id,pwd);
            Statement st=conn.createStatement();
            
            if(name.equals("") || year.equals("") || country.equals("")){
                out.println("Please fill in name/year/country.");
            }
            else{
                int i=st.executeUpdate("INSERT INTO artist(name, birth_year, country, description)values('"+name+"','"+year+"','"+country+"','"+description+"')");
                if (i>0){
                    out.println("Artist is successfully inserted!");
                }
                else{
                    out.println("Artist failed to insert! Try again?");
                }
            }
        }
        catch(Exception e){
            System.out.print(e);
            e.printStackTrace();
        }
        finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
    else if (request.getParameter("AddImage")!=null){
        String title=request.getParameter("title");
        String urlInput = request.getParameter("urlInput");
        String gallery_id = request.getParameter("gallery_id");
        String artist_id=request.getParameter("artist_id");
        String picture_year = request.getParameter("picture_year");
        String picture_type = request.getParameter("picture_type");
        String picture_width = request.getParameter("picture_width");
        String picture_height = request.getParameter("picture_height");
        String picture_location = request.getParameter("picture_location");
        String picture_description = request.getParameter("picture_description");
        Connection conn = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");
            String url="jdbc:mysql://127.0.0.1:3306/gallery";
            String id="gallery";
            String pwd="eecs118";
            conn = DriverManager.getConnection(url,id,pwd);
            Statement st=conn.createStatement();
            
            if(title.equals("") || urlInput.equals("") || gallery_id.equals("") || artist_id.equals("")
            || picture_year.equals("") || picture_type.equals("") || picture_width.equals("") || picture_height.equals("")
            || picture_location.equals("") || picture_description.equals("")){
                out.println("Please fill in everything.");
            }
            else{
                int i=st.executeUpdate("INSERT INTO image(title, link, gallery_id, artist_id, detail_id)values('"+title+"','"+urlInput+"',"+gallery_id+","+artist_id+",'0')",st.RETURN_GENERATED_KEYS);
                if (i>0){
                    //create details then modify image
                    ResultSet rs = st.getGeneratedKeys();
                    rs.next();
                    int imageID = rs.getInt(1);
                    int j=st.executeUpdate("INSERT INTO detail(image_id, year, type, width, height, location, description)values('"+imageID+"','"+picture_year+"','"+picture_type+"','"+picture_width+"','"+picture_height+"','"+picture_location+"','"+picture_description+"')",st.RETURN_GENERATED_KEYS);
                    if(j>0){
                        rs = st.getGeneratedKeys();
                        rs.next();
                        int detailID = rs.getInt(1);
                        int k = st.executeUpdate("UPDATE `gallery`.`image` SET `detail_id` = '"+detailID+"' WHERE (`image_id` = '"+imageID+"');");
                        if(k>0){
                            out.println("Image is successfully inserted!");
                        }
                    }
                    else{
                        out.println("Image failed to insert! Detail failed to create. Try again?");
                    }
                }
                else{
                    out.println("Image failed to insert! Try again?");
                }
            }
        }
        catch(Exception e){
            System.out.print(e);
            e.printStackTrace();
        }
        finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
    %>
        <br>

        <button onclick="goBack()">Go Back</button>
        <script>
        function goBack(){
            window.history.back()
        }
        </script>
   </body>
</html>