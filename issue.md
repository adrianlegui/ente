---
title: agregar validación de escena al agregar Data a DataList
assignees: adrianlegui
labels: enhancement
milestone: 0.11
---
El método add_data tiene que tener parametro only_one con valor predeterminado false; si only_one es true tiene que comprobar si ya existe un nodo Data de la misma escena; si existe, lanzar un error y regresa null, si no existe agregar el nodo Data a la lista y regresar el nodo agregado.