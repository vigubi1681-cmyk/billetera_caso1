<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="en_ES"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mi Billetera Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    :root { --azul-marino: #14213d; }

    .bg-marino { background-color: var(--azul-marino) !important; }

    .table-marino {
        --bs-table-bg: var(--azul-marino);
        --bs-table-color: #fff;
        --bs-table-border-color: #2b3a5c;
    }
</style>
</head>
<body class="bg-body-tertiary">

<nav class="navbar bg-marino mb-4" data-bs-theme="dark">
    <div class="container">
        <span class="navbar-brand mb-0 h1">Mi Billetera Digital</span>
        <span class="badge text-bg-warning">JSP + Servlet</span>
    </div>
</nav>

<main class="container">

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <small class="text-body-secondary text-uppercase">Saldo disponible</small>
            <p class="display-5 fw-bold text-success mb-0">
                S/ <fmt:formatNumber value="${billetera.saldo}" minFractionDigits="2" maxFractionDigits="2"/>
            </p>
            <small class="text-body-secondary">
                Después de <c:out value="${billetera.movimientos.size()}"/> movimientos válidos
            </small>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="${not empty gastoSolicitado ? 'col-lg-8' : 'col-12'}">
            <h2 class="h5">Movimientos recientes</h2>
            <div class="table-responsive">
                <table class="table table-bordered align-middle bg-white mb-0">
                    <thead class="table-marino">
                        <tr><th>Tipo</th><th>Monto (S/)</th><th>Orden</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${billetera.movimientos}" var="m" varStatus="st">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${m.recarga}"><span class="badge text-bg-success">Recarga</span></c:when>
                                        <c:otherwise><span class="badge text-bg-danger">Gasto</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="${m.recarga ? 'text-success' : 'text-danger'}">
                                    ${m.recarga ? '+' : '-'}
                                    <fmt:formatNumber value="${m.monto}" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="text-body-secondary">${st.first ? 'Más reciente' : 'Anterior'}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${billetera.movimientos.size() == 0}">
                            <tr><td colspan="3" class="text-center text-body-secondary">Aún no hay movimientos</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Panel de validación: solo cuando el gasto excede el saldo --%>
        <c:if test="${not empty gastoSolicitado}">
            <div class="col-lg-4">
                <div class="card border-danger-subtle h-100">
                    <div class="card-body">
                        <h2 class="h6 text-danger">Operación denegada</h2>
                        <p class="mb-1">Gasto solicitado:
                            S/ <fmt:formatNumber value="${gastoSolicitado}" minFractionDigits="2" maxFractionDigits="2"/></p>
                        <p class="mb-2">Saldo disponible:
                            S/ <fmt:formatNumber value="${saldoDisponible}" minFractionDigits="2" maxFractionDigits="2"/></p>
                        <div class="alert alert-danger py-2 mb-0" role="alert">
                            <c:out value="${error}"/>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <div class="card shadow-sm mb-5">
        <div class="card-body">
            <h2 class="h5">Nuevo movimiento</h2>
            <form action="${pageContext.request.contextPath}/billetera" method="post" novalidate class="row g-3">
                <div class="col-md-3">
                    <label for="tipo" class="form-label">Tipo</label>
                    <select class="form-select" id="tipo" name="tipo">
                        <option value="RECARGA" ${tipoSel == 'RECARGA' ? 'selected' : ''}>Recarga</option>
                        <option value="GASTO" ${tipoSel == 'GASTO' ? 'selected' : ''}>Gasto</option>
                    </select>
                </div>
                <div class="col-md-5">
                    <label for="monto" class="form-label">Monto (S/)</label>
                    <input type="text" inputmode="decimal" class="form-control" id="monto" name="monto"
                           placeholder="0.00" value="<c:out value='${montoIngresado}'/>">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">Registrar movimiento</button>
                </div>
            </form>
        </div>
    </div>
</main>

<%-- Datos para SweetAlert --%>
<c:choose>
    <c:when test="${not empty gastoSolicitado}">
        <fmt:formatNumber value="${gastoSolicitado}" minFractionDigits="2" maxFractionDigits="2" var="solFmt"/>
        <fmt:formatNumber value="${saldoDisponible}" minFractionDigits="2" maxFractionDigits="2" var="disFmt"/>
        <div id="mensaje" data-icono="error" data-titulo="<c:out value='${error}'/>"
             data-solicitado="<c:out value='${solFmt}'/>" data-disponible="<c:out value='${disFmt}'/>" hidden></div>
    </c:when>
    <c:when test="${not empty error}">
        <div id="mensaje" data-icono="error" data-titulo="Movimiento rechazado"
             data-texto="<c:out value='${error}'/>" hidden></div>
    </c:when>
    <c:when test="${not empty exito}">
        <div id="mensaje" data-icono="success" data-titulo="¡Listo!"
             data-texto="<c:out value='${exito}'/>" hidden></div>
    </c:when>
</c:choose>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const msg = document.getElementById('mensaje');
    if (msg) {
        const d = msg.dataset;
        const opciones = { icon: d.icono, title: d.titulo, confirmButtonText: 'Aceptar' };
        if (d.solicitado) {
            // Saldo insuficiente: mostrar gasto solicitado y saldo disponible
            opciones.html = 'Gasto solicitado: <b>S/ ' + d.solicitado + '</b><br>' +
                            'Saldo disponible: <b>S/ ' + d.disponible + '</b>';
        } else {
            opciones.text = d.texto;
        }
        Swal.fire(opciones);
    }
</script>
</body>
</html>