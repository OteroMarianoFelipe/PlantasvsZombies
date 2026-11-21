# Explicaciones teóricas

### 1. Polimorfismo
* ***ImageProvider*:** Un ejemplo claro de polimorfismo en nuestro proyecto son los *`ImageProvider`*: objetos que mantienen una referencia y los parámetros necesarios para decidir qué imagen mostrar en cada momento. Pueden ser una animación, un *sprite* o un proveedor que cambia de imagen según la vida del usuario, respondiendo todos de forma distinta bajo un mismo contrato.
  
  ![Diagrama de clase/estático de `ImageProviders`](Polimorfismo-ImageProvider.png)
  
* **Estados de cartas de planta**: Las cartas que gestionan la selección y el *spawneo* de plantas tienen cuatro estados posibles (`available`, `unavailable`, `selected` y `onCoolDown`). Aunque heredan de una clase padre común, cada uno sobrescribe los métodos que necesita. La carta interactúa con ellos a través de su interfaz base para delegar comportamientos sin depender de su implementación concreta.

  ![Diagrama de clase/estático de `CardStates`](Polimorfismo-PlantCardState.png)

### 2. Encapsulamiento
* ***ImageProviderStateTracker*:** Las entidades delegan en un `ImageProviderHandler` el cambio entre animaciones y el uso de animaciones temporales. Este *handler* se apoya en `ImageProviderStateTracker` para ocultarle cuándo cambia de *frame* o cómo se determina que una animación terminó, limitándose a consultarle el estado resultante. Así se separan responsabilidades y se encapsula el seguimiento interno de la animación.

  ![Diagrama de clase/estático de `ImageProviderStateTracker`](Encapsulamiento-ImageProviderStateTracker.png)

### 3. Composición
* **Módulos de acción y comportamientos en entidades activas:** Las entidades que incorporan el `mixin` `Active` reciben al crearse un `ActionModule` al que delegan su comportamiento. Por ejemplo, un *zombie* utiliza un `ActionModule` formado por distintos `Behavior`, cada uno compuesto por una *key* que lo identifica, un `imageProviderKey` y una estrategia que define cuándo activarse y qué efecto producir. Esto facilita distinguir o variar tipos de zombis sin duplicar clases ni añadir lógica extra en subclases.

  ![Diagrama de clase/estático de `ActionModule` y `Behaviors`](Composición-ActionModule&Behaviors.png)

### 4. Mixins
* **Mixins (capacidades modulares):** Utilizamos *mixins* para componer capacidades específicas según lo que cada entidad necesita, evitando clases o estructuras base sobrecargadas o jerarquías de herencia rígidas. Contamos con `Ticks` (para recibir actualizaciones periódicas, como un sol actualizando su temporizador para desaparecer), `Alive` (para entidades con vida y muerte, como plantas y *zombies*, pero no proyectiles), `HandlesCollisions` (usado en proyectiles de impacto como el guisante, pero no en plantas ni en el sol) y `Active` (que extiende `Ticks` y aporta un `ActionModule` para comportamientos complejos). Por ejemplo, Active abarca distintos tipos de entidades, como *zombies*, plantas y proyectiles como el guisante para gestionar su movimiento, mientras que una nuez no lo necesita y se limita a `Alive` y `Ticks` para rastrear su vida, actualizar su *sprite* y morir.

  ![Diagrama de clase/estático de `Active`](Mixins-Active.png)
