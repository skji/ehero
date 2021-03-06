//
//  EHHomeAgentCell.m
//  ehero
//
//  Created by Mac on 16/8/5.
//  Copyright © 2016年 ehero. All rights reserved.
//

#import "EHHomeAgentCell.h"

@interface EHHomeAgentCell()
@property (weak, nonatomic) IBOutlet UIImageView *txImgView;
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UILabel *position;

@end

@implementation EHHomeAgentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)homeAgentCellWithTableView:(UITableView *)tableView{
    static NSString *reuseId = @"reuseHomeAgentCell";
    EHHomeAgentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EHHomeAgentCell" owner:nil options:nil] lastObject];
        cell.txImgView.layer.cornerRadius = cell.txImgView.bounds.size.width / 2;
        cell.txImgView.layer.masksToBounds = YES;
        cell.region.backgroundColor = RGB(68, 180, 244);
        cell.userInteractionEnabled = NO;
        cell.position.backgroundColor = RGB(234, 243, 248);
    }
    
    return cell;
    
}

@end
