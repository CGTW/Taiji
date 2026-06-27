package com.agent.taiji.practice.client;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ChatConfig {

    /**
     * 注入一个聊天Bean
     * @param builder
     * @return
     */
    @Bean
    public ChatClient chatClient(ChatClient.Builder builder) {
        // 在这里进行全局默认配置
        return builder
                .defaultSystem("你是一个乐于助人的AI助手。")
                .build();
    }
}
