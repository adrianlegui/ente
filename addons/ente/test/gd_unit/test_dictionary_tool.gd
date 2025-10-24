extends GutTest


func test_merge() -> void:
	var key_1: String = "key 1"
	var value_1: int = 99
	var key_2: String = "key 2"
	var value_2: int = 123
	var key_3: String = "key 3"
	var value_3: Dictionary = {key_2: value_2}
	var dict_a: Dictionary = {key_3: {}}
	var dict_b: Dictionary = {key_1: value_1, key_3: value_3}

# result = {
# 	"key 1" : 99,
# 	"key 3" : {
# 		"key 2" : 123
# 	}
# }
	var result: Dictionary = EnteDictionaryTool.merge(dict_a, dict_b)

	assert_not_null(result)
	assert_false(result.is_empty())
	assert_eq(result.keys().size(), 2)
	assert_true(result.has_all([key_1, key_3]))
	assert_eq(result[key_1], value_1)
	assert_eq(result[key_3][key_2], value_2)


func test_diff() -> void:
	var k0 := "k0"
	var k1 := "k1"
	var k2 := "k2"
	var k3 := "k3"
	var k4 := "k4"
	var k5 := "k5"
	var k6 := "k6"
	var da := {
		k0 : 1,
		k1 : 2,
		k2 : {
			k4 : true
		},
		k3 : {
			k5 : 99
		}
	}
	var k1_v := 3
	var db := {
		k0 : 1,
		k1 : k1_v,
		k2 : {
			k4 : false
		},
		k3 : {
			k5 : 99
		},
		k6: 999
	}

	# { "k1": 3, "k2": { "k4": false }, "k6": 999 }
	var result := EnteDictionaryTool.diff(da, db)

	assert_not_null(result)
	assert_false(result.is_empty())
	assert_false(result.has_all([k0, k3]))
	assert_true(result.has_all([k1, k2]))
	assert_false(result[k2][k4])
	assert_eq(result[k1], k1_v)
