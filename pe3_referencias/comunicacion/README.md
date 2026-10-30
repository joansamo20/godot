# Comunicación

- [`Node::propagate_notification`](../../scene/main/node.cpp#L2609): notificación con identificador `int`, al nodo y luego a los descendientes; no entrega argumentos adicionales.
- [`Node::propagate_call`](../../scene/main/node.cpp#L2620): invoca métodos con `Array` de argumentos sobre la rama; permite ejecutar al padre antes o después de sus hijos.
- [`SceneTree::call_group_flagsp`](../../scene/main/scene_tree.cpp#L362): distribuye llamadas con argumentos a grupos; admite orden inverso, ejecución diferida y deduplicación en cierto modo.
- [`SceneTree::notify_group_flags`](../../scene/main/scene_tree.cpp#L455): notifica a miembros de un grupo.
- [`SceneTree::_call_input_pause`](../../scene/main/scene_tree.cpp#L1446): distribuye eventos entre nodos habilitados y detiene el recorrido cuando `Viewport::is_input_handled()`.

**Diferencia importante:** `propagate_call` ya combina argumentos y recorrido descendente. Por tanto, antes de crear notificaciones con argumentos, comparar su legibilidad y comportamiento con esta API.

**No equiparar:** los grupos no son por sí mismos una rama jerárquica; la distribución de input citada recorre una colección de procesamiento, no necesariamente los ancestros del emisor.
