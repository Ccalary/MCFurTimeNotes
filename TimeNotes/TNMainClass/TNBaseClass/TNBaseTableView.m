//
//  TNBaseTableView.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/29.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNBaseTableView.h"

#import "FBKVOController.h"

@interface TNBaseTableView()
@property (nonatomic, strong) FBKVOController *kvoController;
@property (nonatomic, strong) UILabel *stringLabel;

@end

@implementation TNBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self){
        //默认无数据高度
        self.noDataHeight = 20;
        
        [self drawView];
        [self initFBKVO];
    }
    return self;
}

//可以自定义的view,可以添加图片按钮等，这里只是简单的显示个label
- (void)drawView{
    _stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    _stringLabel.center = CGPointMake(self.center.x, self.center.y - 40);
    _stringLabel.text = @"什么都没有哎~";
    _stringLabel.hidden = YES;
    _stringLabel.font = [UIFont systemFontOfSize:25];
    _stringLabel.textAlignment = NSTextAlignmentCenter;
    _stringLabel.textColor = [UIColor grayColor];
    [self addSubview:_stringLabel];
}

//关键代码
- (void)initFBKVO{
    
    //KVO
    __weak typeof (self) weakSelf = self;
    self.kvoController = [FBKVOController controllerWithObserver:self];
    [self.kvoController observe:self keyPath:@"contentSize" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        // contentSize有了变化即会走这里
        CGFloat height =  weakSelf.contentSize.height;
        //如果高度大于我们规定的无数据时的高度则隐藏无数据界面，否则展示
        if ( height > weakSelf.noDataHeight){
            weakSelf.stringLabel.hidden = YES;
        }else {
            weakSelf.stringLabel.hidden = NO;
        }
    }];
}

@end
