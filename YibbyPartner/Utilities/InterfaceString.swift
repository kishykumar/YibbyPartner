//
//  InterfaceString.swift
//  Yibby
//
//  Created by Kishy Kumar on 6/29/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import Foundation

public struct InterfaceString {
    
    public struct StoryboardName {
        static let Main = NSLocalizedString("Main", comment: "Main Storyboard")
        static let About = NSLocalizedString("About", comment: "About Storyboard")
        static let Settings = NSLocalizedString("Settings", comment: "Settings Storyboard")
        static let Notifications = NSLocalizedString("Notifications", comment: "Notifications Storyboard")
        static let App = NSLocalizedString("App", comment: "App Storyboard")
        static let Destination = NSLocalizedString("Destination", comment: "Destination Storyboard")
        static let Login = NSLocalizedString("Login", comment: "Login Storyboard")
        static let SignUp = NSLocalizedString("SignUp", comment: "SignUp Storyboard")
        static let Drawer = NSLocalizedString("Drawer", comment: "Drawer Storyboard")
        static let DriverEnRoute = NSLocalizedString("DriverEnRoute", comment: "DriverEnRoute Storyboard")
        static let Help = NSLocalizedString("Help", comment: "Help Storyboard")
        static let History = NSLocalizedString("History", comment: "History Storyboard")
        static let Online = NSLocalizedString("Online", comment: "Online Storyboard")
        static let Rewards = NSLocalizedString("Rewards", comment: "Rewards Storyboard")
        static let Ride = NSLocalizedString("Ride", comment: "Ride Storyboard")
        static let Register = NSLocalizedString("Register", comment: "Register Storyboard")
        static let Offer = NSLocalizedString("Offer", comment: "Offer Storyboard")
        static let Earnings = NSLocalizedString("Earnings", comment: "Earnings Storyboard")
        static let Documents = NSLocalizedString("Documents", comment: "Documents Storyboard")

    }
    
    public struct EmptyDataMsg {
        static let NotRiddenYetTitle = NSLocalizedString("Bummer! No rides.", comment: "NotRiddenYet Title")
        static let NotRiddenYetDescription = NSLocalizedString("Save money by driving with Yibby.", comment: "NotRiddenYet Description")
        
    }
    
    public struct ActivityIndicator {
        static let Loading = NSLocalizedString("Loading...", comment: "Loading...")
    }
    
    public struct SignOut {
        static let SignOut = NSLocalizedString("Sign Out", comment: "SignOut")
        static let ConfirmSignOutTitle = NSLocalizedString("Are you sure", comment: "Are you sure?")
        static let ConfirmSignOutMessage = NSLocalizedString("You want to sign out?", comment: "You want to sign out?")
    }
    
    public struct Button {
        static let TANDC = NSLocalizedString("TERMS OF SERVICE AND PRIVACY POLICY", comment: "TANDC")
    }
    
    public struct Ride {
        static let Pickup = NSLocalizedString("Pickup", comment: "Pickup")
        static let Dropoff = NSLocalizedString("Dropoff", comment: "Dropoff")
        static let Driver = NSLocalizedString("Driver", comment: "Driver")
        static let ArrivedAtPickup = NSLocalizedString("Arrived at Pickup", comment: "ArrivedAtPickup")
        static let StartRide = NSLocalizedString("Start Ride", comment: "StartRide")
        static let EndRide = NSLocalizedString("End Ride", comment: "EndRide")
    }
    
    
    public struct Upload {
        static let License = NSLocalizedString("Upload License", comment: "Upload License")
        static let Insurance = NSLocalizedString("Upload Insurance", comment: "Upload Insurance")
        static let ProfilePicture = NSLocalizedString("Upload Profile Picture", comment: "Upload Profile Picture")
        static let VehicleInspectionForm = NSLocalizedString("Upload Vehicle Inspection Form", comment: "Upload Vehicle Inspection Form")
    }
    
    public struct ActionSheet {
        static let VehicleYear = NSLocalizedString("Vehicle Year", comment: "Vehicle Year")
        static let VehicleMake = NSLocalizedString("Vehicle Make", comment: "Vehicle Make")
        static let VehicleModel = NSLocalizedString("Vehicle Model", comment: "Vehicle Model")
        static let VehicleColor = NSLocalizedString("Vehicle Color", comment: "Vehicle Color")
        static let VehicleCapacity = NSLocalizedString("Vehicle Capacity", comment: "Vehicle Capacity")
        
        static let DriverLicenseState = NSLocalizedString("Driver License State", comment: "Driver License State")
        static let LicenseExpirationDate = NSLocalizedString("License Expiration Date", comment: "License Expiration Date")
        static let BirthDate = NSLocalizedString("Birth Date", comment: "Birth Date")
        
        static let AddressState = NSLocalizedString("Address State", comment: "Address State")

        static let InsuranceState = NSLocalizedString("Insurance State", comment: "Insurance State")
        static let InsuranceExpirationDate = NSLocalizedString("Insurance Expiration Date", comment: "Insurance Expiration Date")
    }
    
    public struct TableSections {
        static let Trips = NSLocalizedString("Trips", comment: "Trips")
    }
    
    public struct Notifications {
        static let Title = NSLocalizedString("Notifications", comment: "Notifications title")
        static let Reply = NSLocalizedString("Reply", comment: "Reply button title")
        static let NoResultsTitle = NSLocalizedString("Welcome to your Notifications Center!", comment: "No notification results title")
        static let NoResultsBody = NSLocalizedString("Whenever someone mentions you, follows you, accepts an invitation, comments, reposts or Loves one of your posts, you'll be notified here.", comment: "No notification results body.")
    }
    
    public struct Search {
        static let Title = NSLocalizedString("Search", comment: "Search title")
        static let Prompt = NSLocalizedString("Search Ello", comment: "search ello prompt")
        static let Posts = NSLocalizedString("Posts", comment: "Posts search toggle")
        static let People = NSLocalizedString("People", comment: "People search toggle")
        static let FindFriendsPrompt = NSLocalizedString("Help grow the Ello community.\nShare the experience.", comment: "Search zero state button title")
        static let NoMatches = NSLocalizedString("We couldn't find any matches.", comment: "No search results found title")
        static let TryAgain = NSLocalizedString("Try another search?", comment: "No search results found body")
    }
    
    public struct Drawer {
        static let Store = NSLocalizedString("Store", comment: "Store")
        static let Invite = NSLocalizedString("Invite", comment: "Invite")
        static let Help = NSLocalizedString("Help", comment: "Help")
        static let Resources = NSLocalizedString("Resources", comment: "Resources")
        static let About = NSLocalizedString("About", comment: "About")
        static let Logout = NSLocalizedString("Logout", comment: "Logout")
        //        static let Version: String = {
        //            let marketingVersion: String
        //            let buildVersion: String
        //            if AppSetup.sharedState.isSimulator {
        //                marketingVersion = "SPECS"
        //                buildVersion = "specs"
        //            }
        //            else {
        //                marketingVersion = (NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String) ?? "???"
        //                buildVersion = (NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String) ?? "???"
        //            }
        //            return NSLocalizedString("Ello v\(marketingVersion) b\(buildVersion)", comment: "version number")
        //        }()
    }
    
    public struct Settings {
        static let EditProfile = NSLocalizedString("Edit Profile", comment: "Edit Profile Title")
        static let Name = NSLocalizedString("Name", comment: "name setting")
        static let Links = NSLocalizedString("Links", comment: "links setting")
        static let AvatarUploaded = NSLocalizedString("You’ve updated your Avatar.\n\nIt may take a few minutes for your new avatar/header to appear on Ello, so please be patient. It’ll be live soon!", comment: "Avatar updated copy")
        static let CoverImageUploaded = NSLocalizedString("You’ve updated your Header.\n\nIt may take a few minutes for your new avatar/header to appear on Ello, so please be patient. It’ll be live soon!", comment: "Cover Image updated copy")
        static let BlockedTitle = NSLocalizedString("Blocked", comment: "blocked settings item")
        static let MutedTitle = NSLocalizedString("Muted", comment: "muted settings item")
        static let DeleteAccountTitle = NSLocalizedString("Account Deletion", comment: "account deletion settings button")
        static let DeleteAccount = NSLocalizedString("Delete Account", comment: "account deletion label")
        static let DeleteAccountExplanation = NSLocalizedString("By deleting your account you remove your personal information from Ello. Your account cannot be restored.", comment: "By deleting your account you remove your personal information from Ello. Your account cannot be restored.")
        static let DeleteAccountConfirm = NSLocalizedString("Delete Account?", comment: "delete account question")
        static let AccountIsBeingDeleted = NSLocalizedString("Your account is in the process of being deleted.", comment: "Your account is in the process of being deleted.")
        static let RedirectedCountdownTemplate = NSLocalizedString("You will be redirected in %d...", comment: "You will be redirected in ...")
    }
    
    public struct Profile {
        static let Title = NSLocalizedString("Profile", comment: "Profile Title")
        static let Mention = NSLocalizedString("@ Mention", comment: "Mention button title")
        static let EditProfile = NSLocalizedString("Edit Profile", comment: "Edit Profile button title")
        static let PostsCount = NSLocalizedString("Posts", comment: "Posts count header")
        static let FollowingCount = NSLocalizedString("Following", comment: "Following count header")
        static let LovesCount = NSLocalizedString("Loves", comment: "Loves count header")
        static let FollowersCount = NSLocalizedString("Followers", comment: "Followers count header")
        static let CurrentUserNoResultsTitle = NSLocalizedString("Welcome to your Profile", comment: "")
        static let CurrentUserNoResultsBody = NSLocalizedString("Everything you post lives here!\n\nThis is the place to find everyone you’re following and everyone that’s following you. You’ll find your Loves here too!", comment: "")
        static let NoResultsTitle = NSLocalizedString("Ello is more fun with friends!", comment: "")
        static let NoResultsBody = NSLocalizedString("This person hasn't posted yet.\n\nFollow or mention them to help them get started!", comment: "")
    }
    
    
    public struct PushNotifications {
        static let PermissionPrompt = NSLocalizedString("Ello would like to send you push notifications.\n\nWe will let you know when you have new notifications. You can makes changes in your settings.\n", comment: "Turn on Push Notifications prompt")
        static let PermissionYes = NSLocalizedString("Yes please", comment: "Allow")
        static let PermissionNo = NSLocalizedString("No thanks", comment: "Disallow")
    }
    
    public struct ImagePicker {
        static let ChooseSource = NSLocalizedString("Choose a photo source", comment: "choose photo source (camera or library)")
        static let Camera = NSLocalizedString("Camera", comment: "camera button")
        static let Library = NSLocalizedString("Library", comment: "library button")
        static let NoSourceAvailable = NSLocalizedString("Sorry, but your device doesn’t have a photo library!", comment: "device doesn't support photo library")
        static let TakePhoto = NSLocalizedString("Take Photo Or Video", comment: "Camera button")
        static let PhotoLibrary = NSLocalizedString("Photo Library", comment: "Library button")
        static let AddImagesTemplate = NSLocalizedString("Add %lu Image(s)", comment: "Add Images")
    }
    
    public struct SignIn {
        static let EmailInvalid = NSLocalizedString("Invalid email", comment: "Invalid email message")
        static let PasswordInvalid = NSLocalizedString("Invalid password", comment: "Invalid password message")
        static let CredentialsInvalid = NSLocalizedString("Invalid credentials", comment: "Invalid credentials message")
        static let LoadUserError = NSLocalizedString("Unable to load user.", comment: "Unable to load user message")
        static let ForgotPassword = NSLocalizedString("Forgot Password", comment: "forgot password title")
    }
    
    public struct Join {
        static let Login = NSLocalizedString("Login", comment: "Login")
        static let Signup = NSLocalizedString("Signup", comment: "Signup")

        static let SignInAfterJoinError = NSLocalizedString("Your account has been created, but there was an error logging in, please try again", comment: "After successfully joining, there was an error signing in")
        static let Email = NSLocalizedString("Email", comment: "email key")
        static let EmailRequired = NSLocalizedString("Email is required.", comment: "email is required message")
        static let EmailInvalid = NSLocalizedString("That email is invalid.\nPlease try again.", comment: "invalid email message")
        static let Username = NSLocalizedString("Username", comment: "username key")
        static let UsernameRequired = NSLocalizedString("Username is required.", comment: "username is required message")
        static let UsernameUnavailable = NSLocalizedString("Username already exists.\nPlease try a new one.", comment: "username exists error message")
        static let UsernameSuggestionTemplate = NSLocalizedString("Here are some available usernames -\n%@", comment: "username suggestions showmes")
        static let Password = NSLocalizedString("Password", comment: "password key")
        static let PasswordInvalid = NSLocalizedString("Password must be at least 8\ncharacters long.", comment: "password length error message")
    }
    
    public struct Resource {
        static let USStatesList: [String] = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
        
        static let VehicleColorsList: [String] = ["Aluminum", "Beige", "Black", "Blue", "Bronze", "Brown", "Claret", "Copper", "Cream", "Gold", "Gray", "Green", "Maroon", "Metallic", "Navy", "Orange", "Pink", "Purple", "Red", "Rose", "Rust", "Silver", "Tan", "Turquoise", "White", "Yellow"]
    }
    
    static let GenericError = NSLocalizedString("Something went wrong. Thank you for your patience with Yibby Beta!", comment: "Generic error message")
    static let UnknownError = NSLocalizedString("Unknown error", comment: "Unknown error message")
    
    static let Yes = NSLocalizedString("Yes", comment: "Yes")
    static let No = NSLocalizedString("No", comment: "No")
    static let Cancel = NSLocalizedString("Cancel", comment: "Cancel")
    static let Retry = NSLocalizedString("Retry", comment: "Retry")
    static let AreYouSure = NSLocalizedString("Are You Sure?", comment: "are you sure question")
    static let OK = NSLocalizedString("OK", comment: "OK")
    static let ThatIsOK = NSLocalizedString("It’s OK, I understand!", comment: "It’s OK, I understand!")
    static let Delete = NSLocalizedString("Delete", comment: "Delete")
    static let Next = NSLocalizedString("Next", comment: "Next button")
    static let Done = NSLocalizedString("Done", comment: "Done button title")
    static let Skip = NSLocalizedString("Skip", comment: "Skip action")
    static let SettingsAction = NSLocalizedString("Settings", comment: "Settings")

}
