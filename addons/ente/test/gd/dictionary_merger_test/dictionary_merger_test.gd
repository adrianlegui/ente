# GdUnit generated TestSuite
class_name DictionaryMergerTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/ente/src/gd/dictionary_merger/dictionary_merger.gd"


func test_merge() -> void:
	var key: String = "key"
	var key_overwrite: String = "key_overwrite"
	var valor: String = "original"
	var dict_key := "dict_key"
	var dict_a: Dictionary = {
		key: valor, key_overwrite: valor, dict_key: {key: valor, key_overwrite: valor}
	}

	var new_key: String = "new_key"
	var new_valor: String = "no es original"
	var dict_b: Dictionary = {
		key_overwrite: new_valor,
		new_key: valor,
		dict_key: {key_overwrite: new_valor, new_key: valor}
	}

	var result: Dictionary = DictionaryMerger.merge(dict_a, dict_b)
	assert_object(result).is_same(dict_a)
	assert_str(result[key]).is_equal(valor)
	assert_str(result[new_key]).is_equal(valor)
	assert_str(result[key_overwrite]).is_equal(new_valor)
	assert_str(result[dict_key][key]).is_equal(valor)
	assert_str(result[dict_key][key_overwrite]).is_equal(new_valor)
	assert_str(result[dict_key][new_key]).is_equal(valor)
