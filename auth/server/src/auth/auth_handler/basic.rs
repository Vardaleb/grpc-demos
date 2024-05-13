use http_auth_basic::Credentials;

pub async fn handle(credentials: &str) -> Result<String, String> {
    match Credentials::decode(String::from(credentials)) {
        Ok(credentials) => {
            // Here goes the authentication.
            //
            // In a real world implementation, some user database would be queried. Also, 
            // the returned error should not be to specific. The real cause (wrong password, unknown user)
            // would only be stored locally for later analysis through authorized personel. The return 
            // value should be more general like: "Authentication Failed" or "User or password wrong".
            // The reason for this is to not reveal to much information, on what part (user or password) 
            // might be correct.
            println!("User: {}", credentials.user_id);
            println!("Password: {}", credentials.password);
            if "user".eq(credentials.user_id.as_str()) {
                if "password".eq(credentials.password.as_str()) {
                    Ok(credentials.user_id)
                } else {
                    Err("Wrong password".to_string())
                }
            } else {
                Err("Unknown user".to_string())
            }
        }
        Err(e) => Err(e.to_string()),
    }
}
