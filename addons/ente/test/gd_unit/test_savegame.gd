extends GutTest


func test_init__without_args__not_null() -> void:
	var result: EnteSavegame = EnteSavegame.new()
	assert_not_null(result)
