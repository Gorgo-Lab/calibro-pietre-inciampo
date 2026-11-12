# Calibro per i solchi delle pietre d'inciampo

Modello OpenSCAD parametrico di un calibro da stampare in 3D, per verificare che i solchi scavati nella pavimentazione per la posa delle pietre d'inciampo siano tutti conformi.

> **Stato: prototipo non ancora validato.** Misure, presa e impostazioni di stampa sono in fase di prova.

## A cosa serve

Le pietre d'inciampo sono cubi di circa 96 × 96 × 100 mm. Il calibro riproduce l'ingombro massimo della pietra e serve come controllo *passa / non passa*:

1. l'impresa scava il solco;
2. inserisce il calibro: deve entrare senza forzare e risultare **a filo** con la pavimentazione;
3. se il calibro entra a filo, la pietra (leggermente più piccola) entrerà sicuramente; lo spazio residuo viene riempito con la malta di posa.

Per questo le misure del calibro sono quelle **nominali**, senza tolleranze aggiuntive: è la precisione della stampa a dover essere verificata (vedi [Verifica dimensionale](#verifica-dimensionale)).

## Caratteristiche

- Blocco pieno 96 × 96 × 100 mm, con smusso di 0,5 mm sullo spigolo inferiore (invito nel solco e compensazione dell'allargamento dei primi layer).
- Scritta **incisa** sulla faccia superiore («PROTOTIPO» sopra, «Pietra d'inciampo» sotto): nulla sporge oltre i 100 mm.
- Presa centrale a **mezzo toro**: due aperture tonde da 22 mm in cui infilare due dita, che si incontrano sotto un ponticello centrale. La presa è centrata in modo che la trazione sia in asse con il blocco e non lo faccia ruotare e incastrare nel solco.
- La sezione tonda del tubo rende il soffitto del passaggio un arco autoportante: **si stampa senza supporti**.

## File

| File | Contenuto |
|---|---|
| `pietra_inciampo.scad` | Modello completo, con tutti i parametri in testa al file |
| `pietra_inciampo_test.scad` | Fetta di prova: solo la parte alta (scritta + presa) più 5 mm di fondo pieno, alta circa 35 mm |

La fetta di prova importa il modello con `use <pietra_inciampo.scad>`: ogni modifica ai parametri del modello completo si riflette automaticamente anche sulla fetta.

## Requisiti

- [OpenSCAD](https://openscad.org/) (sviluppato e provato con la 2021.01; le *development snapshot* recenti generano il modello molto più velocemente).
- Font **Liberation Sans Bold** installato (su Debian/Ubuntu: pacchetto `fonts-liberation`). Se il font manca, OpenSCAD ne usa un altro senza avvisare e le dimensioni del testo cambiano.

## Generare gli STL

Gli STL non sono versionati: si generano dai sorgenti.

```bash
openscad -o pietra_inciampo.stl      pietra_inciampo.scad
openscad -o pietra_inciampo_test.stl pietra_inciampo_test.scad
```

In alternativa: aprire il file in OpenSCAD, *Render* (F6), poi *Export as STL*.

## Stampa

Materiale consigliato: **PETG**. Il PLA è più preciso in stampa, ma si ammorbidisce già a 55–60 °C (un'auto al sole d'estate basta a deformarlo) ed è più fragile agli urti; per un attrezzo da cantiere il PETG è più affidabile.

Orientamento: faccia con la scritta **verso l'alto**, nessun supporto.

| Parametro | Valore consigliato | Motivo |
|---|---|---|
| Riempimento | gyroid 10–15 % | resistente in tutte le direzioni, leggero |
| Perimetri | 4 | le pareti laterali sono le superfici di riferimento del calibro |
| Layer superiori | 6–7 | faccia superiore piana per la verifica a filo |
| Layer inferiori | 4 | |
| Modificatore sulla presa | riempimento 100 % in X 18–78, Y 35–61, Z 70–100 mm | il ponticello centrale deve essere pieno per reggere la trazione |
| Compensazione *elephant foot* | attiva | evita che la base risulti più larga di 96 mm |

Le coordinate del modificatore valgono con i parametri di default; se si modificano `r_tubo`, `r_anima` o la posizione della presa vanno aggiornate.

### Prima la fetta di prova

Prima della stampa completa (molte ore) conviene stampare `pietra_inciampo_test.scad` **con le stesse identiche impostazioni** e verificare:

- presa con le dita (anche con i guanti da lavoro);
- tenuta del ponticello sotto trazione;
- qualità del soffitto del passaggio sotto il ponticello;
- leggibilità dell'incisione;
- misure reali del lato.

### Verifica dimensionale

Misurare il lato con un calibro a metà altezza, in X e in Y. Se lo scostamento da 96 mm supera 0,2–0,3 mm, correggere la compensazione dimensionale nello slicer (o il parametro `lato`) e ristampare la fetta prima del modello completo.

## Parametri principali

Tutti in testa a `pietra_inciampo.scad`, modificabili anche dal *Customizer* di OpenSCAD.

| Parametro | Default | Significato |
|---|---|---|
| `lato` | 96 | lato della base (mm) |
| `altezza` | 100 | altezza totale (mm) |
| `smusso` | 0,5 | smusso dello spigolo inferiore (mm) |
| `righe` | — | righe di testo: `[testo, dimensione, quota Y della linea di base]` |
| `profondita` | 1,2 | profondità dell'incisione (mm) |
| `r_tubo` | 11 | raggio della sezione del tubo della presa (aperture da 22 mm) |
| `r_anima` | 7,5 | raggio del ponticello centrale (mm) |
| `r_bordo` | 1,5 | raccordo del bordo delle aperture (mm) |

Il centro del toro deve restare sulla faccia superiore: abbassandolo, la parte alta della parete esterna dei fori diventerebbe uno sbalzo da supportare.

## Nota

Questo è uno strumento di cantiere indipendente, realizzato per supportare la posa. Non è affiliato né approvato dal progetto *Stolpersteine* di Gunter Demnig.

## Licenza

[Creative Commons Attribuzione – Condividi allo stesso modo 4.0 Internazionale (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/deed.it). Testo completo in [`LICENSE`](LICENSE).
