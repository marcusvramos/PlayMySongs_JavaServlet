<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="unoeste.fipp.playmysongs.security.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Enviar Músicas - Play My Songs</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var inputs = document.querySelectorAll('#musicName, #musicStyle, #artistName');
            inputs.forEach(function(input) {
                input.addEventListener('input', function() {
                    this.value = this.value.replace(/[^A-Za-z0-9_]/g, '');
                });
            });
        });
    </script>
</head>
<body>


<!-- Navbar (similar ao index.jsp, mas pode remover o formulário de login) -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <img src="assets/images/love-song-icon.jpg" alt="logo sistema" height="70px"/>
        </a>
        <div class="ms-auto">
            <% User usuario = (User) session.getAttribute("usuario"); %>
            <% if (usuario != null) { %>
            <span class="navbar-text">
          Olá, <%= usuario.getUsername() %>!
        </span>
            <!-- Botão de voltar para tela anterior -->
            <button class="btn btn-secondary" type="button" onclick="location.href='<%=request.getContextPath()%>/index.jsp'">Voltar</button>
            <button class="btn btn-primary" type="button" onclick="location.href='<%=request.getContextPath()%>/logout-servlet'">Logout</button>
            <% } %>
        </div>
    </div>
</nav>

<!-- Conteúdo principal -->
<div class="container mt-4">
    <h2>Envio de Músicas</h2>
    <p>Informe os detalhes da música e escolha o arquivo para enviar:</p>
    <!-- Formulário de upload -->
    <form action="<%=request.getContextPath()%>/upload-servlet" method="POST" enctype="multipart/form-data">
    <div class="mb-3">
            <label for="musicName" class="form-label">Nome da música:</label>
            <input type="text" class="form-control" name="musicName" id="musicName" required>
        </div>
        <div class="mb-3">
            <label for="musicStyle" class="form-label">Estilo:</label>
            <input type="text" class="form-control" name="musicStyle" id="musicStyle" required>
        </div>
        <div class="mb-3">
            <label for="artistName" class="form-label">Cantor:</label>
            <input type="text" class="form-control" name="artistName" id="artistName" required>
        </div>
        <div class="mb-3">
            <label for="fileUpload" class="form-label">Arquivo:</label>
            <input type="file" class="form-control" name="fileUpload" id="fileUpload" required>
        </div>
        <button type="submit" class="btn btn-primary">Enviar</button>

        <% if (session.getAttribute("uploadStatus") != null && session.getAttribute("message") != null) { %>
        <div class="alert <%= "success".equals(session.getAttribute("uploadStatus")) ? "alert-success" : "alert-danger" %>" role="alert">
            <%= session.getAttribute("message") %>
        </div>
        <%
            session.removeAttribute("uploadStatus");
            session.removeAttribute("message");
        %>
        <% } %>
    </form>
</div>

</body>
</html>
