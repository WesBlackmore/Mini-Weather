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

@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *fontLabelArray;

@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *dayLabelArray;

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

#pragma mark Hourly Weather Conditions
//Now
@property (weak, nonatomic) IBOutlet UILabel *nowText;
@property (weak, nonatomic) IBOutlet UILabel *nowIcon;
@property (weak, nonatomic) IBOutlet UILabel *nowTemp;

//Hour 1
@property (weak, nonatomic) IBOutlet UILabel *hour1Text;
@property (weak, nonatomic) IBOutlet UILabel *hour1Icon;
@property (weak, nonatomic) IBOutlet UILabel *hour1Temp;

//Hour 2
@property (weak, nonatomic) IBOutlet UILabel *hour2Text;
@property (weak, nonatomic) IBOutlet UILabel *hour2Icon;
@property (weak, nonatomic) IBOutlet UILabel *hour2Temp;

//Hour 3
@property (weak, nonatomic) IBOutlet UILabel *hour3Text;
@property (weak, nonatomic) IBOutlet UILabel *hour3Icon;
@property (weak, nonatomic) IBOutlet UILabel *hour3Temp;

//Hour 4
@property (weak, nonatomic) IBOutlet UILabel *hour4Text;
@property (weak, nonatomic) IBOutlet UILabel *hour4Icon;
@property (weak, nonatomic) IBOutlet UILabel *hour4Temp;

#pragma mark Week Weather Conditions
//Day 1
@property (weak, nonatomic) IBOutlet UILabel *day1Text;
@property (weak, nonatomic) IBOutlet UILabel *day1Icon;
@property (weak, nonatomic) IBOutlet UILabel *day1Temp;
@property (weak, nonatomic) IBOutlet UILabel *day1TempMin;

//Day 2
@property (weak, nonatomic) IBOutlet UILabel *day2Text;
@property (weak, nonatomic) IBOutlet UILabel *day2Icon;
@property (weak, nonatomic) IBOutlet UILabel *day2Temp;
@property (weak, nonatomic) IBOutlet UILabel *day2TempMin;

//Day 3
@property (weak, nonatomic) IBOutlet UILabel *day3Text;
@property (weak, nonatomic) IBOutlet UILabel *day3Icon;
@property (weak, nonatomic) IBOutlet UILabel *day3Temp;
@property (weak, nonatomic) IBOutlet UILabel *day3TempMin;

//Day 4
@property (weak, nonatomic) IBOutlet UILabel *day4Text;
@property (weak, nonatomic) IBOutlet UILabel *day4Icon;
@property (weak, nonatomic) IBOutlet UILabel *day4Temp;
@property (weak, nonatomic) IBOutlet UILabel *day4TempMin;

//Day 5
@property (weak, nonatomic) IBOutlet UILabel *day5Text;
@property (weak, nonatomic) IBOutlet UILabel *day5Icon;
@property (weak, nonatomic) IBOutlet UILabel *day5Temp;
@property (weak, nonatomic) IBOutlet UILabel *day5TempMin;

@end
