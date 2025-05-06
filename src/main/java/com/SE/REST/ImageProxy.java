package com.SE.REST;

import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;

@RestController
public class ImageProxy {

	 @GetMapping("/fetchImage/{fileId}")
	    public void fetchImage(@PathVariable("fileId") String fileId, HttpServletResponse response) {
	        String imageUrl = "https://drive.google.com/uc?export=download&id=" + fileId;

	        try {
	            URL url = new URL(imageUrl);
	            URLConnection connection = url.openConnection();

	            // Dynamically get content type
	            String contentType = connection.getContentType();
	            response.setContentType(contentType != null ? contentType : "application/octet-stream");

	            try (InputStream inputStream = connection.getInputStream();
	                 OutputStream outputStream = response.getOutputStream()) {

	                byte[] buffer = new byte[8192];
	                int bytesRead;

	                while ((bytesRead = inputStream.read(buffer)) != -1) {
	                    outputStream.write(buffer, 0, bytesRead);
	                }
	            }
	        } catch (Exception e) {
	            try {
	                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Image fetch failed");
	            } catch (IOException ex) {
	                ex.printStackTrace();
	            }
	        }
	    }
}