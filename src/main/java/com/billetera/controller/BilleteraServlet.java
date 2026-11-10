package com.billetera.controller;

import java.io.IOException;
import java.math.BigDecimal;

import com.billetera.model.Billetera;
import com.billetera.model.Movimiento;
import com.billetera.model.SaldoInsuficienteException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/billetera")
public class BilleteraServlet extends HttpServlet {

    private static final String VISTA = "/WEB-INF/views/billetera.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        request.setAttribute("billetera", obtenerBilletera(session));

        // Mensaje "flash" dejado por un POST exitoso (PRG)
        Object exito = session.getAttribute("exito");
        if (exito != null) {
            request.setAttribute("exito", exito);
            session.removeAttribute("exito");
        }
        request.getRequestDispatcher(VISTA).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Billetera billetera = obtenerBilletera(session);

        String tipoParam = request.getParameter("tipo");
        String montoParam = request.getParameter("monto");

        try {
            Movimiento.Tipo tipo = parsearTipo(tipoParam);
            BigDecimal monto = parsearMonto(montoParam);

            synchronized (billetera) {
                billetera.registrar(tipo, monto);
            }

            session.setAttribute("exito",
                    (tipo == Movimiento.Tipo.RECARGA ? "Recarga" : "Gasto") + " registrado correctamente.");
            response.sendRedirect(request.getContextPath() + "/billetera"); // PRG

        } catch (SaldoInsuficienteException e) {
            request.setAttribute("billetera", billetera);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("gastoSolicitado", e.getSolicitado());
            request.setAttribute("saldoDisponible", e.getDisponible());
            request.setAttribute("tipoSel", tipoParam);
            request.setAttribute("montoIngresado", montoParam);
            request.getRequestDispatcher(VISTA).forward(request, response);
        } catch (IllegalArgumentException e) {
            // Error: no se modifica nada y se muestra en la misma vista
            request.setAttribute("billetera", billetera);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("tipoSel", tipoParam);
            request.setAttribute("montoIngresado", montoParam);
            request.getRequestDispatcher(VISTA).forward(request, response);
        }
    }

    private Billetera obtenerBilletera(HttpSession session) {
        Billetera b = (Billetera) session.getAttribute("billetera");
        if (b == null) {
            b = new Billetera();
            session.setAttribute("billetera", b);
        }
        return b;
    }

    private Movimiento.Tipo parsearTipo(String tipo) {
        try {
            return Movimiento.Tipo.valueOf(tipo);
        } catch (IllegalArgumentException | NullPointerException e) {
            throw new IllegalArgumentException("Seleccione un tipo de movimiento válido.");
        }
    }

    private BigDecimal parsearMonto(String monto) {
        if (monto == null || monto.isBlank()) {
            throw new IllegalArgumentException("Ingrese un monto.");
        }
        try {
            return new BigDecimal(monto.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("El monto debe ser un número válido.");
        }
    }
}
