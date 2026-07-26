package com.dazi.community.websocket;

import com.dazi.community.common.jwt.JwtUtil;
import com.dazi.community.entity.po.ChatMessage;
import com.dazi.community.mapper.ChatMessageMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import jakarta.annotation.Resource;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private static final Logger log = LoggerFactory.getLogger(ChatWebSocketHandler.class);
    private static final Map<Long, WebSocketSession> userSessions = new ConcurrentHashMap<>();

    @Resource
    private JwtUtil jwtUtil;
    @Resource
    private ChatMessageMapper chatMessageMapper;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        String query = session.getUri() != null ? session.getUri().getQuery() : "";
        String token = parseTokenFromQuery(query);
        if (token == null || !jwtUtil.validateToken(token)) {
            try { session.close(); } catch (IOException ignored) {}
            return;
        }
        Long userId = jwtUtil.getUserIdFromToken(token);
        session.getAttributes().put("userId", userId);
        userSessions.put(userId, session);
        log.info("User {} connected to WebSocket", userId);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        Long fromUserId = (Long) session.getAttributes().get("userId");
        String payload = message.getPayload();

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> msg = new com.fasterxml.jackson.databind.ObjectMapper().readValue(payload, Map.class);
            Long toUserId = msg.get("toUserId") != null ? Long.valueOf(msg.get("toUserId").toString()) : null;
            Long circleId = msg.get("circleId") != null ? Long.valueOf(msg.get("circleId").toString()) : null;
            String content = (String) msg.get("content");
            String msgType = (String) msg.getOrDefault("msgType", "text");

            ChatMessage chatMsg = new ChatMessage();
            chatMsg.setFromUserId(fromUserId);
            chatMsg.setToUserId(toUserId);
            chatMsg.setCircleId(circleId);
            chatMsg.setContent(content);
            chatMsg.setMsgType(msgType);
            chatMsg.setStatus(0);
            chatMessageMapper.insert(chatMsg);

            // Send to specific user (private chat)
            if (toUserId != null) {
                sendToUser(toUserId, payload);
            }
        } catch (Exception e) {
            log.error("Error handling WebSocket message", e);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        Long userId = (Long) session.getAttributes().get("userId");
        if (userId != null) {
            userSessions.remove(userId);
            log.info("User {} disconnected", userId);
        }
    }

    public void sendToUser(Long userId, String message) {
        WebSocketSession session = userSessions.get(userId);
        if (session != null && session.isOpen()) {
            try {
                session.sendMessage(new TextMessage(message));
            } catch (IOException e) {
                log.error("Failed to send message to user {}", userId, e);
            }
        }
    }

    private String parseTokenFromQuery(String query) {
        if (query == null) return null;
        for (String param : query.split("&")) {
            String[] parts = param.split("=", 2);
            if (parts.length == 2 && "token".equals(parts[0])) {
                return parts[1];
            }
        }
        return null;
    }
}
