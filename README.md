# Mod Manager

Complemento para [Godot Engine](https://godotengine.org/).


## Features

- Carga escenas inciales de la partida
- Carga Mods del juego
- Mods basados en escenas
- Carga Mods en formato [ConfigFile](./addons/mod_manager/schema/mod.cfg)
- Carga [paquetes de recursos](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html#overview-of-pck-files)
- Guarda y carga partida
- Las partidas están cifradas
- Persistencia de propiedades facilmente configurable
- [Godot](https://godotengine.org/) 4.3

## Installation

[Documentación de como instalar un complemento](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html).

Solo es necesario copiar lo siguiente:
```
addons/mod_manager/plugin.cfc
addons/mod_manager/plugin.gd
addons/mod_manager/src
```
Si está usando [gd-plug](https://github.com/imjp94/gd-plug), agregar los siguiente al fichero plug.gd.
```gdscript
plug(
	"adrianlegui/mod_manager",
	{"exclude": ["addons/mod_manager/test", "addons/mod_manager/schema", "addons/mod_manager/docs"], "tag": "TAG_A_INSTALAR"}
)
```
Reemplazar ```TAG_A_INSTALAR``` con el nombre del tag que se quiere instalar.

## Documentation

[Documentation](./addons/mod_manager/docs/index.md)


## Demo

[Runer 3D](https://github.com/adrianlegui/runner_3d)


## License

Mod Manager se proporciona bajo la licencia [MIT](./addons/mod_manager/LICENSE).
