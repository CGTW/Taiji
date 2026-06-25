package com.agent.taiji.practice.client;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ChatConfig {

    @Bean
    public ChatClient chatClient(ChatClient.Builder builder) {
        // 在这里进行全局默认配置
        return builder
                .defaultSystem("你是一个乐于助人的AI助手。") // 设置全局系统提示词[reference:1]
                // .defaultTemperature(0.7) // 设置默认温度参数等
                .build();
    }
}
