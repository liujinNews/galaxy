//
//  AddExpenseTypeViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/7/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@protocol AddExpenseTypeDelegate <NSObject>

-(void)AddExpenseTypeBtn:(NSString *)str type:(int)type;

@end

@interface AddExpenseTypeViewController : RootViewController

@property (weak, nonatomic) IBOutlet UITextField *txf_text;
@property (weak, nonatomic) IBOutlet UITextView *txv_textview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lay_txfview_hight;

//1 添加type 2 修改type  3 添加sub  4 修改sub
@property (nonatomic, assign) int type;

@property (nonatomic, strong) NSString *str_txf;

@property (nonatomic, weak) id <AddExpenseTypeDelegate> delegate;

@end
