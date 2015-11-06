//
//  ProfileHeaderView.h
//  collectionview
//
//  Created by Rahiem Klugh on 10/1/15.
//  Copyright (c) 2015 Rahiem Klugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *viewProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;

@end
