//
//  Order+CoreDataProperties.m
//  
//
//  Created by caohouhong on 2018/7/29.
//
//

#import "Order+CoreDataProperties.h"

@implementation Order (CoreDataProperties)

+ (NSFetchRequest<Order *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Order"];
}

@dynamic content;
@dynamic on;
@dynamic timestamp;
@dynamic creatTime;

@end
