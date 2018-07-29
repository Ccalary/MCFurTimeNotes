//
//  TNAddNotesVC.m
//  TimeNotes
//
//  Created by caohouhong on 2018/7/29.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "TNAddNotesVC.h"
#import "AppDelegate.h"
#import "Notes+CoreDataClass.h"
#import <CoreData/CoreData.h>

@interface TNAddNotesVC ()
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UIButton *colorBtn;
@property (nonatomic, assign) int colorType;

@end

@implementation TNAddNotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加笔记";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    [self.titleTF becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)selectColorAction:(UIButton *)sender {
    [self.colorBtn setBackgroundColor:sender.backgroundColor];
    self.colorType = (int)sender.tag - 1000;
}

- (void)cancelAction {
    [self dismissVC];
}

- (void)finishAction {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appdelegate.persistentContainer.viewContext;
    Notes *notes = [NSEntityDescription insertNewObjectForEntityForName:ENTITYNAME_NOTES inManagedObjectContext:context];
    notes.content = self.contentTF.text;
    notes.title = self.titleTF.text;
    notes.colorType = self.colorType;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    notes.dateStr = dateStr;
    
    NSError *error = nil;
    [context save:&error];
    if (error){
        NSLog(@"error,%@",error);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOTES_CHANGED_SUCCESS object:nil];
    [self dismissVC];
}

- (void)dismissVC {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
