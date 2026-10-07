# Wollok Game: Título de juego

**Grupo:** GruPOO7

**Integrantes:**
- Joaquin abalos
- Jeronimo vazza
- Matias albanell
- Gonzalo bacigalupo
- Mariano Felipe Otero

## Consignas

Todo lo que necesitan saber está explicado en [este documento](https://docs.google.com/document/d/1KoB12RIZk_xPhmnOJ-EfLIPNwkETD_EaYMp2srDu9QY/edit?tab=t.0#heading=h.wnm2lu4cls8j). Para todo lo demás, aseguren prestar atención a los comunicados por Discord.

Revisen los archivos de base y cambien lo que quieran para ajustarlo a sus necesidades. Lo primero que deberían hacer es actualizar 

Recuerden que para cada checkpoint hay [expectativas mínimas](https://docs.google.com/document/d/1KoB12RIZk_xPhmnOJ-EfLIPNwkETD_EaYMp2srDu9QY/edit?tab=t.0#heading=h.56t0qdv908v3) respecto a los conceptos aplicados. Procuren:
- Validar su idea con el equipo docente que corresponda por su canal de Discord
- Para cada checkpoint, asegurar que implementaron lo necesario para esa instancia, y crear un **tag** en el repositorio para facilitar la comparación entre versiones final e intermedias.
- Para la demo final, crear un nuevo tag **demo** y actualizar este README con todo lo necesario.

# Cómo jugar

## Cómo ejecutar

Desde la raíz del proyecto, ejecuten:

```sh
wollok run juego.juego -p .
```

## Objetivo

Proteger el jardin en cinco filas. Cada fila tiene una planta al comienzo y un zombie que avanza desde el extremo derecho.

## Controles

Por ahora no hay controles manuales: los zombies avanzan automaticamente una casilla cada 1,2 segundos. Los lanzaguisantes disparan cada 4 segundos y las plantas pierden vida cuando las alcanza un zombie.

# Explicaciones

Las explicaciones teóricas y diagramas van a encontrarse en [explicaciones.md](explicaciones.md) a partir del Checkpoint #2.