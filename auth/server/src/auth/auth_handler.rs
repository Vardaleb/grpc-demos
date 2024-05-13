use tonic::async_trait;


#[async_trait]
pub trait AuthHandler: Send + Sync + 'static {
    async fn handle(&self, scheme: &str, params: &str) -> Result<String, String>;
}

#[derive(Default, Clone)]
pub struct AuthHandlerImpl {}

mod basic;
mod bearer;

#[async_trait]
impl AuthHandler for AuthHandlerImpl {
    async fn handle(&self, scheme: &str, params: &str) -> Result<String, String> {
        match scheme {
            "Basic" => basic::handle(params).await,
            "Bearer" => bearer::handle(params).await,
            _ => Err(format!("Scheme '{}’ not implemented", scheme)),
        }
    }
}
