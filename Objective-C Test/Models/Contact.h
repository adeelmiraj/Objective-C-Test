//
//  Contact.h
//  Objective-C Test
//
//  Created by Adeel Miraj on 15/11/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

@interface Contact : NSObject

@property NSString *name;
@property NSString *number;
@property NSString *identifier;

- (instancetype)initWithContact:(CNContact *)contact;

@end
