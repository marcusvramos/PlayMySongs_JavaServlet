package unoeste.fipp.playmysongs.servlets;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 100,
    maxRequestSize = 1024 * 1024 * 10 * 10
)
@WebServlet(name = "uploadServlet", value = "/upload-servlet")
public class UploadServlet extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter writer = response.getWriter();

        System.out.println(getValue(request.getPart("musicName")));

        String musicName = getValue(request.getPart("musicName"));
        String musicStyle = getValue(request.getPart("musicStyle"));
        String artistName = getValue(request.getPart("artistName"));


        String fileName = musicName + "_" + musicStyle + "_" + artistName + ".mp3";

        String uploadPath = getServletContext().getRealPath("/") + "uploads";

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        try {
            Part filePart = request.getPart("fileUpload");
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // MSIE fix.

            if(submittedFileName.endsWith(".mp3")) {
                File file = new File(uploadDir, fileName);
                try (OutputStream out = new FileOutputStream(file);
                     InputStream fileContent = filePart.getInputStream()) {
                    int read;
                    final byte[] bytes = new byte[1024];
                    while ((read = fileContent.read(bytes)) != -1) {
                        out.write(bytes, 0, read);
                    }
                    HttpSession session = request.getSession();
                    session.setAttribute("uploadStatus", "success");
                    session.setAttribute("message", "Upload realizado com sucesso para " + fileName + ".");
                    response.sendRedirect(request.getContextPath() + "/enviamusica.jsp");
                }
            } else {
                setUploadErrorMessage(request, response, "Formato de arquivo inválido. Por favor, envie um arquivo .mp3.");
            }
        } catch (Exception fne) {
            setUploadErrorMessage(request, response, "Erro ao realizar o upload: " + fne.getMessage());
        }
    }

    private String getValue(Part part) throws IOException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream(), StandardCharsets.UTF_8))) {
            return reader.lines().collect(Collectors.joining(System.lineSeparator()));
        }
    }

    private void setUploadErrorMessage(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("uploadStatus", "error");
        session.setAttribute("message", message);
        response.sendRedirect(request.getContextPath() + "/enviamusica.jsp");
    }

}