//
//  TNOrderTableViewCell.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/25.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNOrderTableViewCell.h"
#import "TNLocalNotification.h"
@interface TNOrderTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel, *dateLabel, *contentLabel;
@property (nonatomic, strong) UISwitch *rightSwitch;
@end
@implementation TNOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self tn_drawView];
    }
    return self;
}

- (void)tn_drawView {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"06:45";
    _titleLabel.font = [UIFont systemFontOfSize:50];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(10);
    }];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:15];
    _dateLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.bottom.centerY.mas_equalTo(self.titleLabel);
    }];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"闹钟";
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.offset(-10);
    }];
    
    _rightSwitch = [[UISwitch alloc] init];
    [_rightSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_rightSwitch];
    [_rightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.right.offset(-20);
    }];
    
}

- (void)switchChanged:(UISwitch *)mSwitch{
    BOOL isOn = mSwitch.isOn;
    if (self.block){
        self.block(isOn, self.indexPath.row);
    }
}

- (void)setOrderModel:(Order *)orderModel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[orderModel.timestamp doubleValue]];
     _titleLabel.text = [formatter stringFromDate:date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy.MM.dd"];
    _dateLabel.text = [NSString stringWithFormat:@"(%@)",[formatter1 stringFromDate:date]];
    
    _contentLabel.text = orderModel.content;
    [_rightSwitch setOn:[@"1" isEqualToString:orderModel.on] ? YES : NO];
    
    if (_rightSwitch.isOn){
        // 时间差
        NSTimeInterval timeDef = [date timeIntervalSinceDate:[NSDate date]];
        if (timeDef > 60){ // 是未来时间就添加
            [TNLocalNotification registerNotificationWithTitle:@"预约" content:_contentLabel.text notiID:orderModel.creatTime startDate:date repeats:NO];
        }
    }else {
        [TNLocalNotification removeLocalNotificationWithID:orderModel.creatTime];
    }
}

@end
