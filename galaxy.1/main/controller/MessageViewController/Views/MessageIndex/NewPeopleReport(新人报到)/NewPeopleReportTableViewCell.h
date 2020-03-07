//
//  NewPeopleReportTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NewPeopleReportTableViewCellDelegate <NSObject>
@optional
- (void)NewPeopleReportTableViewCellClickedLoadBtn:(NSDictionary *)dic isReject:(int)Reject;
@end

@interface NewPeopleReportTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UILabel *lab_name;

@property (weak, nonatomic) IBOutlet UILabel *lab_phone;
@property (weak, nonatomic) IBOutlet UILabel *lab_company;
@property (weak, nonatomic) IBOutlet UIButton *btn_OK;

@property (weak, nonatomic) IBOutlet UIButton *btn_Reject;
@property (weak, nonatomic) IBOutlet UIImageView *img_icon;

@property (weak, nonatomic) IBOutlet UILabel *lab_applyJoin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lau_btn_ok_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lay_applyJoin_width;


@property (nonatomic, weak) id<NewPeopleReportTableViewCellDelegate> delegate;

@end
