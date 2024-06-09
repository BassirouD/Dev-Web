package koula.diallo.ecommerce.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.context.annotation.Bean;
import org.springframework.kafka.config.TopicBuilder;
import org.springframework.stereotype.Service;

@Service
public class KafkaOrderTopicConfig {
    @Bean
    public NewTopic orderTopic(){
        return TopicBuilder
                .name("order-topic")
                .build();
    }
}
