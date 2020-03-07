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

#import <UIKit/UIKit.h>

typedef void (^OKBlock)(NSString* newTitle);

@interface MyInfoItemEditViewController : UIViewController<UITextFieldDelegate>
{
    NSInteger _lenLimit;
}

@property (weak, nonatomic)IBOutlet UILabel *contentTitleLabel;
@property (nonatomic, weak)IBOutlet UITextField* content;
@property (nonatomic, weak)IBOutlet UIButton* btnOK;
@property (nonatomic, weak)IBOutlet UIButton* btnCancel;
@property (nonatomic, copy)OKBlock okBlock;
@property (nonatomic, strong)NSString* orginContent;

- (IBAction)btnOkAction:(id)sender;
- (IBAction)btnCancelAction:(id)sender;

-(instancetype)initWithBlock:(OKBlock)okBlock;
- (void)setItemTitle:(NSString *)title;

@end
