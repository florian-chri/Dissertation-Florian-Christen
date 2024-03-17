# Der Einfluss von Zeitreihenglättungsalgorithmen auf Forecastingergebnisse anhand des Kalman-Filters
##
The influence of time series smoothing on forecasting performance using a Kalman filter



**Type:** Bachelor's Thesis

**Author:** Florian Christen

**Supervisor:** xxx (only if different from the 1st or the 2nd Examiner)

**1st Examiner:** Prof. Dr. Lessmann    

**2nd Examiner:** Prof. Dr. Fabian


## Table of Content

- [Summary](#summary)
- [Working with the repo](#Working-with-the-repo)
    - [Dependencies](#Dependencies)
    - [Setup](#Setup)
- [Reproducing results](#Reproducing-results)
    - [Training code](#Training-code)
    - [Evaluation code](#Evaluation-code)
    - [Pretrained models](#Pretrained-models)
- [Results](#Results)
- [Project structure](-Project-structure)

## Summary

Der Code in diesem Reposirotry hat das Ziel zu untersuchen, wie sich ein voriges Filtern von Daten auf die Modellperformance auswirkt. Untersucht wurde dabei der Kalman Filter, ein Simple Exponential Smoothing Filter und eine Moving Average Filter. Als Forecastingmethoden wurde Moving Average Forecasting und Forecasting mittels Simpler Exponentieller Glättung verwendet.
Als Datensatz diente ein aufbereiteter Hotel-PMS Export, welcher aus Datenschutzgründen nicht zur Verfügung gestellt werden kann. Die verwendete Performancemetrik ist MAPE.

**Keywords**: Kalman Filter, MA-Filter, SES-Filter, Forecasting, Time Series Models

**Full text**: [include a link that points to the full text of your thesis]
*Remark*: a thesis is about research. We believe in the [open science](https://en.wikipedia.org/wiki/Open_science) paradigm. Research results should be available to the public. Therefore, we expect dissertations to be shared publicly. Preferably, you publish your thesis via the [edoc-server of the Humboldt-Universität zu Berlin](https://edoc-info.hu-berlin.de/de/publizieren/andere). However, other sharing options, which ensure permanent availability, are also possible. <br> Exceptions from the default to share the full text of a thesis require the approval of the thesis supervisor.  

## Working with the repo

Alle Analysen sind aufgeteilt auf die Filtermethode in drei .R files aufgeteilt. Damit alle .R files unabhängig voneinander funktionieren wurden die Bestandteile für das Laden und vorbereiten der Daten in allen Files aufgeführt.
Die vorgeschlagene Anwendung hängt von dem unterliegenden Ziel ab. Sollte das Ziel im Testen der Filtermethode liegen ist die Empfehlung die benötigten bestandteile (Filter Methode und Loop zur Erstellung der gefilterten Dataframes) dafür zu kopieren und anzupassen.
Liegt das Ziel darin andere Forecastingmethoden zu verwenden kann die Grundstruktur der Forecasting-loops verwendet werden.

### Dependencies

Alle Analysen wurden mit der R-Version 4.3.2 durchgeführt. Verwendete Packages sind in den Code-Files aufgeführt.
Da keine Rohdaten mit zur Verfügung gestellt werden ist der erste Schritt die Datenaufbereitung durchzuführen. Dazu muss das entsprehende Einlesen der Daten und alle damit verbundenen Aufgaben im Sinne des Pre-Processing durchgeführt werden. Darunter zählen das aufteilen in einen Trainings und Testdatensatz, und das aufsetzen der Datenreihen als Zeitreihe. Der eingereichte Programmcode kann für diese Schritte als Leitfaden dienen.

## Reproducing results

Um die Resultate in Form der Plots nachzustellen können die CSV-Dateien welche die tabellarische Grundlage für die Plots enthalten verwendet werden.

## Results
![Image](images/MAFilterESFC.png)

Vergleich der MAPE der ungeglätteten Zeitreihe mit der MAPE im Optimum.

	                           

Die graphischen Repräsentationen der MAPE sind im Repository enthalten.

## Project structure
