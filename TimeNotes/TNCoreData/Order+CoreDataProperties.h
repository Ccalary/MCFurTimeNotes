//
//  Order+CoreDataProperties.h
//  
//
//  Created by caohouhong on 2018/7/29.
//
//

#import "Order+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Order (CoreDataProperties)

+ (NSFetchRequest<Order *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *on;
@property (nullable, nonatomic, copy) NSString *timestamp;
@property (nullable, nonatomic, copy) NSString *creatTime;

@end

NS_ASSUME_NONNULL_END
