//
//  CustomView.m
//  Objective-C Test
//
//  Created by Adeel Miraj on 25/10/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@property (retain, nonatomic) NSArray *imageViews;

@end

@implementation CustomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    CGRect bounds = self.bounds;
    CGRect imageRect = CGRectMake(0, 0, 30, 30);
    
    for (UIImageView* imageView in self.imageViews) {
        
        imageView.frame = imageRect;
        imageRect.origin.x = CGRectGetMaxX(imageRect);
        
        if (CGRectGetMaxX(imageRect) > CGRectGetMaxX(bounds)) {
            
            imageRect.origin.x = 0.0;
            imageRect.origin.y = CGRectGetMaxY(imageRect);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
