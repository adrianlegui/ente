class_name EncryptDecrypt extends RefCounted


static func load_encrypted_file(
	path: String,
	key: String
) -> String:
	var file_access: FileAccess = null

	if not FileAccess.file_exists(path):
		push_error("file does not exist: %s" % path)

	file_access = FileAccess.open_encrypted_with_pass(
		path,
		FileAccess.ModeFlags.READ,
		key
	)

	if not file_access:
		push_error(
			"could not open file %s. Error: %s" % [
				path,
				error_string(file_access.get_open_error())
			]
		)

	var data: String = file_access.get_line()
	file_access.close()
	return data


static func save_encrypted_file(
	data: String,
	path: String,
	key: String
) -> void:
	var dir: String = path.get_base_dir()
	if DirAccess.dir_exists_absolute(dir):
		var result: int = DirAccess.make_dir_recursive_absolute(dir)
		if result == OK:
			var file_access: FileAccess = FileAccess.open_encrypted_with_pass(
				path,
				FileAccess.ModeFlags.WRITE,
				key
			)
			if not file_access:
				push_error(
					"could not open file %s. Error: %s" % [
						path,
						error_string(file_access.get_open_error())
					]
				)
				push_error("failed to save encrypted file %s" % path)
			else:
				file_access.store_line(data)
				file_access.close()
		else:
			push_error("failed to create directory %s" % dir)
			push_error("failed to save encrypted file %s" % path)
