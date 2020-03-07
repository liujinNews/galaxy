//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MyInfoItemEditViewController.h"
#import "UIResponder+addtion.h"
#import "MyChatCell.h"

@interface MyInfoItemEditViewController ()

@property (nonatomic, strong)NSString* contenTitle;
@property (nonatomic, strong) NSString * changeFrontName;

@end

@implementation MyInfoItemEditViewController

- (instancetype)initWithBlock:(OKBlock)okBlock{
    if (self = [super init]) {
        self.okBlock = okBlock;
    }
    return self;
}

- (void)setItemTitle:(NSString *)title {
    self.contenTitle = title;
    _lenLimit = [self getLimitLen:title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =  [UIColor colorWithWhite:0.5 alpha:0.8];
    self.content.textAlignment = NSTextAlignmentCenter;
    self.content.delegate = self;
    self.content.returnKeyType = UIReturnKeyDone;
    self.contentTitleLabel.text = self.contenTitle;
    _changeFrontName = self.content.text;
    [self.content addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.content becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOkAction:(id)sender{
    [self.content resignFirstResponder];
    self.view.hidden = YES;
    if (self.okBlock && ![self.orginContent isEqualToString:self.content.text]) {
        if (self.content.text.length > MAX_GROUP_INFO_CONTENT_LEN){
        }
        self.okBlock(self.content.text);
    }
    return;
}

- (IBAction)btnCancelAction:(id)sender{
    [self.content resignFirstResponder];
    self.view.hidden = YES;
    return;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)onValueChange:(id)sender{
    if (_lenLimit > 0){//如果需要长度限制的项，才做下面的操作
        UITextField *textField = (UITextField*)sender;
        //记录待选文字记录
        UITextRange *markedTextRange = textField.markedTextRange;
        //如果存在待选文字记录，则暂不处理
        if (markedTextRange) {
            return;
        }
        NSString *changeText;
        //长度变短
        if (_changeFrontName.length > textField.text.length) {
            //将超出最大限制字节的文本删除
            size_t length = strlen([textField.text UTF8String]);
            if ( length > _lenLimit) {
                textField.text = [self cutBeyondText:textField.text];
            }
        }
        else{//长度变长
            changeText = [textField.text substringFromIndex:_changeFrontName.length];
            if ([MyChatCell stringContainsEmoji:changeText]) {
                textField.text = _changeFrontName;
            }
            else{
                //将超出最大限制字节的文本删除
                size_t length = strlen([textField.text UTF8String]);
                if ( length > _lenLimit) {
                    textField.text = [self cutBeyondText:textField.text];
                }
            }
        }
        _changeFrontName = textField.text;
    }
}
    
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if([self.contenTitle isEqualToString:@"群组名称"]){
        if (string.length > 1 && [MyChatCell stringContainsEmoji:string]) {
        return NO;
    }
    }
    if(strlen([toBeString UTF8String]) >= _lenLimit){
        NSLog(@"length = %lu",strlen([toBeString UTF8String]));
        [self showPrompt:[[NSString alloc] initWithFormat:@"最大长度不能超过%ld个字节",_lenLimit]];
        return NO;
    }
    return YES;
}

//递归计算符合规定的文本长度
- (NSString *)cutBeyondText:(NSString *)fieldText{
    size_t length = strlen([fieldText UTF8String]);
    if (length > _lenLimit) {
        fieldText = [fieldText substringToIndex:fieldText.length-1];
        return [self cutBeyondText:fieldText];
    }
    else{
        return fieldText;
    }
}
- (NSInteger)getLimitLen:(NSString *)type
{
    NSInteger len = 0;
    
    if ([type isEqualToString:@"群简介"]) {
        len = MAX_GROUP_INTRODUCTION_LEN;
    }
    if ([type isEqualToString:@"群公告"]) {
        len = MAX_GROUP_NOTICE_LEN;
    }
    if ([type isEqualToString:@"群组名称"]) {
        len = MAX_GROUP_NAME_LEN;
    }
    return len==0 ? -1 : len;//len==0,表示长度无限制
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{   //开始编辑时，整体上移
    if (textField.tag==1) {
        [self moveView:-40];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{     //结束编辑时，整体下移
    if (textField.tag==1) {
        [self moveView:40];
    }
}

-(void)moveView:(CGFloat)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=move;//view的X轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
