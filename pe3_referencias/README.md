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

## Prueba 1 · Contexto de cada nodo (plan, no ejecutada)

**Objetivo.** Observar cuánto comportamiento y conocimiento del entorno ofrece Godot nativamente cuando **A2 cambia de A a B**. El informe es compuesto: cada script entrega sus observaciones con secuencia y mecanismo; no se infieren eventos ausentes.

**Escena fija**

```text
Raíz [script]
├── A
│   ├── A1
│   └── A2 [script] ← mover a B
├── B [script]
│   ├── B1
│   └── B2
└── C [script]
    ├── C1
    └── C2
```

Solo cuatro scripts: Raíz, A2, B y C. Sin clases de comunicación nuevas, sin modificar Godot, sin simular eventos que no ocurran. Se usan señales, notificaciones, métodos virtuales y consultas nativas pertinentes. La acción disparadora es única.

**Cada observación escribe, en el instante del evento y antes de reaccionar:**
1. Secuencia global, nodo observador, mecanismo exacto y evento; origen de la notificación cuando sea accesible.
2. Contexto conocido **en ese momento**: dentro/fuera del SceneTree, padre, hijos, hermanos, ruta, ancestros y grupos; indicar lo no disponible. Evitar interpretar retrospectivamente el estado.
3. Decisión local: condición evaluada, método o reacción ejecutada (o motivo de no actuar); si hubo nueva señal o llamada.

**Diferencias de perspectiva que interesa observar:**
- **A2:** padre anterior/nuevo, entrada/salida, familia y cambios de ruta cuando realmente puedan observarse.
- **B:** sus hijos y las señales/notificaciones que reciba del movimiento.
- **C:** si existe alguna vía nativa de enterarse desde una rama no implicada; ausencia significa ausencia, no error.
- **Raíz:** señales y cambios disponibles al antecesor común; cómo ve la estructura.

**Secuencia de ejecución:**
1. Construir la escena y preparar conexiones nativas **explícitas**, anotando cuáles se conectaron para no confundirlas con eventos automáticos.
2. Registrar una instantánea inicial desde cada uno de los cuatro scripts.
3. Ejecutar **una vez** el cambio de padre de A2 mediante la API de Godot. Registrar operación exacta y su posición en la secuencia global.
4. Cada callback ejecutado toma su instantánea contextual, aplica una reacción informativa diferente y agrega su contribución al registro común.
5. Obtener reporte final ordenado cronológicamente y agrupable por nodo, conservando también observadores sin eventos. Registrar estado final.

**Comparación futura, aún no implementada:** desde este resultado nativo construir control imperativo equivalente y comparar acciones explícitas, cobertura, dependencia entre nodos y legibilidad. No llamar A/B a dos mecanismos con propósitos distintos.

**Criterio:** no premiar cantidad de eventos; identificar **qué contexto da Godot justo cuando ocurre cada evento**, qué reacciones puede habilitar y qué falta. No modificar la arquitectura a partir de supuestos.
