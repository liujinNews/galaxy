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
#import "MyMsgBaseModel.h"
#import "userData.h"

@class UAProgressView;

@interface MyChatBaseCell : UITableViewCell{
}

@property (nonatomic, strong)UIImageView* headView;
@property (nonatomic, strong)UILabel* nameLable;
@property (nonatomic, strong)UIImageView* bubble;
@property (nonatomic, strong)UIView* statusView;
@property (nonatomic, strong)UIImageView* failedImageView;
@property (nonatomic, strong)UAProgressView* sendingView;
@property (nonatomic, assign)TIMConversationType chatType;
@property (nonatomic, assign)BOOL     inMsg;
@property (nonatomic, strong)NSTimer* progressTimer;
@property (nonatomic, strong)MyMsgBaseModel* model;


- (void) setContent:(MyMsgBaseModel*) model;

+ (CGFloat) nickViewHeightWithType:(TIMConversationType)chatType msgIn:(BOOL)inMsg;

- (void)bubblePressed:(id)sender;

- (UIView *)showMenuView;

@end
