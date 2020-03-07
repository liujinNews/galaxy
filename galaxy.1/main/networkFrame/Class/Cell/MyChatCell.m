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

#import "MyChatCell.h"
#import "MyChatModel.h"
#import "UIViewAdditions.h"
#import "MyGroupInfoModel.h"

#define MAX_DISPLAY_NAME_LEN    13

@interface MyChatCell()



@end

@implementation MyChatCell

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (UIView*)badgeView{
    if (_badgeView==nil) {
        _badgeView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _badgeView.backgroundColor = [UIColor clearColor];
        _badgeView.textColor = [UIColor whiteColor];
        _badgeView.layer.cornerRadius = 5.0f;
        _badgeView.numberOfLines = 1;
        _badgeView.textAlignment = NSTextAlignmentCenter;
        _badgeView.preferredMaxLayoutWidth = 15;
        _badgeView.lineBreakMode = NSLineBreakByWordWrapping;
        _badgeView.font = Font_Same_11_20;
        _badgeImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-33, 32, 18, 18)];
        _badgeImage.image = [UIImage imageNamed:@"Message_RedGarden"];
        [_badgeImage addSubview:_badgeView];
        [self addSubview:_badgeImage];
    }
    return _badgeView;
}

- (UILabel*)timeView{
    if (_timeView == nil) {
        self.timeView = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width-105, 9, 90, 20)];
        [self.timeView setTextColor:[UIColor grayColor]];
        [self.timeView setFont:[UIFont systemFontOfSize:13]];
        self.timeView.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeView];
    }
    return _timeView;
}

- (UIImageView*)HeadImage{
    if (_HeadImage == nil) {
        _HeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 41, 41)];
        _HeadImage.image = [UIImage imageNamed:@"Message_Man"];
        [self addSubview:_HeadImage];
    }
    return _HeadImage;
}

- (UILabel*)lab_Name{
    if (_lab_Name == nil) {
        _lab_Name = [[UILabel alloc] initWithFrame:CGRectMake(71, 9, 200, 20)];
        [_lab_Name setTextColor:Color_Black_Important_20];
        [_lab_Name setFont:Font_Important_15_20];
        _lab_Name.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lab_Name];
    }
    return _lab_Name;
}

- (UILabel*)lab_Content{
    if (_lab_Content == nil) {
        _lab_Content = [[UILabel alloc] initWithFrame:CGRectMake(71, 32, 200, 20)];
        [_lab_Content setTextColor:Color_GrayDark_Same_20];
        [_lab_Content setFont:Font_Same_12_20];
        _lab_Content.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lab_Content];
    }
    return _lab_Content;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyNotificationGroupInfoChange object:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59)];
        [self.contentView addSubview:_bgView];
        
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.textColor = [UIColor grayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupInfoChange:) name:kMyNotificationGroupInfoChange object:nil];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    self.badgeView.frame = CGRectMake(self.right-35, (self.height-20)/2, 30, 20);
//    self.timeView.frame = CGRectMake(self.bounds.size.width-130, (self.height-20)/2, 90, 20);
    if (self.model.unreadCount != 0) {
        self.badgeView.hidden = NO;
        _badgeImage.hidden = NO;
        if (self.model.unreadCount < 100) {
            self.badgeView.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.model.unreadCount];
        }
        else {
            self.badgeView.text = @"99";
        }
    }
    else{
        _badgeView.hidden = YES;
        _badgeImage.hidden = YES;
    }
}


- (void) updateModel:(MyChatModel *)model{
    self.model = model;
    //头像,目前是写死统一
    if (model.type == TIM_C2C) {
//        self.imageView.image = [UIImage imageNamed:@"tab_contact_nor"];
        self.HeadImage.frame = CGRectMake(15, 9, 41, 41);
        self.HeadImage.layer.cornerRadius = 20.5f;
        self.HeadImage.layer.masksToBounds = YES;
    }
//    else if (model.type == TIM_GROUP){
//        self.imageView.image = [UIImage imageNamed:@"contacts_nav_group"];
//    }
    
    //名字
    NSString* name = model.title;
    
    if (name==nil || [name isEqualToString:@""]) {
        name = model.chatId;
        
    }else if (name.length >= MAX_DISPLAY_NAME_LEN) {
        NSString *subDetail = [name substringToIndex:MAX_DISPLAY_NAME_LEN-1];
        name = [self getShowDetail:subDetail];
        
    }
//    self.textLabel.text = name;
    self.lab_Name.text = name;
    
    if (model.detailInfo.length >= MAX_DISPLAY_NAME_LEN) {
        NSString *subDetail = [model.detailInfo substringToIndex:MAX_DISPLAY_NAME_LEN-1];
        NSString *result = [self getShowDetail:subDetail];
//        self.detailTextLabel.text = result;
        self.lab_Content.text = result;
    }
    else {
//        self.detailTextLabel.text = model.detailInfo;
        self.lab_Content.text = model.detailInfo;
    }
    
    if (model.unreadCount != 0) {
        self.badgeView.hidden = NO;
        _badgeImage.hidden = NO;
        if (model.unreadCount < 100) {
            self.badgeView.text = [NSString stringWithFormat:@"%lu", (unsigned long)model.unreadCount];
        }
        else {
            self.badgeView.text = @"99";
        }
    }
    else{
        _badgeView.hidden = YES;
        _badgeImage.hidden = YES;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    self.timeView.text = [NSDate NSDateChangeTime:[dateFormatter stringFromDate:model.latestTimestamp]];
}

- (NSString *)getShowDetail:(NSString *)subString{
    NSString *showDetail = [[NSString alloc] init];
    int length = (int)subString.length;
    if (length == 1) {
        return subString;
    }
    for (int i=0;i<length-1;i++) {
        
        NSString *temp  =[subString substringWithRange:NSMakeRange(i, 2)];
        BOOL isEmoji = [MyChatCell stringContainsEmoji:temp];
        if (isEmoji) {
            showDetail = [showDetail stringByAppendingString:temp];
            i++;
        }
        else{
            showDetail = [showDetail stringByAppendingString:[subString substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    NSLog(@"showdetail length == %lu",showDetail.length);
    showDetail = [showDetail stringByAppendingString:@"..."];
    NSLog(@"showdetail length1 == %lu",showDetail.length);
    return showDetail;
}

- (void)groupInfoChange:(NSNotification *)notify{
    if (self.model.type ==TIM_GROUP) {
        id data = [notify.userInfo objectForKey:@"data"];
        if ([data isKindOfClass:[MyGroupInfoModel class]]) {
            MyGroupInfoModel* model = (MyGroupInfoModel *)data;
            if ([model.groupId isEqualToString:self.model.chatId]) {
                self.model.title = model.groupTitle;
                NSString* name = model.groupTitle;
                if (name==nil || [name isEqualToString:@""]) {
                    name = model.groupId;
                }else if (name.length >= MAX_DISPLAY_NAME_LEN) {
                    NSString *subDetail = [name substringToIndex:MAX_DISPLAY_NAME_LEN-1];
                    name = [self getShowDetail:subDetail];
                }
                self.textLabel.text = name;
            }
        }
    }
}

@end
