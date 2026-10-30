# PE3 · Referencias mínimas

## 1. Árbol
- [Entrada](../scene/main/node.cpp#L341), [ready](../scene/main/node.cpp#L323) y [salida](../scene/main/node.cpp#L410): los eventos recorren la jerarquía con órdenes específicos.
- [Notificación descendente](../scene/main/node.cpp#L2609): entrega código entero al nodo y a sus hijos.

## 2. Comunicación
- [propagate_call](../scene/main/node.cpp#L2620): el emisor elige el método y los argumentos; el receptor solo participa si implementa ese método.
- [Llamadas a grupos](../scene/main/scene_tree.cpp#L362): distribución por membresía, no por rama.
- [Entrada consumible](../scene/main/scene_tree.cpp#L1446): termina cuando Viewport indica que fue atendida.

## 3. Diferencia buscada (diseño del usuario)
- Árbol: administra espacio jerárquico y notifica cambios y eventos.
- Notificación propia: viaja por la estructura **con datos**, sin que el emisor deba conocer qué método ejecutará el receptor.
- Cada nodo decide si el dato le interesa y cómo reaccionar.
- En revisión: direcciones ascendente/descendente/lateral y consumo del mensaje.
- Workaround a comparar: notificación sin argumentos + datos en un portal compartido.
- **Prueba A/B pendiente**: `propagate_call` frente a mensaje genérico por rama; medir comportamiento, legibilidad y acoplamiento.

Fuente: `scene/main/node.cpp` y `scene/main/scene_tree.cpp` de este mismo repositorio, consultados el 2026-10-30. No se ha ejecutado prueba A/B. No confundir propuesta con implementación.
