package com.renodesign.dto.quote;

import com.renodesign.entity.QuoteStatus;
import jakarta.validation.constraints.NotNull;

public class UpdateQuoteStatusRequest {

    @NotNull(message = "Status is required")
    private QuoteStatus status;

    public UpdateQuoteStatusRequest() {}

    public UpdateQuoteStatusRequest(QuoteStatus status) {
        this.status = status;
    }

    public QuoteStatus getStatus() { return status; }
    public void setStatus(QuoteStatus status) { this.status = status; }
}
