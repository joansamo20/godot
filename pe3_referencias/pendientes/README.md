# Diseño abierto (no aprobado)

**Expresado por el usuario**
- `Arbol` provee y administra un espacio jerárquico; notifica cambios y eventos.
- Nodo + descendientes se mueve como unidad.
- Comunicación: llamada directa, señal y notificaciones custom con argumentos.
- Explorar propagación ascendente, descendente y lateral; mensajes consumibles.
- Refactorizar/reimaginar/extender con API y fuente existentes, priorizando código autodocumentado.

**Aún por demostrar**
- Qué gana una notificación custom frente a `propagate_call` y a señales conectadas.
- Qué notificaciones reciben descendientes al mover una rama.
- Orden y consumo de mensajes, especialmente si cambia el árbol durante el recorrido.

**Prueba siguiente:** A/B básico, mismo comportamiento nativo frente a variante propia; comparar legibilidad, dependencias y resultados. No modificar el motor antes de tener evidencia.
