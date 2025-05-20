A flutter project for the partial fulfillment of the requirements of the Bachelor's in Computer Engineering (Tribhuwan University) course.

This repo includes the finalized models developed to identify common plant dieseases found in Nepal which are used on device to detect plant diseases.


## 📱 Project Summary

The app detects and classifies plant diseases using on-device machine learning models. The application enables users (especially farmers in Nepal) to identify common plant diseases by uploading or capturing an image of a leaf. The app works **completely offline for disease detection**, utilizing trained CNN models (EfficientNetB0, EfficientNetB1, ResNet50). The community and post features require internet.

---

## 🧠 Key Features

- ✅ **Offline plant disease detection**
- 📸 Capture or upload a plant image
- 🇳🇵 Built for diseases common in Nepal
- 📲 Developed using **Flutter SDK**
- 🧪 Data-driven using CNN architectures: EfficientNet, ResNet, MobileNet
- 🌐 Community feature with **MongoDB Atlas** backend

---

## 🗂 Dataset

- 📁 Source: [Plant Diseases with Augmented Images (Kaggle)](https://www.kaggle.com/datasets/mshrestha/plant-disease-augmented-dataset)
- 📌 Classes: 33 different plant diseases including those found in **apple, banana, corn, tomato, potato, rice, tea, strawberry, and bell pepper**
- 🖼 Total Samples: ~1.4 million images

---

## 🔬 Model Performance

| Model            | Accuracy | Precision | Recall | F1-Score |
|------------------|----------|-----------|--------|----------|
| ResNet50         | 95.60%   | 95.51%    | 95.27% | 95.29%   |
| EfficientNetB0   | 95.34%   | 95.24%    | 94.88% | 95.01%   |
| EfficientNetB1   | 95.07%   | 95.05%    | 94.67% | 94.79%   |
| EfficientNetB3   | 90.86%   | 90.76%    | 90.25% | 90.38%   |
| MobileNetV2      | 68.28%   | 71.58%    | 67.92% | 68.18%   |

🔗 Final predictions are selected using **hard voting** among top 3 models (ResNet50, EfficientNetB0, EfficientNetB1).

---

## 🛠 Technologies Used

- 🧠 **TensorFlow / Keras** – model training
- 📊 **Google Colab** – training environment
- 📱 **Flutter** – mobile app development
- ☁️ **MongoDB Atlas** – cloud database for posts, users, comments
- 🖼 **Figma** – UI design mockups
- 🧪 **tflite_flutter**, `image_picker` – Flutter packages for inference and input

---

## 🧪 Usage Instructions

**Clone the repository**
   ```bash
   git clone https://github.com/shr-gitt/Plant-disease-detection.git
   cd Plant-disease-detection
