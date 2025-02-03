package at.scch.landooe.prolog_web_server.rest.v0.controller;

import at.scch.landooe.prolog_web_server.service.PrologService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static at.scch.landooe.prolog_web_server.constants.RestConstants.V0;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(V0 + "/")
@CrossOrigin(origins = "${spring.security.oauth2.resourceserver.cors-config}")
public class PrologController {
    private final PrologService prologService;

    @GetMapping("fetch-law")
    public ResponseEntity<String> fetchLaw(@RequestParam(name="kurztitel", required = false) String kurzTitel) {
        return prologService.fetchLaw(kurzTitel);
    }

    @GetMapping("status")
    public ResponseEntity<String> status() {
        return prologService.forward("status");
    }

    @GetMapping("version")
    public ResponseEntity<String> version() {
        return prologService.forward("version");
    }

}
