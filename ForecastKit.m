//
//  ForecastKit.m
//  ForecastKit
//
//  Created by Brandon Emrich on 3/29/13.
//  Copyright (c) 2013 Brandon Emrich. All rights reserved.
//

#import "ForecastKit.h"
#import <AFNetworking/AFNetworking.h>

@interface ForecastKit()

@property (nonatomic, strong) NSString *apiKey;

@end

@implementation ForecastKit

-(id)initWithAPIKey:(NSString*)api_key {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.apiKey = [api_key copy];
    
    return self;
}

-(NSString *)roundNumberUp:(NSString *)num {
    float roundedValue = round(2.0f * num.intValue) / 2.0f;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:roundedValue]];
    return numberString;
}

-(NSString *)celciusValue:(NSString *)fahrenheit {
    NSInteger celcius = (fahrenheit.intValue-32)*(0.5556);
    return [NSString stringWithFormat: @"%d", celcius];
}

-(NSString *)kilometersValue:(NSString *)miles {
    NSInteger kilometers = (miles.intValue)*(0.62137);
    return [NSString stringWithFormat: @"%d", kilometers];
}

-(NSString *)iconCharacter:(NSString *)icon  {
    
    if([icon isEqualToString:@"cloudy"]) {
        return @"!"; //Cloudy
    }
    else if([icon isEqualToString:@"hail"]) {
        return @"3"; //Hailing
    }
    else if([icon isEqualToString:@"fog"]) {
        return @"?"; //Fog/Mist
    }
    else if([icon isEqualToString:@"clear-night"]) {
        return @"N"; //Clear Night
    }
    else if([icon isEqualToString:@"partly-cloudy-night"]) {
        return @"#"; //Cloudy Night
    }
    else if([icon isEqualToString:@"partly-cloudy-day"]) {
        return @"\""; //Cloudy with sunshine
    }
    else if([icon isEqualToString:@"rain"]) {
        return @"$"; //Rain
    }
    else if([icon isEqualToString:@"snow"]) {
        return @"9"; //Snow
    }
    else if([icon isEqualToString:@"thunderstorm"]) {
        return @"*"; //Thunderstorm
    }
    else if([icon isEqualToString:@"clear-day"]) {
        return @"I"; //Sunny
    }
    else if([icon isEqualToString:@"sunset"]) {
        return @"M"; //Sunset
    }
    else if([icon isEqualToString:@"wind"]) {
        return @"B"; //Strong winds
    }
    else if([icon isEqualToString:@"compass"]) {
        return @"a"; //Strong winds
    }
    else if([icon isEqualToString:@"compassN"]) {
        return @"b"; //Strong winds
    }
    else if([icon isEqualToString:@"compassS"]) {
        return @"d"; //Strong winds
    }
    else if([icon isEqualToString:@"compassE"]) {
        return @"c"; //Strong winds
    }
    else if([icon isEqualToString:@"compassW"]) {
        return @"e"; //Strong winds
    }
    else if([icon isEqualToString:@"tempLow1"]) {
        return @"Y"; //Strong winds
    }
    else if([icon isEqualToString:@"tempLow2"]) {
        return @"Z"; //Strong winds
    }
    else if([icon isEqualToString:@"tempLow3"]) {
        return @"["; //Strong winds
    }
    else if([icon isEqualToString:@"tempHigh1"]) {
        return @"\\"; //Strong winds
    }
    else if([icon isEqualToString:@"tempHigh2"]) {
        return @"]"; //Strong winds
    }
    else if([icon isEqualToString:@"tempHigh3"]) {
        return @"^"; //Strong winds
    }
    else if([icon isEqualToString:@"umbrella"]) {
        return @"f"; //Strong winds
    }
    else {
        return @"!";
    }
}

-(NSString *)selectIconByTemperature:(NSString *)temp
{
    if (temp.intValue > 30) {
        return @"tempHigh3";
    }
    else if (temp.intValue > 25) {
        return @"tempHigh2";
    }
    else if (temp.intValue > 20) {
        return @"tempHigh1";
    }
    else if (temp.intValue > 15) {
        return @"tempLow3";
    }
    else if (temp.intValue > 10) {
        return @"tempLow2";
    }
    else if (temp.intValue < 10) {
        return @"tempLow1";
    }
    else {
        return @"tempHigh3";
    }
}

-(NSString *)selectIconByWindBearing:(NSString *)windBearing
{
    if (windBearing.intValue < 90) {
        return @"compassE"; //East
    }
    else if (windBearing.intValue < 180) {
        return @"compassS"; //South
    }
    else if (windBearing.intValue < 270) {
        return @"compassW"; //West
    }
    else {
        return @"compassN"; //North
    }
}

-(UIColor *)backgroundColorForTemp:(NSString *)temp
                              icon:(NSString *)icon
                           isNight:(BOOL) isNight {
    if (isNight) {
        return [UIColor colorWithRed:0.235 green:0.188 blue:0.502 alpha:1]; /*#3c3080*/
    }
    else {
        if (temp.intValue > 25) {
            return [UIColor colorWithRed:0.91 green:0.298 blue:0.239 alpha:1]; // Orange/Red #e84c3d
        }
        else if([icon isEqualToString:@"cloudy"] || [icon isEqualToString:@"hail"] || [icon isEqualToString:@"fog"] || [icon isEqualToString:@"rain"] || [icon isEqualToString:@"snow"] || [icon isEqualToString:@"thunderstorm"]) {
            return [UIColor colorWithRed:0.584 green:0.647 blue:0.647 alpha:1]; // Grey #95a5a5
        }
        else {
            return [UIColor colorWithRed:0.945 green:0.769 blue:0.059 alpha:1]; // Yellow #f1c40f
        }
    }
    return 0;
}

-(void)getCurrentConditionsForLatitude:(double)lat
                             longitude:(double)lon
                               success:(void (^)(NSMutableDictionary *responseDict))success
                               failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f", self.apiKey, lat, lon]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            //diskCapacity:100 * 1024 * 1024
                                                                //diskPath:nil];
    //[NSURLCache setSharedURLCache:sharedCache];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([responseObject objectForKey:@"currently"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [operation start];
    
}

-(void)getDailyForcastForLatitude:(double)lat
                        longitude:(double)lon
                          success:(void (^)(NSMutableArray *responseArray))success
                          failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f", self.apiKey, lat, lon]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([responseObject objectForKey:@"daily"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [operation start];
}

-(void)getHourlyForcastForLatitude:(double)lat
                         longitude:(double)lon
                           success:(void (^)(NSMutableArray *responseArray))success
                           failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f", self.apiKey, lat, lon]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([responseObject objectForKey:@"hourly"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [operation start];
}

-(void)getMinutelyForcastForLatitude:(double)lat
                           longitude:(double)lon
                             success:(void (^)(NSMutableArray *responseArray))success
                             failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f", self.apiKey, lat, lon]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([responseObject objectForKey:@"minutely"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [operation start];
}

-(void)getDailyForcastForLatitude:(double)lat
                        longitude:(double)lon
                             time:(NSTimeInterval)time
                          success:(void (^)(NSMutableArray *responseArray))success
                          failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f", self.apiKey, lat, lon]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([responseObject objectForKey:@"daily"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [operation start];
}

-(void)getHourlyForcastForLatitude:(double)lat
                         longitude:(double)lon
                              time:(NSTimeInterval)time
                           success:(void (^)(NSMutableArray *responseArray))success
                           failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f", self.apiKey, lat, lon]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([responseObject objectForKey:@"hourly"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [operation start];
}


@end
