class_name DictionaryMerger extends RefCounted
## Fusiona [Dictionary].


## Fusiona [param dict_b] con [param dict_a].
static func merge(dict_a: Dictionary, dict_b: Dictionary) -> Dictionary:
	for key in dict_b:
		if dict_a.has(key) and typeof(dict_a[key]) == TYPE_DICTIONARY:
			merge(dict_a[key], dict_b[key])
		else:
			dict_a[key] = dict_b[key]
	return dict_a
