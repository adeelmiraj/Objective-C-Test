//
//  ViewController.m
//  Objective-C Test
//
//  Created by Adeel Miraj on 20/10/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self filterArray];
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
    
//    NSArray *filteredArray = [objects filteredArrayUsingPredicate:predicate];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textField.tag = indexPath.row;
    
    return cell;
}


#pragma mark - UITableViewDelegate


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL shouldChange = YES;
    
    NSString *text = [textField.text stringByAppendingString:string];
    
    CGFloat textWidth = [text sizeWithAttributes:@{NSFontAttributeName: textField.font}].width;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
//    CGRect rect = [text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>]
    
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
