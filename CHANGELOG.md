## 0.14.2 (2025-03-19)

### Refactor

- **ModManager**: nodos PersistentData son agregados a grupos antes de entrar al SceneTree

## 0.14.1 (2025-03-15)

### Fix

- **mod.gd**: se usa SECTION_PERSISTENT_DATA para la sección MOD

## 0.14.0 (2025-03-11)

### BREAKING CHANGE

- las escenas que hereden de escenas de ente, deben ser actualizadas; clase **Entity** se convirtio en clase **PersistentData**; en los ficheros cfg, **[Entities]** pasa a llamarse **[PERSISTENT_DATA]**; clase **Scene** ya no existe.

### Refactor

- moví scripts y escenas al directorio gd

## 0.13.0 (2025-03-04)

### BREAKING CHANGE

- Se necesita Godot 4.4+ para que el complemento funcione

### Refactor

- convertí variables Dictionary a Typed Dictionary
- **ModManager**: reduje la complejidad del método save_game

## 0.12.0 (2025-02-23)

### BREAKING CHANGE

- Cambio de nombre del proyecto. Borrar completamente el complemento antes de instalar la nueva versión.

### Feat

- **ModManager**: agregué single_mode; cuando está activo, ModManager solo carga main_mod
- **ModManager**: agregué comprobación de versión en los mods y partidas guardadas

### Refactor

- **ModManager**: extrajé código repetido y lo convertí en método _thread_wait_to_finish
- renombré el proyecto de Mod Manager a Ente
- **DataList**: renombré métodos que agregan, borran o obtienen nodos Data

## 0.11.0 (2025-02-19)

### BREAKING CHANGE

- Los ficheros cfg de mods tienen que ser convertidos para poder funcionar y las partidas guardadas dejan de funcionar.

### Feat

- **Mod**: agregué métodos para cargar y guardar ficheros cfg

### Refactor

- **ModManager**: reducí la complejidad del método save_game
- **DataList**: agregué validación al método add_data
- cambie la forma de organización de los ficheros cfg

## v0.10.0 (2025-02-14)

### Feat

- agregué clase OneShot, llama a método _on_first_start al iniciar la partida por primera véz

### Refactor

- **ModManager**: reducí la complejidad de los método save_game y load_savegame

## v0.9.0 (2025-02-12)

### BREAKING CHANGE

- los mods tienen que ser actualizados para funcionar y las partidas guardadas en formato json dejan de funcionar

### Feat

- **EntityRefence**: agrego método para configurar id utilizando una entidad

### Fix

- **ModManager**: configuraciones son borradas al recargar el proyecto
- **ModManager**: no se utiliza game_id aunque este configurado

### Refactor

- muevo iconos al directorio icons dentro de resources
- borro fichero encryt_decrypt.gd ya no es necesario
- **ModManager**: utliza ConfigFile para las partidas guardadas y mods, antes usaba json
- **Data**: método _get_persistent_keys pasa a llamarse _get_persistent_properties
- **ModManager**: extraigo constantes y métodos, los convierto en clase ModManagerProperties
- cambio el nombre del singleton MOD_MANAGER a ModManager
- **ModManager**: extraigo codigo para la fusión de diccionarios y lo convierto en clase DictionaryMerger

## v0.8.0 (2025-02-05)

### Feat

- agrego clase Scene, mantiene una escena cargada aunque no este siendo usada
- **IntValue**: se puede configurar si el valor base y el modificador del valor son persistentes
- **FloatValue**: se puede configurar si el valor base y el modificador del valor son persistentes

## v0.7.0 (2025-01-31)

### Feat

- **EntityReference**: agrego método entity_exists, se usa para comprobar que la entidad que se referencia existe

## v0.6.2 (2025-01-29)

### Fix

- **DataList**: no puede remover nodos data de la lista

## v0.6.1 (2025-01-29)

### Fix

- **DataList**: método get_data_node falla al no poder convertir Array[Node] en Array[Data]

## v0.6.0 (2025-01-29)

### Docs

- agrego docstring a las clases

## v0.5.1 (2025-01-28)

### Fix

- **Data**: nodos Data creados en tiempo de ejecución tienen configurado _unique como true

### v0.5.0 (2025-01-28)

### Feat
- agrego clase, DataList, lista persistente de nodos data
- **Data**: pueden ser creados en tiempo de ejecución

### Refactor
- **BoolValue**: método set_default agrego argumento force para forzar el valor true

## v0.4.0 (2025-01-26)

### Feat

- **Data**: tipos Vector2, Transform2D y Transform3D pueden ser guardados
- agrego clase BoolValue, usado para guardar variable bool

### Refactor

- **ModManager**: partida guardada no cifrada se guarda con formato
- **ModManager**: agrego parámetro compress al método save_game
- **ModManager**: se pausa SceneTree antes de iniciar la carga de una partida guardada
- **ModManager**: método delete_entity pasa a llamarse delete_entity_by_id
- agrego métodos de configuración a clases FloatValue y IntValue
- **EntityReference**: agrego setter para variable _entity_id

## v0.3.0 (2025-01-19)

### Feat

- **Entity**: agrego método para comprobar si la entidad es única, is_unique
- **ModManager**: agrego métodos para agregar y para obtener una entidad que se encuentre el el arbol de nodos
- agrego clase EntityReference, guarda id de una entidad y permite obtener una refencia de la misma

### Refactor

- método create_data_node se pasa a llamar create_entity y pasa a estar en entity.gd, antes estaba en data.gd
- los nombres de los eventos del juego y nombre de los métodos pasan a la clase GameEvents
- **Entity**: reemplazo get_node por get_node_or_null en método get_entity

## v0.2.1 (2025-01-16)

### Fix

- **Entity**: entidades no reciben el evento GAME_EVENT_ALL_ENTITIES_ADDED
- **Data**: llamando método inexistente, set_data
- **Entity**: método get_entity retorna nodo root

### Refactor

- las clases FloatValue y IntValue ya no tienen la variable mod con @export
- **Data**: agrego comprobación de tipos que pueden ser guardados
- **Data**: _set_data pasa a recibir diccionario data, antes recibia PROPERTIES
- **Data**: par clave y valor de las variables pasan a diccionario PROPERTIES

## v0.2.0 (2025-01-12)

### Feat

- las partidas guardadas están cifradas
- agrego clase Mod para organizar la información de los mods

### Fix

- **ScriptCreator**: Parse Error: Cannot find member "KEY_ENTITIES" in base "ModManager"
- **SaveGameInfo**: invalid type in function 'set_data'
- **Data**: variables del tipo StringName no son configuradas
- entidades no reciben eventos GAME_EVENT_BEFORE_STARTING y GAME_EVENT_STARTED
- **InfoSavegame**: invalid access to property or key 'has' on a base object of type 'Dictionary'

### Refactor

- **mod_manager.gd**: extraigo codigo repetido y lo convierto en método, get_path_to_savegame
- se usa el nombre del juego guardado al comprobar o cargarlo, antes se usaba la ruta del fichero
- **Data**: variables del tipo int, bool, string, o float no usan var_to_str y str_to_var, para evitar las comillas dobles extras

## v0.1.0 (2025-01-08)

### Feat

- guarda y carga partidas del juego
- carga asincrónica de partida guardada
- agrego IntValue, nodo personalizado que contiene valor int
- agrego FloatValue, nodo personalizado que contiene valor float
- **EntityData**: agrego método para obtener entidad por su nombre
- **EntityData**: agrego variable active para controlar si el nodo esta activo
- **ModManager**: agrego método para fusionar diccionarios de forma recursiva
- **InfoSavegame**: agrego métodos is_corrupt y is_correct para comprobar la partida guardada
- agrego escena para ser usada en autoload para cargar los mods de forma automática
- carga mods en formato json y recursos en ficheros pck
- agrego señales que indican que mod fue cargado con exito y cual fallo
- los mod se cargar usando thread
- carga mods indicados en user://mods/load_order.txt