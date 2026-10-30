extends Node

var informe: Node

func _ready() -> void:
    informe = get_tree().current_scene
    child_order_changed.connect(func(): _registrar("senal", "child_order_changed"))
    child_entered_tree.connect(func(n: Node): _registrar("senal", "child_entered_tree", n.name))
    child_exiting_tree.connect(func(n: Node): _registrar("senal", "child_exiting_tree", n.name))
    get_tree().tree_changed.connect(func(): _registrar("SceneTree.senal", "tree_changed"))
    _registrar("virtual", "_ready")

func _notification(codigo: int) -> void:
    match codigo:
        NOTIFICATION_CHILD_ORDER_CHANGED:
            _registrar("notificacion", "CHILD_ORDER_CHANGED")
        NOTIFICATION_PATH_RENAMED:
            _registrar("notificacion", "PATH_RENAMED")

func _registrar(mecanismo: String, evento: String, dato: String = "") -> void:
    if is_instance_valid(informe):
        informe.observar(self, mecanismo, evento, dato)
