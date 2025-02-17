
# ModManager
Complemento para [Godot Engine v4.3](https://godotengine.org/).

Carga mods en formato ConfigFile, carga paquetes de recursos necesarios para los mods, guarda y carga partida del juego. Las partidas guardadas están cifradas.

## Installation

[Documentación de como instalar un complemento](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html).

Solo es necesario copiar lo siguiente:
```
addons/mod_manager/src
addons/mod_manager/plugin.cfc
```
Si está usando [gd-plug](https://github.com/imjp94/gd-plug), agregar los siguiente al fichero plug.gd.
```gdscript
plug(
	"adrianlegui/mod_manager",
	{"exclude": ["addons/mod_manager/test", "addons/mod_manager/schema"], "tag": "TAG_A_INSTALAR"}
)
```
Reemplazar ```TAG_A_INSTALAR``` con el nombre del tag que se quiere instalar.
## License

[MIT](./LICENSE)