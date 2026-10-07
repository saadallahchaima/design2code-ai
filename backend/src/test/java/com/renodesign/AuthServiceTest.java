package com.renodesign;

import com.renodesign.dto.auth.AuthResponse;
import com.renodesign.dto.auth.LoginRequest;
import com.renodesign.dto.auth.RegisterRequest;
import com.renodesign.exception.BadRequestException;
import com.renodesign.exception.UnauthorizedException;
import com.renodesign.service.AuthService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AuthServiceTest {

    @Autowired
    private AuthService authService;

    @Test
    void testRegisterAndLoginSuccess() {
        RegisterRequest registerReq = new RegisterRequest();
        registerReq.setFirstName("Sophie");
        registerReq.setLastName("Laurent");
        registerReq.setEmail("sophie.laurent@example.com");
        registerReq.setPassword("Password123!");
        registerReq.setPhone("+33698765432");

        AuthResponse regResponse = authService.register(registerReq);
        assertNotNull(regResponse);
        assertNotNull(regResponse.getToken());
        assertEquals("sophie.laurent@example.com", regResponse.getUser().getEmail());

        LoginRequest loginReq = new LoginRequest();
        loginReq.setEmail("sophie.laurent@example.com");
        loginReq.setPassword("Password123!");

        AuthResponse loginResponse = authService.login(loginReq);
        assertNotNull(loginResponse);
        assertNotNull(loginResponse.getToken());
        assertEquals("Sophie", loginResponse.getUser().getFirstName());
    }

    @Test
    void testDuplicateEmailFails() {
        RegisterRequest registerReq = new RegisterRequest();
        registerReq.setFirstName("Marc");
        registerReq.setLastName("Dupont");
        registerReq.setEmail("marc.dupont@example.com");
        registerReq.setPassword("Password123!");

        authService.register(registerReq);

        assertThrows(BadRequestException.class, () -> authService.register(registerReq));
    }

    @Test
    void testLoginBadPasswordFails() {
        RegisterRequest registerReq = new RegisterRequest();
        registerReq.setFirstName("Chloe");
        registerReq.setLastName("Martin");
        registerReq.setEmail("chloe.martin@example.com");
        registerReq.setPassword("SecurePass1!");

        authService.register(registerReq);

        LoginRequest badLogin = new LoginRequest();
        badLogin.setEmail("chloe.martin@example.com");
        badLogin.setPassword("WrongPassword!");

        assertThrows(UnauthorizedException.class, () -> authService.login(badLogin));
    }
}
