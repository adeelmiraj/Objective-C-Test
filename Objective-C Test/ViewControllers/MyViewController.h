//
//  MyViewController.h
//  Objective-C Test
//
//  Created by Adeel Miraj on 15/11/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import "BaseViewController.h"

@interface MyViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarItem;

- (IBAction)didTapBarItem:(UIBarButtonItem *)sender;

@end
