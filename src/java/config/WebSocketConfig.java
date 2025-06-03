package config;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/websocket")
public class WebSocketConfig {
    private static final Map<String, Session> sessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        sessions.put(session.getId(), session);
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // Handle incoming messages if needed
    }

    @OnError
    public void onError(Session session, Throwable error) {
        error.printStackTrace();
    }

    public static void broadcast(String message) {
        sessions.values().forEach(session -> {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }
} 