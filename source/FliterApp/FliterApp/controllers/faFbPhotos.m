//
//  faFbPhotos.m
//  FliterApp
//
//  Created by Presley on 13/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
// http://stackoverflow.com/a/6159418/1051198
//https://searchcode.com/codesearch/view/25749028/
//http://www.itexico.com/blog/bid/101321/Working-with-Facebook-Graph-API-for-iOS-Apps

#import "faFbPhotos.h"
#import "SWRevealViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "faAppDelegate.h"
#import "faAlbumCell.h"



@interface faFbPhotos ()<FBLoginViewDelegate, UITableViewDelegate, UITableViewDataSource>




@end



@implementation faFbPhotos



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"FB Photos";
    [self slideMenuSetup];
    [self facebookSession];
    

    _albumArray = [[NSMutableArray alloc]init];
}

-(void)slideMenuSetup{
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)facebookSession{
    
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

//    // Align the button in the center horizontally
//    float Y_Co = self.view.frame.size.height - loginview.frame.size.height;
//    float X_Co = (self.view.frame.size.width - loginview.frame.size.width)/2;
//    [loginview setFrame:CGRectMake(X_Co, Y_Co - 5, loginview.frame.size.width , loginview.frame.size.height)];
//    [self.view addSubview:loginview];
//    [loginview sizeToFit];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnReload:(id)sender {
              [self.albumTableView reloadData];
}



-(NSString*)getPhotoImgURLFromID:(id)photoID{
//  
//    NSString *albumIDValue = [NSString stringWithFormat:@"/%@/photos", photoID];
//    
//    
//    [FBRequestConnection startWithGraphPath:albumIDValue completionHandler:^(
//                                                                             FBRequestConnection *connection,
//                                                                             id result,
//                                                                             NSError *error
//                                                                             )
//     {
//         if (!error) {
//             // Success! Include your code to handle the results here
//             NSLog(@"user events: %@", result);
//             NSArray *feed =[result objectForKey:@"data"];
//             
//             for (NSDictionary *dict in feed) {
//                 
//                 NSLog(@"first %@",dict);
//                 
//             }
//         } else {
//             // An error occurred, we need to handle the error
//             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
//             NSLog(@"error %@", error.description);
//         }
//         
//     }
//     ];
//
//    
   return @"";
}

-(void)getPhotoByAlbumID:(id)albumID{
    
    NSString *albumIDValue = [NSString stringWithFormat:@"/%@/photos", albumID];

    
    [FBRequestConnection startWithGraphPath:albumIDValue completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
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
         
      }
    ];
    
    
}



//- (void)showSpinner{
//    UIView *overlay = [[UIView alloc] initWithFrame:self.view.frame];
//    overlay.backgroundColor = [UIColor blackColor];
//    overlay.alpha = 0.5f;
//    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    [spinner startAnimating];
//    spinner.center = overlay.center;
//    [overlay addSubview:spinner];
//    
//    [self.view addSubview:overlay];
//}


- (IBAction)btnGetAlbumList:(id)sender {
    UIView *overlay = [[UIView alloc] initWithFrame:self.view.frame];
    overlay.backgroundColor = [UIColor lightGrayColor];
    overlay.alpha = 0.5f;

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    spinner.center = overlay.center;
    [overlay addSubview:spinner];

    [self.view addSubview:overlay];
    
    [_albumArray removeAllObjects]; //clear the aray
    _albumDictionary = [[NSMutableDictionary alloc] init];
    [_albumDictionary removeAllObjects]; //Clear the whole dictionary
    
    //Get Album list
    [FBRequestConnection startWithGraphPath:@"me/albums"
      completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
          if (!error) {
              
              
              NSString* albumsID;
              NSString* albumImgURL;
              NSString* albumName;
              NSArray *feed =[result objectForKey:@"data"];
              
              for (NSDictionary *dict in feed) {
                  
                  albumsID = [dict objectForKey:@"id"];
                  albumImgURL = [dict objectForKey:@"cover_photo"];
                  albumName = [dict objectForKey:@"name"];
                  NSLog(@"Id %@", albumsID);
                  if ((albumsID.length > 0) && (albumName.length > 0) && (albumImgURL.length > 0)) {
                      
                      _albumDictionary = @{@"albumName":albumName, @"albumID":albumsID, @"albumImgURL":albumImgURL};
                     [_albumArray addObject:_albumDictionary];
                  }


              }
              NSLog(@"dictionary %@", _albumArray);
              [spinner stopAnimating];
              [overlay removeFromSuperview];
              [self.albumTableView reloadData];
             
          } else {
              // An error occurred, we need to handle the error
              // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
              NSLog(@"error %@", error.description);
              [spinner stopAnimating];
              [overlay removeFromSuperview];
          }
      }];
}

//-(void)getFriendsArray
//{
//    //Create a shadow view to create a user feedback loading animator
//    UIView *shadowView = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
//    [self.navigationController.view addSubview:shadowView];
//    [shadowView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.6]];
//    //Add and activity indicator
//    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [activityIndicator setFrame:CGRectMake(self.view.center.x - 25, self.view.center.y - 25, 50, 50)];
//    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x -25, self.view.center.y + 25, 100, 30)];
//    [loadingLabel setText:@"Loading..."];
//    [loadingLabel setTextColor:[UIColor whiteColor]];
//    //Star animating while the method is executed
//    [activityIndicator startAnimating];
//    
//    [shadowView addSubview:activityIndicator];
//    [shadowView addSubview:loadingLabel];
//    
//    
//    //Call the method to get facebook friends declared below
//    [self getFacebookFriends:^(NSArray *successArray) {
//        //Receive the array that is generated after success
//        self.albumArrayNs = successArray;
//        NSLog(@"Array from the thread : %@", _albumArray);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //Once the method is completed stop the animation of the activity indicator and remove the shadow view.
//            [activityIndicator stopAnimating];
//            [shadowView removeFromSuperview];
//        });
//    } error:^(NSString *errorString) {
//        [activityIndicator stopAnimating];
//        [shadowView removeFromSuperview];
//    }];
//}


//-(void)getFacebookFriends: (FriendsCallbackSuccess)success error:(FriendsCallbackError)inError
//{
//    
//    
//    [_albumArray removeAllObjects]; //clear the aray
//    _albumDictionary = [[NSMutableDictionary alloc] init];
//    [_albumDictionary removeAllObjects]; //Clear the whole dictionary
//    
//    //Get Album list
//    [FBRequestConnection startWithGraphPath:@"me/albums"
//                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              if (!error) {
//                                  self.success = success;
//                                  
//                                  NSString* albumsID;
//                                  NSString* albumImgURL;
//                                  NSString* albumName;
//                                  NSArray *feed =[result objectForKey:@"data"];
//                                  
//                                  for (NSDictionary *dict in feed) {
//                                      
//                                      albumsID = [dict objectForKey:@"id"];
//                                      albumImgURL = [dict objectForKey:@"cover_photo"];
//                                      albumName = [dict objectForKey:@"name"];
//                                      NSLog(@"Id %@", albumsID);
//
//                                      //if ((![albumsID isEqual:[NSNull null]]) && (![albumImgURL isEqual:[NSNull nil]]) &&
//                                      //(![albumName isEqual:[NSNull null]])){
//                                      
//                                      if ((!albumsID.length) && (!albumName.length) && (!albumImgURL.length)) {
//                                      
//                                      _albumDictionary = @{@"albumName":albumName, @"albumID":albumsID, @"albumImgURL":albumImgURL};
//                                      }
//                                      
//                                     // [_albumArrayNs addObject:_albumDictionary];
//                                      [_albumArray addObject:_albumDictionary];
//                                     // NSLog(@"dictionary %@", _albumDictionary);
//                                  }
//                                  
//                                   success(_albumArrayNs);
//                              } else {
//                                  // An error occurred, we need to handle the error
//                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
//                                  NSLog(@"error %@", error.description);
//                                  NSLog(@"ERROR: %@", error);
//                                  self.error = inError;
//
//                              } }];
//   
//}

//tableview controller-----------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.albumArray count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
   // Region *region = [regions objectAtIndex:section];
   // return [region name];
    return @"Albums";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    faAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSUInteger row = [indexPath row];
    NSLog(@"content of the cell from the array %@", [_albumArray objectAtIndex:row]);
    cell.lblalumbName.text = [[_albumArray objectAtIndex:indexPath.row] objectForKey:@"albumName"];
    //cell.lblalbumID.text = [[_albumArray objectAtIndex:indexPath.row] objectForKey:@"albumID"];
    cell.imageView.image = [[UIImage imageNamed:@"album.png"] init];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
@end
