package com.agent.taiji.practice.client;


import com.agent.taiji.core.tool.WebSearchTool;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ChatConfig {

    @Bean
    public ChatClient chatClient(ChatClient.Builder builder, WebSearchTool searchTool) {
        return builder
                .defaultSystem("你是一个乐于助人的AI助手。当用户需要实时信息如时间、最新新闻、或你不知道的内容时，使用搜索工具来获取答案。用中文回答。")
                .defaultTools(searchTool)
                .build();
    }
}
