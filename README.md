# HomePilot

HomePilot est un gestionnaire de tâches pour le quotidien d’un foyer.

L’objectif est de proposer une application simple, lisible et prête à être présentée comme projet de vitrine GitHub : tâches domestiques, suivi des actions, filtres, et structure maintenable.

## Fonctionnalités

- Vue d’ensemble des tâches du foyer
- Liste de tâches avec statut terminé / non terminé
- Filtres : Tous, À faire, Terminées
- Ajout rapide d’une nouvelle tâche
- Suppression d’une tâche
- Statistiques visuelles : total, à faire, terminé
- Thème Material 3 moderne et propre

## Stack technique

- Flutter
- Dart
- Material 3
- Tests widget
- Analyse statique Flutter

## Structure du projet

```text
lib/
  core/
    theme/
      app_theme.dart
  features/
    home/
      models/
        task.dart
      presentation/
        home_page.dart
  main.dart

test/
  widget_test.dart
```

## Prérequis

- Flutter SDK 3.47.7 ou version compatible
- Android Studio / VS Code
- Émulateur ou appareil connecté

## Installation

```bash
flutter pub get
flutter run
```

## Vérifications

```bash
flutter analyze
flutter test
```

## Bonnes pratiques mises en place

- séparation des responsabilités dans les dossiers
- thème centralisé
- code lisible et maintenable
- tests de base pour les principaux parcours utilisateurs
- workflow CI avec analyse + tests sur GitHub Actions
- documentation de contribution

## Roadmap

- sauvegarde locale des tâches
- gestion des priorités
- tâches par pièce / par membre du foyer
- rappels et planning hebdomadaire
- synchronisation possible plus tard

## Contribution

Consultez [CONTRIBUTING.md](CONTRIBUTING.md) pour les conventions et la procédure de contribution.
