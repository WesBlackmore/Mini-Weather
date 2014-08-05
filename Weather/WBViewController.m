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
#import <AFNetworking/AFNetworking.h>

@interface WBViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSMutableArray *hourlyArray;
@property (nonatomic, strong) NSMutableArray *dailyArray;

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
    
    [self loadLocation];
 }

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    self.tempLabel.alpha = 0.0f;
    self.feelsLikeLabel.alpha = 0.0f;
    self.summaryLabel.alpha = 0.0f;
    self.viewMainView.alpha = 0.0f;
    self.locationLabel.text = self.location;
}

#pragma mark Set Location

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
    
    self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    [self setIconLabelFonts];
    [self returnWeatherDictionaries];
    [self updateUI];
    
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(!error) {
            self.location = ([placemarks count] > 0) ? [[placemarks objectAtIndex:0] subLocality] : @"Not Found";
            dispatch_async(dispatch_get_main_queue(), ^{
                self.locationLabel.text = self.location;
            });
        }
        else{
            NSLog(@"Failed getting city: %@", [error description]);
        }
    }];
}

-(void)setIconLabelFonts {
    for (UILabel *label in self.fontLabelArray) {
        label.font = [UIFont fontWithName:@"Climacons-Font" size:35];
    }
}

-(void)returnWeatherDictionaries {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    ForecastKit *forecast = [[ForecastKit alloc] initWithAPIKey:@"4f3b47f06c6a8e18ea2a07fa0c290d6c"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f", @"4f3b47f06c6a8e18ea2a07fa0c290d6c", [self.latitude doubleValue], [self.longitude doubleValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        _hourlyArray = [responseObject objectForKey:@"hourly"];
        _dailyArray = [responseObject objectForKey:@"daily"];
        NSLog(@"Hourly: %@", [[_dailyArray valueForKeyPath:@"data"] objectAtIndex:0]);
        
        //Update UI Hourly TODO
        [dateFormatter setDateFormat: @"ha"];
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];
        
        int i = 0;
        for (UILabel *label in self.hourLabelArray) {
            i++;
            label.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[_hourlyArray valueForKeyPath:@"data.time"] objectAtIndex:i++] doubleValue]]];
        }
        
        i = 0;
        for (UILabel *label in self.hourIconArray) {
            i++;
            label.text =[forecast iconCharacter:[[_hourlyArray valueForKeyPath:@"data.icon"] objectAtIndex:i++]];
        }
        
        i = 0;
        for (UILabel *label in self.hourTempArray) {
            i++;
            label.text =[forecast celciusValue:[[_hourlyArray valueForKeyPath:@"data.temperature"] objectAtIndex:i++]];
        }
        
        //Update UI Daily
        
        [dateFormatter setDateFormat: @"EEE"];
        
        i = 0;
        for (UILabel *label in self.dayLabelArray)
            label.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[_dailyArray valueForKeyPath:@"data.time"] objectAtIndex:i++] doubleValue]]];
       
        i = 0;
        for (UILabel *label in self.dayIconArray)
            label.text =[forecast iconCharacter:[[_dailyArray valueForKeyPath:@"data.icon"] objectAtIndex:i++]];
        
        i = 0;
        for (UILabel *label in self.dayTempArray)
            label.text =[forecast celciusValue:[[_dailyArray valueForKeyPath:@"data.temperatureMax"] objectAtIndex:i++]];
        
        i = 0;
        for (UILabel *label in self.dayTempMinArray)
            label.text =[forecast celciusValue:[[_dailyArray valueForKeyPath:@"data.temperatureMin"] objectAtIndex:i++]];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  operation.responseString);
    }];
    [operation start];
    
}

#pragma mark Update UI Elements
- (void)updateUI {
    /*
     TO DO:
     1. Caching
        2. Location - DONE
        2.5 Date and Time - DONE
     3. Today & Week Data
     4. Animation
     5. Fix Layout
     6. Add F/C M/KM check
     7. Remove NSLogs
     */
    
    ForecastKit *forecast = [[ForecastKit alloc] initWithAPIKey:@"4f3b47f06c6a8e18ea2a07fa0c290d6c"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    
    self.tempLabel.alpha = 0.0f;
    self.feelsLikeLabel.alpha = 0.0f;
    self.summaryLabel.alpha = 0.0f;
    self.viewMainView.alpha = 0.0f;
    
    //getCurrentConditionsForLatitude:-27.9253 longitude:30.4239
    

    [forecast getCurrentConditionsForLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue] success:^(NSMutableDictionary *responseDict) {
        
        NSString *temp = [responseDict objectForKey:@"temperature"];
        NSString *feelsLike = [responseDict objectForKey:@"apparentTemperature"];
        NSString *summary = [responseDict objectForKey:@"summary"];
        NSString *icon = [responseDict objectForKey:@"icon"];
        NSString *windBearing = [responseDict objectForKey:@"windBearing"];
        NSString *windSpeed = [responseDict objectForKey:@"windSpeed"];
        
        
        NSDateFormatter* day = [[NSDateFormatter alloc] init];
        [day setDateFormat: @"EEEE ha"];
        [day setAMSymbol:@"am"];
        [day setPMSymbol:@"pm"];
        
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
        //self.locationLabel.text = self.location;
        self.currentDateTime.text = [NSString stringWithFormat:@"%@", [day stringFromDate:[NSDate date]]];
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
@end
