package at.scch.landooe.prolog_web_server.conf;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
@EnableScheduling
@ComponentScan(
        basePackages = {
                "at.scch.landooe.prolog_web_server.service",
                "at.scch.landooe.prolog_web_server.rest",
        })
public class ComponentConfig {
}
