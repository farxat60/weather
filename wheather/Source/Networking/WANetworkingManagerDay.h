//
//  WANetworkingManagerDay.h
//  wheather
//
//  Created by Joe Franc on 10/26/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

typedef void (^completionBlock)(NSDictionary *resposeData);

@interface WANetworkManagerDay : NSObject

+ (instancetype)sharedInstance;

- (void)loadWeatherForTownDay:(NSString *)townName completion:(completionBlock)completion;

@end
