package websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/websocket/chat/{sessionId}")
public class ChatWebSocket {
    
    private static final Map<String, Set<Session>> sessions = new ConcurrentHashMap<>();
    private static final Map<String, String> sessionToUser = new ConcurrentHashMap<>();
    
    @OnOpen
    public void onOpen(Session session, @PathParam("sessionId") String sessionId) {
        System.out.println("WebSocket opened for session: " + sessionId);
        sessions.computeIfAbsent(sessionId, k -> new CopyOnWriteArraySet<>()).add(session);
    }
    
    @OnClose
    public void onClose(Session session, @PathParam("sessionId") String sessionId) {
        System.out.println("WebSocket closed for session: " + sessionId);
        Set<Session> sessionSet = sessions.get(sessionId);
        if (sessionSet != null) {
            sessionSet.remove(session);
            if (sessionSet.isEmpty()) {
                sessions.remove(sessionId);
            }
        }
    }
    
    @OnMessage
    public void onMessage(String message, Session session, @PathParam("sessionId") String sessionId) {
        System.out.println("Received message for session " + sessionId + ": " + message);
        // Broadcast message to all sessions in the same chat room
        broadcastToSession(sessionId, message);
    }
    
    @OnError
    public void onError(Session session, Throwable error) {
        System.err.println("WebSocket error: " + error.getMessage());
        error.printStackTrace();
    }
    
    public static void broadcastToSession(String sessionId, String message) {
        Set<Session> sessionSet = sessions.get(sessionId);
        if (sessionSet != null) {
            for (Session s : sessionSet) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        System.err.println("Error broadcasting message: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
        }
    }
    
    public static void broadcastToAll(String message) {
        sessions.values().forEach(sessionSet -> {
            for (Session s : sessionSet) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        System.err.println("Error broadcasting to all: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
        });
    }
} 