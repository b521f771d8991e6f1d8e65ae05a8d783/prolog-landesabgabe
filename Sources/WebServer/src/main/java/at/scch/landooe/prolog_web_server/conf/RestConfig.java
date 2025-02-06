package at.scch.landooe.prolog_web_server.conf;

import com.fasterxml.jackson.core.JsonFactoryBuilder;
import com.fasterxml.jackson.core.StreamReadConstraints;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestConfig {

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }


    @Bean
    public StreamReadConstraints streamReadConstraints() {
        return StreamReadConstraints.builder()
                .maxStringLength(Integer.MAX_VALUE).
                build();
    }

    @Bean
    public ObjectMapper objectMapper() {
        JsonFactoryBuilder builder = new JsonFactoryBuilder();
        builder.streamReadConstraints(streamReadConstraints());
        ObjectMapper objectMapper = new ObjectMapper(builder.build());
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        objectMapper.registerModule(new JavaTimeModule());
        return objectMapper;
    }
}
