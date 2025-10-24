class_name EnteDictionaryTool extends RefCounted
## Fusiona [Dictionary].


## Fusiona [param dict_b] con [param dict_a].
static func merge(dict_a: Dictionary, dict_b: Dictionary) -> Dictionary:
	var d := {}
	for key in dict_b:
		if dict_a.has(key) and typeof(dict_a[key]) == TYPE_DICTIONARY:
			d[key] = merge(dict_a[key], dict_b[key])
		else:
			d[key] = dict_b[key]
	return d


## Regresa un diccionario con la diferencia entre ambos diccionarios.
static func diff(dict_a: Dictionary, dict_b: Dictionary) -> Dictionary:
	var d := {}
	for key in dict_b:
		if dict_a.has(key) and typeof(dict_a[key]) == TYPE_DICTIONARY:
			var d0 := diff(dict_a[key], dict_b[key])
			if not d0.is_empty():
				d[key] = d0
		elif not dict_a.has(key) or dict_a[key] != dict_b[key]:
			d[key] = dict_b[key]

	for key in d:
		var v = d[key]
		if typeof(v) == TYPE_DICTIONARY and (v as Dictionary).is_empty():
			d.erase(key)
	return d
