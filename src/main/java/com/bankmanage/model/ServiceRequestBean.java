package com.bankmanage.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ServiceRequestBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int requestId;
    private int accountId;
    private String requestType; // DEPOSIT, DEBIT_CARD, CREDIT_CARD
    private double amount;      // Nullable, used for DEPOSIT
    private String status;      // PENDING, APPROVED, REJECTED
    private Timestamp createdAt;
    private Timestamp resolvedAt;

    public ServiceRequestBean() {}

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
    }
}
