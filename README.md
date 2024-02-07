# masam_flutter_task



This is a Flutter application for fetching and displaying weather data using the OpenWeatherMap API.

## Getting Started
## project structure
1.I am using code structure MVC in my weather apllictaion.

2.Create a seperate file for seperate code for implement clean architecture.

3.Getx statemenagement in my project(solution provider). 

To get started with this project, follow these steps:

1. Clone the repository to your local machine:

    ```bash
   https://github.com/MasamRehman/masam_test_task.git
    ```

2. Navigate into the project directory:

    ```bash
    cd weather_app
    ```

3. Install dependencies using Flutter:

    ```bash
    flutter pub get
    ```

4. Obtain an API key from OpenWeatherMap by signing up on their website: [OpenWeatherMap API](https://openweathermap.org/api).

5. Add your API key to the project:
   - Open the file `lib/controller/weathercntroller.dart/`.
   - Replace `fc8d7048351e691809fdc416f294b8cc` with your actual API key in the `fetchWeatherData` function.

## Running the App

To run the app on an emulator or physical device, use the following command:

```bash
flutter run

