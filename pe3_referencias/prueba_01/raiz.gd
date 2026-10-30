extends Node

var activo := false
var secuencia := 0
var registros: Array[Dictionary] = []

func _ready() -> void:
    child_order_changed.connect(func(): observar(self, "senal", "child_order_changed"))
    child_entered_tree.connect(func(n: Node): observar(self, "senal", "child_entered_tree", n.name))
    child_exiting_tree.connect(func(n: Node): observar(self, "senal", "child_exiting_tree", n.name))
    tree_entered.connect(func(): observar(self, "senal", "tree_entered"))
    tree_exiting.connect(func(): observar(self, "senal", "tree_exiting"))
    tree_exited.connect(func(): observar(self, "senal", "tree_exited"))
    get_tree().tree_changed.connect(func(): observar(self, "SceneTree.senal", "tree_changed"))
    get_tree().node_added.connect(func(n: Node): observar(self, "SceneTree.senal", "node_added", n.name))
    get_tree().node_removed.connect(func(n: Node): observar(self, "SceneTree.senal", "node_removed", n.name))
    activo = true
    observar(self, "control", "estado_inicial")
    call_deferred("_ejecutar")

func _notification(codigo: int) -> void:
    if not activo:
        return
    if codigo == NOTIFICATION_CHILD_ORDER_CHANGED:
        observar(self, "notificacion", "CHILD_ORDER_CHANGED")
    elif codigo == NOTIFICATION_PATH_RENAMED:
        observar(self, "notificacion", "PATH_RENAMED")

func _enter_tree() -> void:
    if activo:
        observar(self, "virtual", "_enter_tree")

func _exit_tree() -> void:
    if activo:
        observar(self, "virtual", "_exit_tree")

func _ejecutar() -> void:
    observar(self, "control", "antes_de_reparent")
    $A/A2.reparent($B)
    observar(self, "control", "despues_de_reparent")
    await get_tree().process_frame
    observar(self, "control", "estado_final")
    var archivo := FileAccess.open("user://prueba_01.jsonl", FileAccess.WRITE)
    if archivo == null:
        push_error("No se pudo abrir el reporte JSONL")
        return
    for registro in registros:
        archivo.store_line(JSON.stringify(registro))
    archivo.close()
    print("FIN | registros=", registros.size(), " | archivo=", ProjectSettings.globalize_path("user://prueba_01.jsonl"))
    get_tree().quit()

func observar(nodo: Node, mecanismo: String, evento: String, dato: String = "") -> void:
    if not activo:
        return
    secuencia += 1
    var padre := nodo.get_parent()
    var hermanos: Array[String] = []
    if padre != null:
        for hermano in padre.get_children():
            if hermano != nodo:
                hermanos.append(hermano.name)
    var hijos: Array[String] = []
    for hijo in nodo.get_children():
        hijos.append(hijo.name)
    var ancestros: Array[String] = []
    var actual := padre
    while actual != null:
        ancestros.append(actual.name)
        actual = actual.get_parent()
    var registro := {
        "orden": secuencia,
        "observador": nodo.name,
        "mecanismo": mecanismo,
        "evento": evento,
        "dato": dato,
        "en_tree": nodo.is_inside_tree(),
        "padre": padre.name if padre != null else "(ninguno)",
        "hermanos": hermanos,
        "hijos": hijos,
        "ancestros": ancestros,
        "ruta": str(nodo.get_path()) if nodo.is_inside_tree() else "(fuera de tree)",
        "grupos": Array(nodo.get_groups()),
        "decision": "registrar contexto; sin reaccion de dominio"
    }
    registros.append(registro)
    print(JSON.stringify(registro))
