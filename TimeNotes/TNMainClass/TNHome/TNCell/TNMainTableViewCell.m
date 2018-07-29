//
//  TNMainTableViewCell.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/29.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNMainTableViewCell.h"
@interface TNMainTableViewCell ()
@property (nonatomic, strong) UIView *roundView;
@property (nonatomic, strong) UILabel *titleLabel, *thingsLabel, *timeLabel;
@end

@implementation TNMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self tn_drawView];
    }
    return self;
}

- (void)tn_drawView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor tn_colorWithHex:0xf2f2f2];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.centerY.mas_equalTo(self.contentView);
        make.left.offset(30);
    }];
    
    _roundView = [[UIView alloc] init];
    _roundView.backgroundColor = [UIColor tn_themeColor];
    _roundView.layer.cornerRadius = 10;
    _roundView.layer.masksToBounds = YES;
    [self.contentView addSubview:_roundView];
    [_roundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.center.mas_equalTo(lineView);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"title";
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roundView.mas_right).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-5);
    }];
    
    _thingsLabel = [[UILabel alloc] init];
    _thingsLabel.text = @"things";
    _thingsLabel.font = [UIFont systemFontOfSize:14];
    _thingsLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_thingsLabel];
    [_thingsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(5);
        make.right.offset(-40);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"2018.08.01 18:00:00";
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
}

- (void)setNotesModel:(Notes *)notesModel {
    _titleLabel.text = notesModel.title;
    _thingsLabel.text = notesModel.content;
    _timeLabel.text = notesModel.dateStr;
    _roundView.backgroundColor = [UIColor tnColorWithColorType:notesModel.colorType];
}

@end
