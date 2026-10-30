# Jerarquía

- [`Node::_propagate_enter_tree`](../../scene/main/node.cpp#L341): entrada desde el padre hacia los hijos; asigna árbol, profundidad y viewport, registra grupos y emite eventos.
- [`Node::_propagate_ready`](../../scene/main/node.cpp#L323): procesa hijos antes de notificar `READY` al padre.
- [`Node::_propagate_exit_tree`](../../scene/main/node.cpp#L410): salida recorriendo primero descendientes.
- [`Node::_propagate_after_exit_tree`](../../scene/main/node.cpp#L391): limpieza posterior; contempla propiedad de nodos fuera de la rama.
- [`Node::propagate_notification`](../../scene/main/node.cpp#L2609): recorre nodo y descendientes.

**Observación:** la jerarquía determina parte del ciclo de vida y el orden de ejecución; no solo las dependencias entre objetos. No se ha ejecutado una prueba A/B nueva.
