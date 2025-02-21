# GdUnit generated TestSuite
class_name SceneTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/mod_manager/src/gd/data/scene/scene.gd"
const SCENE = preload("res://addons/mod_manager/src/gd/data/scene/scene.tscn")
const ENTITY_FOR_TEST = preload(
	"res://addons/mod_manager/test/entity_for_test/entity_for_test.tscn"
)
const SCENE_PATH: String = "res://addons/mod_manager/test/entity_for_test/entity_for_test.tscn"

var _entity: Entity


func before() -> void:
	_entity = auto_free(ENTITY_FOR_TEST.instantiate()) as Entity
	add_child(_entity)


func test_set_scene_path_persistent() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	assert_str(scene.get_scene_path()).is_empty()
	scene.set_scene_path_persistent(true)
	assert_bool(scene.is_scene_path_persistent()).is_true()


func test_is_scene_path_persistent() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	assert_bool(scene.is_scene_path_persistent()).is_false()


func test_add_unload_blocker() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	scene.set_scene_path(SCENE_PATH)
	scene.add_unload_blocker(_entity)
	assert_bool(scene.has_unload_blocker(_entity)).is_true()
	assert_bool(scene.is_preloaded()).is_true()


func test_remove_unload_blocker() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	scene.set_scene_path(SCENE_PATH)
	scene.add_unload_blocker(_entity)
	assert_bool(scene.has_unload_blocker(_entity)).is_true()
	assert_bool(scene.is_preloaded()).is_true()
	scene.remove_unload_blocker(_entity)
	assert_bool(scene.has_unload_blocker(_entity)).is_false()
	assert_bool(scene.is_preloaded()).is_false()


func test_set_scene_path() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	scene.set_scene_path(SCENE_PATH)
	assert_str(scene.get_scene_path()).is_equal(SCENE_PATH)


func test_get_scene_path() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	assert_str(scene.get_scene_path()).is_empty()


func test_is_preloaded() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	assert_bool(scene.is_preloaded()).is_false()


func test_set_preloaded() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	scene.set_preloaded(true)
	assert_bool(scene.is_preloaded()).is_true()


func test_get_scene() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	scene.set_scene_path(SCENE_PATH)
	var node: Node = auto_free(scene.get_scene() as Node)
	assert_str(node.scene_file_path).is_equal(SCENE_PATH)


func test__get_persistent_properties() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	assert_array(scene._get_persistent_properties()).contains(
		["_unloaded", "_scene_path_persistent"]
	)
	scene.set_scene_path_persistent(false)
	assert_array(scene._get_persistent_properties()).not_contains(["_scene_path"])
	scene.set_scene_path_persistent(true)
	assert_array(scene._get_persistent_properties()).contains(["_scene_path"])


func test_has_unload_blocker() -> void:
	var scene = auto_free(SCENE.instantiate()) as Scene
	assert_bool(scene.has_unload_blocker(_entity)).is_false()
	scene.add_unload_blocker(_entity)
	assert_bool(scene.has_unload_blocker(_entity)).is_true()
