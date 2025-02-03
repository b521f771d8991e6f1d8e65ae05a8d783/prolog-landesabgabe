package at.scch.landooe.prolog_web_server.conf;

import at.scch.landooe.celeryutils.conf.CeleryConfig;
import at.scch.landooe.celeryutils.conf.CeleryProperties;
import at.scch.landooe.commons.conf.rabbit.GlobalRabbitConfig;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.core.Queue;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * Configuration for all beans and properties that are rabbitmq-related.
 */
//@Configuration
//@Import({GlobalRabbitConfig.class, CeleryConfig.class})
//@RequiredArgsConstructor
public class RabbitConfig {
//    private final CeleryProperties celeryProperties;
//
//    @Bean
//    public Queue transcriptionQueue() {
//        return new Queue(celeryProperties.celeryTaskQueueTranscription);
//    }
//
//    @Bean
//    public Queue transcriptionResponse() {
//        return new Queue(celeryProperties.celeryTaskReplyTo);
//    }
}
