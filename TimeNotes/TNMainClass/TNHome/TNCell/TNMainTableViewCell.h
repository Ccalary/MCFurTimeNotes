//
//  TNMainTableViewCell.h
//  TimeNotes
//
//  Created by caohouhong on 2018/7/29.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notes+CoreDataClass.h"
@interface TNMainTableViewCell : UITableViewCell
@property (nonatomic, strong) Notes *notesModel;
@end
