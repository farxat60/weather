//
//  City+CoreDataProperties.m
//  
//
//  Created by Joe Franc on 10/30/17.
//
//  This file was automatically generated and should not be edited.
//

#import "City+CoreDataProperties.h"

@implementation City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"City"];
}

@dynamic name;

@end
