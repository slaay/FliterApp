//
//  faFbPhotos.m
//  FliterApp
//
//  Created by Presley on 13/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
// http://stackoverflow.com/a/6159418/1051198
//https://searchcode.com/codesearch/view/25749028/
//http://www.itexico.com/blog/bid/101321/Working-with-Facebook-Graph-API-for-iOS-Apps
//https://gist.github.com/ekoneil/3178821

#import "faFbPhotos.h"
#import "SWRevealViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "faAppDelegate.h"
#import "faAlbumCell.h"



@interface faFbPhotos ()<FBLoginViewDelegate, UITableViewDelegate, UITableViewDataSource>




@end



@implementation faFbPhotos {
    UIView *overlay;
    UIActivityIndicatorView *spinner;

}



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

- (IBAction)btnAlubm:(id)sender {
    [self getAlbumCoverPhotoByAlbumID:494170180601711];
    //[self requestAlbums];
    
}

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
    
   // NSString *albumIDValue = [NSString stringWithFormat:@"/%@/photos", albumID];

    
    // /albums[0]/photos
     NSString* photos = [NSString stringWithFormat:@"%@/photos", albumID];
    [FBRequestConnection startWithGraphPath:photos
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              NSArray* photos = (NSArray*)[result data];
                              NSLog(@"Photo Array %@", photos);
                             
                              NSDictionary *dictionary = [photos objectAtIndex:0];
                              NSString *coverPicURL = [dictionary objectForKey:@"picture"];
                              NSLog(@"URL %@", coverPicURL);
                              
                          }];

}


-(void)getAlbumCoverPhotoByAlbumID:(NSInteger)albumID{
    // /albums[0]/photos
    NSString* photos = [NSString stringWithFormat:@"%ld/photos", (long)albumID];
    [FBRequestConnection startWithGraphPath:photos
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              
                              NSArray* photos = (NSArray*)[result data];
                              //NSLog(@"photos %@", photos);
                              NSDictionary *dictionary = [photos objectAtIndex:0];
                              NSString *coverPicURL = [dictionary objectForKey:@"picture"];
                              NSLog(@"URL %@", coverPicURL);
                              
                          }];
}


- (void)showSpinner:(int)showSpinner{
    
    if (showSpinner == 1){
        overlay = [[UIView alloc] initWithFrame:self.view.frame];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0.5f;
        
        spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner startAnimating];
        spinner.center = overlay.center;
        [overlay addSubview:spinner];
        
        [self.view addSubview:overlay];
    } else if (showSpinner == 0){
        [spinner stopAnimating];
        [overlay removeFromSuperview];
    }
}


- (IBAction)btnGetAlbumList:(id)sender {
    
    [self showSpinner:1];
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
                  NSLog(@"feed %@", feed);
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
              [self showSpinner:0];
              [self.albumTableView reloadData];
             
          } else {
              // An error occurred, we need to handle the error
              // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
              NSLog(@"error %@", error.description);
              [self showSpinner:0];
          }
      }];
}


// #3: Graph API: /me/albums && /{albums[0]}/photos
-(void)requestAlbums {
    [FBRequestConnection startWithGraphPath:@"/me/albums"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if(error) {
                                  //[self printError:@"Error requesting /me/albums" error:error];
                                  return;
                              }
                              
                              NSArray* collection = (NSArray*)[result data];
                              NSLog(@"You have %lu albums", (unsigned long)[collection count]);
                              
                              NSDictionary* album = [collection objectAtIndex:0];
                              NSLog(@"Album ID: %@", [album objectForKey:@"id"]);
                              
                              // /albums[0]/photos
                              NSString* photos = [NSString stringWithFormat:@"%@/photos", [album objectForKey:@"id"]];
                              [FBRequestConnection startWithGraphPath:photos
                                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                       
                                                        
                                                        NSArray* photos = (NSArray*)[result data];
                                                        NSLog(@"photos %@", photos);
                                                        NSLog(@"You have %lu photo(s) in the album %@",                                                              (unsigned long)[photos count],
                                                              [album objectForKey:@"name"]);
                                                        NSDictionary *dictionary = [photos objectAtIndex:0];
                                                        NSString *coverPicURL = [dictionary objectForKey:@"picture"];
                                                        NSLog(@"URL %@", coverPicURL);
                                                        
                                                    }];
                          }];
}

//tableview controller-----------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.albumArray count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
