//
//  WBViewController.m
//  Weather
//
//  Created by Wes Blackmore on 6/10/14.
//  Copyright (c) 2014 Wesley Blackmore. All rights reserved.
//

#import "WBViewController.h"
#import "ForecastKit.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WBViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitue;
@end

@implementation WBViewController
@synthesize viewMainView = _viewMainView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tempLabel.alpha = 0.0f;
    self.feelsLikeLabel.alpha = 0.0f;
    self.summaryLabel.alpha = 0.0f;
    self.viewMainView.alpha = 0.0f;
    NSLog(@"viewDidLoad!");
    [self loadLocation];
 }

-(void)loadLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = 1000;
        [self.locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    
    //CLLocationCoordinate2D coord;
    //coord.longitude = location.coordinate.longitude;
    //coord.latitude = location.coordinate.latitude;
    
    self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = placemark.name;
    }];
    
    NSLog( @"didUpdateLocation!");
    NSLog( @"We're in: %@", self.location);
    //NSLog( @"latitude is %f and longitude is %f", coord.latitude, coord.longitude);
}

-(void) viewWillAppear:(BOOL)animated {
    self.tempLabel.alpha = 0.0f;
    self.feelsLikeLabel.alpha = 0.0f;
    self.summaryLabel.alpha = 0.0f;
    self.viewMainView.alpha = 0.0f;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /*
    TO DO:
     1. Caching
     2. Location
     3. Week Data
     4. Animation
     5. Fix Layout
     6. Add F/C M/KM check
    */
    
	ForecastKit *forecast = [[ForecastKit alloc] initWithAPIKey:@"4f3b47f06c6a8e18ea2a07fa0c290d6c"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    
    self.tempLabel.alpha = 0.0f;
    self.feelsLikeLabel.alpha = 0.0f;
    self.summaryLabel.alpha = 0.0f;
    self.viewMainView.alpha = 0.0f;
    
    //getCurrentConditionsForLatitude:-27.9253 longitude:30.4239
    
    [forecast getCurrentConditionsForLatitude:[self.latitude doubleValue] longitude:[self.longitue doubleValue] success:^(NSMutableDictionary *responseDict) {
        
        NSLog(@"%@", responseDict);
        
        NSString *temp = [responseDict objectForKey:@"temperature"];
        NSString *feelsLike = [responseDict objectForKey:@"apparentTemperature"];
        NSString *summary = [responseDict objectForKey:@"summary"];
        NSString *icon = [responseDict objectForKey:@"icon"];
        NSString *windBearing = [responseDict objectForKey:@"windBearing"];
        NSString *windSpeed = [responseDict objectForKey:@"windSpeed"];
        //NSDecimalNumber *precipIntensity = @([@"42.42" floatValue]); //[responseDict objectForKey:@"precipIntensity"];
        //NSDecimalNumber *precipIntensity = [[NSDecimalNumber decimalNumberWithString:@"0.42"] decimalNumberByMultiplyingByPowerOf10:2];
        NSDecimalNumber *precipIntensity = [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"precipIntensity"]]] decimalNumberByMultiplyingByPowerOf10:2];
        BOOL isNight = ([icon rangeOfString:@"night"].location != NSNotFound);
        
        //[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"precipIntensity"]]
        
        //int precipIntensityInMM = precipIntensity.intValue;
        //NSLog(@"%@", precipShow);
        
        
        //Set Celcius/Fahrenheit & km/m
        temp = [forecast celciusValue:temp];
        feelsLike = [forecast celciusValue:feelsLike];
        windSpeed = [forecast kilometersValue:windSpeed];
        
        //Set label text
        self.locationLabel.text = self.location;
        self.tempLabel.text = [forecast iconCharacter:icon];
        self.summaryLabel.text = summary;
        self.currentTempLabel.text = [NSString stringWithFormat:@"%@%@", [forecast roundNumberUp:temp], @"\u00B0"];
        self.feelsLikeLabel.text = [NSString stringWithFormat:@"%@ %@%@", @"Feels like:", [forecast roundNumberUp:feelsLike], @"\u00B0"];
        self.windSpeedLabel.text = [NSString stringWithFormat:@"%@%@", [forecast roundNumberUp:windSpeed], @"km/h"];
        //self.windSpeedLabel.text = [NSString stringWithFormat:@"%@%@", windSpeed, @""];
        
        //Set fonts & colors
        self.tempLabel.font = [UIFont fontWithName:@"Climacons-Font" size:150];
        UIColor *backgroundColor = [forecast backgroundColorForTemp:temp icon:icon isNight:isNight];
        self.viewMainView.backgroundColor = backgroundColor;
        
        self.windSpeedIcon.font = [UIFont fontWithName:@"Climacons-Font" size:30];
        self.windSpeedIcon.text = [forecast iconCharacter:[forecast selectIconByWindBearing:windBearing]];
        
        self.currentTempIcon.font = [UIFont fontWithName:@"Climacons-Font" size:30];
        self.currentTempIcon.text = [forecast iconCharacter:[forecast selectIconByTemperature:temp]];
       
        
        self.rainIntensityIcon.font = [UIFont fontWithName:@"Climacons-Font" size:30];
        self.rainIntensityIcon.text = [forecast iconCharacter:@"umbrella"];
        self.rainIntensityLabel.text = [NSString stringWithFormat:@"%@%@", precipIntensity, @"mm"];
        
        
    } failure:^(NSError *error){
        
        NSLog(@"Currently %@", error.description);
        
    }];
    [UIView animateWithDuration:1.0 animations:^{
        self.tempLabel.alpha = 1.0f;
        self.feelsLikeLabel.alpha = 1.0f;
        self.summaryLabel.alpha = 1.0f;
        self.viewMainView.alpha = 1.0f;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
