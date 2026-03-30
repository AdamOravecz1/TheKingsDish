# 👑 TheKingsDish

> *„Főzz, vadássz, kereskedj – és ne haragítsd meg a királyt."*

TheKingsDish egy 7 napos főzős stratégiai játék Godot 4 motorban, amelyben a játékos a király fejszakácsaként dolgozik. Minden döntésnek következménye van – a helytelen étel kirúgással, mérgezéssel vagy éppen a trónszékkel végződhet.

---

## 🎮 Játék leírás

A játékos minden nap bejárja a középkori királyság helyszíneit: a kastélyt, az erdőt, a tömlöcöt és a tróntermet. Nyersanyagokat gyűjt, állatokat vadász, NPC-kkel kereskedik, majd a begyűjtött hozzávalókból ételt főz az üstben. Az elkészített fogást a Király Tányérjára kell helyezni, amit a Butler visz el a királynak.

A király reakciója az étel minőségétől és típusától függ. A Butler másnap visszajelzést ad: dicséretet, fizetséget – vagy fenyegetést. Ha kétszer silány ételt kap a király, a játékos elveszíti állását. Ha tiltott ételt (pl. húst böjtnapon) vagy mérgező fogást szolgál fel, a büntetés súlyosabb.

A játéknak **7 különböző befejezése** van, amelyek a meghozott döntések alapján érhetők el – a becsületes „jó szakács" végtől kezdve a rituális fogáson, a sárkány legyőzésén és a király megmérgezésén át egészen a trónszék megszerzéséig.

---

## 📖 Sztori

Az új fejszakács első napján a Butler bevezeti a kastély működésébe: arannyal fizetnek, a falusiaktól recepteket és hozzávalókat vásárolhat, és minden nap el kell készítenie a király ebédjét. A király maga is megjelenik, és elárulja titkos vágyát: egy sárkányból készült fogást szeretne, amely – a legenda szerint – 81 évig biztosítja uralmát.

Eközben egy titokzatos barát felbukkan, aki sötétebb lehetőségekre mutat rá: mérgező gombák, rituális fogások, és az emberi természet határainak feszegetése. A játékos maga dönti el, melyik utat választja.

---

## 🕹 Vezérlők

| Billentyű | Funkció |
|-----------|---------|
| `A` / `D` vagy `←` `→` | Mozgás balra / jobbra |
| `Space` vagy `W` | Ugrás |
| `S` | Guggolás |
| `E` | Interakció (NPC, tárgy, kapu) |
| `F` | Fegyverváltás (KNIFE → AXE → CROSSBOW) |
| `LMB` / `Z` | Támadás / Lövés |
| `R` | Nyílvessző újratöltés |
| `T` | Csapda lerakása |
| `I` | Leltár megnyitása / bezárása |
| `Q` | Receptkönyv megnyitása / bezárása |
| `ESC` | Szünet menü |

> A billentyűkiosztás a beállítások menüben átdefiniálható, az egyéni kiosztás automatikusan mentésre kerül.

---

## ⚙️ Technikai architektúra

### Motor és nyelv
- **Motor:** Godot Engine 4
- **Szkriptnyelv:** GDScript (99.9%) + GDShader (0.1%)

### Jelenetstruktúra
A játék jelenetei `.tscn` fájlokban tárolódnak. A főbb jelenetek:

| Jelenet | Leírás |
|---------|--------|
| `main_menu.tscn` | Főmenü, befejezések, beállítások |
| `castle.tscn` | Kastély – Butler, Király, NPC-k |
| `forest.tscn` | Erdő – vadászat, gyűjtés, Erdei NPC-k |
| `dungeon.tscn` | Tömlöc – zombik, speciális hozzávalók |
| `throne_room.tscn` | Trónterem – a király közvetlen elérése |

### Singleton architektúra
A játék két Autoload singleton-t használ, amelyek az összes jelenetből elérhetők:

- **`Global.gd`** – Játékállapot, NPC dialógusok (fa struktúra), teljes receptkönyv (50+ recept), mentés/betöltés logika, befejezés flag-ek kezelése.
- **`BigGlobal.gd`** – Permanens adatok: billentyűkiosztás, valaha elkészített receptek, megtalált befejezések.
- **`TransitionLayer`** – Jelenetváltás fade animációval (0.5s be, 0.5s ki).
- **`Music`** – Globális zenelejátszó, jelenetenként váltja a zenét.
- **`InteractionManager`** – Interakció kezelő, a játékos közelségét figyeli.

### Mentési rendszer
Két JSON fájl a Godot `user://` könyvtárában:

- **`save_data.json`** – Menet közbeni állapot (leltár, NPC-k, napszám, flag-ek). Befejezéskor törlődik.
- **`save_big_data.json`** – Permanens adatok (keybind, receptek, befejezések). Soha nem törlődik.

### Leltárrendszer
Az `inventory/` mappa önálló leltármodult tartalmaz. 12 slot-os játékos leltár, slot-alapú drag & drop UI. Minden tárgy `.tres` resource fájlként van definiálva, amely tartalmazza a tárgy nevét, textúráját, értékét és `types` tömbjét (pl. `meat`, `poison`, `dragon`, `ritual`).

---

## 🚀 Telepítés és futtatás

### Előfeltételek
- [Godot Engine 4.x](https://godotengine.org/download) telepítve

### Futtatás szerkesztőből
```bash
git clone https://github.com/AdamOravecz1/TheKingsDish.git
```
1. Nyisd meg a Godot Engine-t
2. **Import** → válaszd ki a klónozott mappa `project.godot` fájlját
3. **Run** (F5) a projekt futtatásához

### Futtatás exportált verzióból
Ha van exportált `.exe` / `.x86_64` fájl, azt közvetlenül futtathatod Godot telepítése nélkül.
Ezt a `.exe` fájlt az https://fokos001.itch.io/the-kings-dish oldalról a `Download` gombra kattintva töltheted le.

---

## 📁 Mappastruktúra

```
TheKingsDish/
├── Global/          # Autoload singleton scriptek
├── Scenes/          # Játékjelenetek és szkriptek
├── inventory/       # Leltárrendszer és item resource-ok
├── Sprites/         # Játék grafikai elemek
├── Fonts/           # Betűtípusok
├── Music/           # Háttérzenék
├── Sounds/          # Hangeffektek
├── Shaders/         # GDShader vizuális effektek
└── project.godot    # Godot projektfájl
```

---

## 👤 Szerző

**AdamOravecz1** – [GitHub](https://github.com/AdamOravecz1)
