/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//http://stackoverflow.com/questions/11889725/how-can-i-convert-fbprofilepictureview-to-an-uiimage?rq=1
//http://stackoverflow.com/questions/12387988/how-to-programmatically-allign-a-button-in-ios-applications

#import "HFViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SWRevealViewController.h"
#import "faAppDelegate.h"
#import "FXBlurView.h"
#import <QuartzCore/QuartzCore.h>


@interface HFViewController () <FBLoginViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostStatus;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickFriends;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickPlace;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (strong, nonatomic) IBOutlet UIImageView *imgBlur;
@property (strong, nonatomic) IBOutlet FXBlurView *blurView;

- (IBAction)postStatusUpdateClick:(UIButton *)sender;
- (IBAction)postPhotoOrVideoClick:(UIButton *)sender;
- (IBAction)pickFriendsClick:(UIButton *)sender;
- (IBAction)pickPlaceClick:(UIButton *)sender;

- (IBAction)btnRefresh:(id)sender;

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;


@end

@implementation HFViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *loginview = [[FBLoginView alloc] init];

    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, 5, 25);
    }
#endif
#endif
#endif
    loginview.delegate = self;
    
    // Align the button in the center horizontally
    float Y_Co = self.view.frame.size.height - loginview.frame.size.height;
    float X_Co = (self.view.frame.size.width - loginview.frame.size.width)/2;
    [loginview setFrame:CGRectMake(X_Co, Y_Co - 5, loginview.frame.size.width , loginview.frame.size.height)];
    [self.view addSubview:loginview];
    [loginview sizeToFit];
    
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self roundedControls:_profilePic];
    
    self.blurView.blurRadius = 20;
}



-(void)roundedControls:(FBProfilePictureView*)sender{
    FBProfilePictureView* roundedButton = (FBProfilePictureView*)sender;
    roundedButton.layer.cornerRadius = roundedButton.frame.size.width / 2;
    roundedButton.clipsToBounds = YES;
    roundedButton.layer.borderWidth = 1.0f;
    roundedButton.layer.borderColor = [UIColor greenColor].CGColor;
    
}

- (void)viewDidUnload {
    self.buttonPickFriends = nil;
    self.buttonPickPlace = nil;
    self.buttonPostPhoto = nil;
    self.buttonPostStatus = nil;
    self.labelFirstName = nil;
    self.loggedInUser = nil;
    self.profilePic = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    self.buttonPostPhoto.enabled = YES;
    self.buttonPostStatus.enabled = YES;
    self.buttonPickFriends.enabled = YES;
    self.buttonPickPlace.enabled = YES;

    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    self.profilePic.profileID = user.objectID;
    self.loggedInUser = user;
    [self getProfileImage];

}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBLinkShareParams *p = [[FBLinkShareParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    BOOL canShareFBPhoto = [FBDialogs canPresentShareDialogWithPhotos];

    self.buttonPostStatus.enabled = canShareFB || canShareiOS6;
    self.buttonPostPhoto.enabled = canShareFBPhoto;
    self.buttonPickFriends.enabled = NO;
    self.buttonPickPlace.enabled = NO;

    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.buttonPostStatus setTitle:@"Post Status Update (Logged Off)" forState:self.buttonPostStatus.state];

    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void)performPublishAction:(void(^)(void))action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }

}

// Post Status Update button handler; will attempt different approaches depending upon configuration.
- (IBAction)postStatusUpdateClick:(UIButton *)sender {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.

    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];

    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.

    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBLinkShareParams *params = [[FBLinkShareParams alloc] initWithLink:urlToShare
                                                                   name:@"Hello Facebook"
                                                                caption:nil
                                                            description:@"The 'Hello Facebook' sample application showcases simple Facebook integration."
                                                                picture:nil];

    BOOL isSuccessful = NO;
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        FBAppCall *appCall = [FBDialogs presentShareDialogWithParams:params
                                                         clientState:nil
                                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                                 if (error) {
                                                                     NSLog(@"Error: %@", error.description);
                                                                 } else {
                                                                     NSLog(@"Success!");
                                                                 }
                                                             }];
        isSuccessful = (appCall  != nil);
    }
    if (!isSuccessful && [FBDialogs canPresentOSIntegratedShareDialogWithSession:[FBSession activeSession]]){
        // Next try to post using Facebook's iOS6 integration
        isSuccessful = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                initialText:nil
                                                                      image:nil
                                                                        url:urlToShare
                                                                    handler:nil];
    }
    if (!isSuccessful) {
        [self performPublishAction:^{
            NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", self.loggedInUser.first_name, [NSDate date]];

            FBRequestConnection *connection = [[FBRequestConnection alloc] init];

            connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
            | FBRequestConnectionErrorBehaviorAlertUser
            | FBRequestConnectionErrorBehaviorRetry;

            [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                 completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                     [self showAlert:message result:result error:error];
                     self.buttonPostStatus.enabled = YES;
                 }];
            [connection start];

            self.buttonPostStatus.enabled = NO;
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSString *videoPath = [info objectForKey:UIImagePickerControllerMediaURL];
        [self publishVideo:videoPath];
    } else {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self publishPhoto:img];
    }

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)publishPhoto:(UIImage *)image
{
    BOOL canPresent = [FBDialogs canPresentShareDialogWithPhotos];
    NSLog(@"canPresent: %d", canPresent);

    FBPhotoParams *params = [[FBPhotoParams alloc] init];
    params.photos = @[image];
    
    BOOL isSuccessful = NO;
    if (canPresent) {
        FBAppCall *appCall = [FBDialogs presentShareDialogWithPhotoParams:params
                                                              clientState:nil
                                                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                                      if (error) {
                                                                          NSLog(@"Error: %@", error.description);
                                                                      } else {
                                                                          NSLog(@"Success!");
                                                                      }
                                                                  }];
        isSuccessful = (appCall  != nil);
    }

    if (!isSuccessful) {
        [self performPublishAction:^{
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
            | FBRequestConnectionErrorBehaviorAlertUser
            | FBRequestConnectionErrorBehaviorRetry;

            [connection addRequest:[FBRequest requestForUploadPhoto:image]
                 completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                     [self showAlert:@"Photo Post" result:result error:error];
                     if (FBSession.activeSession.isOpen) {
                         self.buttonPostPhoto.enabled = YES;
                     }
                 }];
            [connection start];

            self.buttonPostPhoto.enabled = NO;
        }];
    }
}

- (void)publishVideo:(NSString *)filePath
{
    [self performPublishAction:^{
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
        | FBRequestConnectionErrorBehaviorAlertUser
        | FBRequestConnectionErrorBehaviorRetry;

        [connection addRequest:[FBRequest requestForUploadVideo:filePath]
             completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                 [self showAlert:@"Video Post" result:result error:error];
                 if (FBSession.activeSession.isOpen) {
                     self.buttonPostPhoto.enabled = YES;
                 }
             }];
        [connection start];

        self.buttonPostPhoto.enabled = NO;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// Post photo or video button handler
- (IBAction)postPhotoOrVideoClick:(UIButton *)sender {
    // Open the media picker and have the user choose an item from photos
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.mediaTypes = @[ (NSString *) kUTTypeImage, (NSString *) kUTTypeMovie];
    ipc.delegate = self;

    [self presentViewController:ipc animated:YES completion:NULL];
}

// Pick Friends button handler
- (IBAction)pickFriendsClick:(UIButton *)sender {
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];

    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }

         NSString *message;

         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {

             NSMutableString *text = [[NSMutableString alloc] init];

             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }

         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}

// Pick Place button handler
- (IBAction)pickPlaceClick:(UIButton *)sender {
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.title = @"Pick a Seattle Place";
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(47.6097, -122.3331);
    [placePickerController loadData];

    // Use the modal wrapper method to display the picker.
    [placePickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }

         NSString *placeName = placePickerController.selection.name;
         if (!placeName) {
             placeName = @"<No Place Selected>";
         }

         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:placeName
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}





// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {

    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;

        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }

    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// leee code

- (void)getProfileImage {
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             
             _labelFirstName.text = user.name;
             _profilePic.profileID = user.objectID;
             
             //NOTE THIS LINE WHICH DOES THE MAGIC
             
             [self performSelector:@selector(getUserImageFromFBView) withObject:nil afterDelay:1.0];
         }
     }];
}
    
- (void)getUserImageFromFBView{
        
        UIImage *img = nil;
        
        //1 - Solution to get UIImage obj
        
        for (NSObject *obj in [_profilePic subviews]) {
            if ([obj isMemberOfClass:[UIImageView class]]) {
                UIImageView *objImg = (UIImageView *)obj;
                img = objImg.image;
                break;
            }
        }
        
        //2 - Solution to get UIImage obj
        
        //    UIGraphicsBeginImageContext(profileDP.frame.size);
        //    [profileDP.layer renderInContext:UIGraphicsGetCurrentContext()];
        //    img = UIGraphicsGetImageFromCurrentImageContext();
        //    UIGraphicsEndImageContext();
        
        //Here I'm setting image and it works 100% for me.
    
    _imgBlur.image = img;
    _imgBlur.contentMode = UIViewContentModeScaleAspectFill;

    
    }

- (IBAction)btnRefresh:(id)sender {
    [self getProfileImage];
}







- (IBAction)btnGetAlbumList:(id)sender {
    //Get Album list
//    [FBRequestConnection startWithGraphPath:@"me/albums"
//                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              if (!error) {
//                                  // Success! Include your code to handle the results here
//                                  NSLog(@"user events: %@", result);
//                                  NSArray *feed =[result objectForKey:@"data"];
//                                  
//                                  for (NSDictionary *dict in feed) {
//                                      
//                                      NSLog(@"first %@",dict);
//                                      
//                                  }
//                              } else {
//                                  // An error occurred, we need to handle the error
//                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
//                                  NSLog(@"error %@", error.description);
//                              }
//                          }];
//    
    
    
//  user information
    //https://developers.facebook.com/docs/ios/graph#userinfo
//    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            // Success! Include your code to handle the results here
//            NSLog(@"user info: %@", result);
//        } else {
//            // An error occurred, we need to handle the error
//            // See: https://developers.facebook.com/docs/ios/errors
//        }
//    }];
    
    
    
    
//    // We will request the user's public profile and the user's birthday
//    // These are the permissions we need:
//    NSArray *permissionsNeeded = @[@"user_photos"];
//    
//    // Request the permissions the user currently has
//    [FBRequestConnection startWithGraphPath:@"/me/permissions"
//                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              if (!error){
//                                  
//                                  // Request permissions in active session with  FBSession.activeSession.accessTokenData.permissions
//                                  // Then current permissions the user has:
//                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
//                                  
//                                  // We will store here the missing permissions that we will have to request
//                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
//                                  
//                                  // Check if all the permissions we need are present in the user's current permissions
//                                  // If they are not present add them to the permissions to be requested
//                                  for (NSString *permission in permissionsNeeded){
//                                      if (![currentPermissions objectForKey:permission]){
//                                          [requestPermissions addObject:permission];
//                                      }
//                                  }
//                                  
//                                  // If we have permissions to request
//                                  if ([requestPermissions count] > 0){
//                                      // Ask for the missing permissions
//                                      [FBSession.activeSession
//                                       requestNewReadPermissions:requestPermissions
//                                       completionHandler:^(FBSession *session, NSError *error) {
//                                           if (!error) {
//                                               // Permission granted
//                                               NSLog(@"new permissions %@", [FBSession.activeSession permissions]);
//                                               // We can request the user information
//
//                                           } else {
//                                               // An error occurred, we need to handle the error
//                                               // See: https://developers.facebook.com/docs/ios/errors
//                                           }
//                                       }];
//                                  } else {
//                                      // Permissions are present
//                                      // We can request the user information
//                                      
//                                          [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                                             if (!error) {
//                                                  // Success! Include your code to handle the results here
//                                                  NSLog(@"user info: %@", result);
//                                              } else {
//                                                 // An error occurred, we need to handle the error
//                                                  // See: https://developers.facebook.com/docs/ios/errors
//                                              }
//                                          }];
//
//                                  }
//                                  
//                              } else {
//                                  // An error occurred, we need to handle the error
//                                  // See: https://developers.facebook.com/docs/ios/errors
//                                  
//                                  [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                                      if (!error) {
//                                          // Success! Include your code to handle the results here
//                                          NSLog(@"user info: %@", result);
//                                      } else {
//                                          // An error occurred, we need to handle the error
//                                          // See: https://developers.facebook.com/docs/ios/errors
//                                      }
//                                  }];
//                              }
//                          }];
//    
    
    
    
    [FBRequestConnection startWithGraphPath:@"/929970610354997/photos"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if (!error) {
                                            // Success! Include your code to handle the results here
                                            NSLog(@"user events: %@", result);
                                            NSArray *feed =[result objectForKey:@"data"];
          
                                            for (NSDictionary *dict in feed) {
          
                                                NSLog(@"first %@",dict);
          
                                            }
                                            } else {
                                                // An error occurred, we need to handle the error
                                                // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                                NSLog(@"error %@", error.description);
                                           }

                          }];
    
    
    
    
}
@end
