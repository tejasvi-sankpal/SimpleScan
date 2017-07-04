//
//  AppDelegate.m
//  TextRecognitionDemo
//
//  Created by Admin on 13/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import "AppDelegate.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"

static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // determine if the user has onboarded yet or not
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    
    // if the user has already onboarded, just set up the normal root view controller
    // for the application
    if (userHasOnboarded) {
        [self setupNormalRootViewController];
    }
    
    // otherwise set the root view controller to the onboarding view controller
    else {
        self.window.rootViewController = [self generateStandardOnboardingVC];
        //        self.window.rootViewController = [self generateMovieOnboardingVC];
        //        self.window.rootViewController = [self generateContentVideoOnboardingVC];
        
        //        __weak typeof(self) weakSelf = self;
        //
        //        self.window.rootViewController = [[MyOnboardingViewController alloc] initWithCompletionHandler:^{
        //            [weakSelf setupNormalRootViewController];
        //        }];
    }
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TextRecognitionDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark Onboarding Methods

- (void)setupNormalRootViewController {
    // create whatever your root view controller is going to be, in this case just a simple view controller
    // wrapped in a navigation controller
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationVC = [sb instantiateViewControllerWithIdentifier:@"RootNavController"];
     self.window.rootViewController = navigationVC;
    
}

- (void)handleOnboardingCompletion {
    // set that we have completed onboarding so we only do it once... for demo
    // purposes we don't want to have to set this every time so I'll just leave
    // this here...
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    
    // transition to the main application
    [self setupNormalRootViewController];
}




- (OnboardingViewController *)generateStandardOnboardingVC {
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Welcome to SimpleScan" body:@"Scan and manage useful information here, view them wherever you want." image:[UIImage imageNamed:@"first.png"] buttonText:@"" action:^{
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Here you can prompt users for various application permissions, providing them useful information about why you'd like those permissions to enhance their experience, increasing your chances they will grant those permissions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"Image Optimizing" body:@"Smart copying and enhancing, make your texts and graphics look clear and sharp." image:[UIImage imageNamed:@"second.png"] buttonText:@"" action:^{
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Prompt users to do other cool things on startup. As you can see, hitting the action button on the prior page brought you automatically to the next page. Cool, huh?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    secondPage.movesToNextViewController = YES;
    secondPage.viewDidAppearBlock = ^{
//        [[[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"You've arrived on the second page, and this alert was displayed from within the page's viewDidAppearBlock." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    };
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Easy Sharing" body:@"Share docs via email, facebook and twitter with one tap" image:[UIImage imageNamed:@"third.png"] buttonText:@"Get Started" action:^{
        [self handleOnboardingCompletion];
    }];
    
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"onboard1.jpg"] contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    onboardingVC.fadeSkipButtonOnLastPage = YES;
    
    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [self handleOnboardingCompletion];
    };
    
    return onboardingVC;
}

- (OnboardingViewController *)generateMovieOnboardingVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Everything Under The Sun" body:@"The temperature of the photosphere is over 10,000°F." image:nil buttonText:nil action:nil];
    firstPage.topPadding = -15;
    firstPage.underTitlePadding = 160;
    firstPage.titleLabel.textColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    firstPage.titleLabel.font = [UIFont fontWithName:@"SFOuterLimitsUpright" size:38.0];
    firstPage.bodyLabel.textColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    firstPage.bodyLabel.font = [UIFont fontWithName:@"NasalizationRg-Regular" size:18.0];
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"Every Second" body:@"600 million tons of protons are converted into helium atoms." image:nil buttonText:nil action:nil];
    secondPage.titleLabel.font = [UIFont fontWithName:@"SFOuterLimitsUpright" size:38.0];
    secondPage.underTitlePadding = 170;
    secondPage.topPadding = 0;
    secondPage.titleLabel.textColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    secondPage.bodyLabel.textColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    secondPage.bodyLabel.font = [UIFont fontWithName:@"NasalizationRg-Regular" size:18.0];
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"We're All Star Stuff" body:@"Our very bodies consist of the same chemical elements found in the most distant nebulae, and our activities are guided by the same universal rules." image:nil buttonText:@"Explore the universe" action:^{
        [self handleOnboardingCompletion];
    }];
    thirdPage.topPadding = 10;
    thirdPage.underTitlePadding = 160;
    thirdPage.bottomPadding = -10;
    thirdPage.titleLabel.font = [UIFont fontWithName:@"SFOuterLimitsUpright" size:38.0];
    thirdPage.titleLabel.textColor = [UIColor colorWithRed:58/255.0 green:105/255.0 blue:136/255.0 alpha:1.0];
    thirdPage.bodyLabel.textColor = [UIColor colorWithRed:58/255.0 green:105/255.0 blue:136/255.0 alpha:1.0];
    thirdPage.bodyLabel.font = [UIFont fontWithName:@"NasalizationRg-Regular" size:15.0];
    [thirdPage.actionButton setTitleColor:[UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0] forState:UIControlStateNormal];
    thirdPage.actionButton.titleLabel.font = [UIFont fontWithName:@"SpaceAge" size:17.0];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"sun" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundVideoURL:movieURL contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    onboardingVC.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    return onboardingVC;
}

- (OnboardingViewController *)generateContentVideoOnboardingVC {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"sun" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Everything Under The Sun" body:@"The temperature of the photosphere is over 10,000°F." videoURL:movieURL buttonText:nil action:nil];
    firstPage.topPadding = -15;
    firstPage.underTitlePadding = 160;
    firstPage.titleLabel.textColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    firstPage.titleLabel.font = [UIFont fontWithName:@"SFOuterLimitsUpright" size:38.0];
    firstPage.bodyLabel.textColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    firstPage.bodyLabel.font = [UIFont fontWithName:@"NasalizationRg-Regular" size:18.0];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"Every Second" body:@"600 million tons of protons are converted into helium atoms." videoURL:movieURL buttonText:nil action:nil];
    secondPage.titleLabel.font = [UIFont fontWithName:@"SFOuterLimitsUpright" size:38.0];
    secondPage.underTitlePadding = 170;
    secondPage.topPadding = 0;
    secondPage.titleLabel.textColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    secondPage.bodyLabel.textColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    secondPage.bodyLabel.font = [UIFont fontWithName:@"NasalizationRg-Regular" size:18.0];
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"We're All Star Stuff" body:@"Our very bodies consist of the same chemical elements found in the most distant nebulae, and our activities are guided by the same universal rules." videoURL:movieURL buttonText:nil action:^{
        [self handleOnboardingCompletion];
    }];
    thirdPage.topPadding = 10;
    thirdPage.underTitlePadding = 160;
    thirdPage.bottomPadding = -10;
    thirdPage.titleLabel.font = [UIFont fontWithName:@"SFOuterLimitsUpright" size:38.0];
    thirdPage.titleLabel.textColor = [UIColor colorWithRed:58/255.0 green:105/255.0 blue:136/255.0 alpha:1.0];
    thirdPage.bodyLabel.textColor = [UIColor colorWithRed:58/255.0 green:105/255.0 blue:136/255.0 alpha:1.0];
    thirdPage.bodyLabel.font = [UIFont fontWithName:@"NasalizationRg-Regular" size:15.0];
    [thirdPage.actionButton setTitleColor:[UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0] forState:UIControlStateNormal];
    thirdPage.actionButton.titleLabel.font = [UIFont fontWithName:@"SpaceAge" size:17.0];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:nil contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.view.backgroundColor = [UIColor blackColor];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    onboardingVC.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    return onboardingVC;
}


@end
