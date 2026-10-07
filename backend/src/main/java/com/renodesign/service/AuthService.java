package com.renodesign.service;

import com.renodesign.config.JwtService;
import com.renodesign.dto.auth.AuthResponse;
import com.renodesign.dto.auth.LoginRequest;
import com.renodesign.dto.auth.RegisterRequest;
import com.renodesign.dto.auth.UserDto;
import com.renodesign.entity.Role;
import com.renodesign.entity.User;
import com.renodesign.exception.BadRequestException;
import com.renodesign.exception.UnauthorizedException;
import com.renodesign.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail().toLowerCase().trim())) {
            throw new BadRequestException("An account with this email address already exists.");
        }

        User user = new User();
        user.setFirstName(request.getFirstName().trim());
        user.setLastName(request.getLastName().trim());
        user.setEmail(request.getEmail().toLowerCase().trim());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setPhone(request.getPhone() != null ? request.getPhone().trim() : null);
        user.setRole(Role.USER);

        User savedUser = userRepository.save(user);

        String token = jwtService.generateToken(savedUser.getEmail(), savedUser.getId(), savedUser.getRole().name());
        return new AuthResponse(token, jwtService.getExpirationMs(), UserDto.fromEntity(savedUser));
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        String email = request.getEmail().toLowerCase().trim();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UnauthorizedException("Invalid email or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new UnauthorizedException("Invalid email or password");
        }

        String token = jwtService.generateToken(user.getEmail(), user.getId(), user.getRole().name());
        return new AuthResponse(token, jwtService.getExpirationMs(), UserDto.fromEntity(user));
    }

    @Transactional(readOnly = true)
    public UserDto getCurrentUser(User user) {
        if (user == null) {
            throw new UnauthorizedException("Not authenticated");
        }
        return UserDto.fromEntity(user);
    }
}
