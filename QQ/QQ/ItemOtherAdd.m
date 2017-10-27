//
//  ItemOtherAdd.m
//  QQ
//
//  Created by JACK-GU on 2017/10/27.
//  Copyright © 2017年 JACK-GU. All rights reserved.
//

#import "ItemOtherAdd.h"

@interface ItemOtherAdd()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sixTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sixLeftConstraint;


@property (weak, nonatomic) IBOutlet UIButton *four;



@end

@implementation ItemOtherAdd

//设置间隔
-(void)set:(float)padding{
    self.oneLeftConstraint.constant = padding;
    self.oneTopConstraint.constant = padding;
    
    self.fourTopConstraint.constant = padding;
    self.fourLeftConstraint.constant = padding;
    self.fourBottomConstraint.constant = padding;
    
    self.twoLeftConstraint.constant = padding;
    self.twoTopConstraint.constant = padding;
    
    self.fiveLeftConstraint.constant = padding;
    self.fiveBottomConstraint.constant = padding;
    self.fiveTopConstraint.constant = padding;
    
    self.threeTopConstraint.constant = padding;
    self.threeLeftConstraint.constant = padding;
    
    self.sixTopConstraint.constant = padding;
    self.sixLeftConstraint.constant = padding;
}


/**
 设置view的高度
 @param height view的高度
 */
-(void)setHeight:(float)height{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

/**
 获得最大的Y
 */
-(float)getMaxY{
    return CGRectGetMaxY(self.four.frame);
}


@end
