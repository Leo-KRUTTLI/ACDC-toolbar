// =========================================================================
// AUTORUN : CHARGEMENT & MISE À JOUR DYNAMIQUE DE LA BARRE ACDC
// =========================================================================

// 1. Chemins et URL
url = "https://raw.githubusercontent.com/Leo-KRUTTLI/ACDC-toolbar/refs/heads/main/toolbar/MACRO_toolbar.txt";
dirAutoRun = getDirectory("macros") + "toolsets" + File.separator;
fileName = "MACRO_toolbar.ijm";
fullPath = dirAutoRun + fileName;

// Création du dossier AutoRun s'il n'existe pas encore
if (!File.exists(dirAutoRun)) {
    File.makeDirectory(dirAutoRun);
}

// 2. TENTATIVE DE MISE À JOUR
code = File.openUrlAsString(url);

if (startsWith(code, "<Error") || code == "" || startsWith(code, "404")) {
    // ÉCHEC DU TÉLÉCHARGEMENT (Hors-ligne)
    if (File.exists(fullPath)) {
        print("Mode Hors-ligne : Chargement de la version locale.");
        code = File.openAsString(fullPath);
    } else {
        exit("Erreur : Première installation impossible sans connexion internet.");
    }
} else {
    // SUCCÈS : Enregistrement sur le disque
    File.saveString(code, fullPath);
    showStatus("MACRO toolbar updated!");
}

// 3. ÉXÉCUTION DANS LE CONTEXTE GLOBAL
// eval() permet d'exécuter le code distant DANS l'AutoRun direct,
// ce qui rend la commande run("Install...", ...) fonctionnelle !
eval(code);
