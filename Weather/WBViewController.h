//
//  WBViewController.h
//  Weather
//
//  Created by Wes Blackmore on 6/10/14.
//  Copyright (c) 2014 Wesley Blackmore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface WBViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *currentDateTime;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (retain, nonatomic) IBOutlet UIView *viewMainView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *feelsLikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *poweredByForcastLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedIcon;
@property (weak, nonatomic) IBOutlet UILabel *currentTempIcon;
@property (weak, nonatomic) IBOutlet UILabel *rainIntensityLabel;
@property (weak, nonatomic) IBOutlet UILabel *rainIntensityIcon;


@end
