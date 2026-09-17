#!/usr/bin/env python3
"""Build the offline ERD data model from the canonical PostgreSQL DDL.

The parser intentionally covers the constrained DDL style used by this
prototype. It is not intended to be a general SQL parser.
"""

from __future__ import annotations

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "database" / "prototype-v0.sql"
OUTPUT_PATH = ROOT / "docs" / "erd" / "model.js"


def load_sql(path: Path, visited: set[Path] | None = None) -> str:
    """Read a psql entrypoint and recursively expand its ``\\ir`` includes."""
    resolved = path.resolve()
    seen = visited or set()
    if resolved in seen:
        raise ValueError(f"Recursive SQL include: {resolved}")
    seen.add(resolved)

    expanded: list[str] = []
    include_pattern = re.compile(r"^\\ir\s+(.+?)\s*$")
    for line in resolved.read_text(encoding="utf-8").splitlines(keepends=True):
        match = include_pattern.match(line.strip())
        if match:
            included = (resolved.parent / match.group(1)).resolve()
            expanded.append(load_sql(included, seen.copy()))
        else:
            expanded.append(line)
    return "".join(expanded)


MODULES = {
    "core": {
        "order": 10,
        "label": {"en": "People & organizations", "es": "Personas y organizaciones"},
        "short": {"en": "Identity", "es": "Identidad"},
        "description": {
            "en": "Canonical actors, verified identifiers, roles, contacts, branches, and sites.",
            "es": "Actores canónicos, identificadores verificados, roles, contactos, sucursales y lugares.",
        },
        "phase": "CORE",
        "evidence": "MIXED",
        "color": "#2d6cdf",
    },
    "files": {
        "order": 20,
        "label": {"en": "Documents", "es": "Documentos"},
        "short": {"en": "Documents", "es": "Documentos"},
        "description": {
            "en": "Stored files and business documents, kept separately from the events they prove.",
            "es": "Archivos y documentos de negocio, separados de los eventos que sirven como evidencia.",
        },
        "phase": "CORE",
        "evidence": "OBSERVED",
        "color": "#4979a8",
    },
    "staging": {
        "order": 30,
        "label": {"en": "Imports & review", "es": "Importación y revisión"},
        "short": {"en": "Staging", "es": "Precanónico"},
        "description": {
            "en": "Immutable source rows, pipeline versions, quarantine, duplicates, and human resolutions.",
            "es": "Filas fuente inmutables, versiones del proceso, cuarentena, duplicados y decisiones humanas.",
        },
        "phase": "CORE",
        "evidence": "OBSERVED",
        "color": "#65748b",
    },
    "iam": {
        "order": 40,
        "label": {"en": "Access & audit", "es": "Acceso y auditoría"},
        "short": {"en": "Access", "es": "Acceso"},
        "description": {
            "en": "Users, permissions, and audit history. Administrator and accountant are roles, not people tables.",
            "es": "Usuarios, permisos e historial. Administrador y contable son roles, no tablas de personas.",
        },
        "phase": "CORE",
        "evidence": "REQUIRED",
        "color": "#7656c5",
    },
    "projects": {
        "order": 50,
        "label": {"en": "Projects & planning", "es": "Proyectos y planificación"},
        "short": {"en": "Projects", "es": "Proyectos"},
        "description": {
            "en": "Projects, stakeholders, cost centers, work breakdown, schedule, progress, budgets, and additions.",
            "es": "Proyectos, participantes, centros de costo, partidas, cronograma, avance, presupuestos y adicionales.",
        },
        "phase": "CORE",
        "evidence": "MIXED",
        "color": "#008f83",
    },
    "catalog": {
        "order": 60,
        "label": {"en": "Resources & APU", "es": "Recursos y APU"},
        "short": {"en": "Catalog", "es": "Catálogo"},
        "description": {
            "en": "Materials, labor, equipment, services, units, supplier prices, and versioned unit-cost analysis.",
            "es": "Materiales, mano de obra, equipos, servicios, unidades, precios y análisis de costos versionados.",
        },
        "phase": "PROTOTYPE",
        "evidence": "REQUIRED",
        "color": "#3c8d57",
    },
    "procurement": {
        "order": 70,
        "label": {"en": "Purchases & contractor claims", "es": "Compras y cubicaciones de contratistas"},
        "short": {"en": "Purchasing", "es": "Compras"},
        "description": {
            "en": "Supplier invoices and outgoing contractor progress claims, kept as two distinct cost domains.",
            "es": "Facturas de proveedores y cubicaciones salientes de contratistas, conservadas como dominios distintos.",
        },
        "phase": "CORE",
        "evidence": "OBSERVED",
        "color": "#d47a18",
    },
    "workforce": {
        "order": 80,
        "label": {"en": "Workforce & payroll", "es": "Personal y nómina"},
        "short": {"en": "Workforce", "es": "Personal"},
        "description": {
            "en": "Employment/crew relationships, positions, pay periods, payroll entries, and typed deductions.",
            "es": "Relaciones laborales o de cuadrilla, posiciones, períodos, nómina y deducciones tipificadas.",
        },
        "phase": "CORE",
        "evidence": "OBSERVED",
        "color": "#b35a75",
    },
    "billing": {
        "order": 90,
        "label": {"en": "Client contracts & billing", "es": "Contratos y facturación a clientes"},
        "short": {"en": "Billing", "es": "Facturación"},
        "description": {
            "en": "Client contracts, cash-flow plans, incoming progress certificates, and sales invoices.",
            "es": "Contratos, planes de flujo, cubicaciones de clientes y facturas de venta.",
        },
        "phase": "PROTOTYPE",
        "evidence": "REQUIRED",
        "color": "#c34c3f",
    },
    "finance": {
        "order": 100,
        "label": {"en": "Payments", "es": "Pagos y cobros"},
        "short": {"en": "Payments", "es": "Pagos"},
        "description": {
            "en": "Actual money movement and typed allocations to invoices, claims, payroll, or receivables.",
            "es": "Movimiento real de dinero y aplicaciones a facturas, cubicaciones, nómina o cuentas por cobrar.",
        },
        "phase": "CORE",
        "evidence": "REQUIRED",
        "color": "#c59a16",
    },
    "tax": {
        "order": 110,
        "label": {"en": "DGII reporting", "es": "Reportes DGII"},
        "short": {"en": "Tax", "es": "DGII"},
        "description": {
            "en": "Versioned reporting submissions and the exact 606 snapshot sent to DGII.",
            "es": "Envíos versionados y la instantánea exacta del 606 remitida a la DGII.",
        },
        "phase": "PROTOTYPE",
        "evidence": "VERIFIED_REQUIREMENT",
        "color": "#415d73",
    },
    "accounting": {
        "order": 120,
        "label": {"en": "General ledger", "es": "Contabilidad general"},
        "short": {"en": "Ledger", "es": "Contabilidad"},
        "description": {
            "en": "Minimal double-entry spine. The chart and posting rules still require accountant approval.",
            "es": "Base mínima de partida doble. El catálogo y las reglas aún requieren aprobación contable.",
        },
        "phase": "PROTOTYPE",
        "evidence": "REQUIRED",
        "color": "#4d6471",
    },
    "fleet": {
        "order": 130,
        "label": {"en": "Fleet extension", "es": "Extensión de flota"},
        "short": {"en": "Fleet", "es": "Flota"},
        "description": {
            "en": "Candidate extension for vehicles, drivers, maintenance, documents, and telemetry.",
            "es": "Extensión candidata para vehículos, choferes, mantenimiento, documentos y telemetría.",
        },
        "phase": "EXTENSION",
        "evidence": "MEETING_ONLY",
        "color": "#79624f",
    },
    "reporting": {
        "order": 140,
        "label": {"en": "Reporting views", "es": "Vistas de análisis"},
        "short": {"en": "Reporting", "es": "Análisis"},
        "description": {
            "en": "Read-only consolidation across separate operational domains.",
            "es": "Consolidación de solo lectura entre dominios operativos separados.",
        },
        "phase": "CORE",
        "evidence": "REQUIRED",
        "color": "#4c718a",
    },
}


# Human labels and explanations shown in the inspector. Exact SQL names and
# columns remain visible alongside these descriptions.
ENTITY_META = {
    "core.party": ("Party", "Actor", "A person or organization that may hold several business roles.", "Persona u organización que puede tener varios roles de negocio."),
    "core.person_profile": ("Person profile", "Perfil de persona", "Person-only names and demographic attributes.", "Nombres y atributos exclusivos de una persona."),
    "core.organization_profile": ("Organization profile", "Perfil de organización", "Legal, trade, and organization details.", "Datos legales, comerciales y tipo de organización."),
    "core.party_identifier": ("Verified identifier", "Identificador verificado", "RNC, Cédula, passport, or another identifier with an explicit review state.", "RNC, cédula, pasaporte u otro identificador con estado explícito de revisión."),
    "core.legal_entity": ("Operating legal entity", "Entidad legal operativa", "The company boundary used by accounting and transactions; one row is enough today.", "Límite empresarial usado por contabilidad y transacciones; hoy basta una fila."),
    "core.party_role": ("Business role", "Rol de negocio", "Makes one actor a client, supplier, contractor, employee, worker, or other role.", "Convierte un actor en cliente, proveedor, contratista, empleado, obrero u otro rol."),
    "core.party_alias": ("Party alias", "Alias de actor", "Approved source spelling, nickname, trade name, or legacy code.", "Nombre crudo aprobado, apodo, nombre comercial o código legado."),
    "core.site": ("Site or branch", "Lugar o sucursal", "A supplier branch, project site, office, warehouse, or workshop with geography.", "Sucursal, obra, oficina, almacén o taller con información geográfica."),
    "core.contact_point": ("Contact method", "Medio de contacto", "Phone, WhatsApp, email, web address, and optional extension.", "Teléfono, WhatsApp, correo, web y extensión opcional."),
    "core.party_relationship": ("Party relationship", "Relación entre actores", "Connects contacts, representatives, employees, and related organizations.", "Conecta contactos, representantes, empleados y organizaciones relacionadas."),
    "iam.app_user": ("Application user", "Usuario de la aplicación", "Login identity, optionally linked to a real person.", "Identidad de acceso, vinculable a una persona real."),
    "iam.access_role": ("Access role", "Rol de acceso", "Named permission bundle such as administrator, accountant, or client viewer.", "Conjunto de permisos como administrador, contable o cliente lector."),
    "iam.app_user_role": ("Role assignment", "Asignación de rol", "Grants a role globally, by company, or by project.", "Otorga un rol global, por empresa o por proyecto."),
    "iam.audit_event": ("Audit event", "Evento de auditoría", "Append-only trace of material user actions and data changes.", "Rastro inmutable de acciones y cambios importantes."),
    "files.stored_file": ("Stored file", "Archivo almacenado", "Physical object metadata, checksum, location, and original filename.", "Metadatos, hash, ubicación y nombre original del archivo físico."),
    "files.document": ("Business document", "Documento de negocio", "Business meaning layered over a stored file, including dates and verification.", "Significado de negocio sobre un archivo, con fechas y verificación."),
    "files.party_document": ("Party document", "Documento de actor", "Links identity, contract, or other evidence to a party.", "Vincula evidencia de identidad, contrato u otro tipo con un actor."),
    "files.project_document": ("Project document", "Documento de proyecto", "Links plans, surveys, photos, contracts, and other evidence to a project.", "Vincula planos, fotos, contratos y otras evidencias con un proyecto."),
    "staging.import_batch": ("Import batch", "Lote de importación", "A reproducible ingestion run with source domain and pipeline version.", "Ejecución reproducible con dominio fuente y versión del proceso."),
    "staging.source_file": ("Source file", "Archivo fuente", "A file as encountered within one import, including its full path and extraction result.", "Archivo dentro de una importación, con ruta completa y resultado de extracción."),
    "staging.source_record": ("Source record", "Registro fuente", "Immutable raw row/cell payload and exact locator before canonical mapping.", "Fila o celdas crudas e inmutables antes del mapeo canónico."),
    "staging.review_issue": ("Review issue", "Caso de revisión", "Quarantine, duplicate, identity, arithmetic, or mapping decision requiring a person.", "Decisión de cuarentena, duplicado, identidad, cálculo o mapeo que requiere una persona."),
    "projects.project": ("Project", "Proyecto", "A real construction project from the human-owned project register.", "Proyecto de construcción real definido en el catálogo aprobado."),
    "projects.project_alias": ("Project alias", "Alias de proyecto", "Approved mapping from historical text to a real project.", "Mapeo aprobado desde texto histórico hacia un proyecto real."),
    "projects.project_site": ("Project site assignment", "Lugar del proyecto", "Associates one or more geographic sites with a project.", "Asocia uno o varios lugares geográficos con un proyecto."),
    "projects.project_party": ("Project stakeholder", "Participante del proyecto", "Client, owner, contact, partner, manager, or supervisor on a project.", "Cliente, propietario, contacto, socio, gerente o supervisor del proyecto."),
    "projects.cost_center": ("Cost center", "Centro de costo", "Receives project, overhead, workshop, fleet, or unallocated cost.", "Recibe costos de proyecto, administración, taller, flota o pendientes de asignar."),
    "projects.work_item": ("Work item / WBS", "Partida de trabajo / EDT", "Hierarchical activity or deliverable used by budget, progress, and claims.", "Actividad o entregable jerárquico usado por presupuesto, avance y cubicaciones."),
    "projects.schedule_activity": ("Schedule activity", "Actividad de cronograma", "Planned and actual timing with execution status and completion.", "Fechas planificadas y reales con estado y porcentaje de terminación."),
    "projects.activity_dependency": ("Schedule dependency", "Dependencia de cronograma", "Predecessor/successor rule with optional lag.", "Regla entre actividad predecesora y sucesora, con holgura opcional."),
    "projects.progress_measurement": ("Progress measurement", "Medición de avance", "Dated physical-progress report shared by certification and analysis.", "Reporte fechado de avance físico utilizado por certificación y análisis."),
    "projects.progress_measurement_line": ("Progress line", "Línea de avance", "Previous, current, and cumulative progress for a work item.", "Avance anterior, actual y acumulado de una partida."),
    "projects.budget": ("Project budget", "Presupuesto del proyecto", "Stable identity for a budget across its revisions.", "Identidad estable de un presupuesto a través de sus revisiones."),
    "projects.budget_version": ("Budget version", "Versión de presupuesto", "Draft, submitted, approved, or superseded budget snapshot.", "Instantánea de presupuesto borrador, sometida, aprobada o reemplazada."),
    "projects.budget_line": ("Budget line", "Partida presupuestaria", "Hierarchical priced line optionally linked to work and an APU version.", "Partida jerárquica valorada y vinculable a trabajo y versión de APU."),
    "projects.budget_approval": ("Budget approval", "Aprobación de presupuesto", "Explicit client decision with timestamp and evidence.", "Decisión explícita del cliente con fecha y evidencia."),
    "projects.change_order": ("Addition / change order", "Adicional / orden de cambio", "Commercial change kept separate from the approved original budget.", "Cambio comercial separado del presupuesto original aprobado."),
    "projects.change_order_line": ("Change-order line", "Partida de adicional", "Quantity or value change, optionally against an existing budget line.", "Cambio de cantidad o valor, posiblemente sobre una partida existente."),
    "projects.change_order_approval": ("Change-order approval", "Aprobación de adicional", "Independent client acceptance of an addition or change.", "Aceptación independiente del cliente para un adicional o cambio."),
    "catalog.unit_of_measure": ("Unit of measure", "Unidad de medida", "Controlled units used consistently across products, work, invoices, and APU.", "Unidades controladas usadas en productos, partidas, facturas y APU."),
    "catalog.resource": ("Resource / product", "Recurso / producto", "Reusable material, labor, equipment, subcontract, or service catalog item.", "Material, mano de obra, equipo, subcontrato o servicio reutilizable."),
    "catalog.resource_alias": ("Resource alias", "Alias de recurso", "Reviewed source spelling mapped to a catalog resource.", "Texto fuente revisado y asociado a un recurso del catálogo."),
    "catalog.specialty": ("Specialty", "Especialidad", "Controlled construction trade or discipline.", "Oficio o disciplina de construcción controlada."),
    "catalog.party_specialty": ("Party specialty", "Especialidad del actor", "Many-to-many assignment of trades to workers or contractors.", "Asignación de uno o varios oficios a obreros o contratistas."),
    "catalog.supplier_price": ("Supplier price", "Precio de proveedor", "Time-, branch-, unit-, and evidence-specific resource price.", "Precio de recurso por fecha, sucursal, unidad y evidencia."),
    "catalog.cost_analysis": ("Unit-cost analysis (APU)", "Análisis de precio unitario (APU)", "Reusable APU identity, global but traceable to its project of origin.", "APU reutilizable y global, con trazabilidad a su proyecto de origen."),
    "catalog.cost_analysis_version": ("APU version", "Versión de APU", "Effective-dated cost snapshot and assumptions.", "Instantánea fechada de costos y supuestos."),
    "catalog.cost_analysis_component": ("APU component", "Componente de APU", "Resource quantity, waste, and cost within one APU version.", "Cantidad, desperdicio y costo de un recurso dentro de una versión de APU."),
    "procurement.purchase_invoice": ("Supplier invoice", "Factura de proveedor", "Commercial obligation supported by NCF; not a payment and not itself a 606 submission.", "Obligación comercial con NCF; no es pago ni es por sí sola un envío 606."),
    "procurement.purchase_invoice_line": ("Supplier invoice line", "Línea de factura", "Supplier wording and price snapshot, optionally mapped to a resource.", "Descripción y precio del proveedor, vinculables opcionalmente a un recurso."),
    "procurement.purchase_invoice_tax": ("Invoice tax", "Impuesto de factura", "Typed ITBIS, ISR, ISC, legal tip, tax, or fee amount.", "Monto tipificado de ITBIS, ISR, ISC, propina, impuesto o tasa."),
    "procurement.purchase_cost_allocation": ("Purchase allocation", "Distribución de compra", "Splits invoice cost across project or non-project cost centers.", "Distribuye el costo de una factura entre centros de costo."),
    "procurement.contractor_claim": ("Contractor progress claim", "Cubicación de contratista", "Outgoing construction cost claimed by a contractor, with date certainty and review state.", "Costo saliente reclamado por un contratista, con precisión de fecha y revisión."),
    "procurement.contractor_claim_line": ("Contractor claim line", "Partida de cubicación", "Measured work, snapshot description, quantity, unit, rate, and total.", "Trabajo medido con descripción, cantidad, unidad, precio y total."),
    "procurement.contractor_claim_deduction": ("Claim deduction", "Deducción de cubicación", "Positive typed withholding, retainage, recovery, penalty, or other deduction.", "Retención, garantía, recuperación, penalidad u otra deducción positiva y tipificada."),
    "workforce.position": ("Position", "Posición", "Controlled job or payroll position.", "Puesto u oficio controlado para nómina."),
    "workforce.engagement": ("Worker engagement", "Relación laboral", "Defines whether a person is staff, day labor, workshop staff, or contractor crew.", "Define si una persona es personal fijo, jornalero, taller o cuadrilla de contratista."),
    "workforce.payroll_run": ("Payroll run", "Nómina", "One approved pay period with explicit date precision.", "Un período de pago con precisión de fechas explícita."),
    "workforce.payroll_entry": ("Payroll entry", "Detalle de nómina", "Worker/project/cost-center earnings and net amount for one run.", "Devengo y neto de un trabajador, proyecto y centro de costo en una nómina."),
    "workforce.payroll_deduction": ("Payroll deduction", "Deducción de nómina", "Typed, positive deduction instead of an unexplained signed column.", "Deducción positiva y tipificada en vez de una columna con signo ambiguo."),
    "billing.client_contract": ("Client contract", "Contrato de cliente", "Commercial agreement and choice of cash-flow, progress, or mixed billing.", "Acuerdo comercial y modalidad de cobro por flujo, avance o mixta."),
    "billing.payment_plan": ("Client payment plan", "Plan de cobros", "Versioned plan for the base contract or a separate addition.", "Plan versionado del contrato base o de un adicional independiente."),
    "billing.payment_plan_installment": ("Planned installment", "Cuota planificada", "Date- or milestone-triggered expected client charge.", "Cobro esperado activado por fecha o hito."),
    "billing.client_progress_certificate": ("Client progress certificate", "Cubicación al cliente", "Approved incoming billing basis derived from physical progress.", "Base aprobada de cobro al cliente derivada del avance físico."),
    "billing.sales_invoice": ("Client invoice", "Factura al cliente", "Receivable and electronic fiscal-document lifecycle.", "Cuenta por cobrar y ciclo del comprobante fiscal electrónico."),
    "billing.sales_invoice_line": ("Client invoice line", "Línea de factura al cliente", "Billed work or addition with a stable description snapshot.", "Trabajo o adicional facturado con descripción estable."),
    "finance.financial_account": ("Cash/bank account", "Cuenta de caja o banco", "Internal source or destination of actual money movement.", "Origen o destino interno de un movimiento real de dinero."),
    "finance.payment": ("Payment or receipt", "Pago o cobro", "Actual incoming or outgoing money; receipt evidence is attached here.", "Movimiento real entrante o saliente; aquí se adjunta el recibo."),
    "finance.purchase_invoice_payment": ("Purchase payment application", "Aplicación a factura de compra", "Applies part of a payment to a supplier invoice.", "Aplica una parte de un pago a una factura de proveedor."),
    "finance.contractor_claim_payment": ("Claim payment application", "Aplicación a cubicación", "Applies part of a payment to a contractor claim.", "Aplica una parte de un pago a una cubicación de contratista."),
    "finance.payroll_entry_payment": ("Payroll payment application", "Aplicación a nómina", "Applies part of a payment to one worker obligation.", "Aplica una parte de un pago a la obligación de un trabajador."),
    "finance.sales_invoice_payment": ("Client receipt application", "Aplicación de cobro", "Applies incoming money to a client invoice.", "Aplica dinero recibido a una factura de cliente."),
    "tax.dgii_submission": ("DGII submission", "Envío DGII", "Versioned 606/607/608/609 reporting envelope and response state.", "Sobre versionado de reporte 606/607/608/609 y su estado de respuesta."),
    "tax.dgii_606_record": ("Reported 606 row", "Registro reportado en 606", "Exact immutable tax-field snapshot reported for one purchase invoice.", "Instantánea inmutable de los campos fiscales reportados para una compra."),
    "accounting.accounting_period": ("Accounting period", "Período contable", "Open or closed posting interval.", "Intervalo abierto o cerrado para contabilización."),
    "accounting.gl_account": ("Ledger account", "Cuenta contable", "Hierarchical chart-of-accounts entry approved by the accountant.", "Cuenta jerárquica del catálogo aprobado por el contable."),
    "accounting.journal_entry": ("Journal entry", "Asiento contable", "Header for a draft, posted, or reversed double-entry transaction.", "Cabecera de una transacción de partida doble en borrador, contabilizada o reversada."),
    "accounting.journal_line": ("Journal line", "Línea de asiento", "Debit or credit optionally analyzed by party, project, and cost center.", "Débito o crédito analizable por actor, proyecto y centro de costo."),
    "fleet.asset": ("Asset", "Activo", "Vehicle, heavy equipment, tool, or other owned operational asset.", "Vehículo, equipo pesado, herramienta u otro activo operativo."),
    "fleet.vehicle_profile": ("Vehicle profile", "Perfil de vehículo", "Plate, VIN, make, model, year, and odometer unit.", "Placa, chasis, marca, modelo, año y unidad del odómetro."),
    "fleet.asset_document": ("Asset document", "Documento de activo", "Registration, insurance, inspection, title, or license evidence.", "Matrícula, seguro, inspección, título o evidencia de licencia."),
    "fleet.driver_assignment": ("Driver assignment", "Asignación de chofer", "Time-bounded relationship between a driver and an asset.", "Relación con fechas entre un chofer y un activo."),
    "fleet.maintenance_order": ("Maintenance order", "Orden de mantenimiento", "Service event, supplier, odometer, status, cost, and evidence.", "Servicio, proveedor, odómetro, estado, costo y evidencia."),
    "fleet.maintenance_line": ("Maintenance line", "Detalle de mantenimiento", "Part, service, quantity, unit cost, and replacement note.", "Pieza o servicio con cantidad, costo y nota de reemplazo."),
    "fleet.telemetry_position": ("Telemetry point", "Punto de telemetría", "Timestamped vehicle location and optional movement data.", "Ubicación fechada del vehículo y datos opcionales de movimiento."),
    "reporting.project_cost_event": ("Unified project-cost view", "Vista unificada de costos", "Read-only union of gross purchases, contractor claims, and payroll without merging their source tables.", "Unión de solo lectura de compras, cubicaciones y nómina sin mezclar sus tablas fuente."),
}


def find_closing_parenthesis(sql: str, opening: int) -> int:
    depth = 0
    in_string = False
    i = opening
    while i < len(sql):
        char = sql[i]
        if in_string:
            if char == "'" and i + 1 < len(sql) and sql[i + 1] == "'":
                i += 2
                continue
            if char == "'":
                in_string = False
        else:
            if char == "'":
                in_string = True
            elif char == "(":
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0:
                    return i
        i += 1
    raise ValueError("Unclosed CREATE TABLE body")


def split_top_level(body: str) -> list[str]:
    parts: list[str] = []
    start = 0
    depth = 0
    in_string = False
    i = 0
    while i < len(body):
        char = body[i]
        if in_string:
            if char == "'" and i + 1 < len(body) and body[i + 1] == "'":
                i += 2
                continue
            if char == "'":
                in_string = False
        else:
            if char == "'":
                in_string = True
            elif char == "(":
                depth += 1
            elif char == ")":
                depth -= 1
            elif char == "," and depth == 0:
                parts.append(body[start:i].strip())
                start = i + 1
        i += 1
    tail = body[start:].strip()
    if tail:
        parts.append(tail)
    return parts


def cleaned(fragment: str) -> str:
    return re.sub(r"--[^\n]*", "", fragment).strip()


def human_fallback(name: str) -> str:
    return name.replace("_", " ").title()


def build_model() -> dict:
    sql = load_sql(SQL_PATH)
    table_pattern = re.compile(r"create\s+table\s+([a-z_][\w]*)\.([a-z_][\w]*)\s*\(", re.I)
    entities: list[dict] = []
    relationships: list[dict] = []

    for match in table_pattern.finditer(sql):
        schema, table = match.group(1).lower(), match.group(2).lower()
        opening = match.end() - 1
        closing = find_closing_parenthesis(sql, opening)
        body = sql[opening + 1 : closing]
        fragments = [cleaned(part) for part in split_top_level(body)]
        columns: list[dict] = []
        primary_keys: set[str] = set()
        table_foreign_keys: list[tuple[list[str], str, str, list[str]]] = []

        for fragment in fragments:
            if not fragment:
                continue
            low = fragment.lower()
            pk_match = re.match(r"primary\s+key\s*\(([^)]+)\)", fragment, re.I | re.S)
            if pk_match:
                primary_keys.update(x.strip() for x in pk_match.group(1).split(","))
                continue
            fk_match = re.match(
                r"(?:constraint\s+\w+\s+)?foreign\s+key\s*\(([^)]+)\)\s*references\s+([\w]+)\.([\w]+)\s*\(([^)]+)\)",
                fragment,
                re.I | re.S,
            )
            if fk_match:
                table_foreign_keys.append(
                    (
                        [x.strip() for x in fk_match.group(1).split(",")],
                        fk_match.group(2).lower(),
                        fk_match.group(3).lower(),
                        [x.strip() for x in fk_match.group(4).split(",")],
                    )
                )
                continue
            if low.startswith(("unique ", "unique(", "check ", "constraint ")):
                continue
            col_match = re.match(r"([a-z_][\w]*)\s+(.+)", fragment, re.I | re.S)
            if not col_match:
                continue
            name, remainder = col_match.group(1), " ".join(col_match.group(2).split())
            type_part = re.split(
                r"\s+(?=not\s+null|default\s|check\s*\(|references\s|primary\s+key|unique(?:\s|$)|generated\s)",
                remainder,
                maxsplit=1,
                flags=re.I,
            )[0]
            is_pk = bool(re.search(r"\bprimary\s+key\b", remainder, re.I))
            if is_pk:
                primary_keys.add(name)
            column = {
                "name": name,
                "type": type_part,
                "nullable": not bool(re.search(r"\bnot\s+null\b", remainder, re.I)) and not is_pk,
                "primaryKey": is_pk,
            }
            reference = re.search(r"\breferences\s+([\w]+)\.([\w]+)\s*\(([^)]+)\)", remainder, re.I)
            if reference:
                target_schema, target_table, target_column = (
                    reference.group(1).lower(),
                    reference.group(2).lower(),
                    reference.group(3).strip(),
                )
                column["foreignKey"] = f"{target_schema}.{target_table}.{target_column}"
                relationships.append(
                    {
                        "id": f"{schema}.{table}.{name}__{target_schema}.{target_table}.{target_column}",
                        "source": f"{schema}.{table}",
                        "sourceColumns": [name],
                        "target": f"{target_schema}.{target_table}",
                        "targetColumns": [target_column],
                    }
                )
            columns.append(column)

        for column in columns:
            if column["name"] in primary_keys:
                column["primaryKey"] = True
                column["nullable"] = False

        for source_columns, target_schema, target_table, target_columns in table_foreign_keys:
            relationships.append(
                {
                    "id": f"{schema}.{table}.{'_'.join(source_columns)}__{target_schema}.{target_table}.{'_'.join(target_columns)}",
                    "source": f"{schema}.{table}",
                    "sourceColumns": source_columns,
                    "target": f"{target_schema}.{target_table}",
                    "targetColumns": target_columns,
                }
            )
            for name in source_columns:
                for column in columns:
                    if column["name"] == name:
                        column["foreignKey"] = f"{target_schema}.{target_table}.{','.join(target_columns)}"

        key = f"{schema}.{table}"
        meta = ENTITY_META.get(key)
        label = {"en": meta[0], "es": meta[1]} if meta else {"en": human_fallback(table), "es": human_fallback(table)}
        description = {"en": meta[2], "es": meta[3]} if meta else {"en": "Canonical schema entity.", "es": "Entidad del esquema canónico."}
        entities.append(
            {
                "id": key,
                "schema": schema,
                "name": table,
                "kind": "TABLE",
                "label": label,
                "description": description,
                "columns": columns,
            }
        )

    # Foreign key added after projects.project is created.
    for alter in re.finditer(
        r"alter\s+table\s+([\w]+)\.([\w]+).*?foreign\s+key\s*\(([^)]+)\)\s*references\s+([\w]+)\.([\w]+)\s*\(([^)]+)\)",
        sql,
        re.I | re.S,
    ):
        source_schema, source_table = alter.group(1).lower(), alter.group(2).lower()
        source_columns = [x.strip() for x in alter.group(3).split(",")]
        target_schema, target_table = alter.group(4).lower(), alter.group(5).lower()
        target_columns = [x.strip() for x in alter.group(6).split(",")]
        relationship = {
            "id": f"{source_schema}.{source_table}.{'_'.join(source_columns)}__{target_schema}.{target_table}.{'_'.join(target_columns)}",
            "source": f"{source_schema}.{source_table}",
            "sourceColumns": source_columns,
            "target": f"{target_schema}.{target_table}",
            "targetColumns": target_columns,
        }
        if relationship["id"] not in {r["id"] for r in relationships}:
            relationships.append(relationship)
        entity = next(e for e in entities if e["id"] == f"{source_schema}.{source_table}")
        for column in entity["columns"]:
            if column["name"] in source_columns:
                column["foreignKey"] = f"{target_schema}.{target_table}.{','.join(target_columns)}"

    view_columns = [
        ("cost_source", "text"),
        ("source_id", "uuid"),
        ("event_date", "date"),
        ("project_id", "uuid"),
        ("cost_center_id", "uuid"),
        ("counterparty_party_id", "uuid"),
        ("gross_cost", "core.money_amount"),
        ("currency_code", "char(3)"),
        ("review_status", "text"),
    ]
    meta = ENTITY_META["reporting.project_cost_event"]
    entities.append(
        {
            "id": "reporting.project_cost_event",
            "schema": "reporting",
            "name": "project_cost_event",
            "kind": "VIEW",
            "label": {"en": meta[0], "es": meta[1]},
            "description": {"en": meta[2], "es": meta[3]},
            "columns": [
                {"name": name, "type": data_type, "nullable": True, "primaryKey": False}
                for name, data_type in view_columns
            ],
        }
    )
    for source in (
        "procurement.purchase_invoice",
        "procurement.contractor_claim",
        "workforce.payroll_entry",
    ):
        relationships.append(
            {
                "id": f"reporting.project_cost_event__{source}",
                "source": "reporting.project_cost_event",
                "sourceColumns": ["source_id"],
                "target": source,
                "targetColumns": ["id"],
                "relationshipType": "VIEW_SOURCE",
            }
        )

    entities.sort(key=lambda entity: (MODULES[entity["schema"]]["order"], entity["name"]))
    relationship_ids: set[str] = set()
    unique_relationships = []
    for relationship in relationships:
        if relationship["id"] not in relationship_ids:
            unique_relationships.append(relationship)
            relationship_ids.add(relationship["id"])

    modules = []
    for code, module in sorted(MODULES.items(), key=lambda item: item[1]["order"]):
        item = {"id": code, **module}
        item["entityCount"] = sum(entity["schema"] == code for entity in entities)
        modules.append(item)

    return {
        "version": "v0",
        "generatedFrom": str(SQL_PATH.relative_to(ROOT)),
        "modules": modules,
        "entities": entities,
        "relationships": unique_relationships,
    }


def main() -> None:
    model = build_model()
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(model, ensure_ascii=False, separators=(",", ":"))
    OUTPUT_PATH.write_text(
        "// Generated by tools/generate_erd_model.py; do not edit manually.\n"
        f"window.ERD_MODEL={payload};\n",
        encoding="utf-8",
    )
    print(
        f"Wrote {OUTPUT_PATH.relative_to(ROOT)}: "
        f"{len(model['entities'])} entities, {len(model['relationships'])} relationships"
    )


if __name__ == "__main__":
    main()
