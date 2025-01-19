## v0.3.0 (2025-01-19)

### Feat

- **Entity**: agrego método para comprobar si la entidad es única, is_unique
- **ModManager**: agrego métodos para agregar y para obtener una entidad que se encuentre el el arbol de nodos
- agrego clase EntityReference, guarda id de una entidad y permite obtener una refencia de la misma

### Refactor

- método create_data_node se pasa a llamar create_entity y pasa a estar en entity.gd, antes estaba en data.gd
- **EntityReference**: agrego variable entity_id como clave persistente
- **EntityReference**: simplifico la clase usando método de ModManager
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
- quito escenas que ya no son necesarias

## v0.2.0 (2025-01-12)

### Feat

- las partidas guardadas están cifradas
- agrego clase Mod para organizar la información de los mods

### Fix

- **ScriptCreator**: Parse Error: Cannot find member "KEY_ENTITIES" in base "ModManager"
- cannot call method 'get_open_error' on a null value
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

- carga asincrónica de partida guardada
- agrego escena que crea script con constantes con los nombres de las entidades de un fichero json
- agrego IntValue, nodo personalizado que contiene valor int
- agrego FloatValue, nodo personalizado que contiene valor float
- **EntityData**: agrego método para obtener entidad por su nombre
- **EntityData**: agrego variable active para controlar si el nodo esta activo
- **ModManager**: agrego método para fusionar diccionarios de forma recursiva
- **InfoSavegame**: agrego métodos is_corrupt y is_correct para comprobar la partida guardada
- guarda y carga partidas del juego
- agrego escena para ser usada en autoload para cargar los mods de forma automática
- carga mods en formato json y recursos en ficheros pck
- agrego señales que indican que mod fue cargado con exito y cual fallo
- los mod se cargar usando threads
- carga mods indicados en user://mods/load_order.txt

### Fix

- no carga la última linea de load_order.txt
- **EntityData**: Cannot find member "KEY_SCENE_FILE_PATH" in base "EntityData"
- **EntityData**: no se llama al setter cuando se configura variable active
- **ModManager**: acceso inválido a diccionario cuando no contiene GAME_ID
- no se puede puede usar get_open_error() en null

### Refactor

- **ModManager**: método clean_scene_tree usa método call_group para limpiar el arbol, antes usaba un buqle for
- **Data**: quito variable active por que no es necesaria ya que existe process_mode
- **Data**: el parse se pasa a realizar usando los métodos str_to_var y var_to_str
- **EntityData**: las nombres de las variables persistentes se obtiene con método, ántes se usaba constantes
- pongo EntityData en una carpeta y el ejemplo de mod en otra, y agrego escena principal simple
- cambio GAME_NAME por GAME_ID
- renombro métodos y constantes con nombres mas explicitos
- reestructuración del proyecto
