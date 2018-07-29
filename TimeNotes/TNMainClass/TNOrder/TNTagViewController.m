//
//  TNTagViewController.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/27.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNTagViewController.h"

@interface TNTagViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tagTF;

@end

@implementation TNTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(nav_rightBtnAction)];
    self.tagTF.text = self.tagStr;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tagTF becomeFirstResponder];
}

- (void)nav_rightBtnAction {
    if(_tagTF.text.length > 0 && self.block){
        self.block(_tagTF.text);
    }
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
