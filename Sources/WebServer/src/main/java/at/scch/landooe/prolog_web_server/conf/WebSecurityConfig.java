package at.scch.landooe.prolog_web_server.conf;

import at.scch.landooe.commons.conf.security.GlobalWebSecurity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

@Slf4j
@Configuration
@EnableWebSecurity
@Import(GlobalWebSecurity.class)
class WebSecurityConfig {
}
