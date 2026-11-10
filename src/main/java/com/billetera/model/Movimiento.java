package com.billetera.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Movimiento implements Serializable {

    public enum Tipo { RECARGA, GASTO }

    private final Tipo tipo;
    private final BigDecimal monto;

    public Movimiento(Tipo tipo, BigDecimal monto) {
        this.tipo = tipo;
        this.monto = monto;
    }

    public Tipo getTipo() { return tipo; }
    public Tipo setTipo(Tipo tipo) { return this.tipo; }    
    public BigDecimal getMonto() { return monto; }
    public BigDecimal setMonto(BigDecimal monto) { return this.monto; }  
    public boolean isRecarga() { return tipo == Tipo.RECARGA; }
}
