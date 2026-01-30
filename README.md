# Wrench - Smart Vehicle Maintenance & Mileage Tracker

**Wrench** is a comprehensive Flutter application designed to help vehicle owners track maintenance history, monitor fuel efficiency, and estimate trip costs.

---

## About The Project

One of my friends approached me with a common problem: his vehicle maintenance logs were a mess. He was losing track of when he last changed his oil, replaced his brake pads, or serviced his engine. He asked for a simple app to store this list.

I realized that a digital logbook could be so much more. Instead of just "storing" data, the app could "use" that data to help him daily. 

I expanded the scope to include:
* **Mileage Tracking:** To monitor vehicle health via fuel efficiency.
* **Analytics:** Visual graphs to see trends over time.
* **Trip Calculator:** A smart tool that uses his real historical data to predict the cost of future trips.

## Key Features

### Service Management
* **Timeline View:** A clean, vertical timeline of all past service sessions.
* **Task Checklist:** detailed breakdown of tasks (e.g., Oil Change, Filter Replacement) for each session.
* **Search & Filter:** Instantly find specific maintenance records (e.g., search "Battery" to see when it was last replaced).
* **Custom Dates:** Record maintenance logs for past dates, not just today.

### Mileage & Fuel Economy
* **Efficiency Tracking:** Automatically calculates mileage (km/L) for every refill.
* **Visual Graphs:** Interactive charts showing mileage trends over time.
* **Monthly Averages:** View your average performance month-by-month.
* **Best Mileage:** Highlights your all-time best fuel efficiency record.

### Smart Utilities
* **Trip Cost Calculator:** Estimates the fuel cost for any trip distance based on your vehicle's *actual* historical average mileage.
* **Dark Mode:** Fully supported dark theme for better visibility at night.
* **Offline First:** All data is stored locally using Hive, ensuring privacy and instant access without internet.

---

## Video



https://github.com/user-attachments/assets/cbaca467-3397-4b10-a80a-b3db49251d13


---

## Tech Stack

This project is built using the **Flutter** ecosystem.

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **State Management:** [Provider](https://pub.dev/packages/provider)
* **Local Database:** [Hive](https://pub.dev/packages/hive)
* **Charting:** [Fl_Chart](https://pub.dev/packages/fl_chart)
* **UI Components:** 
    * `animated_notch_bottom_bar` for smooth navigation.
    * `timeline_tile` for the history view.
    * `intl` for date formatting.

---

## Getting Started

To run this project locally, follow these steps:

### Prerequisites
* Flutter SDK installed ([Guide](https://docs.flutter.dev/get-started/install))
* Android Studio or VS Code

### Installation

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/Ajallen14/Wrench](https://github.com/Ajallen14/Wrench)
    cd wrench
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the App**
    ```bash
    flutter run
    ```

4.  **Build APK (Optional)**
    ```bash
    flutter build apk --release
    ```

---
