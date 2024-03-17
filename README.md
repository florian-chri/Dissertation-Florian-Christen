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

Um die Resultate in Form der Plots nachzustellen können die CSV-Dateien, welche die tabellarische Grundlage für die Plots enthalten, verwendet werden.

## Results

Tabellarische Repräsentation der Ergebnisse:
![ResultTable](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/ef3a0b85-2365-4849-9286-ed82a080a7c0)

MAPE nach ansteigendem Filtergrad des Kalman Filters:

![MAPEKalmanMAFC](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/7722c94c-1916-4a37-b6f8-d007ee591468)
![MAPEKalmanESFC](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/e3ea2dc2-1ebe-440e-8bfa-64f73a56bbb1)

MAPE nach ansteigendem Filtergrad des SES Filters:

![SESFilterSESFC](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/03a7d59c-5401-4cea-aaef-f4c215dbc35b)
![SESFilterMAFC](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/4fb17053-8140-4868-a32f-794493c1da84)

MAPE nach ansteigendem Filtergrad des MA Filters:

![MAFilterMAFC](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/036bcef8-44cd-414a-a96c-f9a9a0646c8c)
![MAFilter ESFC](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/ea2c2979-469b-4e7c-ad40-b44c4e2da169)

Zusätzlich dazu die Forecasts der optimalen Filtergrade im Vergleich zur Testreihe:

Kalman Filter:
![KalmanOptvsReal](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/330cd415-2c6f-41db-a0cf-898ae2a94548)

Moving Average Filter:
![MAoptvsReal](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/900d088c-d63a-4301-b3ef-6d8b6fea2929)

Exponential Smoothing Filter:
![SEoptvsReal](https://github.com/florian-chri/Dissertation-Florian-Christen/assets/163172948/4825dea2-dcca-4768-9820-ad6ca0c796ec)
## Project structure

Alle .R Files der Filtertypen sind mit dem Ziel aufgebaut unabhängig zu funktionieren.
Vorgeschlagene Struktur:

Kalman Filter 2.R,
Moving average Filter.R.
Simple exponential smoother.R.
