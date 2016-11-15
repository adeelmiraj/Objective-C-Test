//
//  ContactsManager.h
//  Objective-C Test
//
//  Created by Adeel Miraj on 15/11/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

#import "Contact.h"

@interface ContactsManager : NSObject

@property (readonly, nonatomic) NSArray <CNContact *> *contacts;

+ (instancetype)sharedManager;

- (void)deleteContactWithIdentifier:(NSString *)identifier;
- (void)getContacts:(void(^)(NSMutableArray *contacts, NSError *error))completionHandler;
- (void)contactsWithSameFirstName:(void(^)(NSMutableArray *contacts, NSError *error))completionHandler;

@end
