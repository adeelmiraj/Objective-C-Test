//
//  ViewController.h
//  Objective-C Test
//
//  Created by Adeel Miraj on 20/10/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import "BaseViewController.h"

@interface ViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

