extends GutTest


func test_merge() -> void:
	var key_1: String = "key 1"
	var value_1: int = 99
	var key_2: String = "key 2"
	var value_2: int = 123
	var key_3: String = "key 3"
	var value_3: Dictionary = {key_2 : value_2}
	var dict_a: Dictionary = {key_3 : {}}
	var dict_b: Dictionary = {key_1 : value_1, key_3 : value_3}

# result = {
# 	"key 1" : 99,
# 	"key 3" : {
# 		"key 2" : 123
# 	}
# }
	var result: Dictionary = DictionaryMerger.merge(dict_a, dict_b)

	assert_not_null(result)
	assert_false(result.is_empty())
	assert_eq(result.keys().size(), 2)
	assert_true(result.has_all([key_1, key_3]))
	assert_eq(result[key_1], value_1)
	assert_eq(result[key_3][key_2], value_2)
