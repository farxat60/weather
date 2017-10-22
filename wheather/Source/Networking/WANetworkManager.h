//
//  WANetworkManager.h
//  wheather
//
//  Created by Joe Franc on 10/11/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^completionBlock)(NSDictionary *resposeData);

@interface WANetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)loadWeatherForTown:(NSString *)townName completion:(completionBlock)completion;



@end
