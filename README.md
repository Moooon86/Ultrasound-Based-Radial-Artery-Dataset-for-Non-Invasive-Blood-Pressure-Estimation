# Ultrasound-Based-Radial-Artery-Dataset-for-Non-Invasive-Blood-Pressure-Estimation
> **Overview:** This project provides a testing demo designed to facilitate the validation and reproduction of experimental results. The repository primarily contains a clinical dataset, corresponding test scripts and the trained model weights, serving as a practical reference for researchers and developers working in related fields. The dataset comprises ultrasound and invasive blood pressure (IBP) data collected from 90 patients in the cardiac surgery ICU. The data has been categorized according to the blood pressure classification standards of the European Society of Cardiology (ESC) and the European Society of Hypertension (ESH).

## Dataset Overview

This dataset was collected from the cardiac surgery Intensive Care Unit (ICU) of a tertiary-level hospital. The subjects were patients undergoing radial artery puncture, comprising data from **90 distinct patients**.

For each patient, data acquisition was performed on five separate occasions. The collected data includes both ultrasound imaging and invasive blood pressure (IBP) readings.

The blood pressure data has been categorized according to the classification standards of the European Society of Cardiology (ESC) and the European Society of Hypertension (ESH).

**Blood Pressure Data Distribution:**

| Metric | Category | Percentage |
| :--- | :--- | :--- |
| **Systolic BP (SBP)** | Hypertension | 36.84% |
| | Hypotension | 0.24% |
| **Diastolic BP (DBP)** | Hypertension | 3.49% |
| | Hypotension | 25.80% |

---

## File Format and Description

The data file is a MATLAB structure array (`Dirlist.mat`) containing the following four fields:

| Field Name | Type | Description |
| :--- | :--- | :--- |
| **name** | String | Acquisition timestamp and patient identifier. |
| **cbp** | Numeric Array | Reference continuous blood pressure waveform used for evaluating the performance of continuous BP estimation. Derived from arterial diameter pulse waves. |
| **input** | Numeric Matrix | Model input features for blood pressure estimation. Each column contains:<br>- Systolic blood pressure (SBP) of the first segment of the pulse wave<br>- Diastolic blood pressure (DBP) of the first segment of the pulse wave<br>- Maximum diameter of the first segment of the pulse wave<br>- Minimum diameter of the first segment of the pulse wave<br>- Maximum diameter of the current pulse wave<br>- Minimum diameter of the current pulse wave |
| **output** | Numeric Array | Model output targets. Each entry contains:<br>- Systolic Blood Pressure (SBP)<br>- Diastolic Blood Pressure (DBP) |

---

## Repository Content

- **`Dirlist/`**: Contains the `.mat` data files for testing.
- **`net_weight/`**: Contains the trained model weight files.
- **`MLP_for_BP_prediction/`**: Contains the test script.
---

## License

This project is for academic research purposes only.
