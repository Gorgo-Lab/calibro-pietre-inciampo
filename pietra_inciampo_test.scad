// Fetta di prova del prototipo: solo la parte alta (scritta + presa) più un fondo pieno.
// Serve a provare presa, profondità del testo e precisione dimensionale
// senza stampare l'intero blocco. Usa le stesse impostazioni di stampa del modello completo.

use <pietra_inciampo.scad>

fondo = 5;  // mm di solido pieno sotto il punto più basso della presa

h_fetta = prof_presa() + fondo;

// porto la fetta a quota zero, appoggiata sul piatto
translate([0, 0, -(altezza_modello() - h_fetta)])
    intersection() {
        modello();
        translate([-1, -1, altezza_modello() - h_fetta])
            cube([lato_modello() + 2, lato_modello() + 2, h_fetta + 1]);
    }
