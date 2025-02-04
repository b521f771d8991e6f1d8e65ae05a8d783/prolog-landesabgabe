package at.scch.landooe.prolog_web_server.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@RequiredArgsConstructor
public class PrologService {
    private final RestTemplate restTemplate;
    @Value("${lx.backend.base-url}")
    private String lxBaseUrl; // SWIFT BACKEND

    public ResponseEntity<String> fetchLaw(String kurzTitel) {
        String url = kurzTitel == null || kurzTitel.isEmpty()
                ? lxBaseUrl + "/fetch-law"
                : lxBaseUrl + "/fetch-law?kurztitel=" + kurzTitel;
        return restTemplate.getForEntity(url, String.class);
    }

    public ResponseEntity<String> forward(String resource) {
        return restTemplate.getForEntity(lxBaseUrl + "/" + resource, String.class);
    }
}
