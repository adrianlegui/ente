# GdUnit generated TestSuite
class_name EncryptDecryptTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/encrypt_decrypt.gd'


func test_load_encrypted_file() -> void:
	var ed: EncryptDecrypt = (load(__source) as Script).new()
	var data: String = "mi_data"
	var path: String = "user://otra_cosa.encrypted"
	var key: String = "my_key"
	var file: FileAccess = FileAccess.open_encrypted_with_pass(
		path,
		FileAccess.WRITE,
		key
	)

	file.store_line(data)
	file.close()

	var d: String = ed.load_encrypted_file(path, key)
	assert_str(d).is_equal(data)


func test_save_encrypted_file() -> void:
	var ed: EncryptDecrypt = (load(__source) as Script).new()
	var data: String = "mi_data"
	var path: String = "user://cosa.encrypted"
	var key: String = "my_key"

	ed.save_encrypted_file(data, path, key)

	assert_bool(FileAccess.file_exists(path)).is_true()

	var file: FileAccess = FileAccess.open_encrypted_with_pass(
		path, FileAccess.READ, key
	)
	print(error_string(file.get_open_error()))
	assert_object(file).is_not_null()

	assert_str(file.get_line()).is_equal(data)

	file.close()
