package com.renodesign;

import com.renodesign.dto.quote.QuoteCreateRequest;
import com.renodesign.dto.quote.QuoteResponse;
import com.renodesign.dto.quote.UpdateQuoteStatusRequest;
import com.renodesign.entity.QuoteStatus;
import com.renodesign.entity.Role;
import com.renodesign.entity.User;
import com.renodesign.repository.UserRepository;
import com.renodesign.service.QuoteService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class QuoteServiceTest {

    @Autowired
    private QuoteService quoteService;

    @Autowired
    private UserRepository userRepository;

    @Test
    void testCreateAndManageQuote() {
        User user = new User("Lucas", "Bernard", "lucas.bernard@example.com", "hash", "+33611223344", Role.USER);
        user = userRepository.save(user);

        QuoteCreateRequest request = new QuoteCreateRequest();
        request.setFullName("Lucas Bernard");
        request.setPhone("+33611223344");
        request.setEmail("lucas.bernard@example.com");
        request.setCity("Bordeaux");
        request.setRoomType("Living Room");
        request.setSurfaceArea(45.0);
        request.setMessage("Looking for complete floor and wall replacement.");

        QuoteResponse created = quoteService.createQuote(user, request);
        assertNotNull(created.getId());
        assertEquals(QuoteStatus.PENDING, created.getStatus());
        assertEquals("Bordeaux", created.getCity());

        List<QuoteResponse> userQuotes = quoteService.getUserQuotes(user);
        assertFalse(userQuotes.isEmpty());

        // Admin updates status to CONTACTED
        QuoteResponse updated = quoteService.updateQuoteStatus(created.getId(), new UpdateQuoteStatusRequest(QuoteStatus.CONTACTED));
        assertEquals(QuoteStatus.CONTACTED, updated.getStatus());
    }
}
