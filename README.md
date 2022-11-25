<img src="./readme/title1.svg"/>

<div align="center">

> Touristy is your place to find new places and connect with travelers from around the world. It is your trips wallet.

**[PROJECT PHILOSOPHY](https://github.com/asmaahamid02/touristy#-project-philosophy) • [WIREFRAMES](https://github.com/asmaahamid02/touristy#-wireframes) • [TECH STACK](https://github.com/asmaahamid02/touristy#-tech-stack) • [IMPLEMENTATION](https://github.com/asmaahamid02/touristy#-impplementation) • [HOW TO RUN?](https://github.com/asmaahamid02/touristy#-how-to-run)**

</div>

<br><br>

<img src="./readme/title2.svg"/>

>Touristy app is a social media application made for travelers to share their memories in different countries, and their trips.
>It is a social network that connects different people with different nationalities to meet, post, talk, and share interesting experiences.

### User Stories

- As a user, I want to browse posts, so that I can find new places to visit
- As a user, I want to create posts and comments, so that I can share my experiences
- As a user, I want to add new trip, so that I can find company and save my activities
- As a user, I want to start chat with other users, so that I can make friends
- As a user, I want to follow other users, so that I can see their activities
- As a user , I want to browse a map, so that I can see the users' activities locations

<br><br>

<img src="./readme/title3.svg"/>

> This design was planned before on paper, then moved to Figma app for the fine details.
> Note that i didn't use any styling library or theme, all from scratch and using pure css modules and flutter widgets styling

# Wireframes

| Landing | Signup | Homepage | Profile | Edit Profile | 
| ----------------------------------------- | ----------------------------------------- | ----------------------------------------- |  ----------------------------------------- | ----------------------------------------- |
| <img src='./readme/wireframes/landing.png' /> | <img src='./readme/wireframes/signup.png' /> | <img src='./readme/wireframes/homepage.png' /> | <img src='./readme/wireframes/profile.png' /> | <img src='./readme/wireframes/edit_profile.png' /> | 


# Mockups

| Landing | Signup | Homepage | Add Post | 
| ----------------------------------------- | ----------------------------------------- | ----------------------------------------- |  ----------------------------------------- | 
| <img src='./readme/mockups/landing.png' /> | <img src='./readme/mockups/signup.png' /> | <img src='./readme/mockups/homepage.png' /> | <img src='./readme/mockups/add_post.png' /> | 

| Profile | Edit Profile | Chat | Explore | 
| -----------------------------------------| -----------------------------------------| -----------------------------------------|  -----------------------------------------| 
<img src='./readme/mockups/profile.png' /> | <img src='./readme/mockups/edit_profile.png' /> | <img src='./readme/mockups/chat.png' /> | <img src='./readme/mockups/explore.png' /> |

# Prototypes

| Stories | New Post | Chat | Explore | Profile |
| -----------------------------------------| -----------------------------------------| -----------------------------------------|  -----------------------------------------|-----------------------------------------|
<img src='./readme/prototypes/homepage.gif' /> | <img src='./readme/prototypes/post.gif' /> | <img src='./readme/prototypes/chat.gif' /> | <img src='./readme/prototypes/explore.gif' /> | <img src='./readme/prototypes/profile.gif' /> |

<br><br>

<img src="./readme/title4.svg"/>


**IMPORTANT** - This application runs on **ANDROID** devices **ONLY** and was **NEVER** tested on IOS devices

Here's a brief high-level overview of the tech stack the Well app uses:
- This project uses the [Flutter app development framework](https://flutter.dev/). Flutter is a cross-platform hybrid app development platform which allows us to use a single codebase for apps on mobile, desktop, and the web.
- For creating the APIs, the app users [Laravel framework](https://laravel.com/). Laravel is an open-source PHP web framework, created by Taylor Otwell and intended for the development of web applications following the model–view–controller architectural pattern.
- For database, the app uses the [MySQL](https://www.mysql.com/) database.
- For the live chat, the app uses [cloud_firestore](https://pub.dev/packages/cloud_firestore) plugin to use [Cloud Firestore API](https://firebase.google.com/docs/firestore/) which is a flexible, scalable database for mobile, web, and server development from Firebase and Google Cloud.
- The app uses the font [Mullish](https://fonts.google.com/specimen/Mulish) as its main font for light theme, and font [Inter](https://fonts.google.com/specimen/Inter) for dark theme, and the design of the app adheres to the material design guidelines.
- Packages used in the app:
  - [intel](https://pub.dev/packages/intl) for date formatting.
  - [image_picker](https://pub.dev/packages/image_picker) for selecting media from the device camera or storage.
  - [video_player](https://pub.dev/packages/video_player) for playing back video on a Widget surface.
  - [permission_handler](https://pub.dev/packages/permission_handler) for checking user's permissions given to the app.
  - [flag](https://pub.dev/packages/flag) to get the flag icon of a country from its code
  - [provider](https://pub.dev/packages/provider) for state management and reusability.
  - [http](https://pub.dev/packages/http) for HTTP requests
  - [shared_preferences](https://pub.dev/packages/shared_preferences) as persistent storage for simple data.
  - [timago](https://pub.dev/packages/timeago) for converting date into a humanized text.
  - [cached_network_image](https://pub.dev/packages/cached_network_image) to show images from the internet and keep them in the cache directory.
  - [google_fonts](https://pub.dev/packages/google_fonts)
    to use fonts from [Google Fonts](https://fonts.google.com/)
  - [fluttertoast](https://pub.dev/packages/fluttertoast) to display toast messages without BuildContext.
  - [collection](https://pub.dev/packages/collection) to work with collections and grouping data.
  - [geolocator](https://pub.dev/packages/geolocator) to get the current position of the user.
  - [geocoding](https://pub.dev/packages/geocoding) to convert longitude and latitude to a human readable address.
    - Your device should support a connection with Google Play Services.
  - [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) to use GoogleMap Widget.
  - [date_time_picker](https://pub.dev/packages/date_time_picker) to use DateTimePicker Widget.
  - [uuid](https://pub.dev/packages/uuid) to generate session token for autocomplete API.
  - [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) to load environment variables from .env file.
  - [custom_map_markers](https://pub.dev/packages/custom_map_markers) to use custom markers on the map.

<br><br>
<img src="./readme/title5.svg"/>

> Using the above mentioned tech stacks and the wireframes build with figma from the user sotries we have, the implementation of the app is shown as below, these are screenshots from the real app

>Note: Some of the screenshots are from the dark theme, and some are from the light theme, the app has both themes

>Note: The design of Figma is been modified a bit during implementation, so some screenshots/videos may differ


| Landing | Signup | Homepage | Profile | Edit Profile | 
| ----------------------------------------- | ----------------------------------------- | ----------------------------------------- |  ----------------------------------------- | ----------------------------------------- |
|<img src="./readme/implementation/signup.PNG"/>|<img src="./readme/implementation/signup.PNG"/>|<img src="./readme/implementation/homepage.PNG"/>|<img src="./readme/implementation/profile.PNG"/>|<img src="./readme/implementation/edit_profile.PNG"/>|

|  |  |  |  |
| ----------------------------------------- | ----------------------------------------- |----------------------------------------- | ----------------------------------------- |  
|<img src="./readme/implementation/search_map.gif"/>|<img src="./readme/implementation/dark_mode.gif"/>|<img src="./readme/implementation/chat.gif"/>|<img src="./readme/implementation/explore.gif"/>|
|<img src="./readme/implementation/delete_trip.gif"/>|<img src="./readme/implementation/map.gif"/>|<img src="./readme/implementation/autocomplete.gif"/>|<img src="./readme/implementation/homepage.gif"/>|

<br><br>
<img src="./readme/title6.svg"/>

> Follow the below steps in order to run the application and use it.

### Prerequisites

1. You need to install Flutter in order to be able to run this app.
   - Follow the steps listed here - [Flutter Install](https://docs.flutter.dev/get-started/install)
   - *Setup an Emulator/Use Phone that supports Google Play Services*
2. PHP v7+   
2. Intall XAMPP for installing PHP and creating the database from here - [XAMPP install](https://www.apachefriends.org/download.html)   
3. Install Composer for PHP dependencies from here - [Composer Install](https://getcomposer.org/)
4. Determine your ip address for running the server
   - Open command line
   - type this command
     ```sh
     ipconfig
     ``` 
   - copy the ipv4 address and save it 😉
   - If you are using a real device, get more info from the accepted answer here: [Access localhost from android device](https://stackoverflow.com/questions/4779963/how-can-i-access-my-localhost-from-my-android-device) 

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/asmaahamid02/touristy.git
   ```
2. Create database in **phpmyadmin** named **touristydb**
   - You need to Start Apache and MySQL in XAMPP Control panel
   - Then go to http://localhost/phpmyadmin

3. Navigate to server folder   
   ```sh
   cd touristy_backend
   ```
4. Install dependencies
   ```sh
   composer install 
   ```
5. Rename **.env.example** to **.env**

6. Add database configuration inside **.env**
   * DB_DATABASE=touristydb
   * DB_USERNAME=*Your_Username*
   * DB_PASSWORD=*Your_Password*

7. Run migrations and seeders
   ```sh
   php artisan migrate --seed 
   ```
8. Run server
   ```sh
   php artisan serve --host=YOUR_IP_ADDRESS
   ```
9. Open touristy_frontend folder
10. Rename **.env-example** to **.env** in assets folder
11. Add your **Google Api Key** inside .env file
    - You can get the key from here: [Get Google API Key](https://developers.google.com/maps/documentation/javascript/get-api-key)
12. Replace the *GOOGLE_API_KEY* inside **touristy_frontend/android/app/src/main/AndroidManifest.xml** file with your key 
    - At this line: *android:value="GOOGLE_API_KEY"*
13. Add your host_url and port number inside .env file
14. Back to the cmd, navigate to app folder   
    ```sh
    cd touristy_frontend
    ```    
15. Get packages
    ```sh
    flutter pub get
    ```
16. Run the app
     ```sh
     flutter run
     ```
17. Gongratulations 🎉 You are now using **TOURISTY** ✈️
    - Start the journey by creating a new account ...
