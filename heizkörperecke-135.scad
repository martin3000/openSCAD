// Parameter
dicke = 1.7;           // Materialstärke
laenge = 135;          // Länge des Winkels
schenkel1 = 30;        // Breite Schenkel 1
schenkel2 = 20;        // Breite Schenkel 2
einbuchtung_breite = 33;
einbuchtung_tiefe = 6.5;
abstand_vom_rand = 40;  //Einbuchtung
radius = 23;            //Einbuchtung
begrenzungshoehe = 10; // Begrenzung rechts und links

// Schlüssel-Parameter
maul_aussen = 40;
maul_innen = 24;
maul_dicke = 4;
maul_winkel = 45;  // Neigung des Schlüssels
maul_abstand = 15;

module maulschluessel() {
    difference() {
        // Außenkreis
        cylinder(h = maul_dicke, r = maul_aussen / 2, $fn = 100);

        // Innenausschnitt (Maulöffnung)
        translate([0, 0, -1])
          cylinder(h = maul_dicke + 2, r = maul_innen / 2, $fn = 100);

        // Schlitz in Richtung Öffnung
        rotate([0, 0, -135])
        translate([5, -maul_innen/2+0.5, -1])
            cube([maul_innen, maul_innen-3, maul_dicke + 2]);
    }



}

module maulhalter(pos_x) {
        translate([pos_x-maul_dicke, 0, 1])
    color([0,1,0]) 
            cube([maul_dicke, 15, 5+dicke-1]);
      
        translate([pos_x-maul_dicke, 12, 0])
          rotate([45, 0, 0])
            color([1,0,0]) 
            cube([maul_dicke, 15, 11]);
}

module seitliche_begrenzung(pos_x) {
    // Eine 10mm hohe Wand an einer Stirnseite des Winkels
    translate([pos_x, 0, 0])
        cube([dicke, schenkel1, begrenzungshoehe]); // auf Schenkel 1
    translate([pos_x, 0, 0])
        cube([dicke, begrenzungshoehe,schenkel2]); // auf Schenkel 1
}


difference() {
    union() {
        // Schenkel 1 (unten)
        cube([laenge, schenkel1, dicke]);

        // Schenkel 2 (oben)
        translate([0, 0, 0])
            cube([laenge, dicke, schenkel2]);
        
        // Rechte Begrenzung (am Ende)
        seitliche_begrenzung(laenge - dicke);

        // Linke Begrenzung (am Anfang)
        seitliche_begrenzung(0);

        // Maulschlüssel links vorne
        translate([maul_abstand+maul_dicke, maul_aussen/2+11, maul_aussen/2+7])
         rotate([180, 90, 0]) {
            maulschluessel();
         }
         //halter
        maulhalter(maul_abstand+maul_dicke);

        // Zweiter Schlüssel rechts hinten 
      translate([laenge-maul_abstand-maul_dicke,maul_aussen/2+11,maul_aussen/2+7])
        rotate([180, 90, 0])
            maulschluessel();   
         //halter
        maulhalter(laenge-maul_abstand-maul_dicke);
           
      }

    // Einbuchtungen auf Schenkel 2
    for (pos = [abstand_vom_rand, laenge - abstand_vom_rand]) {
        translate([pos, dicke+0.5, schenkel2+radius-einbuchtung_tiefe])
            rotate([90, 0, 0])
                cylinder(h = dicke + 1.2, r = radius, $fn = 100);
    }

}
    

