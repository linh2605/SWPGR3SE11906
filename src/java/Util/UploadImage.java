package Util;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.UUID;

public class UploadImage {
    public static String generateUniqueFileName(String originalFileName) {
        String extension = "";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < originalFileName.length() - 1) {
            extension = originalFileName.substring(dotIndex + 1);
        }
        String uniquePart = UUID.randomUUID() + "-" + System.currentTimeMillis();
        return uniquePart + "." + extension;
    }

    public static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim()
                        .replace("\"", "");
            }
        }
        return null;
    }

    public static String saveImage(HttpServletRequest req, String fieldName) throws ServletException, IOException {
        Part filePart = req.getPart(fieldName);
        String fileName = UploadImage.getFileName(filePart);
        assert fileName != null;

        // Kiểm tra kiểu MIME của file
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new ServletException("File tải lên không phải là hình ảnh hợp lệ.");
        }

        String newFileName = UploadImage.generateUniqueFileName(fileName);
        String uploadDir = req.getServletContext().getRealPath("/") + "views/assets/uploads";
        Path filePath = Paths.get(uploadDir, newFileName);

        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        newFileName = "uploads/" + newFileName;
        return newFileName;
    }
    public static String readFile(String filePath) {
        StringBuilder content = new StringBuilder();

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line).append("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return content.toString();
    }
    public static ArrayList<String> multipleFileUpload(HttpServletRequest req, String fieldName) throws ServletException, IOException {
        ArrayList<String> fileNames = new ArrayList<>();
        for (Part part : req.getParts()){
            if (part.getName().equals(fieldName) && part.getSize() != 0){
                String originFileName = part.getSubmittedFileName();
                String newFileName = generateUniqueFileName(originFileName);
                String uploadDir = req.getServletContext().getRealPath("/") + "views/assets/uploads";
                Path filePath = Paths.get(uploadDir, newFileName);
                try (InputStream fileContent = part.getInputStream()) {
                    Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                newFileName = "uploads/" + newFileName;
                fileNames.add(newFileName);
            }
        }
        return fileNames;
    }
}
