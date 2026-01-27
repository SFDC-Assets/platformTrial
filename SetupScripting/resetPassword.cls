List<User> users = [
    SELECT Id
    FROM User
    WHERE Alias = 'UUser'
    LIMIT 1
];

if (!users.isEmpty()) {
    try {
        System.resetPassword(users[0].Id, true);
    } catch (Exception e) {
        System.debug('Password reset failed: ' + e.getMessage());
    }
} else {
    System.debug('No user found with alias UUser');
}
