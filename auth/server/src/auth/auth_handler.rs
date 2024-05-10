use http_auth_basic::Credentials;
use tonic::async_trait;

#[async_trait]
pub trait AuthHandler: Send + Sync + 'static {
    async fn handle(&self, scheme: &str, params: &str) -> Result<String, String>;
}

#[derive(Default, Clone)]
pub struct AuthHandlerImpl {}

impl AuthHandlerImpl {
    async fn basic(&self, credentials: &str) -> Result<String, String> {
        match Credentials::decode(String::from(credentials)) {
            Ok(credentials) => {
                println!("User: {}", credentials.user_id);
                println!("Password: {}", credentials.password);

                if "password".eq(credentials.password.as_str()) {
                    Ok(credentials.user_id)
                } else {
                    Err("Wrong password".to_string())
                }
            }
            Err(e) => Err(e.to_string()),
        }
    }

    async fn bearer(&self, _token: &str) -> Result<String, String> {
        Err("not implemented".to_string())
    }
}

#[async_trait]
impl AuthHandler for AuthHandlerImpl {
    async fn handle(&self, scheme: &str, params: &str) -> Result<String, String> {
        match scheme {
            "Basic" => self.basic(params).await,
            "Bearer" => self.bearer(params).await,
            _ => Err(format!("Scheme '{}’ not implemented", scheme)),
        }
    }
}
