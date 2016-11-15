//
//  Contact.m
//  Objective-C Test
//
//  Created by Adeel Miraj on 15/11/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize name;
@synthesize number;
@synthesize identifier;

- (instancetype)initWithContact:(CNContact *)contact {
    
    self = [super init];
    
    if (self) {
        
        name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        number = ((CNPhoneNumber *)contact.phoneNumbers[0].value).stringValue;
        identifier = contact.identifier;
    }
    
    return self;
}

@end
