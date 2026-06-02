// 1. Chemins et URL
url = "https://raw.githubusercontent.com/Leo-KRUTTLI/ACDC-toolbar/refs/heads/main/toolbar/ACDC_toolbar.txt";
dirPlugins = getDirectory("plugins") + "ActionBar" + File.separator;
fileName = "ACDC_toolbar.txt";
fullPath = dirPlugins + fileName;

// 2. TENTATIVE DE MISE À JOUR
// On utilise une petite astuce : on tente le téléchargement
code = File.openUrlAsString(url);

if (startsWith(code, "<Error") || code == "") {
    // ÉCHEC DU TÉLÉCHARGEMENT (Hors-ligne)
    if (File.exists(fullPath)) {
        print("Mode Hors-ligne : Chargement de la version locale.");
    } else {
        exit("Erreur : Première installation impossible sans connexion internet.");
    }
} else {
    // SUCCÈS : On enregistre la nouvelle version sur le disque
    File.saveString(code, fullPath);
}




// 3. LANCEMENT (Dans tous les cas, on lance le fichier qui est sur le disque)
run("Action Bar", "plugins/ActionBar/" + fileName);


// =========================================================================
// SCRIPT AUTORUN : GÉNÉRATEUR DYNAMIQUE DE BOUTON
// =========================================================================

// 1. On récupère la liste de vos macros dans le dossier /macros/
macroDir = getDirectory("macros");
rawlist = getFileList(macroDir);

// 2. On prépare le texte du menu
menuItems = "newArray('Open Macros Folder', '-'";
count = 0;

for (i=0; i<rawlist.length; i++) {
    if (endsWith(rawlist[i], ".ijm")) {
        // On enlève le .ijm pour l'affichage
        name = substring(rawlist[i], 0, lengthOf(rawlist[i])-4);
        menuItems += ", '" + name + "'";
        count++;
    }
}
menuItems += ")";

// 3. On écrit le code du bouton "virtuel" dans un fichier temporaire
tempFile = getDirectory("temp") + "generated_menu.txt";
f = File.open(tempFile);

print(f, "var mCmds = newMenu('My Macros Menu Tool', " + menuItems + ");");
print(f, "macro 'My Macros Menu Tool - C070T0b11MT7b09ctTcb09r' {"); 
print(f, "    cmd = getArgument();");
print(f, "    if (cmd == 'Open Macros Folder') { open(getDirectory('macros')); }");
print(f, "    else if (cmd != '-') { runMacro(getDirectory('macros') + cmd + '.ijm'); }");
print(f, "}");

File.close(f);

// 4. L'ÉTAPPE MAGIQUE : On installe ce bouton directement dans la barre d'outils
run("Install...", "install=[" + tempFile + "]");
