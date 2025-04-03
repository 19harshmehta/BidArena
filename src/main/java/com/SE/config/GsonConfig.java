package com.SE.config;

import com.SE.util.LocalDateTimeAdapter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.http.converter.json.GsonHttpMessageConverter;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component
public class GsonConfig {

    @Bean
    public Gson gson() {
        return new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter()) // Custom adapter for LocalDateTime
                .setPrettyPrinting()
                .create();
    }

    @Bean
    public GsonHttpMessageConverter gsonHttpMessageConverter() {
        return new GsonHttpMessageConverter(gson());
    }
}
