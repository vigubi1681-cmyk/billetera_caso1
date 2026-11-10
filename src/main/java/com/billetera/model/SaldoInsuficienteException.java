package com.billetera.model;

import java.math.BigDecimal;

public class SaldoInsuficienteException extends IllegalArgumentException {

    private final BigDecimal solicitado;
    private final BigDecimal disponible;

    public SaldoInsuficienteException(BigDecimal solicitado, BigDecimal disponible) {
        super("Saldo insuficiente");
        this.solicitado = solicitado;
        this.disponible = disponible;
    }

    public BigDecimal getSolicitado() { return solicitado; }
    public BigDecimal getDisponible() { return disponible; }
}