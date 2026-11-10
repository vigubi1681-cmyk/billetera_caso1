package com.billetera.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.LinkedList;
import java.util.List;

public class Billetera implements Serializable {

    private BigDecimal saldo = new BigDecimal("250.00");
    private final LinkedList<Movimiento> movimientos = new LinkedList<>();

    public void registrar(Movimiento.Tipo tipo, BigDecimal monto) {
        if (monto == null || monto.signum() <= 0) {
            throw new IllegalArgumentException("El monto debe ser mayor que cero.");
        }
        if (tipo == Movimiento.Tipo.GASTO) {
            if (monto.compareTo(saldo) > 0) {
                throw new SaldoInsuficienteException(monto, saldo);
            }
            saldo = saldo.subtract(monto);
        } else {
            saldo = saldo.add(monto);
        }
        movimientos.addFirst(new Movimiento(tipo, monto)); // orden de más reciente a más antiguo
    }

    public BigDecimal getSaldo() { return saldo; }
    public List<Movimiento> getMovimientos() { return movimientos; }
}