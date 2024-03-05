<%@ page import="unoeste.fipp.playmysongs.security.User" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FilenameFilter" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Play My Songs</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    function searchMusic() {
      var searchTerm = document.getElementById('searchTerm').value;
      window.location.href = '?search=' + encodeURIComponent(searchTerm);
    }
  </script>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">
      <img src="assets/images/love-song-icon.jpg" alt="logo sistema" height="70px"/>
    </a>
    <div class="ms-auto">
      <% User usuario = (User) session.getAttribute("usuario"); %>
      <% if (usuario == null) { %>
      <!-- Login Form -->
      <form class="d-flex" action="<%=request.getContextPath()%>/login-servlet" method="POST">
        <input class="form-control me-2" type="text" name="username" placeholder="Usuário" required>
        <input class="form-control me-2" type="password" name="password" placeholder="Senha" required>
        <button class="btn btn-outline-primary me-2" type="submit">Login</button>
      </form>
      <% } else { %>
      <span class="navbar-text" style="margin-right: 15px">
        Olá, <%= usuario.getUsername() %>!
      </span>
      <button class="btn btn-outline-secondary me-2" type="button" onclick="location.href='enviamusica.jsp'">Enviar músicas</button>
      <button class="btn btn-primary" type="button" onclick="location.href='<%=request.getContextPath()%>/logout-servlet'">Logout</button>
      <% } %>
    </div>
    <% if (session.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger" role="alert">
      <%= session.getAttribute("errorMessage") %>
    </div>
    <% session.removeAttribute("errorMessage"); %>
    <% } %>
  </div>
</nav>

<!-- Conteúdo principal -->
<div class="container mt-4">
  <div class="text-center my-4">
    <h1>Play My Songs</h1>
    <p class="text-secondary">Você pode enviar músicas aqui</p>
  </div>

  <!-- Form de busca -->
  <div class="input-group mb-4">
    <input type="text" class="form-control" placeholder="Informe a música, cantor ou estilo" id="searchTerm">
    <button class="btn btn-outline-secondary" type="button" id="button-search" onclick="searchMusic()">Pesquisar</button>
    <button class="btn btn-outline-primary" type="button" onclick="window.location.href='index.jsp'">Limpar</button>
  </div>

  <!-- Music list com controle de audio -->
  <div class="list-group">
    <%
      String searchTerm = request.getParameter("search");
      boolean found = false;
      if (searchTerm != null) {
        searchTerm = searchTerm.toLowerCase().replace(" ", "");
      }

      String uploadPath = application.getRealPath("/") + "uploads";
      File dir = new File(uploadPath);
      FilenameFilter filter = (dir1, name) -> name.endsWith(".mp3");

      if (dir.isDirectory()) {
        File[] files = dir.listFiles(filter);
        for (File file : files) {
          String fileName = file.getName();
          String filePath = "uploads/" + fileName;

          if (searchTerm == null || fileName.toLowerCase().contains(searchTerm)) {
            found = true;
            String[] parts = fileName.split("_");
    %>
    <!-- Início do item da lista -->
    <div class="list-group-item">
      <div class="d-flex w-100 justify-content-between">
        <h5 class="mb-1"><%= parts[0].replace(".mp3", "") %></h5>
        <small class="text-muted"><%= parts.length > 1 ? parts[1] : "" %></small>
      </div>
      <p class="mb-1"><%= parts.length > 2 ? parts[2] : "" %></p>
      <audio controls>
        <source src="<%=filePath%>" type="audio/mpeg">
      </audio>
    </div>
    <!-- Fim do item da lista -->
    <%
        }
      }
      if (!found && searchTerm != null && !searchTerm.trim().isEmpty()) {
    %>
    <div class="alert alert-info">Nenhuma música encontrada para "<%= searchTerm %>".</div>
    <%
        }
      }
    %>
  </div>
</div>
</body>
</html>
