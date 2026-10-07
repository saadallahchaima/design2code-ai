package com.renodesign;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class RenoDesignApplication {
    public static void main(String[] args) {
        SpringApplication.run(RenoDesignApplication.class, args);
    }
}
