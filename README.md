# GitRepoSearch
Assignment project for the implementation of consuming rest APIs in iOS Swift. It's an application that uses github apis to get repos details. You can search repo based on language and topic.
## How to run project
This project was developed on **Xcode 12.2** using **Swift 5** . Please run **pod install** after cloning the repo and checking out to master for running the project.

## Project Overview
It's an application that let user query public github repositories based on language and topic. User can also view the details by tapping the repository. Every Single request is **paginated** and show **10** repositories in a single call after which user must have to scroll to the very end to **load more** for viewwing further repositories. It's build on the **MVVM** architecture and and every module's interactor and presenter are unit tested.

## Pods used
- MBProgressHUD - To show the Loader
- Kingfisher - To download and display the owner images asynchronously
- ReachabilitySwift - To check the internet connection

## Shortcuts used
- Aforementioned Pods are used to display the images and to show the loader


## How to run the tests
-Once opened the application in Xcode(12+),
    -Go to Products -> Test or press command+U
    
## Application Flow
- On home screen, search bar is provided for the user to enter language or topic to search repos on Github. 
- Debounce search have been implemented to avoid calling api so many times unnecessaryly even when user is typing. Server request will be done only when user stops typing for atleast 1 second.

- On click of any tile, Detail View is presented, which will display the language, name, and Github url for the selected Repo.
- on click of the URL, it will open up a SafariView within the app to load the specific Github URL.
- Pagination is done on scroll, and at a time 10 results are loaded. At the end of the screen, when user continues to scroll, another page is requested from the API.
-Admin button on the top right corner displays the recent searches in the app and the results for those searches. NOTE: ADMIN screen is what user has already searched.
- you can also preview the Owner image in detail screen.

## App Architecture
This app is developed in MVVM
URLSession is used to communicate with the server
Storyboards are used for the UI with Autolayout.


Generate a report based on searches requirement was not very clear so Admin screen is developed to view the recent searches.

In case of any query feel free to contact @ sohail.tabish2@gmail.com

