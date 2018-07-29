//
//  Notes+CoreDataProperties.h
//  
//
//  Created by caohouhong on 2018/7/29.
//
//

#import "Notes+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Notes (CoreDataProperties)

+ (NSFetchRequest<Notes *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *dateStr;
@property (nonatomic) int16_t colorType;

@end

NS_ASSUME_NONNULL_END
