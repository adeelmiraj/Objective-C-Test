//
//  ContactsManager.m
//  Objective-C Test
//
//  Created by Adeel Miraj on 15/11/2016.
//  Copyright © 2016 AM Co. All rights reserved.
//

#import "ContactsManager.h"

@interface ContactsManager ()

@property (readwrite, nonatomic) NSMutableArray <CNContact *> *contacts;

@property BOOL permissionGranted;

@end

@implementation ContactsManager

static CNContactStore *store;

+ (instancetype)sharedManager {
    
    static ContactsManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        store = [[CNContactStore alloc] init];
        [self checkAndRequestAccess];
    }
    
    return self;
}

- (void)checkAndRequestAccess {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    switch (status) {
        case CNAuthorizationStatusDenied: {
            
            self.permissionGranted = NO;
        }
            break;
            
        case CNAuthorizationStatusAuthorized: {
            
            self.permissionGranted = YES;
        }
            break;
            
        case CNAuthorizationStatusRestricted: {
            
            self.permissionGranted = NO;
        }
            break;
            
        case CNAuthorizationStatusNotDetermined: {
            
            [store requestAccessForEntityType:CNEntityTypeContacts
                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                
                                self.permissionGranted = granted;
                            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)deleteContactWithIdentifier:(NSString *)identifier {
    
    NSArray *keys = @[CNContactGivenNameKey,
                      CNContactPhoneNumbersKey,
                      CNContactEmailAddressesKey,
                      CNContactIdentifierKey];
    CNMutableContact *contact = [[store unifiedContactWithIdentifier:identifier keysToFetch:keys error:nil] mutableCopy];
    NSError *error;
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest deleteContact:contact];
    [store executeSaveRequest:saveRequest error:&error];
}

- (void)getContacts:(void (^)(NSMutableArray *, NSError *))completionHandler {
    
    if (self.permissionGranted) {
        
        NSArray *keysToFetch = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                                 CNContactPhoneNumbersKey,
                                 CNContactEmailAddressesKey,
                                 CNContactIdentifierKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        fetchRequest.sortOrder = CNContactSortOrderGivenName;
        NSError *error;
        
        __block NSMutableArray *array = [NSMutableArray new];
        
        BOOL success = [store enumerateContactsWithFetchRequest:fetchRequest
                                                          error:(&error)
                                                     usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                                          
                                                         if (error) {
                                              
                                                             NSLog(@"%@", error.localizedDescription);
                                                             completionHandler(nil, error);
                                                         }
                                                         else {
                                                             [_contacts addObject:contact];
                                                             Contact *newContact = [[Contact alloc] initWithContact:contact];
                                                             [array addObject:newContact];
                                                         }
                                                     }];
        NSLog(@"%d", success);
        if (success) {
            completionHandler(array, nil);
        }
    }
}

- (void)contactsWithSameFirstName:(void(^)(NSMutableArray *contacts, NSError *error))completionHandler {
    NSArray *keys = @[CNContactGivenNameKey,
                      CNContactPhoneNumbersKey,
                      CNContactEmailAddressesKey,
                      CNContactIdentifierKey];
    NSError *anError;
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@"Ghulam"];
    NSMutableArray *result = [[store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&anError] mutableCopy];
    completionHandler(result, anError);
}

- (NSMutableArray <CNContact *> *)contacts {
    
    if (!_contacts) {
        _contacts = [NSMutableArray new];
    }
    
    return _contacts;
}

@end
