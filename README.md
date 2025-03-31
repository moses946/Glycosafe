# GlycoSafe

## Introduction
Diabetes management requires careful monitoring of food intake, especially the glycemic load of meals, which directly impacts blood sugar levels. However, most individuals, particularly those in low-resource settings, struggle to manually estimate the glycemic load of their meals. Traditional methods involve referencing food databases, weighing portions, and performing manual calculations, which can be time-consuming and prone to inaccuracies.

Additionally, current dietary assessment tools often rely on subjective user input, leading to potential errors and inconsistencies. There is a need for an automated, image-assisted approach to simplify this process and provide reliable glycemic load estimates.

## The Solution
GlycoSafe is an AI-powered mobile application that estimates the glycemic load of meals using image recognition. Users simply capture a photo of their meal, and the system processes the image to identify food items, estimate portion sizes, and calculate the corresponding glycemic load.

### Key Features:
- **Image-Based Food Recognition**: Uses machine learning models to analyze food images and detect meal components.
- **Glycemic Load Calculation**: Automatically computes the glycemic load based on recognized food items and portion sizes.
- **Nutritional Insights**: Provides a detailed breakdown of macronutrients and dietary recommendations.
- **User-Friendly Interface**: Enables diabetic patients and health-conscious individuals to monitor their diet effortlessly.
- **Integration with Health Tools**: Allows users to log meals, track historical data, and receive personalized insights for better diabetes management.

## Technologies Used
### Frontend:
- **Flutter** - For building a cross-platform mobile application.
- **Dart** - The programming language used for the frontend.
- **Firebase** - For user authentication and real-time database management.

### Backend:
- **Django** - A high-performance web framework for processing meal images.
- **Python** - Used for backend logic and AI model implementation.
- **Pytorch/Tensorflow** - For training and deploying deep learning models for food recognition.
- **NoSQL database** - For storing food data and user logs.
- **Docker** - For containerizing the backend services.

### AI & Image Processing:
- **OpenCV** - For image preprocessing and analysis.
- **YOLO/ResNet** - For food recognition and classification.
- **NVIDIA Hardware** - Used during the prototype development phase for model training.

### DevOps & Deployment:
- **GitHub Actions** - For CI/CD automation.
- **Microsoft Azure** - For cloud hosting and scalable backend deployment.
- **GitHub Pages** - For project documentation and web-based details.

---
### Contributing
If you’d like to contribute to GlycoSafe, please follow the contribution guidelines in [CONTRIBUTING.md](CONTRIBUTING.md).

### License
GlycoSafe is released under the MIT License. See [LICENSE](LICENSE) for details.

For more information, visit the **[Glycosafe Website](https://glycosafe.jhubafrica.com)**.

