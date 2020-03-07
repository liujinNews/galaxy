//
//  travelPlanBtnCell.h
//  galaxy
//
//  Created by 贺一鸣 on 15/11/11.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface travelPlanBtnCell : UITableViewCell

@property (nonatomic,strong)UILabel  * lab_title;
@property (nonatomic,strong)UILabel  * lab_content;
@property (nonatomic,strong)UIButton  * btn;
@property (nonatomic,strong)UIImageView  * images;
@property (nonatomic,strong)UIDatePicker  * datePicker;
@property (nonatomic,copy) NSString *type;

-(travelPlanBtnCell *)initModelwithView:(NSString *)name value:(NSString *)value type:(NSString *)type;

@end
