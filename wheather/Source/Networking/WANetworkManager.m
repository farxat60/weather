//
//  WANetworkManager.m
//  wheather
//
//  Created by Joe Franc on 10/11/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import "WANetworkManager.h"
#import "AFNetworking.h"
//http://api.openweathermap.org/data/2.5/forecast?id=524901&APPID=acb253427df5652a6367d50cff2e61ee

//static NSString const * apiKey = @"&appid=acb253427df5652a6367d50cff2e61ee";  //@"&appid=d2a6b21c943e38d9e44edcc03c9912ad";
//
//static NSString const * baceUrl = @"http://api.openweathermap.org/";
//
//static NSString const * weatherUrl = @"data/2.5/weather?q=";
static NSString const * apiKey = @"&units=metric&appid=acb253427df5652a6367d50cff2e61ee";  //@"&appid=d2a6b21c943e38d9e44edcc03c9912ad";

static NSString const * baceUrl = @"http://api.openweathermap.org/";

static NSString const * weatherUrl = @"data/2.5/forecast?q="; //weather

@interface WANetworkManager  ()

@property (nonatomic, strong) AFURLSessionManager *manager;


@end

@implementation WANetworkManager

+ (instancetype)sharedInstance {
    static WANetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WANetworkManager alloc] init];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sharedInstance.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        sharedInstance.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    });
    return sharedInstance;
}


- (void)loadWeatherForTown:(NSString *)townName completion:(completionBlock)completion {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", baceUrl, weatherUrl, townName, apiKey];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request
                                                     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
        } else {
            if (completion) {
                NSError* error;
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:&error];
             completion(json);
            }
        }
    }];
    [dataTask resume];
    
}






@end


