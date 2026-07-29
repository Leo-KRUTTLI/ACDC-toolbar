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
    showStatus("ACDC toolbar updated!");
}




// 3. LANCEMENT (Dans tous les cas, on lance le fichier qui est sur le disque)
run("Action Bar", "plugins/ActionBar/" + fileName);
