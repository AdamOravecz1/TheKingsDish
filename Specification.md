# The King's Dish — Játék Specifikáció

---

##  Áttekintés

A The King's Dish egy 2D-s, oldalnézetes platformer játék, amelyet Godot 4-ben kell megvalósítani GDScript nyelven. A játékos egy kastélyszakács szerepét tölti be, akinek 7 napon át minden nap ételt kell főznie és felszolgálnia a királynak. Napközben a játékos szabadon bejárja a pályákat, alapanyagokat szerez vadászattal vagy kereskedéssel, majd az üstnél ételt főz, amelyet a Király Tányérjára helyez. A játékos döntései határozzák meg, hogy a 7 lehetséges befejezés közül melyik aktiválódik. A játék PC-re készül, és teljes egészében billentyűzettel irányítható, átdefiniálható gombkiosztással.

---

##  Világ és helyszínek

A játékvilágnak három különálló területből kell állnia, amelyek között a játékos kapukon keresztül közlekedhet.

- A **kastély** minden nap kiindulópontja. Tartalmaznia kell a főzéshez szükséges üstöt, a Király Tányérját az étel átadásához, valamint a Komornyik NPC-t. Minden fő történeti esemény itt kezdődik és végződik.

- Az **erdő** az elsődleges nyersanyagszerző terület. Lehetővé kell tennie a passzív állatok vadászatát, növények gyűjtését és kereskedő NPC-kkel való interakciót. Az állatok csak akkor válnak agresszívvá, ha a játékos egy meghatározott közelségi küszöbön belülre kerül.

- A **dungeon** egy opcionális, magas kockázatú terület. Csapdákat, máshol el nem érhető különleges tárgyakat és egy titokzatos NPC-találkozást kell tartalmaznia. A területre a nap bármely pontján be kell tudni lépni.

---

##  Játékos és mozgás

A játékos karakternek futást, ugrást, guggolást és úszást kell tudnia. A mozgást fizika-alapúan kell megvalósítani Godot `CharacterBody2D` segítségével. A játékosnak véges életerővel kell rendelkeznie (0–100), amelynek nullára csökkenésekor halál állapot aktiválódik. A játékos egy slot-alapú, véges tárhelyen tárolhatja a megszerzett tárgyakat, és bármikor válthat a meglévő fegyverek között.

---

##  Harcrendszer

A játéknak tartalmaznia kell egy harcrendszert, amellyel a játékos az aktuálisan kiválasztott fegyverrel képes támadni ellenfeleket és állatokat. A kezdő fegyver egy konyhai kés. Vásárlással további fegyverek — egy balta és egy íj — szerezhetők meg. Az agresszív ellenfelek (vadkan, kutya, sárkány, zombi) hatótávolságon belül üldözik és sebzik a játékost. A passzív állatok (nyúl, kacsa, hal) közeledésre elmenekülnek. A csapdák lehelyezhető tárgyak, amelyek érintésre sebzést okoznak.

---

##  Főzőrendszer

A játéknak tartalmaznia kell egy üst-alapú főzőrendszert. Az üsttel való interakcióra egy felhasználói felületnek kell megnyílnia, amelyen a játékos kiválaszthatja a leltárából az összeadni kívánt alapanyagokat. Ha a kombináció egyezik egy ismert recepttel, az adott étel elkészül. Ha a kombináció ismeretlen, de érvényes, egy új receptet kell felfedezni és elmenteni. Az elkészült ételt a Király Tányérjára kell helyezni, hogy a nap végi kiértékelés elinduljon.

---

##  NPC és párbeszédrendszer

Minden NPC-nek fa-alapú párbeszédrendszert kell használnia, ahol minden csomópont egy szövegsort vagy választási lehetőséget képvisel. A párbeszéd előrehaladását NPC-nként el kell menteni, hogy visszatéréskor ne kelljen elölről kezdeni a beszélgetést. A kereskedő NPC-knek a megfelelő párbeszéd-opció kiválasztásakor meg kell nyitniuk egy bolt felületet, ahol a játékos aranyért vásárolhat alapanyagokat, fegyvereket vagy recepteket. A Komornyiknak minden nap ki kell értékelnie az átadott étel típusát, és be kell állítania a megfelelő befejezési flageket. Másnapi párbeszédének tükröznie kell az előző nap ételének `previous_day_value` pontszámát.

---

##  Játékciklus és naprendszer

A játéknak szigorúan 7 napos cikluson kell futnia. Minden nap azzal kezdődik, hogy a játékos szabadon mozoghat a kastélyban. Miután az étel felkerül a Király Tányérjára, a Komornyik felveszi és kiértékeli azt. Amint a Komornyik elmegy, a naptárnak interaktívvá kell válnia, lehetővé téve a következő napra lépést. A naptárra kattintás meghívja a `next_day()` függvényt, amely elmenti a teljes játékállapotot, majd meghívja a `check_ending()` függvényt. A `check_ending()` prioritás sorrendben ellenőrzi az összes befejezési feltételt, és ha valamelyik teljesül, betölti a megfelelő befejező jelenetet. Ha egyik sem teljesül, a következő nap kezdődik.

---

##  Befejezések

A játéknak 7 különálló befejezést kell megvalósítania, amelyek mindegyike egy boolean flaghez kötött, amelyet a Komornyik kiértékelése során kell beállítani. A megvalósítandó flagek: `execution`, `ritual`, `king_taker`, `dragon_slayer`, `king_killer`, `kirúgás`, valamint egy túlélési befejezés, amely akkor aktiválódik, ha a játékos mind a 7 napot teljesíti anélkül, hogy bármely más flag aktívvá vált volna. Minden befejezéshez egyedi befejező jelenetet kell betölteni saját vizuális tartalommal és szöveggel. A megtalált befejezéseket tartósan el kell menteni, és a főmenüből elérhetővé kell tenni.

---

##  Mentési rendszer

A játéknak két különálló JSON fájlt kell használnia, amelyeket a Godot `user://` könyvtárában kell tárolni.

A `save_data.json` fájlnak az aktuális menet összes adatát kell tartalmaznia: a játékos statisztikáit (életerő, arany, nyíl, csapda), a teljes leltárt slot-index és item resource path párokként, a ládák tartalmát láda-név szerint kulcsolva, az entitások állapotát jelenetenként (pozíció, sebesség, életerő), a véglegesen meghalt entitások neveit, az NPC párbeszédek előrehaladását, a befejezési flageket, valamint az ételsiker és -kudarc számlálókat. Ezt a fájlt törölni kell, ha bármelyik befejezés aktiválódik.

A `save_big_data.json` fájlnak állandó, meneteken átívelő adatokat kell tárolnia: az összes átdefiniált gombkiosztást szerializált `InputEventKey` objektumként, az összes sikeresen elkészített recept szótárát az elkészítési számokkal, valamint a megtalált befejezések neveit. Ez a fájl soha nem törlődhet. Mivel a JSON nem támogatja a Godot `Vector2` típusát, minden pozíció- és sebességértéket `(x, y)` formátumú stringként kell szerializálni, és betöltéskor reguláris kifejezéssel kell visszaalakítani.

---

##  Állapotgép

A játéknak 12 állapotot kell kezelnie három rétegen. A menü állapotok közé tartozik a Főmenü, a Beállítások és a Szünet képernyő. A játék állapotok az aktív pályát és az átmeneti réteget foglalják magukban. A UI overlay állapotok a Leltárt, az NPC Párbeszédet, a Boltot, az Üstöt és a Király Tányérját fedik le. Két globális singleton-nak kell minden állapotból elérhetőnek lennie: a `Global.gd` az aktuális menet adatait, a `BigGlobal.gd` az állandó adatokat kezeli. A jelenetek közötti átmeneteket a Transition Layer fade animációval kell megvalósítani. A UI overlay-eknek nem szabad megállítaniuk a háttérben futó játéklogikát.

---

##  Főbb osztályok

A következő osztályokat kell megvalósítani. A `Global.gd` és `BigGlobal.gd` singleton-ok kezelik az összes perzisztens állapotot. A `Player` osztály felelős a mozgásért, a fizikáért, a harcért és az életerőért, míg a `Player_graphics` külön kezeli az animációkat. Az `Inventory` osztály a slot-logikát és az inventory UI-val való kommunikációt valósítja meg. Az `Interaction_manager` és `Interaction_area` érzékeli a játékos közelségét és engedélyezi a kontextuális interakciókat. A `Level` osztály az aktív jelenetet és annak entitásait kezeli. Az `Entity` az összes sebződő és mozgó karakter alaposztálya, amelyből az agresszív ellenfelek (`Boar`, `Dog`, `Dragon`, `Zombie`) és a passzív állatok (`Rabbit`, `Duck`, `Fish`) egyaránt örökölnek. A `Speech` osztály kezeli az összes NPC párbeszédfáját. Minden kereskedő NPC (`Blacksmith`, `Miller`, `Hunter`, `Fisher`, `Monk`), valamint a `Butler` és a `King` egy közös NPC alaposztályból örököl, saját bolt UI-jal és párbeszéddel. Az `Ending` az összes befejező jelenet alaposztálya, amelyből minden egyes befejezési flaghez egy specifikus osztály örököl.
