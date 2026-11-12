// Prototipo pietra d'inciampo (calibro per verificare i solchi)
// Stampa: PETG, faccia con il testo verso l'alto, nessun supporto.

/* [Blocco] */
lato     = 96;   // mm, lato della base
altezza  = 100;  // mm, altezza totale del modello
smusso   = 0.5;  // mm, smusso dello spigolo inferiore (invito + compensa elephant foot)

/* [Testo] */
// ogni riga: [testo, altezza caratteri (mm), quota Y della linea di base (mm)]
righe        = [
    ["PROTOTIPO",  10, 73.5],   // sopra la presa
    ["Pietra",      9, 20.5],   // sotto la presa
    ["d'inciampo",  9, 8.5],
];
profondita   = 1.2;           // profondità dell'incisione (mm), ~6 layer da 0.2
font         = "Liberation Sans:style=Bold";

/* [Presa] */
// Presa a mezzo toro: il centro dell'anello sta sulla faccia superiore, l'asse è lungo Y.
// Le dita entrano dalle due aperture tonde e si incontrano sotto il ponticello.
r_tubo     = 11;    // raggio della sezione del tubo (mm): aperture da 2*r_tubo
r_anima    = 7.5;   // raggio del ponticello centrale pieno (mm)
r_bordo    = 1.5;   // raggio di raccordo del bordo delle aperture (mm)
fori_y     = lato / 2;  // centro della presa sull'asse Y: al centro per tirare in asse

$fn = 64;

r_toro = r_anima + r_tubo;  // raggio della linea media dell'anello

// ---------------------------------------------------------------- blocco

module blocco() {
    hull() {
        translate([smusso, smusso, 0])
            cube([lato - 2 * smusso, lato - 2 * smusso, altezza]);
        translate([0, 0, smusso])
            cube([lato, lato, altezza - smusso]);
    }
}

// ---------------------------------------------------------------- testo

module testo() {
    translate([0, 0, altezza - profondita])
        linear_extrude(height = profondita + 0.01)  // sfora in alto per un taglio pulito
            for (r = righe)
                translate([lato / 2, r[2]])
                    text(r[0], size = r[1], font = font,
                         halign = "center", valign = "baseline");
}

// ---------------------------------------------------------------- presa

// raccordo a quarto di cerchio sul bordo superiore di un profilo convesso
module raccordo_bordo(passi = 8) {
    function off(i) = r_bordo - r_bordo * sin(90 * i / passi);
    function dz(i)  = r_bordo - r_bordo * cos(90 * i / passi);
    for (i = [0 : passi - 1])
        hull() {
            for (j = [i, i + 1])
                translate([0, 0, altezza - dz(j)])
                    linear_extrude(height = 0.01) offset(r = off(j)) children();
        }
    translate([0, 0, altezza - 0.01])
        linear_extrude(height = 1) offset(r = r_bordo) children();
}

module presa() {
    translate([lato / 2, fori_y, 0]) {
        // toro completo: la metà superiore cade fuori dal blocco
        translate([0, 0, altezza])
            rotate([90, 0, 0])
                rotate_extrude($fn = 128)
                    translate([r_toro, 0]) circle(r = r_tubo, $fn = 64);
        for (s = [-1, 1])
            raccordo_bordo() translate([s * r_toro, 0]) circle(r = r_tubo);
    }
}

// ---------------------------------------------------------------- modello

// valori esposti ai file che fanno `use <pietra_inciampo.scad>`
function altezza_modello() = altezza;
function lato_modello()    = lato;
function prof_presa()      = r_toro + r_tubo;  // quota più bassa della cavità sotto la cima

module modello() {
    difference() {
        blocco();
        testo();
        presa();
    }
}

modello();
