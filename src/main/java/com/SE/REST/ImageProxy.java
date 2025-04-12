package com.SE.REST;

import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

@RestController
public class ImageProxy {

    @GetMapping("/image-proxy")
    public void imageProxy(@RequestParam("id") String id, HttpServletResponse response) {
        try {
            String driveUrl = "https://drive.google.com/uc?export=view&id=" + id;
            URL url = new URL(driveUrl);
            InputStream inputStream = url.openStream();

            // You can also dynamically detect type if needed
            response.setContentType("image/jpeg");  // or "image/png"

            // Use Spring's StreamUtils to copy stream to response
            StreamUtils.copy(inputStream, response.getOutputStream());
            inputStream.close();
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    } 
}