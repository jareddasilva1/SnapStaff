//
//  ProfileCollectionViewController.h
//  collectionview
//
//  Created by Rahiem Klugh on 10/1/15.
//  Copyright (c) 2015 Rahiem Klugh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LGViewControllerFormatTapMe,
    LGViewControllerFormatGoBack,
} LGViewControllerFormat;


@interface ProfileCollectionViewController : UICollectionViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UITableView *tableView;
    int photos;
     int photosinc;
   NSString *PhotoToSave;
   NSString *PhotoToDisplay;
    NSString *ig;
    NSString *fb;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

-(id)initWithFormat:(LGViewControllerFormat)format;
@property (nonatomic, retain) UITableView *tableView;

@end

