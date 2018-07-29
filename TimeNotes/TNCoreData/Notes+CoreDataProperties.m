//
//  Notes+CoreDataProperties.m
//  
//
//  Created by caohouhong on 2018/7/29.
//
//

#import "Notes+CoreDataProperties.h"

@implementation Notes (CoreDataProperties)

+ (NSFetchRequest<Notes *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Notes"];
}

@dynamic title;
@dynamic content;
@dynamic dateStr;
@dynamic colorType;

@end
