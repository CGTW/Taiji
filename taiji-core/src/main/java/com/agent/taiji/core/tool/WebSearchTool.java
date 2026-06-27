package com.agent.taiji.core.tool;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class WebSearchTool {

    private final HttpClient httpClient;
    private final String searchUrl;

    public WebSearchTool(@Value("${search.base-url:http://localhost:4000}") String searchUrl) {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.searchUrl = searchUrl;
    }

    @Tool(description = "搜索互联网获取实时信息，调用搜索引擎获取最新资料")
    public String search(String query) {
        try {
            String encoded = URLEncoder.encode(query, StandardCharsets.UTF_8);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(searchUrl + "/search?q=" + encoded))
                    .timeout(Duration.ofSeconds(15))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                return "搜索服务暂不可用，状态码: " + response.statusCode();
            }

            List<SearchResult> results = new ObjectMapper()
                    .readValue(response.body(), new TypeReference<List<SearchResult>>() {});

            if (results.isEmpty()) {
                return "未找到相关结果。";
            }

            return results.stream()
                    .limit(5)
                    .map(r -> "• " + r.title() + "\n  " + r.content() + "\n  " + r.url())
                    .collect(Collectors.joining("\n\n"));

        } catch (Exception e) {
            return "搜索请求失败: " + e.getMessage();
        }
    }

    private record SearchResult(String title, String url, String content) {}
}
