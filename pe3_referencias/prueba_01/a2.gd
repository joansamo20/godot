extends Node

var informe: Node

func _ready() -> void:
    informe = get_node("/root/Raiz")
    tree_entered.connect(func(): _registrar("senal", "tree_entered"))
    tree_exiting.connect(func(): _registrar("senal", "tree_exiting"))
    tree_exited.connect(func(): _registrar("senal", "tree_exited"))
    renamed.connect(func(): _registrar("senal", "renamed"))
    get_tree().tree_changed.connect(func(): _registrar("SceneTree.senal", "tree_changed"))
    _registrar("virtual", "_ready")

func _enter_tree() -> void:
    _registrar("virtual", "_enter_tree")

func _exit_tree() -> void:
    _registrar("virtual", "_exit_tree")

func _notification(codigo: int) -> void:
    match codigo:
        NOTIFICATION_PARENTED:
            _registrar("notificacion", "PARENTED")
        NOTIFICATION_UNPARENTED:
            _registrar("notificacion", "UNPARENTED")
        NOTIFICATION_ENTER_TREE:
            _registrar("notificacion", "ENTER_TREE")
        NOTIFICATION_EXIT_TREE:
            _registrar("notificacion", "EXIT_TREE")
        NOTIFICATION_READY:
            _registrar("notificacion", "READY")
        NOTIFICATION_PATH_RENAMED:
            _registrar("notificacion", "PATH_RENAMED")
        NOTIFICATION_CHILD_ORDER_CHANGED:
            _registrar("notificacion", "CHILD_ORDER_CHANGED")

func _registrar(mecanismo: String, evento: String) -> void:
    if is_instance_valid(informe):
        informe.observar(self, mecanismo, evento)
