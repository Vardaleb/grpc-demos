use std::sync::Arc;

use tonic::codegen::http::Request;
use tonic::{async_trait, Status};
use tonic_middleware::RequestInterceptor;

#[async_trait]
pub trait AuthService: Send + Sync + 'static {
    async fn verify_token(&self, token: &str) -> Result<String, String>;
}

#[derive(Default, Clone)]
pub struct AuthServiceImpl;

#[async_trait]
impl AuthService for AuthServiceImpl {
    async fn verify_token(&self, token: &str) -> Result<String, String> {
        if token == "supersecret" {
            Ok("user-1".to_string())
        } else {
            Err("Unauthenticated".to_string())
        }
    }
}

#[derive(Clone)]
pub struct AuthInterceptor<A: AuthService> {
    pub auth_service: Arc<A>,
}

#[async_trait]
impl<A: AuthService> RequestInterceptor for AuthInterceptor<A> {
    async fn intercept(
        &self,
        mut _req: Request<tonic::transport::Body>,
    ) -> Result<Request<tonic::transport::Body>, Status> {
        Err(Status::unauthenticated("not authenticated"))
    }
}
