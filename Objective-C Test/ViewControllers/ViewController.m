//
//  ViewController.m
//  Objective-C Test
//
//  Created by Adeel Miraj on 20/10/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import <Contacts/Contacts.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self filterArray];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterArray {
    
    NSArray *objects = @[@{@"Score": @(20.7),
                           @"NameID": @(1),
                           @"Date": [NSDate date]},
                         @{@"Score": @(25),
                           @"NameID": @(1),
                           @"Date": [NSDate date]},
                         @{@"Score": @(28),
                           @"NameID": @(2),
                           @"Date": [NSDate date]},
                         @{@"Score": @(26),
                           @"NameID": @(3),
                           @"Date": [NSDate date]}];
    NSMutableArray *users = [NSMutableArray array];
    
    for (NSInteger i=0; i<objects.count; i++) {
        
        NSDictionary *dict = objects[i];
        NSNumber *nameID = dict[@"NameID"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.NameID==%@", nameID];
        NSInteger index = [users indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL found = [predicate evaluateWithObject:obj];
            return found;
        }];
        
        if (index != NSNotFound) {
            NSNumber *score1 = dict[@"Score"];
            NSNumber *score2 = users[index][@"Score"];
            
            if (score1.doubleValue > score2.doubleValue) {
                [users replaceObjectAtIndex:index withObject:dict];
            }
        }
        else {
            [users addObject:dict];
        }
    }
    NSLog(@"%@", users);
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        NSPredicate *anotherPredicate = [NSPredicate predicateWithFormat:@"self.NameID==%@", evaluatedObject[@"NameID"]];
        NSInteger index = [users indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL found = [anotherPredicate evaluateWithObject:obj];
            return found;
        }];
        
        if (index != NSNotFound) {
            
            NSDictionary *dict = users[index];
            NSNumber *score1 = dict[@"Score"];
            NSNumber *score2 = evaluatedObject[@"Score"];
            
            if (score2.doubleValue > score1.doubleValue) {
                [users replaceObjectAtIndex:index withObject:evaluatedObject];
            }
            
            return NO;
        }
        [users addObject:evaluatedObject];
        return YES;
    }];
    
    NSArray *filteredArray = [objects filteredArrayUsingPredicate:predicate];
    NSLog(@"%@", filteredArray);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textField.tag = indexPath.row;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"mySegue" sender:nil];
}

- (void)showActionSheet {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Share "
                                 message:@"Select your current status"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* online = [UIAlertAction
                             actionWithTitle:@"Facebook"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    UIAlertAction* offline = [UIAlertAction
                              actionWithTitle:@"Google+"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [view dismissViewControllerAnimated:YES completion:nil];
                              }];
    UIAlertAction* doNotDistrbe = [UIAlertAction
                                   actionWithTitle:@"LinkedIn"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [view dismissViewControllerAnimated:YES completion:nil];
                                   }];
    UIAlertAction* away = [UIAlertAction
                           actionWithTitle:@"Twitter"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [view dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                             }];
    
    [online setValue:[[UIImage imageNamed:@"agreement"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [offline setValue:[[UIImage imageNamed:@"archery"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [doNotDistrbe setValue:[[UIImage imageNamed:@"capitalism"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [away setValue:[[UIImage imageNamed:@"strategy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    [view addAction:online];
    [view addAction:away];
    [view addAction:offline];
    [view addAction:doNotDistrbe];
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:^{
        [self printSubviews:view.view];
    }];
}

- (void)printSubviews:(UIView *)view {
    
    if (view.subviews.count > 0) {
        
//        NSLog(@"Subviews of: %@", [view class]);
        
        for (UIView *subview in view.subviews) {
            [self printSubviews:subview];
        }
    }
    else {
        if ([view isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel *)view;
            label.textAlignment = NSTextAlignmentLeft;
            NSLog(@"%@", view);
        }
    }
}

- (NSArray *)subviews:(UIView *)view {
    
    NSArray *views;
    
    
    
    return views;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL shouldChange = YES;
    
    NSString *text = [textField.text stringByAppendingString:string];
    
    CGFloat textWidth = [text sizeWithAttributes:@{NSFontAttributeName: textField.font}].width;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (textWidth > screenWidth) {
        
        shouldChange = NO;
        
        NSInteger cellIndex = textField.tag;
        
        NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
        
        if (cellIndex < numberOfRows - 1) {
            
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:cellIndex+1 inSection:0];
            
            [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            TableViewCell *cell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
            
            [cell.textField becomeFirstResponder];
        }
    }
    
    return shouldChange;
}


@end
